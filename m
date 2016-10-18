Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:51660 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935657AbcJRUqY (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 18 Oct 2016 16:46:24 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Erik Andren <erik.andren@gmail.com>,
        Brian Johnson <brijohn@gmail.com>, Antonio Ospite <ao2@ao2.it>,
        Wolfram Sang <wsa-dev@sang-engineering.com>,
        Oliver Neukum <oneukum@suse.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Wesley Post <pa4wdh@xs4all.nl>,
        Bhaktipriya Shridhar <bhaktipriya96@gmail.com>
Subject: [PATCH v2 38/58] gspca: don't break long lines
Date: Tue, 18 Oct 2016 18:45:50 -0200
Message-Id: <c67ce1137463b52a152b42e28150df777dc9a922.1476822925.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1476822924.git.mchehab@s-opensource.com>
References: <cover.1476822924.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1476822924.git.mchehab@s-opensource.com>
References: <cover.1476822924.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Due to the 80-cols restrictions, and latter due to checkpatch
warnings, several strings were broken into multiple lines. This
is not considered a good practice anymore, as it makes harder
to grep for strings at the source code.

As we're right now fixing other drivers due to KERN_CONT, we need
to be able to identify what printk strings don't end with a "\n".
It is a way easier to detect those if we don't break long lines.

So, join those continuation lines.

The patch was generated via the script below, and manually
adjusted if needed.

</script>
use Text::Tabs;
while (<>) {
	if ($next ne "") {
		$c=$_;
		if ($c =~ /^\s+\"(.*)/) {
			$c2=$1;
			$next =~ s/\"\n$//;
			$n = expand($next);
			$funpos = index($n, '(');
			$pos = index($c2, '",');
			if ($funpos && $pos > 0) {
				$s1 = substr $c2, 0, $pos + 2;
				$s2 = ' ' x ($funpos + 1) . substr $c2, $pos + 2;
				$s2 =~ s/^\s+//;

				$s2 = ' ' x ($funpos + 1) . $s2 if ($s2 ne "");

				print unexpand("$next$s1\n");
				print unexpand("$s2\n") if ($s2 ne "");
			} else {
				print "$next$c2\n";
			}
			$next="";
			next;
		} else {
			print $next;
		}
		$next="";
	} else {
		if (m/\"$/) {
			if (!m/\\n\"$/) {
				$next=$_;
				next;
			}
		}
	}
	print $_;
}
</script>

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/usb/gspca/gspca.c            |  3 +--
 drivers/media/usb/gspca/m5602/m5602_core.c | 11 ++++-------
 drivers/media/usb/gspca/mr97310a.c         |  3 +--
 drivers/media/usb/gspca/ov519.c            |  3 +--
 drivers/media/usb/gspca/pac207.c           |  4 ++--
 drivers/media/usb/gspca/pac7302.c          |  3 +--
 drivers/media/usb/gspca/sn9c20x.c          |  6 ++----
 drivers/media/usb/gspca/sq905.c            |  3 +--
 drivers/media/usb/gspca/sq905c.c           |  4 ++--
 drivers/media/usb/gspca/stv06xx/stv06xx.c  |  9 +++------
 drivers/media/usb/gspca/sunplus.c          |  3 +--
 drivers/media/usb/gspca/topro.c            |  3 +--
 drivers/media/usb/gspca/zc3xx.c            |  3 +--
 13 files changed, 21 insertions(+), 37 deletions(-)

diff --git a/drivers/media/usb/gspca/gspca.c b/drivers/media/usb/gspca/gspca.c
index af2395a76d8b..fa2cbb981905 100644
--- a/drivers/media/usb/gspca/gspca.c
+++ b/drivers/media/usb/gspca/gspca.c
@@ -201,8 +201,7 @@ static int alloc_and_submit_int_urb(struct gspca_dev *gspca_dev,
 
 	buffer_len = le16_to_cpu(ep->wMaxPacketSize);
 	interval = ep->bInterval;
-	PDEBUG(D_CONF, "found int in endpoint: 0x%x, "
-		"buffer_len=%u, interval=%u",
+	PDEBUG(D_CONF, "found int in endpoint: 0x%x, buffer_len=%u, interval=%u",
 		ep->bEndpointAddress, buffer_len, interval);
 
 	dev = gspca_dev->dev;
diff --git a/drivers/media/usb/gspca/m5602/m5602_core.c b/drivers/media/usb/gspca/m5602/m5602_core.c
index e4a0658e3f83..f1dcd9021983 100644
--- a/drivers/media/usb/gspca/m5602/m5602_core.c
+++ b/drivers/media/usb/gspca/m5602/m5602_core.c
@@ -154,8 +154,8 @@ int m5602_read_sensor(struct sd *sd, const u8 address,
 
 		err = m5602_read_bridge(sd, M5602_XB_I2C_DATA, &(i2c_data[i]));
 
-		PDEBUG(D_CONF, "Reading sensor register "
-			       "0x%x containing 0x%x ", address, *i2c_data);
+		PDEBUG(D_CONF, "Reading sensor register 0x%x containing 0x%x ",
+		       address, *i2c_data);
 	}
 	return err;
 }
@@ -441,13 +441,10 @@ MODULE_DESCRIPTION(DRIVER_DESC);
 MODULE_LICENSE("GPL");
 module_param(force_sensor, int, S_IRUGO | S_IWUSR);
 MODULE_PARM_DESC(force_sensor,
-		"forces detection of a sensor, "
-		"1 = OV9650, 2 = S5K83A, 3 = S5K4AA, "
-		"4 = MT9M111, 5 = PO1030, 6 = OV7660");
+		"forces detection of a sensor, 1 = OV9650, 2 = S5K83A, 3 = S5K4AA, 4 = MT9M111, 5 = PO1030, 6 = OV7660");
 
 module_param(dump_bridge, bool, S_IRUGO | S_IWUSR);
 MODULE_PARM_DESC(dump_bridge, "Dumps all usb bridge registers at startup");
 
 module_param(dump_sensor, bool, S_IRUGO | S_IWUSR);
-MODULE_PARM_DESC(dump_sensor, "Dumps all usb sensor registers "
-		"at startup providing a sensor is found");
+MODULE_PARM_DESC(dump_sensor, "Dumps all usb sensor registers at startup providing a sensor is found");
diff --git a/drivers/media/usb/gspca/mr97310a.c b/drivers/media/usb/gspca/mr97310a.c
index f006e29ca019..6dfb364094ec 100644
--- a/drivers/media/usb/gspca/mr97310a.c
+++ b/drivers/media/usb/gspca/mr97310a.c
@@ -72,8 +72,7 @@
 #define MR97310A_MIN_CLOCKDIV_MAX	8
 #define MR97310A_MIN_CLOCKDIV_DEFAULT	3
 
-MODULE_AUTHOR("Kyle Guinn <elyk03@gmail.com>,"
-	      "Theodore Kilgore <kilgota@auburn.edu>");
+MODULE_AUTHOR("Kyle Guinn <elyk03@gmail.com>,Theodore Kilgore <kilgota@auburn.edu>");
 MODULE_DESCRIPTION("GSPCA/Mars-Semi MR97310A USB Camera Driver");
 MODULE_LICENSE("GPL");
 
diff --git a/drivers/media/usb/gspca/ov519.c b/drivers/media/usb/gspca/ov519.c
index 965372a5ff2f..4dbca54cf2a8 100644
--- a/drivers/media/usb/gspca/ov519.c
+++ b/drivers/media/usb/gspca/ov519.c
@@ -4326,8 +4326,7 @@ static void ov511_pkt_scan(struct gspca_dev *gspca_dev,
 			/* Frame end */
 			if ((in[9] + 1) * 8 != gspca_dev->pixfmt.width ||
 			    (in[10] + 1) * 8 != gspca_dev->pixfmt.height) {
-				PERR("Invalid frame size, got: %dx%d,"
-					" requested: %dx%d\n",
+				PERR("Invalid frame size, got: %dx%d, requested: %dx%d\n",
 					(in[9] + 1) * 8, (in[10] + 1) * 8,
 					gspca_dev->pixfmt.width,
 					gspca_dev->pixfmt.height);
diff --git a/drivers/media/usb/gspca/pac207.c b/drivers/media/usb/gspca/pac207.c
index 07529e5a0c56..51e11248bbb8 100644
--- a/drivers/media/usb/gspca/pac207.c
+++ b/drivers/media/usb/gspca/pac207.c
@@ -179,8 +179,8 @@ static int sd_config(struct gspca_dev *gspca_dev,
 	}
 
 	PDEBUG(D_PROBE,
-		"Pixart PAC207BCA Image Processor and Control Chip detected"
-		" (vid/pid 0x%04X:0x%04X)", id->idVendor, id->idProduct);
+		"Pixart PAC207BCA Image Processor and Control Chip detected (vid/pid 0x%04X:0x%04X)",
+		id->idVendor, id->idProduct);
 
 	cam = &gspca_dev->cam;
 	cam->cam_mode = sif_mode;
diff --git a/drivers/media/usb/gspca/pac7302.c b/drivers/media/usb/gspca/pac7302.c
index 8b08bd0172f4..be07a24c4518 100644
--- a/drivers/media/usb/gspca/pac7302.c
+++ b/drivers/media/usb/gspca/pac7302.c
@@ -105,8 +105,7 @@
 #define PAC7302_EXPOSURE_DEFAULT	 66 /* 33 ms / 30 fps */
 #define PAC7302_EXPOSURE_KNEE		133 /* 66 ms / 15 fps */
 
-MODULE_AUTHOR("Jean-Francois Moine <http://moinejf.free.fr>, "
-		"Thomas Kaiser thomas@kaiser-linux.li");
+MODULE_AUTHOR("Jean-Francois Moine <http://moinejf.free.fr>, Thomas Kaiser thomas@kaiser-linux.li");
 MODULE_DESCRIPTION("Pixart PAC7302");
 MODULE_LICENSE("GPL");
 
diff --git a/drivers/media/usb/gspca/sn9c20x.c b/drivers/media/usb/gspca/sn9c20x.c
index 10269dad9d20..e7430b06526a 100644
--- a/drivers/media/usb/gspca/sn9c20x.c
+++ b/drivers/media/usb/gspca/sn9c20x.c
@@ -29,8 +29,7 @@
 
 #include <linux/dmi.h>
 
-MODULE_AUTHOR("Brian Johnson <brijohn@gmail.com>, "
-		"microdia project <microdia@googlegroups.com>");
+MODULE_AUTHOR("Brian Johnson <brijohn@gmail.com>, microdia project <microdia@googlegroups.com>");
 MODULE_DESCRIPTION("GSPCA/SN9C20X USB Camera Driver");
 MODULE_LICENSE("GPL");
 
@@ -1948,8 +1947,7 @@ static int sd_isoc_init(struct gspca_dev *gspca_dev)
 		intf = usb_ifnum_to_if(gspca_dev->dev, gspca_dev->iface);
 
 		if (intf->num_altsetting != 9) {
-			pr_warn("sn9c20x camera with unknown number of alt "
-				"settings (%d), please report!\n",
+			pr_warn("sn9c20x camera with unknown number of alt settings (%d), please report!\n",
 				intf->num_altsetting);
 			gspca_dev->alt = intf->num_altsetting;
 			return 0;
diff --git a/drivers/media/usb/gspca/sq905.c b/drivers/media/usb/gspca/sq905.c
index a7ae0ec9fa91..9424c33f0ddb 100644
--- a/drivers/media/usb/gspca/sq905.c
+++ b/drivers/media/usb/gspca/sq905.c
@@ -41,8 +41,7 @@
 #include <linux/slab.h>
 #include "gspca.h"
 
-MODULE_AUTHOR("Adam Baker <linux@baker-net.org.uk>, "
-		"Theodore Kilgore <kilgota@auburn.edu>");
+MODULE_AUTHOR("Adam Baker <linux@baker-net.org.uk>, Theodore Kilgore <kilgota@auburn.edu>");
 MODULE_DESCRIPTION("GSPCA/SQ905 USB Camera Driver");
 MODULE_LICENSE("GPL");
 
diff --git a/drivers/media/usb/gspca/sq905c.c b/drivers/media/usb/gspca/sq905c.c
index aa21edc9502d..e02b8c1d06a2 100644
--- a/drivers/media/usb/gspca/sq905c.c
+++ b/drivers/media/usb/gspca/sq905c.c
@@ -210,8 +210,8 @@ static int sd_config(struct gspca_dev *gspca_dev,
 	int ret;
 
 	PDEBUG(D_PROBE,
-		"SQ9050 camera detected"
-		" (vid/pid 0x%04X:0x%04X)", id->idVendor, id->idProduct);
+	       "SQ9050 camera detected (vid/pid 0x%04X:0x%04X)",
+	       id->idVendor, id->idProduct);
 
 	ret = sq905c_command(gspca_dev, SQ905C_GET_ID, 0);
 	if (ret < 0) {
diff --git a/drivers/media/usb/gspca/stv06xx/stv06xx.c b/drivers/media/usb/gspca/stv06xx/stv06xx.c
index 6ac93d8db427..562ddb050cfd 100644
--- a/drivers/media/usb/gspca/stv06xx/stv06xx.c
+++ b/drivers/media/usb/gspca/stv06xx/stv06xx.c
@@ -412,8 +412,7 @@ static void stv06xx_pkt_scan(struct gspca_dev *gspca_dev,
 		len -= 4;
 
 		if (len < chunk_len) {
-			PERR("URB packet length is smaller"
-				" than the specified chunk length");
+			PERR("URB packet length is smaller than the specified chunk length");
 			gspca_dev->last_packet_type = DISCARD_PACKET;
 			return;
 		}
@@ -455,8 +454,7 @@ static void stv06xx_pkt_scan(struct gspca_dev *gspca_dev,
 				sd->to_skip = gspca_dev->pixfmt.width * 4;
 
 			if (chunk_len)
-				PERR("Chunk length is "
-					      "non-zero on a SOF");
+				PERR("Chunk length is non-zero on a SOF");
 			break;
 
 		case 0x8002:
@@ -469,8 +467,7 @@ static void stv06xx_pkt_scan(struct gspca_dev *gspca_dev,
 					NULL, 0);
 
 			if (chunk_len)
-				PERR("Chunk length is "
-					      "non-zero on a EOF");
+				PERR("Chunk length is non-zero on a EOF");
 			break;
 
 		case 0x0005:
diff --git a/drivers/media/usb/gspca/sunplus.c b/drivers/media/usb/gspca/sunplus.c
index 46c9f2229a18..38dc9e7aa313 100644
--- a/drivers/media/usb/gspca/sunplus.c
+++ b/drivers/media/usb/gspca/sunplus.c
@@ -368,8 +368,7 @@ static void spca504_read_info(struct gspca_dev *gspca_dev)
 		info[i] = gspca_dev->usb_buf[0];
 	}
 	PDEBUG(D_STREAM,
-		"Read info: %d %d %d %d %d %d."
-		" Should be 1,0,2,2,0,0",
+		"Read info: %d %d %d %d %d %d. Should be 1,0,2,2,0,0",
 		info[0], info[1], info[2],
 		info[3], info[4], info[5]);
 }
diff --git a/drivers/media/usb/gspca/topro.c b/drivers/media/usb/gspca/topro.c
index 15eb069ab60b..983fc6b500af 100644
--- a/drivers/media/usb/gspca/topro.c
+++ b/drivers/media/usb/gspca/topro.c
@@ -24,8 +24,7 @@
 #include "gspca.h"
 
 MODULE_DESCRIPTION("Topro TP6800/6810 gspca webcam driver");
-MODULE_AUTHOR("Jean-Francois Moine <http://moinejf.free.fr>, "
-		"Anders Blomdell <anders.blomdell@control.lth.se>");
+MODULE_AUTHOR("Jean-Francois Moine <http://moinejf.free.fr>, Anders Blomdell <anders.blomdell@control.lth.se>");
 MODULE_LICENSE("GPL");
 
 static int force_sensor = -1;
diff --git a/drivers/media/usb/gspca/zc3xx.c b/drivers/media/usb/gspca/zc3xx.c
index 5f7254d2bc9a..d5d8c7e81762 100644
--- a/drivers/media/usb/gspca/zc3xx.c
+++ b/drivers/media/usb/gspca/zc3xx.c
@@ -25,8 +25,7 @@
 #include "gspca.h"
 #include "jpeg.h"
 
-MODULE_AUTHOR("Jean-Francois Moine <http://moinejf.free.fr>, "
-		"Serge A. Suchkov <Serge.A.S@tochka.ru>");
+MODULE_AUTHOR("Jean-Francois Moine <http://moinejf.free.fr>, Serge A. Suchkov <Serge.A.S@tochka.ru>");
 MODULE_DESCRIPTION("GSPCA ZC03xx/VC3xx USB Camera Driver");
 MODULE_LICENSE("GPL");
 
-- 
2.7.4


