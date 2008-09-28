Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
From: "Igor M. Liplianin" <liplianin@tut.by>
To: vdr@linuxtv.org,
 n.wagenaar@xs4all.nl
Date: Sun, 28 Sep 2008 13:49:23 +0300
References: <vmime.48da5de9.2764.631c157d48c6c18b@shalafi.ath.cx>
In-Reply-To: <vmime.48da5de9.2764.631c157d48c6c18b@shalafi.ath.cx>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_zE23Ib3yN+qYQMV"
Message-Id: <200809281349.23741.liplianin@tut.by>
Cc: linux-dvb@linuxtv.org
Subject: [linux-dvb] [vdr][PATCH] S2API for vdr-1.7.0(1.7.1) quick hack
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--Boundary-00=_zE23Ib3yN+qYQMV
Content-Type: text/plain;
  charset="koi8-r"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

=F7 =D3=CF=CF=C2=DD=C5=CE=C9=C9 =CF=D4 24 September 2008 18:34:01 Niels Wag=
enaar =CE=C1=D0=C9=D3=C1=CC(=C1):
> Hello all (and especially Klaus):
>
> It's official, the people from V4L have voted for the usage of the S2API
> proposal to be the future for new DVB API improvements (see the official
> announcement at the bottom) within the V4L tree. Currently S2API is in a
> real speed-train and new devices are added very rapidly. Only the devices
> currently in Multiproto and written by Manu Abraham are not yet ported.
> Also people are allready busy with patches for Kaffeine (allready done) a=
nd
> MythTV (not seen yet, but it's WIP according to a post on the linux-dvb
> mailinglist).
>
> So, this should mean that VDR 1.7.x should focus on S2API because of the
> obvious reasons. Has anybody started on a patch of somekind to include
> S2API in VDR 1.7.0 or 1.7.1? Mainly I was thinking of doing it myself (I
> have a Hauppauge WinTV-NOVA-HD-S2 which is allready supported in S2API) in
> the hope to have it working in the next weekend. But if it's allready done
> or in progress, then I would like to use my time for something else ;)
>
> Regards,
>
> Niels Wagenaar

Hi Niels

S2API for vdr-1.7.0(1.7.1) quick hack
Patch is ugly and only supported DVB-S. But it is useful to begin.=20
You may modify it like you wish.

Igor

--Boundary-00=_zE23Ib3yN+qYQMV
Content-Type: text/x-diff;
  charset="koi8-r";
  name="vde-1.7.0-s2.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="vde-1.7.0-s2.patch"

