Return-path: <linux-media-owner@vger.kernel.org>
Received: from www46.your-server.de ([213.133.104.46]:59798 "EHLO
	www46.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751842Ab1IWT2Y (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Sep 2011 15:28:24 -0400
Received: from [217.162.186.144] (helo=dagobah)
	by www46.your-server.de with esmtpsa (TLSv1:AES256-SHA:256)
	(Exim 4.72)
	(envelope-from <root@butcher.gotdns.org>)
	id 1R7B72-0007mD-S6
	for linux-media@vger.kernel.org; Fri, 23 Sep 2011 21:08:40 +0200
Received: from root by dagobah with local (Exim 4.76)
	(envelope-from <root@dagobah>)
	id 1R7B6w-0000Pk-Tb
	for linux-media@vger.kernel.org; Fri, 23 Sep 2011 21:08:34 +0200
Date: Fri, 23 Sep 2011 21:08:34 +0200
From: Patrick Ruckstuhl <patrick@tario.org>
To: linux-media@vger.kernel.org
Subject: [PATCH] trying to add PAL support to SAA7164
Message-ID: <20110923190834.GA1263@dagobah>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="LZvS9be/3tNcYl/X"
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--LZvS9be/3tNcYl/X
Content-Type: text/plain; charset=us-ascii
Content-Description: pal patch for saa7164
Content-Disposition: inline

Hello,

I have a saa7164 card and am using it with PAL.
To get this working I started from the patch by Julian Scheel

http://www.spinics.net/lists/linux-media/msg27603.html

I saw that some of the changes (added supported device) were already in
the repository. I also tried to clean up the rest of the changes a bit
but I'm a complete v4l/kernel coding beginner.

The patch applies to the current HEAD but is not yet usable as it
initializes the card to PAL per default.

Is there anyone that could help me with getting this thing in a good
state so that it could be added into the repository for others to use
it?

Thanks and Regards,
Patrick

--LZvS9be/3tNcYl/X
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="pal.patch"

diff --git a/drivers/media/video/saa7164/saa7164-api.c b/drivers/media/video/saa7164/saa7164-api.c
index 8a98ab6..8142d0f 100644
--- a/drivers/media/video/saa7164/saa7164-api.c
+++ b/drivers/media/video/saa7164/saa7164-api.c
@@ -631,7 +631,7 @@ int saa7164_api_set_dif(struct saa7164_port *port, u8 reg, u8 val)
 	dprintk(DBGLVL_API, "%s(nr=%d type=%d val=%x)\n", __func__,
 		port->nr, port->type, val);
 
-	if (port->nr == 0)
+	if (port->nr < 3)
 		mas = 0xd0;
 	else
 		mas = 0xe0;
diff --git a/drivers/media/video/saa7164/saa7164-encoder.c b/drivers/media/video/saa7164/saa7164-encoder.c
index 2fd38a0..390fa58 100644
--- a/drivers/media/video/saa7164/saa7164-encoder.c
+++ b/drivers/media/video/saa7164/saa7164-encoder.c
@@ -32,7 +32,25 @@ static struct saa7164_tvnorm saa7164_tvnorms[] = {
 	}, {
 		.name      = "NTSC-JP",
 		.id        = V4L2_STD_NTSC_M_JP,
-	}
+	}, {
+                .name      = "PAL-I",
+                .id        = V4L2_STD_PAL_I,
+	}, {
+                .name      = "PAL-M",
+                .id        = V4L2_STD_PAL_M,
+	}, {
+                .name      = "PAL-N",
+                .id        = V4L2_STD_PAL_N,
+	}, {
+                .name      = "PAL-Nc",
+                .id        = V4L2_STD_PAL_Nc,
+	}, {
+                .name      = "PAL-B",
+                .id        = V4L2_STD_PAL_B,
+	}, {
+                .name      = "PAL-DK",
+                .id        = V4L2_STD_PAL_DK,
+        }
 };
 
 static const u32 saa7164_v4l2_ctrls[] = {
@@ -1362,7 +1380,7 @@ static struct video_device saa7164_mpeg_template = {
 	.ioctl_ops     = &mpeg_ioctl_ops,
 	.minor         = -1,
 	.tvnorms       = SAA7164_NORMS,
-	.current_norm  = V4L2_STD_NTSC_M,
+	.current_norm  = V4L2_STD_PAL_B,
 };
 
 static struct video_device *saa7164_encoder_alloc(
@@ -1410,7 +1428,7 @@ int saa7164_encoder_register(struct saa7164_port *port)
 
 	/* Establish encoder defaults here */
 	/* Set default TV standard */
-	port->encodernorm = saa7164_tvnorms[0];
+	port->encodernorm = saa7164_tvnorms[6];
 	port->width = 720;
 	port->mux_input = 1; /* Composite */
 	port->video_format = EU_VIDEO_FORMAT_MPEG_2;
diff --git a/drivers/media/video/saa7164/saa7164-reg.h b/drivers/media/video/saa7164/saa7164-reg.h
index 2bbf815..b95aeaf 100644
--- a/drivers/media/video/saa7164/saa7164-reg.h
+++ b/drivers/media/video/saa7164/saa7164-reg.h
@@ -181,7 +181,7 @@
 #define TU_STANDARD_AUTO_CONTROL	0x01
 #define TU_STANDARD_NONE		0x00
 #define TU_STANDARD_NTSC_M		0x01
-#define TU_STANDARD_PAL_I		0x08
+#define TU_STANDARD_PAL_I		0x04
 #define TU_STANDARD_MANUAL		0x00
 #define TU_STANDARD_AUTO		0x01
 
diff --git a/drivers/media/video/saa7164/saa7164-vbi.c b/drivers/media/video/saa7164/saa7164-vbi.c
index e2e0341..7c40efa 100644
--- a/drivers/media/video/saa7164/saa7164-vbi.c
+++ b/drivers/media/video/saa7164/saa7164-vbi.c
@@ -28,7 +28,25 @@ static struct saa7164_tvnorm saa7164_tvnorms[] = {
 	}, {
 		.name      = "NTSC-JP",
 		.id        = V4L2_STD_NTSC_M_JP,
-	}
+	}, {
+                .name      = "PAL-I",
+                .id        = V4L2_STD_PAL_I,
+        }, {
+                .name      = "PAL-M",
+                .id        = V4L2_STD_PAL_M,
+        }, {
+                .name      = "PAL-N",
+                .id        = V4L2_STD_PAL_N,
+        }, {
+                .name      = "PAL-Nc",
+                .id        = V4L2_STD_PAL_Nc,
+        }, {
+                .name      = "PAL-B",
+                .id        = V4L2_STD_PAL_B,
+        }, {
+                .name      = "PAL-DK",
+                .id        = V4L2_STD_PAL_DK,
+        }
 };
 
 static const u32 saa7164_v4l2_ctrls[] = {
diff --git a/drivers/media/video/saa7164/saa7164.h b/drivers/media/video/saa7164/saa7164.h
index 742b341..adf8baf 100644
--- a/drivers/media/video/saa7164/saa7164.h
+++ b/drivers/media/video/saa7164/saa7164.h
@@ -115,7 +115,7 @@
 #define DBGLVL_CPU 8192
 
 #define SAA7164_NORMS \
-	(V4L2_STD_NTSC_M |  V4L2_STD_NTSC_M_JP |  V4L2_STD_NTSC_443)
+	(V4L2_STD_NTSC_M |  V4L2_STD_NTSC_M_JP |  V4L2_STD_NTSC_443 | V4L2_STD_PAL_I | V4L2_STD_PAL_M | V4L2_STD_PAL_N | V4L2_STD_PAL_Nc | V4L2_STD_PAL_B | V4L2_STD_PAL_DK)
 
 enum port_t {
 	SAA7164_MPEG_UNDEFINED = 0,

--LZvS9be/3tNcYl/X--
