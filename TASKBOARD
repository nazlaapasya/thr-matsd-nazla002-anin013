import { useState } from "react";

const PASYA_COLOR = "#10b981";
const ANIN_COLOR = "#8b5cf6";
const BOTH_COLOR = "#f59e0b";

const initialTasks = [
  {
    phase: "⚙️ Setup Awal",
    phaseDesc: "Sebelum mulai coding — satu kali aja",
    tasks: [
      { id: 1, owner: "pasya", title: "Buat repo GitHub", desc: "Nama: proyek-mini-regresi · visibility: Public · init dengan README", done: false },
      { id: 2, owner: "anin", title: "Accept invite jadi collaborator", desc: "Pasya invite via Settings → Collaborators, Anin accept dari email", done: false },
      { id: 3, owner: "pasya", title: "Buat struktur folder di repo", desc: "Buat folder: data/, matlab/, output/, laporan/ — bisa via GitHub web langsung", done: false },
      { id: 4, owner: "anin", title: "Download dataset dari Kaggle", desc: "Search 'Crop Yield Prediction' by patelris6042 → Download ZIP → extract → rename jadi crop_yield_raw.csv", done: false },
      { id: 5, owner: "anin", title: "Upload dataset ke repo", desc: "Upload crop_yield_raw.csv ke folder data/ di GitHub", done: false },
      { id: 6, owner: "both", title: "Login MATLAB Online masing-masing", desc: "matlab.mathworks.com → daftar pakai email → upload dataset ke MATLAB Drive", done: false },
    ]
  },
  {
    phase: "🔍 EDA & Cleaning",
    phaseDesc: "Pasya handle, Anin paralel nulis bagian laporan intro",
    tasks: [
      { id: 7, owner: "pasya", title: "Jalankan 01_eda.m di MATLAB Online", desc: "Load data → filter Rice → hapus NaN & outlier IQR → simpan crop_yield_clean.csv", done: false },
      { id: 8, owner: "pasya", title: "Screenshot 3 output plot", desc: "scatter_plot.png · histogram_distribusi.png · boxplot_outlier.png → upload ke output/", done: false },
      { id: 9, owner: "pasya", title: "Catat hasil statistik deskriptif", desc: "Copy tabel mean/median/std/min/max dari Command Window → simpan buat laporan", done: false },
      { id: 10, owner: "anin", title: "Tulis bagian intro & latar belakang laporan", desc: "Kenapa tema pertanian? Apa itu regresi linier vs parabolik? Jelaskan variabel X dan Y", done: false },
      { id: 11, owner: "anin", title: "Buat file dataset_source.md", desc: "Tulis link Kaggle + screenshot halaman download dataset → push ke repo", done: false },
    ]
  },
  {
    phase: "📐 Perhitungan Manual",
    phaseDesc: "Anin handle — ini yang masuk tabel di laporan",
    tasks: [
      { id: 12, owner: "anin", title: "Ambil 10–15 sampel data dari dataset", desc: "Pilih data yang representatif, tidak terlalu ekstrem — tulis ke tabel manual", done: false },
      { id: 13, owner: "anin", title: "Buat tabel Σ untuk regresi linier", desc: "Kolom: x, y, x², xy, ŷ, (y-ŷ)² → hitung Σ tiap kolom di bawahnya", done: false },
      { id: 14, owner: "anin", title: "Selesaikan persamaan normal linier", desc: "Dua persamaan: Σy = na + bΣx dan Σxy = aΣx + bΣx² → cari a dan b", done: false },
      { id: 15, owner: "anin", title: "Buat tabel Σ untuk regresi parabolik", desc: "Tambah kolom: x³, x⁴, x²y → selesaikan 3 persamaan normal → cari a, b, c", done: false },
    ]
  },
  {
    phase: "💻 Implementasi MATLAB",
    phaseDesc: "Pasya handle — bikin 3 script",
    tasks: [
      { id: 16, owner: "pasya", title: "Jalankan 02_regresi_linier.m", desc: "polyfit degree 1 → polyval → plot → hitung R², RMSE, MAE → screenshot output", done: false },
      { id: 17, owner: "pasya", title: "Jalankan 03_regresi_parabolik.m", desc: "polyfit degree 2 → polyval → plot → hitung R², RMSE, MAE → screenshot output", done: false },
      { id: 18, owner: "pasya", title: "Jalankan 04_perbandingan.m", desc: "Plot kedua model dalam 1 figure → tabel perbandingan R²/RMSE → residual plot", done: false },
      { id: 19, owner: "pasya", title: "Upload semua .m ke folder matlab/ di GitHub", desc: "Push 4 file: 01_eda.m · 02_regresi_linier.m · 03_regresi_parabolik.m · 04_perbandingan.m", done: false },
    ]
  },
  {
    phase: "📊 Evaluasi & Interpretasi",
    phaseDesc: "Bareng — diskusi hasil dulu sebelum nulis",
    tasks: [
      { id: 20, owner: "both", title: "Diskusi: model mana yang lebih baik?", desc: "Bandingkan R² linier vs parabolik. Kalau R² parabolik jauh lebih tinggi → justifikasi kuat!", done: false },
      { id: 21, owner: "anin", title: "Hitung titik optimal curah hujan", desc: "x_optimal = -b / (2c) dari model y = a + bx + cx² → ini insight utama laporan", done: false },
      { id: 22, owner: "pasya", title: "Tulis bagian hasil & pembahasan MATLAB", desc: "Jelaskan output polyfit, nilai koefisien a/b/c, dan apa artinya secara domain pertanian", done: false },
      { id: 23, owner: "anin", title: "Tulis interpretasi & kesimpulan", desc: "Makna koefisien dalam konteks → keterbatasan model → rekomendasi praktis untuk petani", done: false },
    ]
  },
  {
    phase: "📝 Laporan & Pengumpulan",
    phaseDesc: "Deadline 2 Juni 2026 — jangan sampai telat!",
    tasks: [
      { id: 24, owner: "both", title: "Compile laporan jadi PDF", desc: "Gabungin semua bagian: intro (Anin) + EDA + manual (Anin) + MATLAB (Pasya) + kesimpulan (Anin)", done: false },
      { id: 25, owner: "pasya", title: "Final check repo GitHub", desc: "Pastikan semua file ada: data/ · matlab/ · output/ · laporan/ · README.md · dataset_source.md", done: false },
      { id: 26, owner: "both", title: "Upload ke LeAds", desc: "Submit PDF laporan + file .m + link repo GitHub sesuai ketentuan dosen", done: false },
    ]
  }
];