diff -Naur 1/channels.c 2/channels.c
--- 1/channels.c	2008-04-12 16:49:12.000000000 +0300
+++ 2/channels.c	2008-09-28 13:02:01.000000000 +0300
@@ -21,114 +21,116 @@
 // --- Channel Parameter Maps ------------------------------------------------
 
 const tChannelParameterMap InversionValues[] = {
-  {   0, DVBFE_INVERSION_OFF, trNOOP("off") },
-  {   1, DVBFE_INVERSION_ON,  trNOOP("on") },
-  { 999, DVBFE_INVERSION_AUTO },
+  {   0, INVERSION_OFF, trNOOP("off") },
+  {   1, INVERSION_ON,  trNOOP("on") },
+  { 999, INVERSION_AUTO },
   { -1 }
   };
 
 const tChannelParameterMap BandwidthValues[] = {
-  {   5, DVBFE_BANDWIDTH_5_MHZ, "5 MHz" },
-  {   6, DVBFE_BANDWIDTH_6_MHZ, "6 MHz" },
-  {   7, DVBFE_BANDWIDTH_7_MHZ, "7 MHz" },
-  {   8, DVBFE_BANDWIDTH_8_MHZ, "8 MHz" },
-  { 999, DVBFE_BANDWIDTH_AUTO },
+//  {   5, BANDWIDTH_5_MHZ, "5 MHz" },
+  {   6, BANDWIDTH_6_MHZ, "6 MHz" },
+  {   7, BANDWIDTH_7_MHZ, "7 MHz" },
+  {   8, BANDWIDTH_8_MHZ, "8 MHz" },
+  { 999, BANDWIDTH_AUTO },
   { -1 }
   };
 
 const tChannelParameterMap CoderateValues[] = {
-  {   0, DVBFE_FEC_NONE, trNOOP("none") },
-  {  12, DVBFE_FEC_1_2,  "1/2" },
-  {  13, DVBFE_FEC_1_3,  "1/3" },
-  {  14, DVBFE_FEC_1_4,  "1/4" },
-  {  23, DVBFE_FEC_2_3,  "2/3" },
-  {  25, DVBFE_FEC_2_5,  "2/5" },
-  {  34, DVBFE_FEC_3_4,  "3/4" },
-  {  35, DVBFE_FEC_3_5,  "3/5" },
-  {  45, DVBFE_FEC_4_5,  "4/5" },
-  {  56, DVBFE_FEC_5_6,  "5/6" },
-  {  67, DVBFE_FEC_6_7,  "6/7" },
-  {  78, DVBFE_FEC_7_8,  "7/8" },
-  {  89, DVBFE_FEC_8_9,  "8/9" },
-  { 910, DVBFE_FEC_9_10, "9/10" },
-  { 999, DVBFE_FEC_AUTO },
+  {   0, FEC_NONE, trNOOP("none") },
+  {  12, FEC_1_2,  "1/2" },
+//  {  13, FEC_1_3,  "1/3" },
+//  {  14, FEC_1_4,  "1/4" },
+  {  23, FEC_2_3,  "2/3" },
+//  {  25, FEC_2_5,  "2/5" },
+  {  34, FEC_3_4,  "3/4" },
+  {  35, FEC_3_5,  "3/5" },
+  {  45, FEC_4_5,  "4/5" },
+  {  56, FEC_5_6,  "5/6" },
+  {  67, FEC_6_7,  "6/7" },
+  {  78, FEC_7_8,  "7/8" },
+  {  89, FEC_8_9,  "8/9" },
+  { 910, FEC_9_10, "9/10" },
+  { 999, FEC_AUTO },
   { -1 }
   };
 
 const tChannelParameterMap ModulationValues[] = {
-  {   0, DVBFE_MOD_NONE,    trNOOP("none") },
-  {   4, DVBFE_MOD_QAM4,    "QAM4" },
-  {  16, DVBFE_MOD_QAM16,   "QAM16" },
-  {  32, DVBFE_MOD_QAM32,   "QAM32" },
-  {  64, DVBFE_MOD_QAM64,   "QAM64" },
-  { 128, DVBFE_MOD_QAM128,  "QAM128" },
-  { 256, DVBFE_MOD_QAM256,  "QAM256" },
-  { 512, DVBFE_MOD_QAM512,  "QAM512" },
-  {1024, DVBFE_MOD_QAM1024, "QAM1024" },
-  {   1, DVBFE_MOD_BPSK,    "BPSK" },
-  {   2, DVBFE_MOD_QPSK,    "QPSK" },
-  {   3, DVBFE_MOD_OQPSK,   "OQPSK" },
-  {   5, DVBFE_MOD_8PSK,    "8PSK" },
-  {   6, DVBFE_MOD_16APSK,  "16APSK" },
-  {   7, DVBFE_MOD_32APSK,  "32APSK" },
-  {   8, DVBFE_MOD_OFDM,    "OFDM" },
-  {   9, DVBFE_MOD_COFDM,   "COFDM" },
-  {  10, DVBFE_MOD_VSB8,    "VSB8" },
-  {  11, DVBFE_MOD_VSB16,   "VSB16" },
-  { 998, DVBFE_MOD_QAMAUTO, "QAMAUTO" },
-  { 999, DVBFE_MOD_AUTO },
+//  {   0, MOD_NONE,    trNOOP("none") },
+//  {   4, MOD_QAM4,    "QAM4" },
+  {  16, QAM_16,   "QAM16" },
+  {  32, QAM_32,   "QAM32" },
+  {  64, QAM_64,   "QAM64" },
+  { 128, QAM_128,  "QAM128" },
+  { 256, QAM_256,  "QAM256" },
+//  { 512, MOD_QAM512,  "QAM512" },
+//  {1024, MOD_QAM1024, "QAM1024" },
+//  {   1, MOD_BPSK,    "BPSK" },
+  {   2, QPSK,    "QPSK" },
+//  {   3, MOD_OQPSK,   "OQPSK" },
+  {   5, _8PSK,    "8PSK" },
+  {   6, _16APSK,  "16APSK" },
+//  {   7, MOD_32APSK,  "32APSK" },
+//  {   8, DVBFE_MOD_OFDM,    "OFDM" },
+//  {   9, MOD_COFDM,   "COFDM" },
+  {  10, VSB_8,    "VSB8" },
+  {  11, VSB_16,   "VSB16" },
+  { 998, QAM_AUTO, "QAMAUTO" },
+//  { 999, MOD_AUTO },
   { -1 }
   };
 
 const tChannelParameterMap SystemValues[] = {
-  {   0, DVBFE_DELSYS_DVBS,  "DVB-S" },
-  {   1, DVBFE_DELSYS_DVBS2, "DVB-S2" },
+  {   0, SYS_DVBS,  "DVB-S" },
+  {   1, SYS_DVBS2, "DVB-S2" },
   { -1 }
   };
 
 const tChannelParameterMap TransmissionValues[] = {
-  {   2, DVBFE_TRANSMISSION_MODE_2K, "2K" },
-  {   4, DVBFE_TRANSMISSION_MODE_4K, "4K" },
-  {   8, DVBFE_TRANSMISSION_MODE_8K, "8K" },
-  { 999, DVBFE_TRANSMISSION_MODE_AUTO },
+  {   2, TRANSMISSION_MODE_2K, "2K" },
+//  {   4, TRANSMISSION_MODE_4K, "4K" },
+  {   8, TRANSMISSION_MODE_8K, "8K" },
+  { 999, TRANSMISSION_MODE_AUTO },
   { -1 }
   };
 
 const tChannelParameterMap GuardValues[] = {
-  {   4, DVBFE_GUARD_INTERVAL_1_4,  "1/4" },
-  {   8, DVBFE_GUARD_INTERVAL_1_8,  "1/8" },
-  {  16, DVBFE_GUARD_INTERVAL_1_16, "1/16" },
-  {  32, DVBFE_GUARD_INTERVAL_1_32, "1/32" },
-  { 999, DVBFE_GUARD_INTERVAL_AUTO },
+  {   4, GUARD_INTERVAL_1_4,  "1/4" },
+  {   8, GUARD_INTERVAL_1_8,  "1/8" },
+  {  16, GUARD_INTERVAL_1_16, "1/16" },
+  {  32, GUARD_INTERVAL_1_32, "1/32" },
+  { 999, GUARD_INTERVAL_AUTO },
   { -1 }
   };
 
 const tChannelParameterMap HierarchyValues[] = {
-  {   0, DVBFE_HIERARCHY_OFF, trNOOP("off") },
-  {   1, DVBFE_HIERARCHY_ON,  trNOOP("on") },
-  { 999, DVBFE_HIERARCHY_AUTO },
+  {   0, HIERARCHY_NONE, trNOOP("off") },
+  {   1, HIERARCHY_1,  trNOOP("1") },
+  {   2, HIERARCHY_2,  trNOOP("2") },
+  {   4, HIERARCHY_4,  trNOOP("4") },
+  { 999, HIERARCHY_AUTO },
   { -1 }
   };
 
