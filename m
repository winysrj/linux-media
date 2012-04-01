Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:47159 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751576Ab2DANbE (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 1 Apr 2012 09:31:04 -0400
Message-ID: <1333287054.2357.9.camel@tvbox>
Subject: [stable for 3.2][patch] Kernel 3.2 add support for IT9135 chip
 version 2 devices.
From: Malcolm Priestley <tvboxspy@gmail.com>
To: stable@vger.kernel.org
Cc: linux-media@vger.kernel.org
Date: Sun, 01 Apr 2012 14:30:54 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Originally, IT9135 chip version 2 devices were never intended to be supported in kernel 3.2
as they were thought at the time only on ID 048d:9006.

However, they have since been supplied on ID 048d:9135, the following error occurs.

[   53.512013] usb 2-4: new high-speed USB device number 5 using ehci_hcd
[   53.648936] it913x: Chip Version=02 Chip Type=9135
[   53.650434] it913x: Dual mode=0 Remote=5 Tuner Type=5f
[   53.651556] dvb-usb: found a 'ITE 9135 Generic' in cold state, will try to load a firmware
[   53.660244] dvb-usb: downloading firmware from file 'dvb-usb-it9137-01.fw'
[   53.661026] it913x: FRM Starting Firmware Download
[   54.152006] it913x: FRM Firmware Download Failed (ffffffed)
[   54.352082] it913x: Chip Version=6f Chip Type=0203
[   55.188050] it913x: DEV it913x Error


This patch and the cherry picks fixes the issue and applies firmware differences
in commit 7330f7c157308166c507da9b9926107d85f960d3 and the 3.2 tree.

The driver is updated to version it913x 1.24 and it913x-fe 1.12.

Note existing 048d:9135 version 1 users will need to switch to dvb-usb-it9135-01.fw
firmware as in kernel 3.3 after this update.

./get_dvb_firmware it9135
extracts
dvb-usb-it9135-01.fw
dvb-usb-it9135-02.fw

./get_dvb_firmware it9137
extracts
dvb-usb-it9137-01.fw

The following upstream cherry-picks in order need to be applied.

Cc: <stable@vger.kernel.org> # .32.x: b7d425d39179e125604cbf451a06d3204d2e1398: sched: it913x Support it9135 Verions 2 chip
Cc: <stable@vger.kernel.org> # .32.x: 2b3c13ecce3bc0fbdeb5ef0596b350dc702d01d5: sched: it913x-fe ver 1.09 amend adc table entries
Cc: <stable@vger.kernel.org> # .32.x: 3822c7cef7b422833f1b58949a01bd87b822d280: sched: it913x ver 1.09 support for USB 1 devices (IT9135)
Cc: <stable@vger.kernel.org> # .32.x: 3339a5b165c2769a84346cac342ade67d7b7a510: sched: it913x-fe ver 1.10 correct SNR reading from frontend
Cc: <stable@vger.kernel.org> # .32.x: ed942c507465287777a5342f83af1638ba05a6ac: sched: it913x-fe: more user and debugging info
Cc: <stable@vger.kernel.org> # .32.x: fdb5a9111ef77d537efb86e90e8073ebfd0b553e: sched: Support for Sveon STV22 (IT9137)
Cc: <stable@vger.kernel.org> # .32.x: 9c1133c7c89266d4969e36527ce7be958d1b93c6: sched: it913x: endpoint size changes
Cc: <stable@vger.kernel.org> # .32.x: 990f49af3f564b9a0f572e06f22e2ae34c79c37d: sched: it913x: support for different tuner regs
Cc: <stable@vger.kernel.org> # .32.x: c725ff69737313647f981813e8f39a372c99b0f0: sched: it913x: support for NEC extended keys
Cc: <stable@vger.kernel.org> # .32.x: b69902914803a8bf93f39f0db642430504c800ba: sched: it913x: multi firmware loader
Cc: <stable@vger.kernel.org> # .32.x: 5e642c06b561fd95d77d13f41adeb6e906acc31d: sched: it9135:  add support for IT9135 9005 devices
Cc: <stable@vger.kernel.org> # .32.x: 15157c506d742b6767edcd486d6c73ea907fb7cf: sched: it913x add retry to USB bulk endpoints and IO
Cc: <stable@vger.kernel.org> # .32.x: 50815707eebc7ce12bfd97933a6e68a482c4d7ab: sched: it913x: multiple devices on system.
Cc: <stable@vger.kernel.org> # .32.x: a7187c324ff5a879b5b0e6bb947664071c870803: sched: [BUG] Re: add support for IT9135 9005 devices
Cc: <stable@vger.kernel.org> # .32.x: f36472da3a6d62ee46ae773bbbf05ddb24cd970c: sched: it913x stop dual frontend attach in warm state with single devices
Cc: <stable@vger.kernel.org> # .32.x: 53844c4fc7912fef2f56c1b3f851b30c8ebd1d8a: sched: it913x add support for IT9135 9006 devices
Cc: <stable@vger.kernel.org> # .32.x: ed3189cf989128fe283d6dbffbbae08b67d9e5bd: sched: it913x ver 1.18 Turn pid filter off by caps option only
Cc: <stable@vger.kernel.org> # .32.x: d4d5a40710701abd4535d6a5ada601c885a08865: sched: [BUG] it913x ver 1.20. PID filter problems
Cc: <stable@vger.kernel.org> # .32.x: fa52520cff0b3dce483efa8fb4ae1a4b18a82109: sched: [BUG] it913x ver 1.21 Fixed for issue with 9006 and warm boot
Cc: <stable@vger.kernel.org> # .32.X: 245900c4a7a7d23c2e5b2b64b70770debcac5814: sched: [media] it913x ver 1.22 corrections to Tuner IDs
Cc: <stable@vger.kernel.org> # .32.x: f0e07d7658a81bc185b8ba58f062c16b79ac0e2b: sched: it913x changed firmware loader for chip version 2 types
Cc: <stable@vger.kernel.org> # .32.x: a8ea0218625699a5c635655a17b565bab5888ea1: sched: it913x v1.23 use it913x_config.chip_ver to select firmware
Cc: <stable@vger.kernel.org> # .32.x: fc594e3e5196d4cf7ace7735eeca399f7a80868b: sched: it913x ver 1.24 Make 0x60 default on version 2 devices
Cc: <stable@vger.kernel.org> # .32.x

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 Documentation/dvb/get_dvb_firmware |   22 +++++++++++++++++++++-
 1 files changed, 21 insertions(+), 1 deletions(-)

diff --git a/Documentation/dvb/get_dvb_firmware b/Documentation/dvb/get_dvb_firmware
index e67be7a..a4ff8e7 100755
--- a/Documentation/dvb/get_dvb_firmware
+++ b/Documentation/dvb/get_dvb_firmware
@@ -28,7 +28,7 @@ use IO::Handle;
 		"opera1", "cx231xx", "cx18", "cx23885", "pvrusb2", "mpc718",
 		"af9015", "ngene", "az6027", "lme2510_lg", "lme2510c_s7395",
 		"lme2510c_s7395_old", "drxk", "drxk_terratec_h5", "tda10071",
-		"it9135" );
+		"it9135", "it9137");
 
 # Check args
 syntax() if (scalar(@ARGV) != 1);