const ownerConfig = {
  pasya: { label: "Pasya", color: PASYA_COLOR, bg: "#ecfdf5", border: "#6ee7b7" },
  anin:  { label: "Anin",  color: ANIN_COLOR,  bg: "#f5f3ff", border: "#c4b5fd" },
  both:  { label: "Bareng", color: BOTH_COLOR, bg: "#fffbeb", border: "#fcd34d" },
};

export default function TaskBoard() {
  const [tasks, setTasks] = useState(initialTasks);
  const [filter, setFilter] = useState("all");

  const allTasks = tasks.flatMap(p => p.tasks);
  const doneCount = allTasks.filter(t => t.done).length;
  const totalCount = allTasks.length;
  const pct = Math.round(doneCount / totalCount * 100);

  const pasyaDone = allTasks.filter(t => (t.owner === "pasya" || t.owner === "both") && t.done).length;
  const pasyaTotal = allTasks.filter(t => t.owner === "pasya" || t.owner === "both").length;
  const aninDone = allTasks.filter(t => (t.owner === "anin" || t.owner === "both") && t.done).length;
  const aninTotal = allTasks.filter(t => t.owner === "anin" || t.owner === "both").length;

  const toggle = (phaseIdx, taskId) => {
    setTasks(prev => prev.map((phase, pi) =>
      pi !== phaseIdx ? phase : {
        ...phase,
        tasks: phase.tasks.map(t => t.id === taskId ? { ...t, done: !t.done } : t)
      }
    ));
  };

  const filterTask = (t) => {
    if (filter === "all") return true;
    if (filter === "pasya") return t.owner === "pasya" || t.owner === "both";
    if (filter === "anin") return t.owner === "anin" || t.owner === "both";
    if (filter === "todo") return !t.done;
    return true;
  };

  return (
    <div style={{
      fontFamily: "'DM Sans', sans-serif",
      background: "#f8fafc",
      minHeight: "100vh",
      padding: "20px 16px",
      maxWidth: 680,
      margin: "0 auto",
    }}>
      <link href="https://fonts.googleapis.com/css2?family=DM+Sans:wght@400;500;600;700&family=DM+Mono:wght@400;500&display=swap" rel="stylesheet" />

      {/* Header */}
      <div style={{ marginBottom: 20 }}>
        <div style={{ fontSize: 11, fontWeight: 600, letterSpacing: 2, color: "#94a3b8", textTransform: "uppercase", marginBottom: 4 }}>
          Matematika Sains Data · Pertemuan 12
        </div>
        <h1 style={{ margin: 0, fontSize: 22, fontWeight: 700, color: "#0f172a", lineHeight: 1.2 }}>
          Proyek Mini Regresi 🌾
        </h1>
        <div style={{ fontSize: 13, color: "#64748b", marginTop: 4 }}>Curah Hujan & Hasil Panen · Deadline 2 Juni 2026</div>
      </div>

      {/* Progress bar */}
      <div style={{ background: "white", borderRadius: 14, padding: "16px 18px", marginBottom: 16, boxShadow: "0 1px 4px rgba(0,0,0,0.07)" }}>
        <div style={{ display: "flex", justifyContent: "space-between", alignItems: "center", marginBottom: 10 }}>
          <span style={{ fontSize: 13, fontWeight: 600, color: "#0f172a" }}>Progress Keseluruhan</span>
          <span style={{ fontSize: 13, fontWeight: 700, color: pct === 100 ? PASYA_COLOR : "#0f172a" }}>{doneCount}/{totalCount} task · {pct}%</span>
        </div>
        <div style={{ background: "#e2e8f0", borderRadius: 99, height: 8, marginBottom: 14 }}>
          <div style={{ background: `linear-gradient(90deg, ${PASYA_COLOR}, #3b82f6)`, width: `${pct}%`, height: 8, borderRadius: 99, transition: "width 0.4s" }} />
        </div>
        <div style={{ display: "flex", gap: 12 }}>
          {[
            { label: "Pasya", done: pasyaDone, total: pasyaTotal, color: PASYA_COLOR, bg: "#ecfdf5" },
            { label: "Anin",  done: aninDone,  total: aninTotal,  color: ANIN_COLOR,  bg: "#f5f3ff" },
          ].map(p => (
            <div key={p.label} style={{ flex: 1, background: p.bg, borderRadius: 10, padding: "10px 14px" }}>
              <div style={{ fontSize: 12, fontWeight: 600, color: p.color, marginBottom: 4 }}>{p.label}</div>
              <div style={{ background: "#e2e8f0", borderRadius: 99, height: 5, marginBottom: 4 }}>
                <div style={{ background: p.color, width: `${Math.round(p.done/p.total*100)}%`, height: 5, borderRadius: 99, transition: "width 0.4s" }} />
              </div>
              <div style={{ fontSize: 11, color: "#64748b" }}>{p.done}/{p.total} selesai</div>
            </div>
          ))}
        </div>
      </div>

      {/* Filter */}
      <div style={{ display: "flex", gap: 8, marginBottom: 16, flexWrap: "wrap" }}>
        {[
          { key: "all", label: "Semua" },
          { key: "pasya", label: "🟢 Pasya" },
          { key: "anin",  label: "🟣 Anin" },
          { key: "todo",  label: "⬜ Belum" },
        ].map(f => (
          <button key={f.key} onClick={() => setFilter(f.key)} style={{
            padding: "6px 14px", borderRadius: 99, border: "1.5px solid",
            borderColor: filter === f.key ? "#0f172a" : "#e2e8f0",
            background: filter === f.key ? "#0f172a" : "white",
            color: filter === f.key ? "white" : "#64748b",
            fontSize: 12, fontWeight: 600, cursor: "pointer",
            fontFamily: "inherit",
          }}>{f.label}</button>
        ))}
      </div>

      {/* Phases */}
      {tasks.map((phase, pi) => {
        const visible = phase.tasks.filter(filterTask);
        if (visible.length === 0) return null;
        const phaseDone = phase.tasks.filter(t => t.done).length;
        const phaseTotal = phase.tasks.length;
        return (
          <div key={pi} style={{ marginBottom: 16 }}>
            <div style={{ display: "flex", alignItems: "center", gap: 10, marginBottom: 8 }}>
              <div style={{ fontWeight: 700, fontSize: 15, color: "#0f172a" }}>{phase.phase}</div>
              <div style={{ flex: 1, height: 1, background: "#e2e8f0" }} />
              <div style={{ fontSize: 11, fontWeight: 600, color: phaseDone === phaseTotal ? PASYA_COLOR : "#94a3b8" }}>
                {phaseDone}/{phaseTotal}
              </div>
            </div>
            <div style={{ fontSize: 12, color: "#94a3b8", marginBottom: 10, marginLeft: 2 }}>{phase.phaseDesc}</div>

            <div style={{ display: "flex", flexDirection: "column", gap: 8 }}>
              {visible.map(task => {
                const oc = ownerConfig[task.owner];
                return (
                  <div key={task.id} onClick={() => toggle(pi, task.id)} style={{
                    background: "white",
                    border: `1.5px solid ${task.done ? "#e2e8f0" : oc.border}`,
                    borderRadius: 12,
                    padding: "12px 14px",
                    cursor: "pointer",
                    opacity: task.done ? 0.55 : 1,
                    transition: "all 0.2s",
                    display: "flex",
                    gap: 12,
                    alignItems: "flex-start",
                  }}>
                    {/* Checkbox */}
                    <div style={{
                      width: 20, height: 20, borderRadius: 6, border: `2px solid ${task.done ? oc.color : "#cbd5e1"}`,
                      background: task.done ? oc.color : "white",
                      flexShrink: 0, marginTop: 1,
                      display: "flex", alignItems: "center", justifyContent: "center",
                      transition: "all 0.2s",
                    }}>
                      {task.done && <svg width="11" height="11" viewBox="0 0 12 12"><polyline points="2,6 5,9 10,3" fill="none" stroke="white" strokeWidth="2.2" strokeLinecap="round" strokeLinejoin="round"/></svg>}
                    </div>

                    <div style={{ flex: 1 }}>
                      <div style={{ display: "flex", alignItems: "center", gap: 8, marginBottom: 3, flexWrap: "wrap" }}>
                        <span style={{ fontSize: 13, fontWeight: 600, color: "#0f172a", textDecoration: task.done ? "line-through" : "none" }}>
                          {task.title}
                        </span>
                        <span style={{
                          fontSize: 10, fontWeight: 700, padding: "2px 8px", borderRadius: 99,
                          background: oc.bg, color: oc.color, letterSpacing: 0.5,
                        }}>{oc.label.toUpperCase()}</span>
                      </div>
                      <div style={{ fontSize: 12, color: "#64748b", lineHeight: 1.5 }}>{task.desc}</div>
                    </div>
                  </div>
                );
              })}
            </div>
          </div>
        );
      })}

      <div style={{ textAlign: "center", fontSize: 12, color: "#cbd5e1", marginTop: 24, paddingBottom: 8 }}>
        Klik task untuk centang ✓ · Progress tersimpan selama sesi ini
      </div>
    </div>
  );
}