-const tChannelParameterMap AlphaValues[] = {
-  {   0, 0 },
-  {   1, DVBFE_ALPHA_1 },
-  {   2, DVBFE_ALPHA_2 },
-  {   4, DVBFE_ALPHA_4 },
-  { -1 }
-  };
-
-const tChannelParameterMap PriorityValues[] = {
-  {   0, DVBFE_STREAM_PRIORITY_HP, trNOOP("high") },
-  {   1, DVBFE_STREAM_PRIORITY_LP, trNOOP("low") },
-  { -1 }
-  };
+// const tChannelParameterMap AlphaValues[] = {
+//   {   0, 0 },
+//   {   1, ALPHA_1 },
+//   {   2, ALPHA_2 },
+//   {   4, ALPHA_4 },
+//   { -1 }
+//   };
+// 
+// const tChannelParameterMap PriorityValues[] = {
+//   {   0, STREAM_PRIORITY_HP, trNOOP("high") },
+//   {   1, STREAM_PRIORITY_LP, trNOOP("low") },
+//   { -1 }
+//   };
 
 const tChannelParameterMap RollOffValues[] = {
-  {   0, DVBFE_ROLLOFF_UNKNOWN },
-  {  20, DVBFE_ROLLOFF_20, "0.20" },
-  {  25, DVBFE_ROLLOFF_25, "0.25" },
-  {  35, DVBFE_ROLLOFF_35, "0.35" },
+  {   0, ROLLOFF_AUTO },
+  {  20, ROLLOFF_20, "0.20" },
+  {  25, ROLLOFF_25, "0.25" },
+  {  35, ROLLOFF_35, "0.35" },
   { -1 }
   };
 
