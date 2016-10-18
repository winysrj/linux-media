Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:51561 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934993AbcJRUqW (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 18 Oct 2016 16:46:22 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Julia Lawall <Julia.Lawall@lip6.fr>,
        Wolfram Sang <wsa-dev@sang-engineering.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH v2 44/58] tm6000: don't break long lines
Date: Tue, 18 Oct 2016 18:45:56 -0200
Message-Id: <79d35ee9b553127adb8c9f08bba91216dbd59043.1476822925.git.mchehab@s-opensource.com>
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
 drivers/media/usb/tm6000/tm6000-alsa.c  |  4 +---
 drivers/media/usb/tm6000/tm6000-core.c  | 14 ++++++--------
 drivers/media/usb/tm6000/tm6000-dvb.c   | 16 +++++-----------
 drivers/media/usb/tm6000/tm6000-i2c.c   |  3 +--
 drivers/media/usb/tm6000/tm6000-stds.c  |  3 +--
 drivers/media/usb/tm6000/tm6000-video.c | 18 ++++++++----------
 6 files changed, 22 insertions(+), 36 deletions(-)

diff --git a/drivers/media/usb/tm6000/tm6000-alsa.c b/drivers/media/usb/tm6000/tm6000-alsa.c
index f16fbd1f9f51..422322541af6 100644
--- a/drivers/media/usb/tm6000/tm6000-alsa.c
+++ b/drivers/media/usb/tm6000/tm6000-alsa.c
@@ -58,9 +58,7 @@ MODULE_PARM_DESC(index, "Index value for tm6000x capture interface(s).");
 MODULE_DESCRIPTION("ALSA driver module for tm5600/tm6000/tm6010 based TV cards");
 MODULE_AUTHOR("Mauro Carvalho Chehab");
 MODULE_LICENSE("GPL");
-MODULE_SUPPORTED_DEVICE("{{Trident,tm5600},"
-			"{{Trident,tm6000},"
-			"{{Trident,tm6010}");
+MODULE_SUPPORTED_DEVICE("{{Trident,tm5600},{{Trident,tm6000},{{Trident,tm6010}");
 static unsigned int debug;
 module_param(debug, int, 0644);
 MODULE_PARM_DESC(debug, "enable debug messages");
diff --git a/drivers/media/usb/tm6000/tm6000-core.c b/drivers/media/usb/tm6000/tm6000-core.c
index 7c32353c59db..8d104e5c4be3 100644
--- a/drivers/media/usb/tm6000/tm6000-core.c
+++ b/drivers/media/usb/tm6000/tm6000-core.c
@@ -602,8 +602,8 @@ int tm6000_init(struct tm6000_core *dev)
 	for (i = 0; i < size; i++) {
 		rc = tm6000_set_reg(dev, tab[i].req, tab[i].reg, tab[i].val);
 		if (rc < 0) {
-			printk(KERN_ERR "Error %i while setting req %d, "
-					"reg %d to value %d\n", rc,
+			printk(KERN_ERR "Error %i while setting req %d, reg %d to value %d\n",
+			       rc,
 					tab[i].req, tab[i].reg, tab[i].val);
 			return rc;
 		}
@@ -761,9 +761,8 @@ int tm6000_tvaudio_set_mute(struct tm6000_core *dev, u8 mute)
 		if (dev->dev_type == TM6010)
 			tm6010_set_mute_sif(dev, mute);
 		else {
-			printk(KERN_INFO "ERROR: TM5600 and TM6000 don't has"
-					" SIF audio inputs. Please check the %s"
-					" configuration.\n", dev->name);
+			printk(KERN_INFO "ERROR: TM5600 and TM6000 don't has SIF audio inputs. Please check the %s configuration.\n",
+			       dev->name);
 			return -EINVAL;
 		}
 		break;
@@ -822,9 +821,8 @@ void tm6000_set_volume(struct tm6000_core *dev, int vol)
 		if (dev->dev_type == TM6010)
 			tm6010_set_volume_sif(dev, vol);
 		else
-			printk(KERN_INFO "ERROR: TM5600 and TM6000 don't has"
-					" SIF audio inputs. Please check the %s"
-					" configuration.\n", dev->name);
+			printk(KERN_INFO "ERROR: TM5600 and TM6000 don't has SIF audio inputs. Please check the %s configuration.\n",
+			       dev->name);
 		break;
 	case TM6000_AMUX_ADC1:
 	case TM6000_AMUX_ADC2:
diff --git a/drivers/media/usb/tm6000/tm6000-dvb.c b/drivers/media/usb/tm6000/tm6000-dvb.c
index 0426b210383b..70dbaec1219e 100644
--- a/drivers/media/usb/tm6000/tm6000-dvb.c
+++ b/drivers/media/usb/tm6000/tm6000-dvb.c
@@ -35,9 +35,7 @@ MODULE_DESCRIPTION("DVB driver extension module for tm5600/6000/6010 based TV ca
 MODULE_AUTHOR("Mauro Carvalho Chehab");
 MODULE_LICENSE("GPL");
 
-MODULE_SUPPORTED_DEVICE("{{Trident, tm5600},"
-			"{{Trident, tm6000},"
-			"{{Trident, tm6010}");
+MODULE_SUPPORTED_DEVICE("{{Trident, tm5600},{{Trident, tm6000},{{Trident, tm6010}");
 
 static int debug;
 
@@ -292,13 +290,11 @@ static int register_dvb(struct tm6000_core *dev)
 			}
 
 			if (!dvb_attach(xc2028_attach, dvb->frontend, &cfg)) {
-				printk(KERN_ERR "tm6000: couldn't register "
-						"frontend (xc3028)\n");
+				printk(KERN_ERR "tm6000: couldn't register frontend (xc3028)\n");
 				ret = -EINVAL;
 				goto frontend_err;
 			}
-			printk(KERN_INFO "tm6000: XC2028/3028 asked to be "
-					 "attached to frontend!\n");
+			printk(KERN_INFO "tm6000: XC2028/3028 asked to be attached to frontend!\n");
 			break;
 			}
 		case TUNER_XC5000: {
@@ -315,13 +311,11 @@ static int register_dvb(struct tm6000_core *dev)
 			}
 
 			if (!dvb_attach(xc5000_attach, dvb->frontend, &dev->i2c_adap, &cfg)) {
-				printk(KERN_ERR "tm6000: couldn't register "
-						"frontend (xc5000)\n");
+				printk(KERN_ERR "tm6000: couldn't register frontend (xc5000)\n");
 				ret = -EINVAL;
 				goto frontend_err;
 			}
-			printk(KERN_INFO "tm6000: XC5000 asked to be "
-					 "attached to frontend!\n");
+			printk(KERN_INFO "tm6000: XC5000 asked to be attached to frontend!\n");
 			break;
 			}
 		}
