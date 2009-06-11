Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailrelay003.isp.belgacom.be ([195.238.6.53]:39735 "EHLO
	mailrelay003.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757752AbZFKS1j (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Jun 2009 14:27:39 -0400
Message-ID: <4A314C76.3040000@computer.org>
Date: Thu, 11 Jun 2009 20:27:02 +0200
From: Jan Ceuleers <jan.ceuleers@computer.org>
MIME-Version: 1.0
To: Douglas Schilling Landgraf <dougsland@gmail.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org
Subject: [PATCH] dvb: Fix broken link in get_dvb_firmware for nxt2004 (A180)
References: <4A2BF95E.8040009@computer.org> <20090610235358.3bc559b6@gmail.com>
In-Reply-To: <20090610235358.3bc559b6@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Due to a reorganisation of AVermedia's websites, get_dvb_firmware
no longer works for nxt2004. Fix it.

Signed-off-by: Jan Ceuleers <jan.ceuleers@computer.org>
--- a/Documentation/dvb/get_dvb_firmware.orig        2009-06-07 14:38:20.000000000 +0200
+++ b/Documentation/dvb/get_dvb_firmware     2009-06-07 14:38:55.000000000 +0200
@@ -317,7 +317,7 @@

 sub nxt2004 {
     my $sourcefile = "AVerTVHD_MCE_A180_Drv_v1.2.2.16.zip";
-    my $url = "http://www.aver.com/support/Drivers/$sourcefile";
+    my $url = "http://www.avermedia-usa.com/support/Drivers/$sourcefile";
     my $hash = "111cb885b1e009188346d72acfed024c";
     my $outfile = "dvb-fe-nxt2004.fw";
     my $tmpdir = tempdir(DIR => "/tmp", CLEANUP => 1);
