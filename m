Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:51592 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935155AbcJRUqX (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 18 Oct 2016 16:46:23 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Mike Isely <isely@pobox.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH v2 40/58] pvrusb2: don't break long lines
Date: Tue, 18 Oct 2016 18:45:52 -0200
Message-Id: <5e2d21fb1a252059a24c2611a0c8ec7a7f323714.1476822925.git.mchehab@s-opensource.com>
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
 drivers/media/usb/pvrusb2/pvrusb2-audio.c       |   4 +-
 drivers/media/usb/pvrusb2/pvrusb2-cs53l32a.c    |   4 +-
 drivers/media/usb/pvrusb2/pvrusb2-cx2584x-v4l.c |   4 +-
 drivers/media/usb/pvrusb2/pvrusb2-debugifc.c    |   4 +-
 drivers/media/usb/pvrusb2/pvrusb2-eeprom.c      |   7 +-
 drivers/media/usb/pvrusb2/pvrusb2-encoder.c     |  29 ++--
 drivers/media/usb/pvrusb2/pvrusb2-hdw.c         | 181 ++++++++----------------
 drivers/media/usb/pvrusb2/pvrusb2-i2c-core.c    |  33 ++---
 drivers/media/usb/pvrusb2/pvrusb2-io.c          |  35 ++---
 drivers/media/usb/pvrusb2/pvrusb2-ioread.c      |  36 ++---
 drivers/media/usb/pvrusb2/pvrusb2-std.c         |   3 +-
 drivers/media/usb/pvrusb2/pvrusb2-v4l2.c        |  10 +-
 drivers/media/usb/pvrusb2/pvrusb2-video-v4l.c   |   4 +-
 drivers/media/usb/pvrusb2/pvrusb2-wm8775.c      |   3 +-
 14 files changed, 118 insertions(+), 239 deletions(-)

diff --git a/drivers/media/usb/pvrusb2/pvrusb2-audio.c b/drivers/media/usb/pvrusb2/pvrusb2-audio.c
index 5f953d837bf1..3bac50a248d4 100644
--- a/drivers/media/usb/pvrusb2/pvrusb2-audio.c
+++ b/drivers/media/usb/pvrusb2/pvrusb2-audio.c
@@ -74,9 +74,7 @@ void pvr2_msp3400_subdev_update(struct pvr2_hdw *hdw, struct v4l2_subdev *sd)
 			input = sp->def[hdw->input_val];
 		} else {
 			pvr2_trace(PVR2_TRACE_ERROR_LEGS,
-				   "*** WARNING *** subdev msp3400 set_input:"
-				   " Invalid routing scheme (%u)"
-				   " and/or input (%d)",
+				   "*** WARNING *** subdev msp3400 set_input: Invalid routing scheme (%u) and/or input (%d)",
 				   sid, hdw->input_val);
 			return;
 		}
diff --git a/drivers/media/usb/pvrusb2/pvrusb2-cs53l32a.c b/drivers/media/usb/pvrusb2/pvrusb2-cs53l32a.c
index f82f0f0f2c04..7f29a0464f36 100644
--- a/drivers/media/usb/pvrusb2/pvrusb2-cs53l32a.c
+++ b/drivers/media/usb/pvrusb2/pvrusb2-cs53l32a.c
@@ -72,9 +72,7 @@ void pvr2_cs53l32a_subdev_update(struct pvr2_hdw *hdw, struct v4l2_subdev *sd)
 		    (hdw->input_val < 0) ||
 		    (hdw->input_val >= sp->cnt)) {
 			pvr2_trace(PVR2_TRACE_ERROR_LEGS,
-				   "*** WARNING *** subdev v4l2 set_input:"
-				   " Invalid routing scheme (%u)"
-				   " and/or input (%d)",
+				   "*** WARNING *** subdev v4l2 set_input: Invalid routing scheme (%u) and/or input (%d)",
 				   sid, hdw->input_val);
 			return;
 		}
diff --git a/drivers/media/usb/pvrusb2/pvrusb2-cx2584x-v4l.c b/drivers/media/usb/pvrusb2/pvrusb2-cx2584x-v4l.c
index 7d675fae1846..30eef97ef2ef 100644
--- a/drivers/media/usb/pvrusb2/pvrusb2-cx2584x-v4l.c
+++ b/drivers/media/usb/pvrusb2/pvrusb2-cx2584x-v4l.c
@@ -137,9 +137,7 @@ void pvr2_cx25840_subdev_update(struct pvr2_hdw *hdw, struct v4l2_subdev *sd)
 		    (hdw->input_val < 0) ||
 		    (hdw->input_val >= sp->cnt)) {
 			pvr2_trace(PVR2_TRACE_ERROR_LEGS,
-				   "*** WARNING *** subdev cx2584x set_input:"
-				   " Invalid routing scheme (%u)"
-				   " and/or input (%d)",
+				   "*** WARNING *** subdev cx2584x set_input: Invalid routing scheme (%u) and/or input (%d)",
 				   sid, hdw->input_val);
 			return;
 		}
