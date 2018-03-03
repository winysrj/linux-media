Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:47392 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751896AbeCCPQT (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 3 Mar 2018 10:16:19 -0500
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Andy Walls <awalls@md.metrocast.net>,
        Matthias Schwarzott <zzam@gentoo.org>,
        Bhumika Goyal <bhumirks@gmail.com>
Subject: [PATCH 1/2] media: s5h1409: fix a typo on one of its enum values
Date: Sat,  3 Mar 2018 12:16:11 -0300
Message-Id: <0728180f1e956d290122b3c430632fc352293adb.1520090161.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There is a typo there: continous wer spelled incorrectly.

Fix it with this script:

for i in $(git grep -l S5H1409_MPEGTIMING_CONTINOUS_NONINVERTING_CLOCK); do
	sed s,S5H1409_MPEGTIMING_CONTINOUS_NONINVERTING_CLOCK,S5H1409_MPEGTIMING_CONTINUOUS_NONINVERTING_CLOCK,g -i $i
done

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/dvb-frontends/s5h1409.c   |  2 +-
 drivers/media/dvb-frontends/s5h1409.h   |  2 +-
 drivers/media/pci/cx18/cx18-dvb.c       |  2 +-
 drivers/media/pci/cx23885/cx23885-dvb.c | 12 ++++++------
 drivers/media/pci/cx88/cx88-dvb.c       |  4 ++--
 drivers/media/usb/em28xx/em28xx-dvb.c   |  2 +-
 6 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/media/dvb-frontends/s5h1409.c b/drivers/media/dvb-frontends/s5h1409.c
index aced6a956ec5..a06d5ba4519a 100644
--- a/drivers/media/dvb-frontends/s5h1409.c
+++ b/drivers/media/dvb-frontends/s5h1409.c
@@ -685,7 +685,7 @@ static int s5h1409_set_mpeg_timing(struct dvb_frontend *fe, int mode)
 	case S5H1409_MPEGTIMING_CONTINOUS_INVERTING_CLOCK:
 		val |= 0x0000;
 		break;
-	case S5H1409_MPEGTIMING_CONTINOUS_NONINVERTING_CLOCK:
+	case S5H1409_MPEGTIMING_CONTINUOUS_NONINVERTING_CLOCK:
 		dprintk("%s(%d) Mode1 or Defaulting\n", __func__, mode);
 		val |= 0x1000;
 		break;
diff --git a/drivers/media/dvb-frontends/s5h1409.h b/drivers/media/dvb-frontends/s5h1409.h
index b38557c451b9..14632f970f52 100644
--- a/drivers/media/dvb-frontends/s5h1409.h
+++ b/drivers/media/dvb-frontends/s5h1409.h
@@ -53,7 +53,7 @@ struct s5h1409_config {
 
 	/* MPEG signal timing */
 #define S5H1409_MPEGTIMING_CONTINOUS_INVERTING_CLOCK       0
-#define S5H1409_MPEGTIMING_CONTINOUS_NONINVERTING_CLOCK    1
+#define S5H1409_MPEGTIMING_CONTINUOUS_NONINVERTING_CLOCK    1
 #define S5H1409_MPEGTIMING_NONCONTINOUS_INVERTING_CLOCK    2
 #define S5H1409_MPEGTIMING_NONCONTINOUS_NONINVERTING_CLOCK 3
 	u16 mpeg_timing;
diff --git a/drivers/media/pci/cx18/cx18-dvb.c b/drivers/media/pci/cx18/cx18-dvb.c
index 53f4d6bf81fb..c9a13795c51b 100644
--- a/drivers/media/pci/cx18/cx18-dvb.c
+++ b/drivers/media/pci/cx18/cx18-dvb.c
@@ -72,7 +72,7 @@ static struct s5h1409_config hauppauge_hvr1600_config = {
 	.qam_if        = 44000,
 	.inversion     = S5H1409_INVERSION_OFF,
 	.status_mode   = S5H1409_DEMODLOCKING,
-	.mpeg_timing   = S5H1409_MPEGTIMING_CONTINOUS_NONINVERTING_CLOCK,
+	.mpeg_timing   = S5H1409_MPEGTIMING_CONTINUOUS_NONINVERTING_CLOCK,
 	.hvr1600_opt   = S5H1409_HVR1600_OPTIMIZE
 };
 
diff --git a/drivers/media/pci/cx23885/cx23885-dvb.c b/drivers/media/pci/cx23885/cx23885-dvb.c
index 700422b538c0..47917fb714db 100644
--- a/drivers/media/pci/cx23885/cx23885-dvb.c
+++ b/drivers/media/pci/cx23885/cx23885-dvb.c
@@ -193,7 +193,7 @@ static struct s5h1409_config hauppauge_generic_config = {
 	.qam_if        = 44000,
 	.inversion     = S5H1409_INVERSION_OFF,
 	.status_mode   = S5H1409_DEMODLOCKING,
-	.mpeg_timing   = S5H1409_MPEGTIMING_CONTINOUS_NONINVERTING_CLOCK,
+	.mpeg_timing   = S5H1409_MPEGTIMING_CONTINUOUS_NONINVERTING_CLOCK,
 };
 
 static struct tda10048_config hauppauge_hvr1200_config = {
@@ -225,7 +225,7 @@ static struct s5h1409_config hauppauge_ezqam_config = {
 	.qam_if        = 4000,
 	.inversion     = S5H1409_INVERSION_ON,
 	.status_mode   = S5H1409_DEMODLOCKING,
-	.mpeg_timing   = S5H1409_MPEGTIMING_CONTINOUS_NONINVERTING_CLOCK,
+	.mpeg_timing   = S5H1409_MPEGTIMING_CONTINUOUS_NONINVERTING_CLOCK,
 };
 
 static struct s5h1409_config hauppauge_hvr1800lp_config = {
@@ -235,7 +235,7 @@ static struct s5h1409_config hauppauge_hvr1800lp_config = {
 	.qam_if        = 44000,
 	.inversion     = S5H1409_INVERSION_OFF,
 	.status_mode   = S5H1409_DEMODLOCKING,
-	.mpeg_timing   = S5H1409_MPEGTIMING_CONTINOUS_NONINVERTING_CLOCK,
+	.mpeg_timing   = S5H1409_MPEGTIMING_CONTINUOUS_NONINVERTING_CLOCK,
 };
 
 static struct s5h1409_config hauppauge_hvr1500_config = {
@@ -244,7 +244,7 @@ static struct s5h1409_config hauppauge_hvr1500_config = {
 	.gpio          = S5H1409_GPIO_OFF,
 	.inversion     = S5H1409_INVERSION_OFF,
 	.status_mode   = S5H1409_DEMODLOCKING,
-	.mpeg_timing   = S5H1409_MPEGTIMING_CONTINOUS_NONINVERTING_CLOCK,
+	.mpeg_timing   = S5H1409_MPEGTIMING_CONTINUOUS_NONINVERTING_CLOCK,
 };
 
 static struct mt2131_config hauppauge_generic_tunerconfig = {
@@ -264,7 +264,7 @@ static struct s5h1409_config hauppauge_hvr1500q_config = {
 	.qam_if        = 44000,
 	.inversion     = S5H1409_INVERSION_OFF,
 	.status_mode   = S5H1409_DEMODLOCKING,
-	.mpeg_timing   = S5H1409_MPEGTIMING_CONTINOUS_NONINVERTING_CLOCK,
+	.mpeg_timing   = S5H1409_MPEGTIMING_CONTINUOUS_NONINVERTING_CLOCK,
 };
 
 static struct s5h1409_config dvico_s5h1409_config = {
@@ -274,7 +274,7 @@ static struct s5h1409_config dvico_s5h1409_config = {
 	.qam_if        = 44000,
 	.inversion     = S5H1409_INVERSION_OFF,
 	.status_mode   = S5H1409_DEMODLOCKING,
-	.mpeg_timing   = S5H1409_MPEGTIMING_CONTINOUS_NONINVERTING_CLOCK,
+	.mpeg_timing   = S5H1409_MPEGTIMING_CONTINUOUS_NONINVERTING_CLOCK,
 };
 
 static struct s5h1411_config dvico_s5h1411_config = {
diff --git a/drivers/media/pci/cx88/cx88-dvb.c b/drivers/media/pci/cx88/cx88-dvb.c
index 49a335f4603e..20a3d3e31ab7 100644
--- a/drivers/media/pci/cx88/cx88-dvb.c
+++ b/drivers/media/pci/cx88/cx88-dvb.c
@@ -567,7 +567,7 @@ static const struct s5h1409_config dvico_hdtv5_pci_nano_config = {
 	.gpio          = S5H1409_GPIO_OFF,
 	.inversion     = S5H1409_INVERSION_OFF,
 	.status_mode   = S5H1409_DEMODLOCKING,
-	.mpeg_timing   = S5H1409_MPEGTIMING_CONTINOUS_NONINVERTING_CLOCK,
+	.mpeg_timing   = S5H1409_MPEGTIMING_CONTINUOUS_NONINVERTING_CLOCK,
 };
 
 static const struct s5h1409_config kworld_atsc_120_config = {
@@ -576,7 +576,7 @@ static const struct s5h1409_config kworld_atsc_120_config = {
 	.gpio	       = S5H1409_GPIO_OFF,
 	.inversion     = S5H1409_INVERSION_OFF,
 	.status_mode   = S5H1409_DEMODLOCKING,
-	.mpeg_timing   = S5H1409_MPEGTIMING_CONTINOUS_NONINVERTING_CLOCK,
+	.mpeg_timing   = S5H1409_MPEGTIMING_CONTINUOUS_NONINVERTING_CLOCK,
 };
 
 static const struct xc5000_config pinnacle_pctv_hd_800i_tuner_config = {
diff --git a/drivers/media/usb/em28xx/em28xx-dvb.c b/drivers/media/usb/em28xx/em28xx-dvb.c
index 435c2dc31e90..f188b5ff31b7 100644
--- a/drivers/media/usb/em28xx/em28xx-dvb.c
+++ b/drivers/media/usb/em28xx/em28xx-dvb.c
@@ -358,7 +358,7 @@ static struct s5h1409_config em28xx_s5h1409_with_xc3028 = {
 	.gpio          = S5H1409_GPIO_OFF,
 	.inversion     = S5H1409_INVERSION_OFF,
 	.status_mode   = S5H1409_DEMODLOCKING,
-	.mpeg_timing   = S5H1409_MPEGTIMING_CONTINOUS_NONINVERTING_CLOCK
+	.mpeg_timing   = S5H1409_MPEGTIMING_CONTINUOUS_NONINVERTING_CLOCK
 };
 
 static struct tda18271_std_map kworld_a340_std_map = {
-- 
2.14.3
