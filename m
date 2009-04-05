Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f165.google.com ([209.85.219.165]:53283 "EHLO
	mail-ew0-f165.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754263AbZDEFzZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 5 Apr 2009 01:55:25 -0400
Received: by ewy9 with SMTP id 9so1481558ewy.37
        for <linux-media@vger.kernel.org>; Sat, 04 Apr 2009 22:55:22 -0700 (PDT)
Message-ID: <49D847CA.3080404@gmail.com>
Date: Sun, 05 Apr 2009 07:55:22 +0200
From: joseba <josebagg@gmail.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: get_dvb_firmware patch + c88x board tuner question
Content-Type: multipart/mixed;
 boundary="------------010105000703060205040007"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------010105000703060205040007
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Hi, its my first post, and my first patch, my first try, so probably
iḿ going to make big mistakes. Dont be cruel.

I corrected urls in get_dvb_firmware,  from linux-source-2.6.29, so iḿ
going to suggest a patch


Trying to configure the NPG REAL DVB-T PCI
ttp://www.npgtech.com/producto_info.asp?idProducto=98

lspci -vnn output

03:06.0 Multimedia video controller [0400]: Conexant Systems, Inc.
CX23880/1/2/3 PCI Video and Audio Decoder [14f1:8800] (rev 05)
    Subsystem: Conexant Systems, Inc. Conexant DVB-T reference design
[14f1:0187]
    Flags: medium devsel, IRQ 20
    Memory at fa000000 (32-bit, non-prefetchable) [size=16M]
    Capabilities: [44] Vital Product Data
    Capabilities: [4c] Power Management version 2

03:06.2 Multimedia controller [0480]: Conexant Systems, Inc.
CX23880/1/2/3 PCI Video and Audio Decoder [MPEG Port] [14f1:8802] (rev 05)
    Subsystem: Conexant Systems, Inc. Conexant DVB-T reference design
[14f1:0187]
    Flags: medium devsel, IRQ 20
    Memory at fb000000 (32-bit, non-prefetchable) [size=16M]
    Capabilities: [4c] Power Management version 2


Video input working, and lirc input not checked,  with
insmod c88xx card=51 i2c_scan=1
dmesg output
cx88/2: cx2388x MPEG-TS Driver Manager version 0.0.6 loaded
 cx88[0]: subsystem: 14f1:0187, board: WinFast DTV2000 H
[card=51,insmod option], frontend(s): 1
 cx88[0]: TV tuner type 5, Radio tuner type -1
 tuner' 1-0043: chip found @ 0x86 (cx88[0])
 tda9887 1-0043: creating new instance
 tda9887 1-0043: tda988[5/6/7] found
 All bytes are equal. It is not a TEA5767
 tuner' 1-0060: chip found @ 0xc0 (cx88[0])
 tuner-simple 1-0060: creating new instance
 tuner-simple 1-0060: type set to 5 (Philips PAL_BG (FI1216 and
compatibles))
 input: cx88 IR (WinFast DTV2000 H) as
/devices/pci0000:00/0000:00:14.4/0000:03:06.2/input/input8
 cx88[0]/2: cx2388x 8802 Driver Manager
 cx88-mpeg driver manager 0000:03:06.2: PCI INT A -> GSI 20 (level,
low) -> IRQ 20
 cx88[0]/2: found at 0000:03:06.2, rev: 5, irq: 20, latency: 32, mmio:
0xfb000000
 IRQ 20/cx88[0]: IRQF_DISABLED is not guaranteed on shared IRQs


tuner seems to be a philips tda1004x, supported in  saa7134
chips in board are
conexant cx23881-19 , as pci bridge
conexant cx22702-25 , as frontend
philips tda6651, inside tuner as mixer according to datasheets

So, my newy questions, is anybody working to port this tuner, i will
try but unsure.  I prefer send hardware to a real developer.

Thanks

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAknYR8oACgkQ5c4hZyE8gm9cHgCgvhdSt+Wa4jvjo+uKb98xdC4J
oicAn0nrJEs0evuqYY3MsdHWuINZfUwz
=/Ffq
-----END PGP SIGNATURE-----


--------------010105000703060205040007
Content-Type: text/x-patch;
 name="get_dvb_firmware.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="get_dvb_firmware.patch"

--- get_dvb_firmware	2009-03-24 00:12:14.000000000 +0100
+++ get_dvb_firmware 	2009-04-05 06:55:18.000000000 +0200
@@ -112,7 +112,7 @@
 
 sub tda10046 {
 	my $sourcefile = "TT_PCI_2.19h_28_11_2006.zip";
-	my $url = "http://technotrend-online.com/download/software/219/$sourcefile";
+	my $url = "http://www.tt-download.com/download/updates/219/$sourcefile";
 	my $hash = "6a7e1e2f2644b162ff0502367553c72d";
 	my $outfile = "dvb-fe-tda10046.fw";
 	my $tmpdir = tempdir(DIR => "/tmp", CLEANUP => 1);
@@ -129,8 +129,8 @@
 }
 
 sub tda10046lifeview {
-    my $sourcefile = "Drv_2.11.02.zip";
-    my $url = "http://www.lifeview.com.tw/drivers/pci_card/FlyDVB-T/$sourcefile";
+    my $sourcefile = "7%5Cdrv_2.11.02.zip";
+    my $url = "http://www.lifeview.hk/dbimages/document/$sourcefile";
     my $hash = "1ea24dee4eea8fe971686981f34fd2e0";
     my $outfile = "dvb-fe-tda10046.fw";
     my $tmpdir = tempdir(DIR => "/tmp", CLEANUP => 1);

--------------010105000703060205040007--