diff --git a/drivers/media/usb/pvrusb2/pvrusb2-debugifc.c b/drivers/media/usb/pvrusb2/pvrusb2-debugifc.c
index e4022bcb155b..58ec706ebdb3 100644
--- a/drivers/media/usb/pvrusb2/pvrusb2-debugifc.c
+++ b/drivers/media/usb/pvrusb2/pvrusb2-debugifc.c
@@ -176,9 +176,7 @@ int pvr2_debugifc_print_status(struct pvr2_hdw *hdw,
 		pvr2_stream_get_stats(sp, &stats, 0);
 		ccnt = scnprintf(
 			buf,acnt,
-			"Bytes streamed=%u"
-			" URBs: queued=%u idle=%u ready=%u"
-			" processed=%u failed=%u\n",
+			"Bytes streamed=%u URBs: queued=%u idle=%u ready=%u processed=%u failed=%u\n",
 			stats.bytes_processed,
 			stats.buffers_in_queue,
 			stats.buffers_in_idle,
diff --git a/drivers/media/usb/pvrusb2/pvrusb2-eeprom.c b/drivers/media/usb/pvrusb2/pvrusb2-eeprom.c
index e1907cd0c3b7..3f5f02e2c096 100644
--- a/drivers/media/usb/pvrusb2/pvrusb2-eeprom.c
+++ b/drivers/media/usb/pvrusb2/pvrusb2-eeprom.c
@@ -56,8 +56,7 @@ static u8 *pvr2_eeprom_fetch(struct pvr2_hdw *hdw)
 	eeprom = kmalloc(EEPROM_SIZE,GFP_KERNEL);
 	if (!eeprom) {
 		pvr2_trace(PVR2_TRACE_ERROR_LEGS,
-			   "Failed to allocate memory"
-			   " required to read eeprom");
+			   "Failed to allocate memory required to read eeprom");
 		return NULL;
 	}
 
@@ -74,8 +73,8 @@ static u8 *pvr2_eeprom_fetch(struct pvr2_hdw *hdw)
 	   strange but it's what they do) */
 	mode16 = (addr & 1);
 	eepromSize = (mode16 ? 4096 : 256);
-	trace_eeprom("Examining %d byte eeprom at location 0x%x"
-		     " using %d bit addressing",eepromSize,addr,
+	trace_eeprom("Examining %d byte eeprom at location 0x%x using %d bit addressing",
+		     eepromSize,addr,
 		     mode16 ? 16 : 8);
 
 	msg[0].addr = addr;
diff --git a/drivers/media/usb/pvrusb2/pvrusb2-encoder.c b/drivers/media/usb/pvrusb2/pvrusb2-encoder.c
index 593b3e9b6bfd..36b217f85780 100644
--- a/drivers/media/usb/pvrusb2/pvrusb2-encoder.c
+++ b/drivers/media/usb/pvrusb2/pvrusb2-encoder.c
@@ -188,9 +188,7 @@ static int pvr2_encoder_cmd(void *ctxt,
 	if (arg_cnt_send > (ARRAY_SIZE(wrData) - 4)) {
 		pvr2_trace(
 			PVR2_TRACE_ERROR_LEGS,
-			"Failed to write cx23416 command"
-			" - too many input arguments"
-			" (was given %u limit %lu)",
+			"Failed to write cx23416 command - too many input arguments (was given %u limit %lu)",
 			arg_cnt_send, (long unsigned) ARRAY_SIZE(wrData) - 4);
 		return -EINVAL;
 	}
@@ -198,9 +196,7 @@ static int pvr2_encoder_cmd(void *ctxt,
 	if (arg_cnt_recv > (ARRAY_SIZE(rdData) - 4)) {
 		pvr2_trace(
 			PVR2_TRACE_ERROR_LEGS,
-			"Failed to write cx23416 command"
-			" - too many return arguments"
-			" (was given %u limit %lu)",
+			"Failed to write cx23416 command - too many return arguments (was given %u limit %lu)",
 			arg_cnt_recv, (long unsigned) ARRAY_SIZE(rdData) - 4);
 		return -EINVAL;
 	}
@@ -248,14 +244,12 @@ static int pvr2_encoder_cmd(void *ctxt,
 				retry_flag = !0;
 				pvr2_trace(
 					PVR2_TRACE_ERROR_LEGS,
-					"Encoder timed out waiting for us"
-					"; arranging to retry");
+					"Encoder timed out waiting for us; arranging to retry");
 			} else {
 				pvr2_trace(
 					PVR2_TRACE_ERROR_LEGS,
-					"***WARNING*** device's encoder"
-					" appears to be stuck"
-					" (status=0x%08x)",rdData[0]);
+					"***WARNING*** device's encoder appears to be stuck (status=0x%08x)",
+rdData[0]);
 			}
 			pvr2_trace(
 				PVR2_TRACE_ERROR_LEGS,
@@ -293,11 +287,7 @@ static int pvr2_encoder_cmd(void *ctxt,
 			}
 			pvr2_trace(
 				PVR2_TRACE_ERROR_LEGS,
-				"Giving up on command."
-				"  This is normally recovered via a firmware"
-				" reload and re-initialization; concern"
-				" is only warranted if this happens repeatedly"
-				" and rapidly.");
+				"Giving up on command.  This is normally recovered via a firmware reload and re-initialization; concern is only warranted if this happens repeatedly and rapidly.");
 			break;
 		}
 		wrData[0] = 0x7;
@@ -325,9 +315,7 @@ static int pvr2_encoder_vcmd(struct pvr2_hdw *hdw, int cmd,
 	if (args > ARRAY_SIZE(data)) {
 		pvr2_trace(
 			PVR2_TRACE_ERROR_LEGS,
-			"Failed to write cx23416 command"
-			" - too many arguments"
-			" (was given %u limit %lu)",
+			"Failed to write cx23416 command - too many arguments (was given %u limit %lu)",
 			args, (long unsigned) ARRAY_SIZE(data));
 		return -EINVAL;
 	}
@@ -433,8 +421,7 @@ int pvr2_encoder_configure(struct pvr2_hdw *hdw)
 {
 	int ret;
 	int val;
-	pvr2_trace(PVR2_TRACE_ENCODER,"pvr2_encoder_configure"
-		   " (cx2341x module)");
+	pvr2_trace(PVR2_TRACE_ENCODER,"pvr2_encoder_configure (cx2341x module)");
 	hdw->enc_ctl_state.port = CX2341X_PORT_STREAMING;
 	hdw->enc_ctl_state.width = hdw->res_hor_val;
 	hdw->enc_ctl_state.height = hdw->res_ver_val;
diff --git a/drivers/media/usb/pvrusb2/pvrusb2-hdw.c b/drivers/media/usb/pvrusb2/pvrusb2-hdw.c
index 1eb4f7ba2967..e55f59ac7296 100644
--- a/drivers/media/usb/pvrusb2/pvrusb2-hdw.c
+++ b/drivers/media/usb/pvrusb2/pvrusb2-hdw.c
@@ -1371,8 +1371,7 @@ static int pvr2_locate_firmware(struct pvr2_hdw *hdw,
 				       fwnames[idx],
 				       &hdw->usb_dev->dev);
 		if (!ret) {
-			trace_firmware("Located %s firmware: %s;"
-				       " uploading...",
+			trace_firmware("Located %s firmware: %s; uploading...",
 				       fwtypename,
 				       fwnames[idx]);
 			return idx;
@@ -1383,21 +1382,17 @@ static int pvr2_locate_firmware(struct pvr2_hdw *hdw,
 		return ret;
 	}
 	pvr2_trace(PVR2_TRACE_ERROR_LEGS,
-		   "***WARNING***"
-		   " Device %s firmware"
-		   " seems to be missing.",
+		   "***WARNING*** Device %s firmware seems to be missing.",
 		   fwtypename);
 	pvr2_trace(PVR2_TRACE_ERROR_LEGS,
-		   "Did you install the pvrusb2 firmware files"
-		   " in their proper location?");
+		   "Did you install the pvrusb2 firmware files in their proper location?");
 	if (fwcount == 1) {
 		pvr2_trace(PVR2_TRACE_ERROR_LEGS,
 			   "request_firmware unable to locate %s file %s",
 			   fwtypename,fwnames[0]);
 	} else {
 		pvr2_trace(PVR2_TRACE_ERROR_LEGS,
-			   "request_firmware unable to locate"
-			   " one of the following %s files:",
+			   "request_firmware unable to locate one of the following %s files:",
 			   fwtypename);
 		for (idx = 0; idx < fwcount; idx++) {
 			pvr2_trace(PVR2_TRACE_ERROR_LEGS,
@@ -1431,8 +1426,7 @@ static int pvr2_upload_firmware1(struct pvr2_hdw *hdw)
 	if (!hdw->hdw_desc->fx2_firmware.cnt) {
 		hdw->fw1_state = FW1_STATE_OK;
 		pvr2_trace(PVR2_TRACE_ERROR_LEGS,
-			   "Connected device type defines"
-			   " no firmware to upload; ignoring firmware");
+			   "Connected device type defines no firmware to upload; ignoring firmware");
 		return -ENOTTY;
 	}
 
@@ -1457,13 +1451,11 @@ static int pvr2_upload_firmware1(struct pvr2_hdw *hdw)
 	    (!(hdw->hdw_desc->flag_fx2_16kb && (fwsize == 0x4000)))) {
 		if (hdw->hdw_desc->flag_fx2_16kb) {
 			pvr2_trace(PVR2_TRACE_ERROR_LEGS,
-				   "Wrong fx2 firmware size"
-				   " (expected 8192 or 16384, got %u)",
+				   "Wrong fx2 firmware size (expected 8192 or 16384, got %u)",
 				   fwsize);
 		} else {
 			pvr2_trace(PVR2_TRACE_ERROR_LEGS,
-				   "Wrong fx2 firmware size"
-				   " (expected 8192, got %u)",
+				   "Wrong fx2 firmware size (expected 8192, got %u)",
 				   fwsize);
 		}
 		release_firmware(fw_entry);
@@ -1585,8 +1577,7 @@ int pvr2_upload_firmware2(struct pvr2_hdw *hdw)
 
 	if (fw_len % sizeof(u32)) {
 		pvr2_trace(PVR2_TRACE_ERROR_LEGS,
-			   "size of %s firmware"
-			   " must be a multiple of %zu bytes",
+			   "size of %s firmware must be a multiple of %zu bytes",
 			   fw_files[fwidx],sizeof(u32));
 		release_firmware(fw_entry);
 		ret = -EINVAL;
@@ -1887,8 +1878,7 @@ static void pvr2_hdw_setup_std(struct pvr2_hdw *hdw)
 
 	bcnt = pvr2_std_id_to_str(buf,sizeof(buf),hdw->std_mask_eeprom);
 	pvr2_trace(PVR2_TRACE_STD,
-		   "Supported video standard(s) reported available"
-		   " in hardware: %.*s",
+		   "Supported video standard(s) reported available in hardware: %.*s",
 		   bcnt,buf);
 
 	hdw->std_mask_avail = hdw->std_mask_eeprom;
@@ -1897,8 +1887,7 @@ static void pvr2_hdw_setup_std(struct pvr2_hdw *hdw)
 	if (std2) {
 		bcnt = pvr2_std_id_to_str(buf,sizeof(buf),std2);
 		pvr2_trace(PVR2_TRACE_STD,
-			   "Expanding supported video standards"
-			   " to include: %.*s",
+			   "Expanding supported video standards to include: %.*s",
 			   bcnt,buf);
 		hdw->std_mask_avail |= std2;
 	}
@@ -1917,8 +1906,8 @@ static void pvr2_hdw_setup_std(struct pvr2_hdw *hdw)
 	if (std3) {
 		bcnt = pvr2_std_id_to_str(buf,sizeof(buf),std3);
 		pvr2_trace(PVR2_TRACE_STD,
-			   "Initial video standard"
-			   " (determined by device type): %.*s",bcnt,buf);
+			   "Initial video standard (determined by device type): %.*s",
+bcnt,buf);
 		hdw->std_mask_cur = std3;
 		hdw->std_dirty = !0;
 		return;
@@ -1980,8 +1969,7 @@ static void pvr2_hdw_cx25840_vbi_hack(struct pvr2_hdw *hdw)
 	}
 
 	pvr2_trace(PVR2_TRACE_INIT,
-		   "Module ID %u:"
-		   " Executing cx25840 VBI hack",
+		   "Module ID %u: Executing cx25840 VBI hack",
 		   hdw->decoder_client_id);
 	memset(&fmt, 0, sizeof(fmt));
 	fmt.type = V4L2_BUF_TYPE_SLICED_VBI_CAPTURE;
@@ -2007,8 +1995,7 @@ static int pvr2_hdw_load_subdev(struct pvr2_hdw *hdw,
 	fname = (mid < ARRAY_SIZE(module_names)) ? module_names[mid] : NULL;
 	if (!fname) {
 		pvr2_trace(PVR2_TRACE_ERROR_LEGS,
-			   "Module ID %u for device %s has no name?"
-			   "  The driver might have a configuration problem.",
+			   "Module ID %u for device %s has no name?  The driver might have a configuration problem.",
 			   mid,
 			   hdw->hdw_desc->description);
 		return -EINVAL;
@@ -2027,32 +2014,27 @@ static int pvr2_hdw_load_subdev(struct pvr2_hdw *hdw,
 						 ARRAY_SIZE(i2caddr));
 		if (i2ccnt) {
 			pvr2_trace(PVR2_TRACE_INIT,
-				   "Module ID %u:"
-				   " Using default i2c address list",
+				   "Module ID %u: Using default i2c address list",
 				   mid);
 		}
 	}
 
 	if (!i2ccnt) {
 		pvr2_trace(PVR2_TRACE_ERROR_LEGS,
-			   "Module ID %u (%s) for device %s:"
-			   " No i2c addresses."
-			   "  The driver might have a configuration problem.",
+			   "Module ID %u (%s) for device %s: No i2c addresses.	The driver might have a configuration problem.",
 			   mid, fname, hdw->hdw_desc->description);
 		return -EINVAL;
 	}
 
 	if (i2ccnt == 1) {
 		pvr2_trace(PVR2_TRACE_INIT,
-			   "Module ID %u:"
-			   " Setting up with specified i2c address 0x%x",
+			   "Module ID %u: Setting up with specified i2c address 0x%x",
 			   mid, i2caddr[0]);
 		sd = v4l2_i2c_new_subdev(&hdw->v4l2_dev, &hdw->i2c_adap,
 					 fname, i2caddr[0], NULL);
 	} else {
 		pvr2_trace(PVR2_TRACE_INIT,
-			   "Module ID %u:"
-			   " Setting up with address probe list",
+			   "Module ID %u: Setting up with address probe list",
 			   mid);
 		sd = v4l2_i2c_new_subdev(&hdw->v4l2_dev, &hdw->i2c_adap,
 					 fname, 0, i2caddr);
@@ -2060,9 +2042,7 @@ static int pvr2_hdw_load_subdev(struct pvr2_hdw *hdw,
 
 	if (!sd) {
 		pvr2_trace(PVR2_TRACE_ERROR_LEGS,
-			   "Module ID %u (%s) for device %s failed to load."
-			   "  Possible missing sub-device kernel module or"
-			   " initialization failure within module.",
+			   "Module ID %u (%s) for device %s failed to load.  Possible missing sub-device kernel module or initialization failure within module.",
 			   mid, fname, hdw->hdw_desc->description);
 		return -EIO;
 	}
@@ -2124,18 +2104,14 @@ static void pvr2_hdw_setup_low(struct pvr2_hdw *hdw)
 				 == 0);
 			if (reloadFl) {
 				pvr2_trace(PVR2_TRACE_INIT,
-					   "USB endpoint config looks strange"
-					   "; possibly firmware needs to be"
-					   " loaded");
+					   "USB endpoint config looks strange; possibly firmware needs to be loaded");
 			}
 		}
 		if (!reloadFl) {
 			reloadFl = !pvr2_hdw_check_firmware(hdw);
 			if (reloadFl) {
 				pvr2_trace(PVR2_TRACE_INIT,
-					   "Check for FX2 firmware failed"
-					   "; possibly firmware needs to be"
-					   " loaded");
+					   "Check for FX2 firmware failed; possibly firmware needs to be loaded");
 			}
 		}
 		if (reloadFl) {
@@ -2200,8 +2176,7 @@ static void pvr2_hdw_setup_low(struct pvr2_hdw *hdw)
 		if (!pvr2_hdw_dev_ok(hdw)) return;
 		if (ret < 0) {
 			pvr2_trace(PVR2_TRACE_ERROR_LEGS,
-				   "Unable to determine location of eeprom,"
-				   " skipping");
+				   "Unable to determine location of eeprom, skipping");
 		} else {
 			hdw->eeprom_addr = ret;
 			pvr2_eeprom_analyze(hdw);
@@ -2254,8 +2229,7 @@ static void pvr2_hdw_setup_low(struct pvr2_hdw *hdw)
 		idx = get_default_error_tolerance(hdw);
 		if (idx) {
 			pvr2_trace(PVR2_TRACE_INIT,
-				   "pvr2_hdw_setup: video stream %p"
-				   " setting tolerance %u",
+				   "pvr2_hdw_setup: video stream %p setting tolerance %u",
 				   hdw->vid_stream,idx);
 		}
 		pvr2_stream_setup(hdw->vid_stream,hdw->usb_dev,
@@ -2285,16 +2259,13 @@ static void pvr2_hdw_setup(struct pvr2_hdw *hdw)
 			if (hdw->flag_init_ok) {
 				pvr2_trace(
 					PVR2_TRACE_INFO,
-					"Device initialization"
-					" completed successfully.");
+					"Device initialization completed successfully.");
 				break;
 			}
 			if (hdw->fw1_state == FW1_STATE_RELOAD) {
 				pvr2_trace(
 					PVR2_TRACE_INFO,
-					"Device microcontroller firmware"
-					" (re)loaded; it should now reset"
-					" and reconnect.");
+					"Device microcontroller firmware (re)loaded; it should now reset and reconnect.");
 				break;
 			}
 			pvr2_trace(
@@ -2303,48 +2274,35 @@ static void pvr2_hdw_setup(struct pvr2_hdw *hdw)
 			if (hdw->fw1_state == FW1_STATE_MISSING) {
 				pvr2_trace(
 					PVR2_TRACE_ERROR_LEGS,
-					"Giving up since device"
-					" microcontroller firmware"
-					" appears to be missing.");
+					"Giving up since device microcontroller firmware appears to be missing.");
 				break;
 			}
 		}
 		if (hdw->flag_modulefail) {
 			pvr2_trace(
 				PVR2_TRACE_ERROR_LEGS,
-				"***WARNING*** pvrusb2 driver initialization"
-				" failed due to the failure of one or more"
-				" sub-device kernel modules.");
+				"***WARNING*** pvrusb2 driver initialization failed due to the failure of one or more sub-device kernel modules.");
 			pvr2_trace(
 				PVR2_TRACE_ERROR_LEGS,
-				"You need to resolve the failing condition"
-				" before this driver can function.  There"
-				" should be some earlier messages giving more"
-				" information about the problem.");
+				"You need to resolve the failing condition before this driver can function.  There should be some earlier messages giving more information about the problem.");
 			break;
 		}
 		if (procreload) {
 			pvr2_trace(
 				PVR2_TRACE_ERROR_LEGS,
-				"Attempting pvrusb2 recovery by reloading"
-				" primary firmware.");
+				"Attempting pvrusb2 recovery by reloading primary firmware.");
 			pvr2_trace(
 				PVR2_TRACE_ERROR_LEGS,
-				"If this works, device should disconnect"
-				" and reconnect in a sane state.");
+				"If this works, device should disconnect and reconnect in a sane state.");
 			hdw->fw1_state = FW1_STATE_UNKNOWN;
 			pvr2_upload_firmware1(hdw);
 		} else {
 			pvr2_trace(
 				PVR2_TRACE_ERROR_LEGS,
-				"***WARNING*** pvrusb2 device hardware"
-				" appears to be jammed"
-				" and I can't clear it.");
+				"***WARNING*** pvrusb2 device hardware appears to be jammed and I can't clear it.");
 			pvr2_trace(
 				PVR2_TRACE_ERROR_LEGS,
-				"You might need to power cycle"
-				" the pvrusb2 device"
-				" in order to recover.");
+				"You might need to power cycle the pvrusb2 device in order to recover.");
 		}
 	} while (0);
 	pvr2_trace(PVR2_TRACE_INIT,"pvr2_hdw_setup(hdw=%p) end",hdw);