@@ -217,18 +219,18 @@
   provider = strdup("");
   portalName = strdup("");
   memset(&__BeginData__, 0, (char *)&__EndData__ - (char *)&__BeginData__);
-  inversion    = DVBFE_INVERSION_AUTO;
-  bandwidth    = DVBFE_BANDWIDTH_AUTO;
-  coderateH    = DVBFE_FEC_AUTO;
-  coderateL    = DVBFE_FEC_AUTO;
-  modulation   = DVBFE_MOD_AUTO;
-  system       = DVBFE_DELSYS_DVBS;
-  transmission = DVBFE_TRANSMISSION_MODE_AUTO;
-  guard        = DVBFE_GUARD_INTERVAL_AUTO;
-  hierarchy    = DVBFE_HIERARCHY_AUTO;
+  inversion    = INVERSION_AUTO;
+  bandwidth    = BANDWIDTH_AUTO;
+  coderateH    = FEC_AUTO;
+  coderateL    = FEC_AUTO;
+  modulation   = QPSK;
+  system       = SYS_DVBS;
+  transmission = TRANSMISSION_MODE_AUTO;
+  guard        = GUARD_INTERVAL_AUTO;
+  hierarchy    = HIERARCHY_AUTO;
   alpha        = 0;
-  priority     = DVBFE_STREAM_PRIORITY_HP;
-  rollOff      = DVBFE_ROLLOFF_UNKNOWN;
+  //priority     = STREAM_PRIORITY_HP;
+  rollOff      = ROLLOFF_AUTO;
   modification = CHANNELMOD_NONE;
   schedule     = NULL;
   linkChannels = NULL;
@@ -669,7 +671,7 @@
   char *q = buffer;
   *q = 0;
   ST(" S ")  q += sprintf(q, "%c", polarization);
-  ST("  T")  q += PrintParameter(q, 'A', MapToUser(alpha, AlphaValues));
+//  ST("  T")  q += PrintParameter(q, 'A', MapToUser(alpha, AlphaValues));
   ST("  T")  q += PrintParameter(q, 'B', MapToUser(bandwidth, BandwidthValues));
   ST("CST")  q += PrintParameter(q, 'C', MapToUser(coderateH, CoderateValues));
   ST("  T")  q += PrintParameter(q, 'D', MapToUser(coderateL, CoderateValues));
@@ -677,7 +679,7 @@
   ST("CST")  q += PrintParameter(q, 'I', MapToUser(inversion, InversionValues));
   ST("CST")  q += PrintParameter(q, 'M', MapToUser(modulation, ModulationValues));
   ST(" S ")  q += PrintParameter(q, 'O', MapToUser(rollOff, RollOffValues));
-  ST("  T")  q += PrintParameter(q, 'P', MapToUser(priority, PriorityValues));
+//  ST("  T")  q += PrintParameter(q, 'P', MapToUser(priority, PriorityValues));
   ST(" S ")  q += PrintParameter(q, 'S', MapToUser(system, SystemValues));
   ST("  T")  q += PrintParameter(q, 'T', MapToUser(transmission, TransmissionValues));
   ST("  T")  q += PrintParameter(q, 'Y', MapToUser(hierarchy, HierarchyValues));