@@ -658,6 +658,26 @@ sub drxk_terratec_h5 {
 }
 
 sub it9135 {
+	my $sourcefile = "dvb-usb-it9135.zip";
+	my $url = "http://www.ite.com.tw/uploads/firmware/v3.6.0.0/$sourcefile";
+	my $hash = "1e55f6c8833f1d0ae067c2bb2953e6a9";
+	my $tmpdir = tempdir(DIR => "/tmp", CLEANUP => 0);
+	my $outfile = "dvb-usb-it9135.fw";
+	my $fwfile1 = "dvb-usb-it9135-01.fw";
+	my $fwfile2 = "dvb-usb-it9135-02.fw";
+
+	checkstandard();
+
+	wgetfile($sourcefile, $url);
+	unzip($sourcefile, $tmpdir);
+	verify("$tmpdir/$outfile", $hash);
+	extract("$tmpdir/$outfile", 64, 8128, "$fwfile1");
+	extract("$tmpdir/$outfile", 12866, 5817, "$fwfile2");
+
+	"$fwfile1 $fwfile2"
+}
+
+sub it9137 {
     my $url = "http://kworld.server261.com/kworld/CD/ITE_TiVme/V1.00/";
     my $zipfile = "Driver_V10.323.1.0412.100412.zip";
     my $hash = "79b597dc648698ed6820845c0c9d0d37";
-- 
1.7.9.1

