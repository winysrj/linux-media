Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp208.alice.it ([82.57.200.104]:43198 "EHLO smtp208.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932884Ab2KEX2f (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 5 Nov 2012 18:28:35 -0500
From: Antonio Ospite <ospite@studenti.unina.it>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Antti Palosaari <crope@iki.fi>,
	Michael Krufky <mkrufky@linuxtv.org>,
	Patrick Boettcher <patrick.boettcher@desy.de>,
	Antonio Ospite <ospite@studenti.unina.it>
Subject: [PATCH 2/5] [media] get_dvb_firmware: add dvb-usb-vp7049-0.95.fw
Date: Tue,  6 Nov 2012 00:28:13 +0100
Message-Id: <1352158096-17737-3-git-send-email-ospite@studenti.unina.it>
In-Reply-To: <1352158096-17737-1-git-send-email-ospite@studenti.unina.it>
References: <1352158096-17737-1-git-send-email-ospite@studenti.unina.it>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Firmware for vp7049 based design, known actual devices are:
  Twinhan/Azurewave DTV-DVB UDTT7049
  Digicom Digitune-S
  Think Xtra Hollywood DVB-T USB2.0

Signed-off-by: Antonio Ospite <ospite@studenti.unina.it>
---

I tried to contact the original manufacturer (Twinhan) but it does not exists
anymore, Azurewave didn't reply and Digicom told me that they could not
provide explicit permission to host the firmware on linuxtv.org;
I decided to put it on my web space for now, let me know if you think it's
safe to host it on linuxtv.org anyways.

Thanks,
   Antonio

 Documentation/dvb/get_dvb_firmware |   15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/Documentation/dvb/get_dvb_firmware b/Documentation/dvb/get_dvb_firmware
index 32bc56b..0cdb157 100755
--- a/Documentation/dvb/get_dvb_firmware
+++ b/Documentation/dvb/get_dvb_firmware
@@ -23,7 +23,7 @@ use IO::Handle;
 
 @components = ( "sp8870", "sp887x", "tda10045", "tda10046",
 		"tda10046lifeview", "av7110", "dec2000t", "dec2540t",
-		"dec3000s", "vp7041", "dibusb", "nxt2002", "nxt2004",
+		"dec3000s", "vp7041", "vp7049", "dibusb", "nxt2002", "nxt2004",
 		"or51211", "or51132_qam", "or51132_vsb", "bluebird",
 		"opera1", "cx231xx", "cx18", "cx23885", "pvrusb2", "mpc718",
 		"af9015", "ngene", "az6027", "lme2510_lg", "lme2510c_s7395",
@@ -289,6 +289,19 @@ sub vp7041 {
     $outfile;
 }
 
+sub vp7049 {
+    my $fwfile = "dvb-usb-vp7049-0.95.fw";
+    my $url = "http://ao2.it/sites/default/files/blog/2012/11/06/linux-support-digicom-digitune-s-vp7049-udtt7049/$fwfile";
+    my $hash = "5609fd295168aea88b25ff43a6f79c36";
+
+    checkstandard();
+
+    wgetfile($fwfile, $url);
+    verify($fwfile, $hash);
+
+    $fwfile;
+}
+
 sub dibusb {
 	my $url = "http://www.linuxtv.org/downloads/firmware/dvb-usb-dibusb-5.0.0.11.fw";
 	my $outfile = "dvb-dibusb-5.0.0.11.fw";
-- 
1.7.10.4