@@ -704,7 +706,7 @@
 {
   while (s && *s) {
         switch (toupper(*s)) {
-          case 'A': s = ParseParameter(s, alpha, AlphaValues); break;
+//          case 'A': s = ParseParameter(s, alpha, AlphaValues); break;
           case 'B': s = ParseParameter(s, bandwidth, BandwidthValues); break;
           case 'C': s = ParseParameter(s, coderateH, CoderateValues); break;
           case 'D': s = ParseParameter(s, coderateL, CoderateValues); break;
@@ -715,7 +717,7 @@
           case 'M': s = ParseParameter(s, modulation, ModulationValues); break;
           case 'Z':// for compatibility with the original DVB-S2 patch - may be removed in future versions
           case 'O': s = ParseParameter(s, rollOff, RollOffValues); break;
-          case 'P': s = ParseParameter(s, priority, PriorityValues); break;
+//          case 'P': s = ParseParameter(s, priority, PriorityValues); break;
           case 'R': polarization = *s++; break;
           case 'S': s = ParseParameter(s, system, SystemValues); break;
           case 'T': s = ParseParameter(s, transmission, TransmissionValues); break;
diff -Naur 1/dvbdevice.c 2/dvbdevice.c
--- 1/dvbdevice.c	2008-08-28 20:47:43.000000000 +0300
+++ 2/dvbdevice.c	2008-09-28 12:31:02.000000000 +0300
@@ -76,7 +76,7 @@
   int tuneTimeout;
   int lockTimeout;
   time_t lastTimeoutReport;
-  dvbfe_delsys frontendType;
+  fe_delivery_system frontendType;
   cChannel channel;
   const char *diseqcCommands;
   eTunerStatus tunerStatus;
@@ -87,14 +87,14 @@
   bool SetFrontend(void);
   virtual void Action(void);
 public:
-  cDvbTuner(int Fd_Frontend, int CardIndex, dvbfe_delsys FrontendType);
+  cDvbTuner(int Fd_Frontend, int CardIndex, fe_delivery_system FrontendType);
   virtual ~cDvbTuner();
   bool IsTunedTo(const cChannel *Channel) const;
   void Set(const cChannel *Channel, bool Tune);
   bool Locked(int TimeoutMs = 0);
   };
 
-cDvbTuner::cDvbTuner(int Fd_Frontend, int CardIndex, dvbfe_delsys FrontendType)
+cDvbTuner::cDvbTuner(int Fd_Frontend, int CardIndex, fe_delivery_system FrontendType)
 {
   fd_frontend = Fd_Frontend;
   cardIndex = CardIndex;
@@ -104,7 +104,7 @@
   lastTimeoutReport = 0;
   diseqcCommands = NULL;
   tunerStatus = tsIdle;
-  if (frontendType & (DVBFE_DELSYS_DVBS | DVBFE_DELSYS_DVBS2))
+  if (frontendType & (SYS_DVBS | SYS_DVBS2))
      CHECK(ioctl(fd_frontend, FE_SET_VOLTAGE, SEC_VOLTAGE_13)); // must explicitly turn on LNB power
   SetDescription("tuner on device %d", cardIndex + 1);
   Start();
@@ -192,10 +192,14 @@
 
 bool cDvbTuner::SetFrontend(void)
 {
-  dvbfe_params Frontend;
+//  dvbfe_params Frontend;
+  dtv_property Frontend[8];
   memset(&Frontend, 0, sizeof(Frontend));
+  dtv_properties cmdseq;
+  cmdseq.num = 8;
+  cmdseq.props = Frontend ;
 
-  if (frontendType & (DVBFE_DELSYS_DVBS | DVBFE_DELSYS_DVBS2)) {
+  if (frontendType & (SYS_DVBS | SYS_DVBS2)) {
      unsigned int frequency = channel.Frequency();
      if (Setup.DiSEqC) {
         cDiseqc *diseqc = Diseqcs.Get(channel.Source(), channel.Frequency(), channel.Polarization());
@@ -249,10 +253,10 @@
         }
      frequency = abs(frequency); // Allow for C-band, where the frequency is less than the LOF
 
-     Frontend.delivery = dvbfe_delsys(channel.System());
+/*     Frontend.delivery = dvbfe_delsys(channel.System());
      Frontend.frequency = frequency * 1000UL;
      Frontend.inversion = fe_spectral_inversion_t(channel.Inversion());
-     if (Frontend.delivery == DVBFE_DELSYS_DVBS) {
+     if (Frontend.delivery == SYS_DVBS) {
         Frontend.delsys.dvbs.modulation = dvbfe_modulation(channel.Modulation());
         Frontend.delsys.dvbs.symbol_rate = channel.Srate() * 1000UL;
         Frontend.delsys.dvbs.fec = dvbfe_fec(channel.CoderateH());
@@ -263,55 +267,73 @@
         Frontend.delsys.dvbs2.fec = dvbfe_fec(channel.CoderateH());
         Frontend.delsys.dvbs2.rolloff = dvbfe_rolloff(channel.RollOff());
         }
+*/
+     Frontend[0].cmd = DTV_DELIVERY_SYSTEM;
+     Frontend[0].u.data = fe_delivery_system_t(channel.System());
+     Frontend[1].cmd = DTV_FREQUENCY;
+     Frontend[1].u.data = frequency * 1000UL;
+     Frontend[2].cmd = DTV_MODULATION;
+     Frontend[2].u.data = fe_modulation_t(channel.Modulation());
+     Frontend[3].cmd = DTV_SYMBOL_RATE;
+     Frontend[3].u.data = channel.Srate() * 1000UL;
+     Frontend[4].cmd = DTV_INNER_FEC;
+     Frontend[4].u.data = fe_code_rate_t(channel.CoderateH());
+     Frontend[5].cmd = DTV_INVERSION;
+     Frontend[5].u.data = fe_spectral_inversion_t(channel.Inversion());
+     Frontend[6].cmd = DTV_ROLLOFF;
+     Frontend[6].u.data = fe_rolloff_t(channel.RollOff());
+     Frontend[7].cmd = DTV_TUNE;
+
+
 
      tuneTimeout = DVBS_TUNE_TIMEOUT;
      lockTimeout = DVBS_LOCK_TIMEOUT;
 
-     dvbfe_info feinfo;
+     //dvbfe_info feinfo;
      //feinfo.delivery = Frontend.delivery;
-     CHECK(ioctl(fd_frontend, DVBFE_GET_INFO, &feinfo)); //switch system
+     //CHECK(ioctl(fd_frontend, DVBFE_GET_INFO, &feinfo)); //switch system
      }
-  else if (frontendType & DVBFE_DELSYS_DVBC) {
-     Frontend.delivery = DVBFE_DELSYS_DVBC;
-     Frontend.frequency = FrequencyToHz(channel.Frequency());
-     Frontend.inversion = fe_spectral_inversion_t(channel.Inversion());
-     Frontend.delsys.dvbc.symbol_rate = channel.Srate() * 1000UL;
-     Frontend.delsys.dvbc.fec = dvbfe_fec(channel.CoderateH());
-     Frontend.delsys.dvbc.modulation = dvbfe_modulation(channel.Modulation());
+  else if (frontendType & (SYS_DVBC_ANNEX_AC | SYS_DVBC_ANNEX_B)) {
+//      Frontend.delivery = SYS_DVBC;
+//      Frontend.frequency = FrequencyToHz(channel.Frequency());
+//      Frontend.inversion = fe_spectral_inversion_t(channel.Inversion());
+//      Frontend.delsys.dvbc.symbol_rate = channel.Srate() * 1000UL;
+//      Frontend.delsys.dvbc.fec = dvbfe_fec(channel.CoderateH());
+//      Frontend.delsys.dvbc.modulation = dvbfe_modulation(channel.Modulation());
 
      tuneTimeout = DVBC_TUNE_TIMEOUT;
      lockTimeout = DVBC_LOCK_TIMEOUT;
 
-     dvbfe_info feinfo;
+     //dvbfe_info feinfo;
      //feinfo.delivery = Frontend.delivery;
-     CHECK(ioctl(fd_frontend, DVBFE_GET_INFO, &feinfo)); //switch system
+     //CHECK(ioctl(fd_frontend, DVBFE_GET_INFO, &feinfo)); //switch system
      }
-  else if (frontendType & DVBFE_DELSYS_DVBT) {
-     Frontend.delivery = DVBFE_DELSYS_DVBT;
-     Frontend.frequency = FrequencyToHz(channel.Frequency());
-     Frontend.inversion = fe_spectral_inversion_t(channel.Inversion());
-     Frontend.delsys.dvbt.bandwidth = dvbfe_bandwidth(channel.Bandwidth());
-     Frontend.delsys.dvbt.code_rate_HP = dvbfe_fec(channel.CoderateH());
-     Frontend.delsys.dvbt.code_rate_LP = dvbfe_fec(channel.CoderateL());
-     Frontend.delsys.dvbt.constellation = dvbfe_modulation(channel.Modulation());
-     Frontend.delsys.dvbt.transmission_mode = dvbfe_transmission_mode(channel.Transmission());
-     Frontend.delsys.dvbt.guard_interval = dvbfe_guard_interval(channel.Guard());
-     Frontend.delsys.dvbt.hierarchy = dvbfe_hierarchy(channel.Hierarchy());
-     Frontend.delsys.dvbt.alpha = dvbfe_alpha(channel.Alpha());
-     Frontend.delsys.dvbt.priority = dvbfe_stream_priority(channel.Priority());
+  else if (frontendType & SYS_DVBT) {
+//      Frontend.delivery = SYS_DVBT;
+//      Frontend.frequency = FrequencyToHz(channel.Frequency());
+//      Frontend.inversion = fe_spectral_inversion_t(channel.Inversion());
+//      Frontend.delsys.dvbt.bandwidth = dvbfe_bandwidth(channel.Bandwidth());
+//      Frontend.delsys.dvbt.code_rate_HP = dvbfe_fec(channel.CoderateH());
+//      Frontend.delsys.dvbt.code_rate_LP = dvbfe_fec(channel.CoderateL());
+//      Frontend.delsys.dvbt.constellation = dvbfe_modulation(channel.Modulation());
+//      Frontend.delsys.dvbt.transmission_mode = dvbfe_transmission_mode(channel.Transmission());
+//      Frontend.delsys.dvbt.guard_interval = dvbfe_guard_interval(channel.Guard());
+//      Frontend.delsys.dvbt.hierarchy = dvbfe_hierarchy(channel.Hierarchy());
+//      Frontend.delsys.dvbt.alpha = dvbfe_alpha(channel.Alpha());
+//      Frontend.delsys.dvbt.priority = dvbfe_stream_priority(channel.Priority());
 
      tuneTimeout = DVBT_TUNE_TIMEOUT;
      lockTimeout = DVBT_LOCK_TIMEOUT;
 
-     dvbfe_info feinfo;
+     //dvbfe_info feinfo;
      //feinfo.delivery = Frontend.delivery;
-     CHECK(ioctl(fd_frontend, DVBFE_GET_INFO, &feinfo)); //switch system
+     //CHECK(ioctl(fd_frontend, DVBFE_GET_INFO, &feinfo)); //switch system
      }
   else {
      esyslog("ERROR: attempt to set channel with unknown DVB frontend type");
      return false;
      }
-  if (ioctl(fd_frontend, DVBFE_SET_PARAMS, &Frontend) < 0) {
+  if (ioctl(fd_frontend, FE_SET_PROPERTY, &cmdseq) < 0) {
      esyslog("ERROR: frontend %d: %m", cardIndex);
      return false;
      }
@@ -397,7 +419,7 @@
 {
   ciAdapter = NULL;
   dvbTuner = NULL;
-  frontendType = DVBFE_DELSYS_DUMMY;
+  frontendType = SYS_DVBS;
   numProvidedSystems = 0;
   spuDecoder = NULL;
   digitalAudio = false;
@@ -460,7 +482,18 @@
   // We only check the devices that must be present - the others will be checked before accessing them://XXX
 
   if (fd_frontend >= 0) {
-     if (ioctl(fd_frontend, DVBFE_GET_DELSYS, &frontendType) >= 0) {
+//     if (ioctl(fd_frontend, DVBFE_GET_DELSYS, &frontendType) >= 0) {
+     dvb_frontend_info feinfo;
+     fe_type fetype;
+     if (ioctl(fd_frontend, FE_GET_INFO, &feinfo) >= 0) {
+        fetype =  feinfo.type;
+        if (fetype == FE_QPSK)
+            frontendType = SYS_DVBS;
+        if (fetype == FE_QAM)
+            frontendType = SYS_DVBT;
+        if (fetype == FE_ATSC)
+            frontendType = SYS_ATSC;
+
         const char **DeliverySystem = DeliverySystems;
         cString ds;
         for (int i = 0; i < 32; i++) {
@@ -800,9 +833,9 @@
 {
   int type = Source & cSource::st_Mask;
   return type == cSource::stNone
-      || type == cSource::stCable && (frontendType & DVBFE_DELSYS_DVBC)
-      || type == cSource::stSat   && (frontendType & (DVBFE_DELSYS_DVBS | DVBFE_DELSYS_DVBS2))
-      || type == cSource::stTerr  && (frontendType & DVBFE_DELSYS_DVBT);
+      || type == cSource::stCable && (frontendType & (SYS_DVBC_ANNEX_AC | SYS_DVBC_ANNEX_B))
+      || type == cSource::stSat   && (frontendType & (SYS_DVBS | SYS_DVBS2))
+      || type == cSource::stTerr  && (frontendType & SYS_DVBT);
 }
 
 bool cDvbDevice::ProvidesTransponder(const cChannel *Channel) const
diff -Naur 1/dvbdevice.h 2/dvbdevice.h
--- 1/dvbdevice.h	2008-09-28 13:17:43.000000000 +0300
+++ 2/dvbdevice.h	2008-09-28 10:55:55.000000000 +0300
@@ -15,9 +15,9 @@
 #include "device.h"
 #include "dvbspu.h"
 
-#if DVB_API_VERSION != 3 || DVB_API_VERSION_MINOR != 3
-#error VDR requires Linux DVB driver API version 3.3!
-#endif
+//#if DVB_API_VERSION != 3 || DVB_API_VERSION_MINOR != 3
+//#error VDR requires Linux DVB driver API version 3.3!
+//#endif
 
 #define MAXDVBDEVICES  8
 
@@ -35,7 +35,7 @@
          ///< Must be called before accessing any DVB functions.
          ///< \return True if any devices are available.
 private:
-  dvbfe_delsys frontendType;
+  fe_delivery_system frontendType;
   int numProvidedSystems;
   int fd_osd, fd_audio, fd_video, fd_dvr, fd_stc, fd_ca;
 protected:
diff -Naur 1/menu.c 2/menu.c
--- 1/menu.c	2008-04-12 14:37:17.000000000 +0300
+++ 2/menu.c	2008-09-28 13:02:50.000000000 +0300
@@ -252,8 +252,8 @@
   ST("  T")  Add(new cMenuEditMapItem( tr("Transmission"), &data.transmission, TransmissionValues));
   ST("  T")  Add(new cMenuEditMapItem( tr("Guard"),        &data.guard,        GuardValues));
   ST("  T")  Add(new cMenuEditMapItem( tr("Hierarchy"),    &data.hierarchy,    HierarchyValues));
-  ST("  T")  Add(new cMenuEditMapItem( tr("Alpha"),        &data.alpha,        AlphaValues));
-  ST("  T")  Add(new cMenuEditMapItem( tr("Priority"),     &data.priority,     PriorityValues));
+//  ST("  T")  Add(new cMenuEditMapItem( tr("Alpha"),        &data.alpha,        AlphaValues));
+//  ST("  T")  Add(new cMenuEditMapItem( tr("Priority"),     &data.priority,     PriorityValues));
   ST(" S ")  Add(new cMenuEditMapItem( tr("Rolloff"),      &data.rollOff,      RollOffValues));
 
   SetCurrent(Get(current));

--Boundary-00=_zE23Ib3yN+qYQMV
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--Boundary-00=_zE23Ib3yN+qYQMV--
