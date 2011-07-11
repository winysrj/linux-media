Return-path: <mchehab@localhost>
Received: from mx1.redhat.com ([209.132.183.28]:34162 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758287Ab1GKRjh (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Jul 2011 13:39:37 -0400
Message-ID: <4E1B3551.4030705@redhat.com>
Date: Mon, 11 Jul 2011 14:39:29 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Oliver Endriss <o.endriss@gmx.de>,
	Ralph Metzler <rjkm@metzlerbros.de>
Subject: Re: [PATCH 00/21] drx-k patches and Terratec H5 support (em28xx)
References: <20110710225907.29f002e1@pedra>
In-Reply-To: <20110710225907.29f002e1@pedra>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@infradead.org>

Em 10-07-2011 22:59, Mauro Carvalho Chehab escreveu:
> This patch series applies after the DRX-K/ngene/ddbridge patches that
> Oliver Endriss submitted.
> 
> It does a cleanup on several small issues at drx-k, including driver
> removal. It also adds support for Terratec H5 (only DVB-C were tested).
> In order to use Terratec H5, a different firmware is needed. I'm trying
> to get a formal permission to release the firmware, or to find some time
> to write an extraction logic for get_firmware script.
> 
> The entire series with DRX-K, ngene support, ddbridge and em28xx are
> hosted at my experimental tree, at branch ngene of:
> 	git://linuxtv.org/mchehab/experimental.git ngene
> 
> In order to make DRX-K driver to work with Terratec H5, I used a refence
> driver found at Terratec site:
> 	http://linux.terratec.de/files/TERRATEC_H7/20110323_TERRATEC_H7_Linux.tar.gz
> 
> The driver there is more complete, and has also analog support, but
> it didn't work as-is for Terratec H7. On both drivers, there were
> some board-specific setup in the middle of the driver. I've parametrized
> the ones found at the ngene/drxk in order to allow re-using the same
> driver for em28xx/drxk. I suspect that I'll need to add more parameters
> for Terratec H7. For example, the driver at Terratec site uses 3 GPIO's 
> for H7, while the other drivers don't seem to need any.
> 
> In order to allow me to check what was going wrong with Terratec H5, I
> wrote a DRX-K parser for em28xx logs, found at:
> 	http://git.linuxtv.org/v4l-utils.git?a=blob;f=contrib/em28xx/parse_em28xx_drxk.pl;h=8659ccac29c0cac1acfa39907cf0239a3201fe26;hb=86a37d95c8c33e6b877a486104da122a0a05931c
> 
> The parser helped a lot to discover what commands were generating errors,
> allowing me to compare with the reference drivers and discovering what
> were broken. I hope it may be useful also for the others. It shouldn't
> be hard to change it to parse logs from other usb devices.
> 
> It is possible to check what's happening in real time with:
> 
> 	sudo ./parse_tcpdump_log.pl |./em28xx/parse_em28xx_drxk.pl
> 
> I'll post a message as soon as I find a way to allow people to obtain
> the DRX-K firmware needed for Terratec H5.

Terratec has granted us a permission to re-distribute the firmware:
	http://www.linuxtv.org/downloads/firmware/#7

I'll be submitting the firmware to linux-firmware tree.

The enclosed patch should make it to work, once the firmware is downloaded
and copyed into /lib/firmware.

Please test.

-

From: Mauro Carvalho Chehab <mchehab@redhat.com>
Date: Mon, 11 Jul 2011 14:33:51 -0300
Subject: [media] em28xx: Change firmware name for Terratec H5 DRX-K

Use a name convention for the firmware file that matches on the
current firmware namespacing. Also, add it to the firmware
download script.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/Documentation/dvb/get_dvb_firmware b/Documentation/dvb/get_dvb_firmware
old mode 100644
new mode 100755
index 224d9e6..c466f58
--- a/Documentation/dvb/get_dvb_firmware
+++ b/Documentation/dvb/get_dvb_firmware
@@ -27,7 +27,7 @@ use IO::Handle;
 		"or51211", "or51132_qam", "or51132_vsb", "bluebird",
 		"opera1", "cx231xx", "cx18", "cx23885", "pvrusb2", "mpc718",
 		"af9015", "ngene", "az6027", "lme2510_lg", "lme2510c_s7395",
-		"lme2510c_s7395_old", "drxk");
+		"lme2510c_s7395_old", "drxk", "drxk_terratec_h5");
 
 # Check args
 syntax() if (scalar(@ARGV) != 1);
@@ -652,6 +652,19 @@ sub drxk {
     "$fwfile"
 }
 
+sub drxk_terratec_h5 {
+    my $url = "http://www.linuxtv.org/downloads/firmware/";
+    my $hash = "19000dada8e2741162ccc50cc91fa7f1";
+    my $fwfile = "dvb-usb-terratec-h5-drxk.fw";
+
+    checkstandard();
+
+    wgetfile($fwfile, $url . $fwfile);
+    verify($fwfile, $hash);
+
+    "$fwfile"
+}
+
 # ---------------------------------------------------------------
 # Utilities
 
diff --git a/drivers/media/video/em28xx/em28xx-dvb.c b/drivers/media/video/em28xx/em28xx-dvb.c
index 9b2be03..f8617d2 100644
--- a/drivers/media/video/em28xx/em28xx-dvb.c
+++ b/drivers/media/video/em28xx/em28xx-dvb.c
@@ -305,7 +305,7 @@ struct drxk_config terratec_h5_drxk = {
 	.adr = 0x29,
 	.single_master = 1,
 	.no_i2c_bridge = 1,
-	.microcode_name = "terratec_h5.fw",
+	.microcode_name = "dvb-usb-terratec-h5-drxk.fw",
 };
 
 static int drxk_gate_ctrl(struct dvb_frontend *fe, int enable)
