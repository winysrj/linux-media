Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.gmx.net ([213.165.64.20])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <HWerner4@gmx.de>) id 1KZ692-0007jg-SW
	for linux-dvb@linuxtv.org; Fri, 29 Aug 2008 17:44:19 +0200
Date: Fri, 29 Aug 2008 17:43:42 +0200
From: "Hans Werner" <HWerner4@gmx.de>
In-Reply-To: <48B802D8.7010806@linuxtv.org>
Message-ID: <20080829154342.74800@gmx.net>
MIME-Version: 1.0
References: <20080821173909.114260@gmx.net> <20080823200531.246370@gmx.net>
	<48B78AE6.1060205@gmx.net> <48B7A60C.4050600@kipdola.com>
	<48B802D8.7010806@linuxtv.org>
To: Steven Toth <stoth@linuxtv.org>, skerit@kipdola.com, linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] [PATCH] Future of DVB-S2
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

> ... and yes, many people understand you.

:) Thanks to everyone who replied so far. I am glad people care about this.

> > We know all about the "coding in your free time" and we can only have =

> > the highest respect for that, but the drivers are completely abandonded,
> > and that's how we feel, too.
> =

> No, and that's my HVR4000 code you're talking about (and the good work =

> of Darron Broad, which was then picked up by Igor). The driver is =

> marginalized, it's not abandoned.

I hope your and Darron's drivers (http://dev.kewl.org/hauppauge) are not se=
en as
marginalized. The multifrontend (MFE) patch by you and Darron is the driver=
 that I
actually *use* for watching TV. It works nicely with Kaffeine without modif=
ication. And I,
for one, appreciate your sane approach and the simplicity of the techniques=
 you used to
add DVB-S2 support (using sysctls for the SFE driver, and wrapping two ioct=
ls to pull in
extra parameters for the MFE driver). If the kernel API is changed sensibly=
 it should be
easy and quick to adapt your drivers to fit in.
 =

> The HVR4000 situation is under review, the wheels are slowly turning.... =

If you are able to say anything about that I would be very interested.

Now, to show how simple I think all this could be, here is a PATCH implemen=
ting what
I think is the *minimal* API required to support DVB-S2.

Notes:

* same API structure, I just added some new enums and variables, nothing re=
moved
* no changes required to any existing drivers (v4l-dvb still compiles)
* no changes required to existing applications (just need to be recompiled)
* no drivers, but I think the HVR4000 MFE patch could be easily adapted

I added the fe_caps2 enum because we're running out of bits in the capabili=
ties bitfield.
More elegant would be to have separate bitfields for FEC capabilities and m=
odulation
capabilities but that would require (easy) changes to (a lot of) drivers an=
d applications.

Why should we not merge something simple like this immediately? This could =
have been done
years ago. If it takes several rounds of API upgrades to reach all the feat=
ure people want then
so be it, but a long journey begins with one step.

Regards.
Hans

diff -r a4843e1304e6 linux/include/linux/dvb/frontend.h
--- a/linux/include/linux/dvb/frontend.h	Sun Aug 24 12:28:11 2008 -0300
+++ b/linux/include/linux/dvb/frontend.h	Fri Aug 29 16:22:47 2008 +0100
@@ -36,6 +36,15 @@
 	FE_ATSC
 } fe_type_t;
 =

+typedef enum fe_standard {
+	DVBS,
+	DVBS2,
+	DVBT,
+	DVBH,
+	DVBC,
+	DSS,
+	ATSC
+} fe_standard_t;
 =

 typedef enum fe_caps {
 	FE_IS_STUPID			=3D 0,
@@ -67,6 +76,16 @@
 	FE_CAN_MUTE_TS			=3D 0x80000000  // frontend can stop spurious TS data ou=
tput
 } fe_caps_t;
 =

+typedef enum fe_caps2 {
+	FE_CAN_FEC_1_3			=3D 0x0,
+	FE_CAN_FEC_1_4			=3D 0x1,
+	FE_CAN_FEC_2_5			=3D 0x2,
+	FE_CAN_FEC_3_5			=3D 0x4,
+	FE_CAN_FEC_9_10			=3D 0x8,
+	FE_CAN_8PSK			=3D 0x10,
+	FE_CAN_16APSK			=3D 0x20,
+	FE_CAN_32APSK			=3D 0x40
+} fe_caps2_t;
 =

 struct dvb_frontend_info {
 	char       name[128];
@@ -80,6 +99,7 @@
 	__u32      symbol_rate_tolerance;	/* ppm */
 	__u32      notifier_delay;		/* DEPRECATED */
 	fe_caps_t  caps;
+	fe_caps2_t caps2;
 };
 =

 =

@@ -140,19 +160,27 @@
 typedef enum fe_code_rate {
 	FEC_NONE =3D 0,
 	FEC_1_2,
+	FEC_1_3,
+	FEC_1_4,
 	FEC_2_3,
+	FEC_2_5,
 	FEC_3_4,
+	FEC_3_5,
 	FEC_4_5,
 	FEC_5_6,
 	FEC_6_7,
 	FEC_7_8,
 	FEC_8_9,
+	FEC_9_10,
 	FEC_AUTO
 } fe_code_rate_t;
 =

 =

 typedef enum fe_modulation {
 	QPSK,
+	PSK_8,
+	APSK_16,
+	APSK_32,
 	QAM_16,
 	QAM_32,
 	QAM_64,
@@ -194,10 +222,25 @@
 	HIERARCHY_AUTO
 } fe_hierarchy_t;
 =

+typedef enum fe_rolloff {
+	ROLLOFF_035,
+	ROLLOFF_025,
+	ROLLOFF_020,
+	ROLLOFF_UNKNOWN
+} fe_rolloff_t;
+
+typedef enum fe_pilot {
+	PILOT_OFF,
+	PILOT_ON,
+	PILOT_AUTO
+} fe_pilot_t;
 =

 struct dvb_qpsk_parameters {
 	__u32		symbol_rate;  /* symbol rate in Symbols per second */
 	fe_code_rate_t	fec_inner;    /* forward error correction (see above) */
+	fe_modulation_t	modulation;   /* DVB-S2 allows modulations QPSK plus 8PSK=
,16APSK,32APSK */
+	fe_rolloff_t 	rolloff;      /* for DVB-S2*/
+	fe_pilot_t	pilot;        /* for DVB-S2*/
 };
 =

 struct dvb_qam_parameters {
@@ -225,6 +268,7 @@
 	__u32 frequency;     /* (absolute) frequency in Hz for QAM/OFDM/ATSC */
 			     /* intermediate frequency in kHz for QPSK */
 	fe_spectral_inversion_t inversion;
+	fe_standard_t           standard;   /* use to set DVBS/DVBS2/DVBT etc */
 	union {
 		struct dvb_qpsk_parameters qpsk;
 		struct dvb_qam_parameters  qam;


-- =

Release early, release often. Really, you should.

GMX Kostenlose Spiele: Einfach online spielen und Spa=DF haben mit Pastry P=
assion!
http://games.entertainment.gmx.net/de/entertainment/games/free/puzzle/61691=
96

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
