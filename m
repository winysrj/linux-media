Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:34340 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752443AbZFGPYj (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 7 Jun 2009 11:24:39 -0400
Date: Sun, 7 Jun 2009 12:24:37 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Jan Ceuleers <jan.ceuleers@computer.org>
Subject: Fw: Broken link in get_dvb_firmware for nxt2004 (A180)
Message-ID: <20090607122437.731302d3@pedra.chehab.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/eghlGvr8G65qKZ8jkRcXsN0"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--MP_/eghlGvr8G65qKZ8jkRcXsN0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Jan,

Instead of v4l-dvb-maintainer and V4L ML, please send patches to
linux-media@vger.kernel.org, otherwise, patchwork won't catch it.

Forwarded message:

Date: Sun, 07 Jun 2009 14:42:15 +0200
From: Jan Ceuleers <jan.ceuleers@computer.org>
To: mchehab@infradead.org, v4l-dvb-maintainer@linuxtv.org,        video4linux-list@redhat.com
Subject: Re: Broken link in get_dvb_firmware for nxt2004 (A180)


Errr... The patch was produced the wrong way around. Sorry about that. 
Trying again.






Cheers,
Mauro

--MP_/eghlGvr8G65qKZ8jkRcXsN0
Content-Type: text/plain; name=averfw.patch
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=averfw.patch

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

--MP_/eghlGvr8G65qKZ8jkRcXsN0--