diff --git a/drivers/media/usb/tm6000/tm6000-i2c.c b/drivers/media/usb/tm6000/tm6000-i2c.c
index c7e23e3dd75e..b01d3ee56e77 100644
--- a/drivers/media/usb/tm6000/tm6000-i2c.c
+++ b/drivers/media/usb/tm6000/tm6000-i2c.c
@@ -173,8 +173,7 @@ static int tm6000_i2c_xfer(struct i2c_adapter *i2c_adap,
 			 * immediately after a 1 or 2 byte write to select
 			 * a register.  We cannot fulfil this request.
 			 */
-			i2c_dprintk(2, " read without preceding write not"
-				       " supported");
+			i2c_dprintk(2, " read without preceding write not supported");
 			rc = -EOPNOTSUPP;
 			goto err;
 		} else if (i + 1 < num && msgs[i].len <= 2 &&
diff --git a/drivers/media/usb/tm6000/tm6000-stds.c b/drivers/media/usb/tm6000/tm6000-stds.c
index 93a4b2434b6e..4064a5e8fae1 100644
--- a/drivers/media/usb/tm6000/tm6000-stds.c
+++ b/drivers/media/usb/tm6000/tm6000-stds.c
@@ -464,8 +464,7 @@ static int tm6000_load_std(struct tm6000_core *dev, struct tm6000_reg_settings *
 	for (i = 0; set[i].req; i++) {
 		rc = tm6000_set_reg(dev, set[i].req, set[i].reg, set[i].value);
 		if (rc < 0) {
-			printk(KERN_ERR "Error %i while setting "
-			       "req %d, reg %d to value %d\n",
+			printk(KERN_ERR "Error %i while setting req %d, reg %d to value %d\n",
 			       rc, set[i].req, set[i].reg, set[i].value);
 			return rc;
 		}
diff --git a/drivers/media/usb/tm6000/tm6000-video.c b/drivers/media/usb/tm6000/tm6000-video.c
index dee7e7d3d47d..d9f3fa5db8dd 100644
--- a/drivers/media/usb/tm6000/tm6000-video.c
+++ b/drivers/media/usb/tm6000/tm6000-video.c
@@ -615,8 +615,7 @@ static int tm6000_prepare_isoc(struct tm6000_core *dev)
 		return -ENOMEM;
 	}
 
-	dprintk(dev, V4L2_DEBUG_QUEUE, "Allocating %d x %d packets"
-		    " (%d bytes) of %d bytes each to handle %u size\n",
+	dprintk(dev, V4L2_DEBUG_QUEUE, "Allocating %d x %d packets (%d bytes) of %d bytes each to handle %u size\n",
 		    max_packets, num_bufs, sb_size,
 		    dev->isoc_in.maxsize, size);
 
@@ -939,8 +938,8 @@ static int vidioc_try_fmt_vid_cap(struct file *file, void *priv,
 
 	fmt = format_by_fourcc(f->fmt.pix.pixelformat);
 	if (NULL == fmt) {
-		dprintk(dev, 2, "Fourcc format (0x%08x)"
-				" invalid.\n", f->fmt.pix.pixelformat);
+		dprintk(dev, 2, "Fourcc format (0x%08x) invalid.\n",
+			f->fmt.pix.pixelformat);
 		return -EINVAL;
 	}
 
@@ -1366,14 +1365,13 @@ static int __tm6000_open(struct file *file)
 	fh->width = dev->width;
 	fh->height = dev->height;
 
-	dprintk(dev, V4L2_DEBUG_OPEN, "Open: fh=0x%08lx, dev=0x%08lx, "
-						"dev->vidq=0x%08lx\n",
+	dprintk(dev, V4L2_DEBUG_OPEN, "Open: fh=0x%08lx, dev=0x%08lx, dev->vidq=0x%08lx\n",
 			(unsigned long)fh, (unsigned long)dev,
 			(unsigned long)&dev->vidq);
-	dprintk(dev, V4L2_DEBUG_OPEN, "Open: list_empty "
-				"queued=%d\n", list_empty(&dev->vidq.queued));
-	dprintk(dev, V4L2_DEBUG_OPEN, "Open: list_empty "
-				"active=%d\n", list_empty(&dev->vidq.active));
+	dprintk(dev, V4L2_DEBUG_OPEN, "Open: list_empty queued=%d\n",
+		list_empty(&dev->vidq.queued));
+	dprintk(dev, V4L2_DEBUG_OPEN, "Open: list_empty active=%d\n",
+		list_empty(&dev->vidq.active));
 
 	/* initialize hardware on analog mode */
 	rc = tm6000_init_analog_mode(dev);
-- 
2.7.4


