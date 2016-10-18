Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:51582 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935873AbcJRUq1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 18 Oct 2016 16:46:27 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Bhaktipriya Shridhar <bhaktipriya96@gmail.com>,
        Tejun Heo <tj@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Sean Young <sean@mess.org>,
        Julia Lawall <Julia.Lawall@lip6.fr>,
        Wolfram Sang <wsa-dev@sang-engineering.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH v2 39/58] hdpvr: don't break long lines
Date: Tue, 18 Oct 2016 18:45:51 -0200
Message-Id: <bcd8e6524d2835d1e66989404350dae73f6371f1.1476822925.git.mchehab@s-opensource.com>
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
 drivers/media/usb/hdpvr/hdpvr-core.c  | 9 +++------
 drivers/media/usb/hdpvr/hdpvr-i2c.c   | 7 +++----
 drivers/media/usb/hdpvr/hdpvr-video.c | 4 +---
 3 files changed, 7 insertions(+), 13 deletions(-)

diff --git a/drivers/media/usb/hdpvr/hdpvr-core.c b/drivers/media/usb/hdpvr/hdpvr-core.c
index a61d8fd63c12..15f016ad5b89 100644
--- a/drivers/media/usb/hdpvr/hdpvr-core.c
+++ b/drivers/media/usb/hdpvr/hdpvr-core.c
@@ -41,13 +41,11 @@ MODULE_PARM_DESC(hdpvr_debug, "enable debugging output");
 
 static uint default_video_input = HDPVR_VIDEO_INPUTS;
 module_param(default_video_input, uint, S_IRUGO|S_IWUSR);
-MODULE_PARM_DESC(default_video_input, "default video input: 0=Component / "
-		 "1=S-Video / 2=Composite");
+MODULE_PARM_DESC(default_video_input, "default video input: 0=Component / 1=S-Video / 2=Composite");
 
 static uint default_audio_input = HDPVR_AUDIO_INPUTS;
 module_param(default_audio_input, uint, S_IRUGO|S_IWUSR);
-MODULE_PARM_DESC(default_audio_input, "default audio input: 0=RCA back / "
-		 "1=RCA front / 2=S/PDIF");
+MODULE_PARM_DESC(default_audio_input, "default audio input: 0=RCA back / 1=RCA front / 2=S/PDIF");
 
 static bool boost_audio;
 module_param(boost_audio, bool, S_IRUGO|S_IWUSR);
@@ -165,8 +163,7 @@ static int device_authorization(struct hdpvr_device *dev)
 		dev->flags |= HDPVR_FLAG_AC3_CAP;
 		break;
 	default:
-		v4l2_info(&dev->v4l2_dev, "untested firmware, the driver might"
-			  " not work.\n");
+		v4l2_info(&dev->v4l2_dev, "untested firmware, the driver might not work.\n");
 		if (dev->fw_ver >= HDPVR_FIRMWARE_VERSION_AC3)
 			dev->flags |= HDPVR_FLAG_AC3_CAP;
 		else
diff --git a/drivers/media/usb/hdpvr/hdpvr-i2c.c b/drivers/media/usb/hdpvr/hdpvr-i2c.c
index 9b641c4d4431..fcab55038d99 100644
--- a/drivers/media/usb/hdpvr/hdpvr-i2c.c
+++ b/drivers/media/usb/hdpvr/hdpvr-i2c.c
@@ -145,15 +145,14 @@ static int hdpvr_transfer(struct i2c_adapter *i2c_adapter, struct i2c_msg *msgs,
 						 msgs[0].len);
 	} else if (num == 2) {
 		if (msgs[0].addr != msgs[1].addr) {
-			v4l2_warn(&dev->v4l2_dev, "refusing 2-phase i2c xfer "
-				  "with conflicting target addresses\n");
+			v4l2_warn(&dev->v4l2_dev, "refusing 2-phase i2c xfer with conflicting target addresses\n");
 			retval = -EINVAL;
 			goto out;
 		}
 
 		if ((msgs[0].flags & I2C_M_RD) || !(msgs[1].flags & I2C_M_RD)) {
-			v4l2_warn(&dev->v4l2_dev, "refusing complex xfer with "
-				  "r0=%d, r1=%d\n", msgs[0].flags & I2C_M_RD,
+			v4l2_warn(&dev->v4l2_dev, "refusing complex xfer with r0=%d, r1=%d\n",
+				  msgs[0].flags & I2C_M_RD,
 				  msgs[1].flags & I2C_M_RD);
 			retval = -EINVAL;
 			goto out;
diff --git a/drivers/media/usb/hdpvr/hdpvr-video.c b/drivers/media/usb/hdpvr/hdpvr-video.c
index 6d43d75493ea..a247063c5816 100644
--- a/drivers/media/usb/hdpvr/hdpvr-video.c
+++ b/drivers/media/usb/hdpvr/hdpvr-video.c
@@ -337,9 +337,7 @@ static int hdpvr_stop_streaming(struct hdpvr_device *dev)
 
 	buf = kmalloc(dev->bulk_in_size, GFP_KERNEL);
 	if (!buf)
-		v4l2_err(&dev->v4l2_dev, "failed to allocate temporary buffer "
-			 "for emptying the internal device buffer. "
-			 "Next capture start will be slow\n");
+		v4l2_err(&dev->v4l2_dev, "failed to allocate temporary buffer for emptying the internal device buffer. Next capture start will be slow\n");
 
 	dev->status = STATUS_SHUTTING_DOWN;
 	hdpvr_config_call(dev, CTRL_STOP_STREAMING_VALUE, 0x00);
-- 
2.7.4