@@ -2396,12 +2354,8 @@ struct pvr2_hdw *pvr2_hdw_create(struct usb_interface *intf,
 	hdw_desc = (const struct pvr2_device_desc *)(devid->driver_info);
 
 	if (hdw_desc == NULL) {
-		pvr2_trace(PVR2_TRACE_INIT, "pvr2_hdw_create:"
-			   " No device description pointer,"
-			   " unable to continue.");
-		pvr2_trace(PVR2_TRACE_INIT, "If you have a new device type,"
-			   " please contact Mike Isely <isely@pobox.com>"
-			   " to get it included in the driver\n");
+		pvr2_trace(PVR2_TRACE_INIT, "pvr2_hdw_create: No device description pointer, unable to continue.");
+		pvr2_trace(PVR2_TRACE_INIT, "If you have a new device type, please contact Mike Isely <isely@pobox.com> to get it included in the driver\n");
 		goto fail;
 	}
 
@@ -2413,14 +2367,12 @@ struct pvr2_hdw *pvr2_hdw_create(struct usb_interface *intf,
 	if (hdw_desc->flag_is_experimental) {
 		pvr2_trace(PVR2_TRACE_INFO, "**********");
 		pvr2_trace(PVR2_TRACE_INFO,
-			   "WARNING: Support for this device (%s) is"
-			   " experimental.", hdw_desc->description);
+			   "WARNING: Support for this device (%s) is experimental.",
+							      hdw_desc->description);
 		pvr2_trace(PVR2_TRACE_INFO,
-			   "Important functionality might not be"
-			   " entirely working.");
+			   "Important functionality might not be entirely working.");
 		pvr2_trace(PVR2_TRACE_INFO,
-			   "Please consider contacting the driver author to"
-			   " help with further stabilization of the driver.");
+			   "Please consider contacting the driver author to help with further stabilization of the driver.");
 		pvr2_trace(PVR2_TRACE_INFO, "**********");
 	}
 	if (!hdw) goto fail;
