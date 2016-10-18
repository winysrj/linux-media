Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:51399 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754129AbcJRUqQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 18 Oct 2016 16:46:16 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: [PATCH v2 02/58] cx25840: don't break long lines
Date: Tue, 18 Oct 2016 18:45:14 -0200
Message-Id: <c418ddf18cf90f17a3011ef07117aabe3a2fa2c4.1476822924.git.mchehab@s-opensource.com>
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
 drivers/media/i2c/cx25840/cx25840-core.c | 11 +++--------
 drivers/media/i2c/cx25840/cx25840-ir.c   |  7 +++----
 2 files changed, 6 insertions(+), 12 deletions(-)

diff --git a/drivers/media/i2c/cx25840/cx25840-core.c b/drivers/media/i2c/cx25840/cx25840-core.c
index 142ae28803bb..0dcf450052ac 100644
--- a/drivers/media/i2c/cx25840/cx25840-core.c
+++ b/drivers/media/i2c/cx25840/cx25840-core.c
@@ -873,10 +873,7 @@ void cx25840_std_setup(struct i2c_client *client)
 					"Chroma sub-carrier freq = %d.%06d MHz\n",
 					fsc / 1000000, fsc % 1000000);
 
-			v4l_dbg(1, cx25840_debug, client, "hblank %i, hactive %i, "
-				"vblank %i, vactive %i, vblank656 %i, src_dec %i, "
-				"burst 0x%02x, luma_lpf %i, uv_lpf %i, comb 0x%02x, "
-				"sc 0x%06x\n",
+			v4l_dbg(1, cx25840_debug, client, "hblank %i, hactive %i, vblank %i, vactive %i, vblank656 %i, src_dec %i, burst 0x%02x, luma_lpf %i, uv_lpf %i, comb 0x%02x, sc 0x%06x\n",
 				hblank, hactive, vblank, vactive, vblank656,
 				src_decimation, burst, luma_lpf, uv_lpf, comb, sc);
 		}
@@ -5169,11 +5166,9 @@ static int cx25840_probe(struct i2c_client *client,
 		id = CX2310X_AV;
 	} else if ((device_id & 0xff) == (device_id >> 8)) {
 		v4l_err(client,
-			"likely a confused/unresponsive cx2388[578] A/V decoder"
-			" found @ 0x%x (%s)\n",
+			"likely a confused/unresponsive cx2388[578] A/V decoder found @ 0x%x (%s)\n",
 			client->addr << 1, client->adapter->name);
-		v4l_err(client, "A method to reset it from the cx25840 driver"
-			" software is not known at this time\n");
+		v4l_err(client, "A method to reset it from the cx25840 driver software is not known at this time\n");
 		return -ENODEV;
 	} else {
 		v4l_dbg(1, cx25840_debug, client, "cx25840 not found\n");
diff --git a/drivers/media/i2c/cx25840/cx25840-ir.c b/drivers/media/i2c/cx25840/cx25840-ir.c
index 4b782012cadc..15fbd9607cee 100644
--- a/drivers/media/i2c/cx25840/cx25840-ir.c
+++ b/drivers/media/i2c/cx25840/cx25840-ir.c
@@ -1113,8 +1113,8 @@ int cx25840_ir_log_status(struct v4l2_subdev *sd)
 			j = 0;
 			break;
 		}
-		v4l2_info(sd, "\tNext carrier edge window:          16 clocks "
-			  "-%1d/+%1d, %u to %u Hz\n", i, j,
+		v4l2_info(sd, "\tNext carrier edge window:	    16 clocks -%1d/+%1d, %u to %u Hz\n",
+			  i, j,
 			  clock_divider_to_freq(rxclk, 16 + j),
 			  clock_divider_to_freq(rxclk, 16 - i));
 	}
@@ -1124,8 +1124,7 @@ int cx25840_ir_log_status(struct v4l2_subdev *sd)
 	v4l2_info(sd, "\tLow pass filter:                   %s\n",
 		  filtr ? "enabled" : "disabled");
 	if (filtr)
-		v4l2_info(sd, "\tMin acceptable pulse width (LPF):  %u us, "
-			  "%u ns\n",
+		v4l2_info(sd, "\tMin acceptable pulse width (LPF):  %u us, %u ns\n",
 			  lpf_count_to_us(filtr),
 			  lpf_count_to_ns(filtr));
 	v4l2_info(sd, "\tPulse width timer timed-out:       %s\n",
-- 
2.7.4


