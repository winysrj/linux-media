Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailrelay009.isp.belgacom.be ([195.238.6.176]:5725 "EHLO
	mailrelay009.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753190AbZFGRbp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 7 Jun 2009 13:31:45 -0400
Received: from [192.168.1.4] (athloroad.xperim.be [192.168.1.4])
	(authenticated bits=0)
	by via.xperim.be (8.14.2/8.14.2/Debian-2build1) with ESMTP id n57HVD1v006709
	for <linux-media@vger.kernel.org>; Sun, 7 Jun 2009 19:31:14 +0200
Message-ID: <4A2BF95E.8040009@computer.org>
Date: Sun, 07 Jun 2009 19:31:10 +0200
From: Jan Ceuleers <jan.ceuleers@computer.org>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Broken link in get_dvb_firmware for nxt2004 (A180)
Content-Type: multipart/mixed;
 boundary="------------070509000805090107070104"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------070509000805090107070104
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hi!

I read the following on the mythtv-users mailing list, and I'd just like to make sure that you guys are aware of it as well.

The script get_dvb_firmware no longer works for obtaining the nxt2004 firmware because AVer have reorganised their websites. The wanted file is now available from the following URL:

http://www.avermedia-usa.com/support/Drivers/AVerTVHD_MCE_A180_Drv_v1.2.2.16.zip

The patch is therefore as follows (this is against 2.6.29; inlined and attached).

Note that I don't subscribe to the mailing list.

Cheers, Jan

--- linux-2.6.29/Documentation/dvb/get_dvb_firmware.orig        2009-06-07 14:38:20.000000000 +0200
+++ linux-2.6.29/Documentation/dvb/get_dvb_firmware     2009-06-07 14:38:55.000000000 +0200
@@ -317,7 +317,7 @@

 sub nxt2004 {
     my $sourcefile = "AVerTVHD_MCE_A180_Drv_v1.2.2.16.zip";
-    my $url = "http://www.aver.com/support/Drivers/$sourcefile";
+    my $url = "http://www.avermedia-usa.com/support/Drivers/$sourcefile";
     my $hash = "111cb885b1e009188346d72acfed024c";
     my $outfile = "dvb-fe-nxt2004.fw";
     my $tmpdir = tempdir(DIR => "/tmp", CLEANUP => 1);

--------------070509000805090107070104
Content-Type: text/plain;
 name="averfw.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="averfw.patch"

--- linux-2.6.29/Documentation/dvb/get_dvb_firmware.orig	2009-06-07 14:38:20.000000000 +0200
+++ linux-2.6.29/Documentation/dvb/get_dvb_firmware	2009-06-07 14:38:55.000000000 +0200
@@ -317,7 +317,7 @@
 
 sub nxt2004 {
     my $sourcefile = "AVerTVHD_MCE_A180_Drv_v1.2.2.16.zip";
-    my $url = "http://www.aver.com/support/Drivers/$sourcefile";
+    my $url = "http://www.avermedia-usa.com/support/Drivers/$sourcefile";
     my $hash = "111cb885b1e009188346d72acfed024c";
     my $outfile = "dvb-fe-nxt2004.fw";
     my $tmpdir = tempdir(DIR => "/tmp", CLEANUP => 1);

--------------070509000805090107070104--