@@ -3375,8 +3327,7 @@ static u8 *pvr2_full_eeprom_fetch(struct pvr2_hdw *hdw)
 	eeprom = kmalloc(EEPROM_SIZE,GFP_KERNEL);
 	if (!eeprom) {
 		pvr2_trace(PVR2_TRACE_ERROR_LEGS,
-			   "Failed to allocate memory"
-			   " required to read eeprom");
+			   "Failed to allocate memory required to read eeprom");
 		return NULL;
 	}
 
@@ -3393,8 +3344,8 @@ static u8 *pvr2_full_eeprom_fetch(struct pvr2_hdw *hdw)
 	   strange but it's what they do) */
 	mode16 = (addr & 1);
 	eepromSize = (mode16 ? EEPROM_SIZE : 256);
-	trace_eeprom("Examining %d byte eeprom at location 0x%x"
-		     " using %d bit addressing",eepromSize,addr,
+	trace_eeprom("Examining %d byte eeprom at location 0x%x using %d bit addressing",
+		     eepromSize,addr,
 		     mode16 ? 16 : 8);
 
 	msg[0].addr = addr;
@@ -3461,8 +3412,8 @@ void pvr2_hdw_cpufw_set_enabled(struct pvr2_hdw *hdw,
 		if (hdw->fw_cpu_flag) {
 			hdw->fw_size = (mode == 1) ? 0x4000 : 0x2000;
 			pvr2_trace(PVR2_TRACE_FIRMWARE,
-				   "Preparing to suck out CPU firmware"
-				   " (size=%u)", hdw->fw_size);
+				   "Preparing to suck out CPU firmware (size=%u)",
+hdw->fw_size);
 			hdw->fw_buffer = kzalloc(hdw->fw_size,GFP_KERNEL);
 			if (!hdw->fw_buffer) {
 				hdw->fw_size = 0;
@@ -3620,21 +3571,18 @@ static int pvr2_send_request_ex(struct pvr2_hdw *hdw,
 	struct timer_list timer;
 	if (!hdw->ctl_lock_held) {
 		pvr2_trace(PVR2_TRACE_ERROR_LEGS,
-			   "Attempted to execute control transfer"
-			   " without lock!!");
+			   "Attempted to execute control transfer without lock!!");
 		return -EDEADLK;
 	}
 	if (!hdw->flag_ok && !probe_fl) {
 		pvr2_trace(PVR2_TRACE_ERROR_LEGS,
-			   "Attempted to execute control transfer"
-			   " when device not ok");
+			   "Attempted to execute control transfer when device not ok");
 		return -EIO;
 	}
 	if (!(hdw->ctl_read_urb && hdw->ctl_write_urb)) {
 		if (!probe_fl) {
 			pvr2_trace(PVR2_TRACE_ERROR_LEGS,
-				   "Attempted to execute control transfer"
-				   " when USB is disconnected");
+				   "Attempted to execute control transfer when USB is disconnected");
 		}
 		return -ENOTTY;
 	}
@@ -3645,16 +3593,14 @@ static int pvr2_send_request_ex(struct pvr2_hdw *hdw,
 	if (write_len > PVR2_CTL_BUFFSIZE) {
 		pvr2_trace(
 			PVR2_TRACE_ERROR_LEGS,
-			"Attempted to execute %d byte"
-			" control-write transfer (limit=%d)",
+			"Attempted to execute %d byte control-write transfer (limit=%d)",
 			write_len,PVR2_CTL_BUFFSIZE);
 		return -EINVAL;
 	}
 	if (read_len > PVR2_CTL_BUFFSIZE) {
 		pvr2_trace(
 			PVR2_TRACE_ERROR_LEGS,
-			"Attempted to execute %d byte"
-			" control-read transfer (limit=%d)",
+			"Attempted to execute %d byte control-read transfer (limit=%d)",
 			write_len,PVR2_CTL_BUFFSIZE);
 		return -EINVAL;
 	}
@@ -3703,8 +3649,8 @@ static int pvr2_send_request_ex(struct pvr2_hdw *hdw,
 		status = usb_submit_urb(hdw->ctl_write_urb,GFP_KERNEL);
 		if (status < 0) {
 			pvr2_trace(PVR2_TRACE_ERROR_LEGS,
-				   "Failed to submit write-control"
-				   " URB status=%d",status);
+				   "Failed to submit write-control URB status=%d",
+status);
 			hdw->ctl_write_pend_flag = 0;
 			goto done;
 		}
@@ -3727,8 +3673,8 @@ static int pvr2_send_request_ex(struct pvr2_hdw *hdw,
 		status = usb_submit_urb(hdw->ctl_read_urb,GFP_KERNEL);
 		if (status < 0) {
 			pvr2_trace(PVR2_TRACE_ERROR_LEGS,
-				   "Failed to submit read-control"
-				   " URB status=%d",status);
+				   "Failed to submit read-control URB status=%d",
+status);
 			hdw->ctl_read_pend_flag = 0;
 			goto done;
 		}
@@ -3770,8 +3716,7 @@ static int pvr2_send_request_ex(struct pvr2_hdw *hdw,
 			status = hdw->ctl_write_urb->status;
 			if (!probe_fl) {
 				pvr2_trace(PVR2_TRACE_ERROR_LEGS,
-					   "control-write URB failure,"
-					   " status=%d",
+					   "control-write URB failure, status=%d",
 					   status);
 			}
 			goto done;
@@ -3781,8 +3726,7 @@ static int pvr2_send_request_ex(struct pvr2_hdw *hdw,
 			status = -EIO;
 			if (!probe_fl) {
 				pvr2_trace(PVR2_TRACE_ERROR_LEGS,
-					   "control-write URB short,"
-					   " expected=%d got=%d",
+					   "control-write URB short, expected=%d got=%d",
 					   write_len,
 					   hdw->ctl_write_urb->actual_length);
 			}
@@ -3800,8 +3744,7 @@ static int pvr2_send_request_ex(struct pvr2_hdw *hdw,
 			status = hdw->ctl_read_urb->status;
 			if (!probe_fl) {
 				pvr2_trace(PVR2_TRACE_ERROR_LEGS,
-					   "control-read URB failure,"
-					   " status=%d",
+					   "control-read URB failure, status=%d",
 					   status);
 			}
 			goto done;
@@ -3811,8 +3754,7 @@ static int pvr2_send_request_ex(struct pvr2_hdw *hdw,
 			status = -EIO;
 			if (!probe_fl) {
 				pvr2_trace(PVR2_TRACE_ERROR_LEGS,
-					   "control-read URB short,"
-					   " expected=%d got=%d",
+					   "control-read URB short, expected=%d got=%d",
 					   read_len,
 					   hdw->ctl_read_urb->actual_length);
 			}
@@ -4799,9 +4741,7 @@ static unsigned int pvr2_hdw_report_unlocked(struct pvr2_hdw *hdw,int which,
 				      0);
 		return scnprintf(
 			buf,acnt,
-			"Bytes streamed=%u"
-			" URBs: queued=%u idle=%u ready=%u"
-			" processed=%u failed=%u",
+			"Bytes streamed=%u URBs: queued=%u idle=%u ready=%u processed=%u failed=%u",
 			stats.bytes_processed,
 			stats.buffers_in_queue,
 			stats.buffers_in_idle,
@@ -5013,8 +4953,7 @@ int pvr2_hdw_gpio_chg_dir(struct pvr2_hdw *hdw,u32 msk,u32 val)
 		if (ret) return ret;
 		nval = (cval & ~msk) | (val & msk);
 		pvr2_trace(PVR2_TRACE_GPIO,
-			   "GPIO direction changing 0x%x:0x%x"
-			   " from 0x%x to 0x%x",
+			   "GPIO direction changing 0x%x:0x%x from 0x%x to 0x%x",
 			   msk,val,cval,nval);
 	} else {
 		nval = val;
@@ -5057,9 +4996,7 @@ void pvr2_hdw_status_poll(struct pvr2_hdw *hdw)
 	   now.  (Of course, no sub-drivers seem to implement it either.
 	   But now it's a a chicken and egg problem...) */
 	v4l2_device_call_all(&hdw->v4l2_dev, 0, tuner, g_tuner, vtp);
-	pvr2_trace(PVR2_TRACE_CHIPS, "subdev status poll"
-		   " type=%u strength=%u audio=0x%x cap=0x%x"
-		   " low=%u hi=%u",
+	pvr2_trace(PVR2_TRACE_CHIPS, "subdev status poll type=%u strength=%u audio=0x%x cap=0x%x low=%u hi=%u",
 		   vtp->type,
 		   vtp->signal, vtp->rxsubchans, vtp->capability,
 		   vtp->rangelow, vtp->rangehigh);
diff --git a/drivers/media/usb/pvrusb2/pvrusb2-i2c-core.c b/drivers/media/usb/pvrusb2/pvrusb2-i2c-core.c
index 6da5fb544817..48d837e39a9c 100644
--- a/drivers/media/usb/pvrusb2/pvrusb2-i2c-core.c
+++ b/drivers/media/usb/pvrusb2/pvrusb2-i2c-core.c
@@ -62,8 +62,7 @@ static int pvr2_i2c_write(struct pvr2_hdw *hdw, /* Context */
 	if (!data) length = 0;
 	if (length > (sizeof(hdw->cmd_buffer) - 3)) {
 		pvr2_trace(PVR2_TRACE_ERROR_LEGS,
-			   "Killing an I2C write to %u that is too large"
-			   " (desired=%u limit=%u)",
+			   "Killing an I2C write to %u that is too large (desired=%u limit=%u)",
 			   i2c_addr,
 			   length,(unsigned int)(sizeof(hdw->cmd_buffer) - 3));
 		return -ENOTSUPP;
@@ -90,8 +89,7 @@ static int pvr2_i2c_write(struct pvr2_hdw *hdw, /* Context */
 		if (hdw->cmd_buffer[0] != 8) {
 			ret = -EIO;
 			if (hdw->cmd_buffer[0] != 7) {
-				trace_i2c("unexpected status"
-					  " from i2_write[%d]: %d",
+				trace_i2c("unexpected status from i2_write[%d]: %d",
 					  i2c_addr,hdw->cmd_buffer[0]);
 			}
 		}
@@ -116,16 +114,14 @@ static int pvr2_i2c_read(struct pvr2_hdw *hdw, /* Context */
 	if (!data) dlen = 0;
 	if (dlen > (sizeof(hdw->cmd_buffer) - 4)) {
 		pvr2_trace(PVR2_TRACE_ERROR_LEGS,
-			   "Killing an I2C read to %u that has wlen too large"
-			   " (desired=%u limit=%u)",
+			   "Killing an I2C read to %u that has wlen too large (desired=%u limit=%u)",
 			   i2c_addr,
 			   dlen,(unsigned int)(sizeof(hdw->cmd_buffer) - 4));
 		return -ENOTSUPP;
 	}
 	if (res && (rlen > (sizeof(hdw->cmd_buffer) - 1))) {
 		pvr2_trace(PVR2_TRACE_ERROR_LEGS,
-			   "Killing an I2C read to %u that has rlen too large"
-			   " (desired=%u limit=%u)",
+			   "Killing an I2C read to %u that has rlen too large (desired=%u limit=%u)",
 			   i2c_addr,
 			   rlen,(unsigned int)(sizeof(hdw->cmd_buffer) - 1));
 		return -ENOTSUPP;
@@ -154,8 +150,7 @@ static int pvr2_i2c_read(struct pvr2_hdw *hdw, /* Context */
 		if (hdw->cmd_buffer[0] != 8) {
 			ret = -EIO;
 			if (hdw->cmd_buffer[0] != 7) {
-				trace_i2c("unexpected status"
-					  " from i2_read[%d]: %d",
+				trace_i2c("unexpected status from i2_read[%d]: %d",
 					  i2c_addr,hdw->cmd_buffer[0]);
 			}
 		}
@@ -352,13 +347,11 @@ static int i2c_hack_cx25840(struct pvr2_hdw *hdw,
 
 	if ((ret != 0) || (*rdata == 0x04) || (*rdata == 0x0a)) {
 		pvr2_trace(PVR2_TRACE_ERROR_LEGS,
-			   "WARNING: Detected a wedged cx25840 chip;"
-			   " the device will not work.");
+			   "WARNING: Detected a wedged cx25840 chip; the device will not work.");
 		pvr2_trace(PVR2_TRACE_ERROR_LEGS,
 			   "WARNING: Try power cycling the pvrusb2 device.");
 		pvr2_trace(PVR2_TRACE_ERROR_LEGS,
-			   "WARNING: Disabling further access to the device"
-			   " to prevent other foul-ups.");
+			   "WARNING: Disabling further access to the device to prevent other foul-ups.");
 		// This blocks all further communication with the part.
 		hdw->i2c_func[0x44] = NULL;
 		pvr2_hdw_render_useless(hdw);
@@ -444,8 +437,7 @@ static int pvr2_i2c_xfer(struct i2c_adapter *i2c_adap,
 		}
 	} else if (num == 2) {
 		if (msgs[0].addr != msgs[1].addr) {
-			trace_i2c("i2c refusing 2 phase transfer with"
-				  " conflicting target addresses");
+			trace_i2c("i2c refusing 2 phase transfer with conflicting target addresses");
 			ret = -ENOTSUPP;
 			goto done;
 		}
@@ -477,8 +469,7 @@ static int pvr2_i2c_xfer(struct i2c_adapter *i2c_adap,
 			ret = 2;
 			goto done;
 		} else {
-			trace_i2c("i2c refusing complex transfer"
-				  " read0=%d read1=%d",
+			trace_i2c("i2c refusing complex transfer read0=%d read1=%d",
 				  (msgs[0].flags & I2C_M_RD),
 				  (msgs[1].flags & I2C_M_RD));
 		}
@@ -492,8 +483,7 @@ static int pvr2_i2c_xfer(struct i2c_adapter *i2c_adap,
 		for (idx = 0; idx < num; idx++) {
 			cnt = msgs[idx].len;
 			printk(KERN_INFO
-			       "pvrusb2 i2c xfer %u/%u:"
-			       " addr=0x%x len=%d %s",
+			       "pvrusb2 i2c xfer %u/%u: addr=0x%x len=%d %s",
 			       idx+1,num,
 			       msgs[idx].addr,
 			       cnt,
@@ -668,8 +658,7 @@ void pvr2_i2c_core_init(struct pvr2_hdw *hdw)
 		   the emulated IR receiver. */
 		if (do_i2c_probe(hdw, 0x71)) {
 			pvr2_trace(PVR2_TRACE_INFO,
-				   "Device has newer IR hardware;"
-				   " disabling unneeded virtual IR device");
+				   "Device has newer IR hardware; disabling unneeded virtual IR device");
 			hdw->i2c_func[0x18] = NULL;
 			/* Remember that this is a different device... */
 			hdw->ir_scheme_active = PVR2_IR_SCHEME_24XXX_MCE;
diff --git a/drivers/media/usb/pvrusb2/pvrusb2-io.c b/drivers/media/usb/pvrusb2/pvrusb2-io.c
index e68ce24f27e3..ba0f413d9ffe 100644
--- a/drivers/media/usb/pvrusb2/pvrusb2-io.c
+++ b/drivers/media/usb/pvrusb2/pvrusb2-io.c
@@ -113,8 +113,7 @@ static const char *pvr2_buffer_state_decode(enum pvr2_buffer_state st)
 static void pvr2_buffer_describe(struct pvr2_buffer *bp,const char *msg)
 {
 	pvr2_trace(PVR2_TRACE_INFO,
-		   "buffer%s%s %p state=%s id=%d status=%d"
-		   " stream=%p purb=%p sig=0x%x",
+		   "buffer%s%s %p state=%s id=%d status=%d stream=%p purb=%p sig=0x%x",
 		   (msg ? " " : ""),
 		   (msg ? msg : ""),
 		   bp,
@@ -156,8 +155,7 @@ static void pvr2_buffer_remove(struct pvr2_buffer *bp)
 	(*cnt)--;
 	(*bcnt) -= ccnt;
 	pvr2_trace(PVR2_TRACE_BUF_FLOW,
-		   "/*---TRACE_FLOW---*/"
-		   " bufferPool     %8s dec cap=%07d cnt=%02d",
+		   "/*---TRACE_FLOW---*/ bufferPool	%8s dec cap=%07d cnt=%02d",
 		   pvr2_buffer_state_decode(bp->state),*bcnt,*cnt);
 	bp->state = pvr2_buffer_state_none;
 }
@@ -198,8 +196,7 @@ static int pvr2_buffer_set_ready(struct pvr2_buffer *bp)
 	(sp->r_count)++;
 	sp->r_bcount += bp->used_count;
 	pvr2_trace(PVR2_TRACE_BUF_FLOW,
-		   "/*---TRACE_FLOW---*/"
-		   " bufferPool     %8s inc cap=%07d cnt=%02d",
+		   "/*---TRACE_FLOW---*/ bufferPool	%8s inc cap=%07d cnt=%02d",
 		   pvr2_buffer_state_decode(bp->state),
 		   sp->r_bcount,sp->r_count);
 	spin_unlock_irqrestore(&sp->list_lock,irq_flags);
@@ -224,8 +221,7 @@ static void pvr2_buffer_set_idle(struct pvr2_buffer *bp)
 	(sp->i_count)++;
 	sp->i_bcount += bp->max_count;
 	pvr2_trace(PVR2_TRACE_BUF_FLOW,
-		   "/*---TRACE_FLOW---*/"
-		   " bufferPool     %8s inc cap=%07d cnt=%02d",
+		   "/*---TRACE_FLOW---*/ bufferPool	%8s inc cap=%07d cnt=%02d",
 		   pvr2_buffer_state_decode(bp->state),
 		   sp->i_bcount,sp->i_count);
 	spin_unlock_irqrestore(&sp->list_lock,irq_flags);
@@ -249,8 +245,7 @@ static void pvr2_buffer_set_queued(struct pvr2_buffer *bp)
 	(sp->q_count)++;
 	sp->q_bcount += bp->max_count;
 	pvr2_trace(PVR2_TRACE_BUF_FLOW,
-		   "/*---TRACE_FLOW---*/"
-		   " bufferPool     %8s inc cap=%07d cnt=%02d",
+		   "/*---TRACE_FLOW---*/ bufferPool	%8s inc cap=%07d cnt=%02d",
 		   pvr2_buffer_state_decode(bp->state),
 		   sp->q_bcount,sp->q_count);
 	spin_unlock_irqrestore(&sp->list_lock,irq_flags);
@@ -293,8 +288,8 @@ static void pvr2_buffer_done(struct pvr2_buffer *bp)
 	bp->signature = 0;
 	bp->stream = NULL;
 	usb_free_urb(bp->purb);
-	pvr2_trace(PVR2_TRACE_BUF_POOL,"/*---TRACE_FLOW---*/"
-		   " bufferDone     %p",bp);
+	pvr2_trace(PVR2_TRACE_BUF_POOL,"/*---TRACE_FLOW---*/ bufferDone     %p",
+		   bp);
 }
 
 static int pvr2_stream_buffer_count(struct pvr2_stream *sp,unsigned int cnt)
@@ -306,8 +301,7 @@ static int pvr2_stream_buffer_count(struct pvr2_stream *sp,unsigned int cnt)
 	if (cnt == sp->buffer_total_count) return 0;
 
 	pvr2_trace(PVR2_TRACE_BUF_POOL,
-		   "/*---TRACE_FLOW---*/ poolResize    "
-		   " stream=%p cur=%d adj=%+d",
+		   "/*---TRACE_FLOW---*/ poolResize	stream=%p cur=%d adj=%+d",
 		   sp,
 		   sp->buffer_total_count,
 		   cnt-sp->buffer_total_count);
@@ -374,8 +368,7 @@ static int pvr2_stream_achieve_buffer_count(struct pvr2_stream *sp)
 	if (sp->buffer_total_count == sp->buffer_target_count) return 0;
 
 	pvr2_trace(PVR2_TRACE_BUF_POOL,
-		   "/*---TRACE_FLOW---*/"
-		   " poolCheck      stream=%p cur=%d tgt=%d",
+		   "/*---TRACE_FLOW---*/ poolCheck	stream=%p cur=%d tgt=%d",
 		   sp,sp->buffer_total_count,sp->buffer_target_count);
 
 	if (sp->buffer_total_count < sp->buffer_target_count) {
@@ -454,8 +447,8 @@ static void buffer_complete(struct urb *urb)
 		bp->used_count = urb->actual_length;
 		if (sp->fail_count) {
 			pvr2_trace(PVR2_TRACE_TOLERANCE,
-				   "stream %p transfer ok"
-				   " - fail count reset",sp);
+				   "stream %p transfer ok - fail count reset",
+sp);
 			sp->fail_count = 0;
 		}
 	} else if (sp->fail_count < sp->fail_tolerance) {
@@ -464,8 +457,7 @@ static void buffer_complete(struct urb *urb)
 		(sp->fail_count)++;
 		(sp->buffers_failed)++;
 		pvr2_trace(PVR2_TRACE_TOLERANCE,
-			   "stream %p ignoring error %d"
-			   " - fail count increased to %u",
+			   "stream %p ignoring error %d - fail count increased to %u",
 			   sp,urb->status,sp->fail_count);
 	} else {
 		(sp->buffers_failed)++;
@@ -666,8 +658,7 @@ int pvr2_buffer_set_buffer(struct pvr2_buffer *bp,void *ptr,unsigned int cnt)
 			bp->max_count = cnt;
 			bp->stream->i_bcount += bp->max_count;
 			pvr2_trace(PVR2_TRACE_BUF_FLOW,
-				   "/*---TRACE_FLOW---*/ bufferPool    "
-				   " %8s cap cap=%07d cnt=%02d",
+				   "/*---TRACE_FLOW---*/ bufferPool	%8s cap cap=%07d cnt=%02d",
 				   pvr2_buffer_state_decode(
 					   pvr2_buffer_state_idle),
 				   bp->stream->i_bcount,bp->stream->i_count);
diff --git a/drivers/media/usb/pvrusb2/pvrusb2-ioread.c b/drivers/media/usb/pvrusb2/pvrusb2-ioread.c
index 614d55767a4e..1f0dce8fc7bf 100644
--- a/drivers/media/usb/pvrusb2/pvrusb2-ioread.c
+++ b/drivers/media/usb/pvrusb2/pvrusb2-ioread.c
@@ -169,9 +169,7 @@ static int pvr2_ioread_start(struct pvr2_ioread *cp)
 		stat = pvr2_buffer_queue(bp);
 		if (stat < 0) {
 			pvr2_trace(PVR2_TRACE_DATA_FLOW,
-				   "/*---TRACE_READ---*/"
-				   " pvr2_ioread_start id=%p"
-				   " error=%d",
+				   "/*---TRACE_READ---*/ pvr2_ioread_start id=%p error=%d",
 				   cp,stat);
 			pvr2_ioread_stop(cp);
 			return stat;
@@ -209,8 +207,8 @@ int pvr2_ioread_setup(struct pvr2_ioread *cp,struct pvr2_stream *sp)
 	do {
 		if (cp->stream) {
 			pvr2_trace(PVR2_TRACE_START_STOP,
-				   "/*---TRACE_READ---*/"
-				   " pvr2_ioread_setup (tear-down) id=%p",cp);
+				   "/*---TRACE_READ---*/ pvr2_ioread_setup (tear-down) id=%p",
+cp);
 			pvr2_ioread_stop(cp);
 			pvr2_stream_kill(cp->stream);
 			if (pvr2_stream_get_buffer_count(cp->stream)) {
@@ -220,8 +218,8 @@ int pvr2_ioread_setup(struct pvr2_ioread *cp,struct pvr2_stream *sp)
 		}
 		if (sp) {
 			pvr2_trace(PVR2_TRACE_START_STOP,
-				   "/*---TRACE_READ---*/"
-				   " pvr2_ioread_setup (setup) id=%p",cp);
+				   "/*---TRACE_READ---*/ pvr2_ioread_setup (setup) id=%p",
+cp);
 			pvr2_stream_kill(sp);
 			ret = pvr2_stream_set_buffer_count(sp,BUFFER_COUNT);
 			if (ret < 0) {
@@ -270,9 +268,7 @@ static int pvr2_ioread_get_buffer(struct pvr2_ioread *cp)
 			if (stat < 0) {
 				// Streaming error...
 				pvr2_trace(PVR2_TRACE_DATA_FLOW,
-					   "/*---TRACE_READ---*/"
-					   " pvr2_ioread_read id=%p"
-					   " queue_error=%d",
+					   "/*---TRACE_READ---*/ pvr2_ioread_read id=%p queue_error=%d",
 					   cp,stat);
 				pvr2_ioread_stop(cp);
 				return 0;
@@ -292,9 +288,7 @@ static int pvr2_ioread_get_buffer(struct pvr2_ioread *cp)
 			if (stat < 0) {
 				// Streaming error...
 				pvr2_trace(PVR2_TRACE_DATA_FLOW,
-					   "/*---TRACE_READ---*/"
-					   " pvr2_ioread_read id=%p"
-					   " buffer_error=%d",
+					   "/*---TRACE_READ---*/ pvr2_ioread_read id=%p buffer_error=%d",
 					   cp,stat);
 				pvr2_ioread_stop(cp);
 				// Give up.
@@ -347,8 +341,7 @@ static void pvr2_ioread_filter(struct pvr2_ioread *cp)
 		if (cp->sync_buf_offs >= cp->sync_key_len) {
 			cp->sync_trashed_count -= cp->sync_key_len;
 			pvr2_trace(PVR2_TRACE_DATA_FLOW,
-				   "/*---TRACE_READ---*/"
-				   " sync_state <== 2 (skipped %u bytes)",
+				   "/*---TRACE_READ---*/ sync_state <== 2 (skipped %u bytes)",
 				   cp->sync_trashed_count);
 			cp->sync_state = 2;
 			cp->sync_buf_offs = 0;
@@ -358,8 +351,7 @@ static void pvr2_ioread_filter(struct pvr2_ioread *cp)
 		if (cp->c_data_offs < cp->c_data_len) {
 			// Sanity check - should NEVER get here
 			pvr2_trace(PVR2_TRACE_ERROR_LEGS,
-				   "ERROR: pvr2_ioread filter sync problem"
-				   " len=%u offs=%u",
+				   "ERROR: pvr2_ioread filter sync problem len=%u offs=%u",
 				   cp->c_data_len,cp->c_data_offs);
 			// Get out so we don't get stuck in an infinite
 			// loop.
@@ -418,8 +410,8 @@ int pvr2_ioread_read(struct pvr2_ioread *cp,void __user *buf,unsigned int cnt)
 
 	if (!cnt) {
 		pvr2_trace(PVR2_TRACE_TRAP,
-			   "/*---TRACE_READ---*/ pvr2_ioread_read id=%p"
-			   " ZERO Request? Returning zero.",cp);
+			   "/*---TRACE_READ---*/ pvr2_ioread_read id=%p ZERO Request? Returning zero.",
+cp);
 		return 0;
 	}
 
@@ -477,8 +469,7 @@ int pvr2_ioread_read(struct pvr2_ioread *cp,void __user *buf,unsigned int cnt)
 					// Consumed entire key; switch mode
 					// to normal.
 					pvr2_trace(PVR2_TRACE_DATA_FLOW,
-						   "/*---TRACE_READ---*/"
-						   " sync_state <== 0");
+						   "/*---TRACE_READ---*/ sync_state <== 0");
 					cp->sync_state = 0;
 				}
 			} else {
@@ -502,8 +493,7 @@ int pvr2_ioread_read(struct pvr2_ioread *cp,void __user *buf,unsigned int cnt)
 	}
 
 	pvr2_trace(PVR2_TRACE_DATA_FLOW,
-		   "/*---TRACE_READ---*/ pvr2_ioread_read"
-		   " id=%p request=%d result=%d",
+		   "/*---TRACE_READ---*/ pvr2_ioread_read id=%p request=%d result=%d",
 		   cp,req_cnt,ret);
 	return ret;
 }
diff --git a/drivers/media/usb/pvrusb2/pvrusb2-std.c b/drivers/media/usb/pvrusb2/pvrusb2-std.c
index 9a596a3a4c27..cd7bc18a1ba2 100644
--- a/drivers/media/usb/pvrusb2/pvrusb2-std.c
+++ b/drivers/media/usb/pvrusb2/pvrusb2-std.c
@@ -357,8 +357,7 @@ struct v4l2_standard *pvr2_std_create_enum(unsigned int *countptr,
 		bcnt = pvr2_std_id_to_str(buf,sizeof(buf),fmsk);
 		pvr2_trace(
 			PVR2_TRACE_ERROR_LEGS,
-			"WARNING:"
-			" Failed to classify the following standard(s): %.*s",
+			"WARNING: Failed to classify the following standard(s): %.*s",
 			bcnt,buf);
 	}
 
diff --git a/drivers/media/usb/pvrusb2/pvrusb2-v4l2.c b/drivers/media/usb/pvrusb2/pvrusb2-v4l2.c
index 2cc4d2b6f810..bbbe18d5275a 100644
--- a/drivers/media/usb/pvrusb2/pvrusb2-v4l2.c
+++ b/drivers/media/usb/pvrusb2/pvrusb2-v4l2.c
@@ -949,8 +949,8 @@ static long pvr2_v4l2_ioctl(struct file *file,
 	if (ret < 0) {
 		if (pvrusb2_debug & PVR2_TRACE_V4LIOCTL) {
 			pvr2_trace(PVR2_TRACE_V4LIOCTL,
-				   "pvr2_v4l2_do_ioctl failure, ret=%ld"
-				   " command was:", ret);
+				   "pvr2_v4l2_do_ioctl failure, ret=%ld command was:",
+ret);
 			v4l_printk_ioctl(pvr2_hdw_get_driver_name(hdw), cmd);
 		}
 	} else {
@@ -1254,8 +1254,7 @@ static void pvr2_v4l2_dev_init(struct pvr2_v4l2_dev *dip,
 		nr_ptr = video_nr;
 		if (!dip->stream) {
 			pr_err(KBUILD_MODNAME
-				": Failed to set up pvrusb2 v4l video dev"
-				" due to missing stream instance\n");
+				": Failed to set up pvrusb2 v4l video dev due to missing stream instance\n");
 			return;
 		}
 		break;
@@ -1272,8 +1271,7 @@ static void pvr2_v4l2_dev_init(struct pvr2_v4l2_dev *dip,
 		break;
 	default:
 		/* Bail out (this should be impossible) */
-		pr_err(KBUILD_MODNAME ": Failed to set up pvrusb2 v4l dev"
-		    " due to unrecognized config\n");
+		pr_err(KBUILD_MODNAME ": Failed to set up pvrusb2 v4l dev due to unrecognized config\n");
 		return;
 	}
 
diff --git a/drivers/media/usb/pvrusb2/pvrusb2-video-v4l.c b/drivers/media/usb/pvrusb2/pvrusb2-video-v4l.c
index 105123ab36aa..6fee367139aa 100644
--- a/drivers/media/usb/pvrusb2/pvrusb2-video-v4l.c
+++ b/drivers/media/usb/pvrusb2/pvrusb2-video-v4l.c
@@ -91,9 +91,7 @@ void pvr2_saa7115_subdev_update(struct pvr2_hdw *hdw, struct v4l2_subdev *sd)
 		    (hdw->input_val < 0) ||
 		    (hdw->input_val >= sp->cnt)) {
 			pvr2_trace(PVR2_TRACE_ERROR_LEGS,
-				   "*** WARNING *** subdev v4l2 set_input:"
-				   " Invalid routing scheme (%u)"
-				   " and/or input (%d)",
+				   "*** WARNING *** subdev v4l2 set_input: Invalid routing scheme (%u) and/or input (%d)",
 				   sid, hdw->input_val);
 			return;
 		}
diff --git a/drivers/media/usb/pvrusb2/pvrusb2-wm8775.c b/drivers/media/usb/pvrusb2/pvrusb2-wm8775.c
index f1df94a2436f..7993983de5a6 100644
--- a/drivers/media/usb/pvrusb2/pvrusb2-wm8775.c
+++ b/drivers/media/usb/pvrusb2/pvrusb2-wm8775.c
@@ -49,8 +49,7 @@ void pvr2_wm8775_subdev_update(struct pvr2_hdw *hdw, struct v4l2_subdev *sd)
 			input = 2;
 			break;
 		}
-		pvr2_trace(PVR2_TRACE_CHIPS, "subdev wm8775"
-			   " set_input(val=%d route=0x%x)",
+		pvr2_trace(PVR2_TRACE_CHIPS, "subdev wm8775 set_input(val=%d route=0x%x)",
 			   hdw->input_val, input);
 
 		sd->ops->audio->s_routing(sd, input, 0, 0);
-- 
2.7.4


