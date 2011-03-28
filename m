Return-path: <mchehab@pedra>
Received: from mailfe04.c2i.net ([212.247.154.98]:39314 "EHLO swip.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754445Ab1C1Ri1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 28 Mar 2011 13:38:27 -0400
Received: from [188.126.198.129] (account mc467741@c2i.net HELO laptop002.hselasky.homeunix.org)
  by mailfe04.swip.net (CommuniGate Pro SMTP 5.2.19)
  with ESMTPA id 106055718 for linux-media@vger.kernel.org; Mon, 28 Mar 2011 19:38:24 +0200
From: Hans Petter Selasky <hselasky@c2i.net>
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: [PATCH] cx24116.c - fix for wrong parameter description
Date: Mon, 28 Mar 2011 19:37:36 +0200
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_gdMkN+AgbVvFf0o"
Message-Id: <201103281937.36599.hselasky@c2i.net>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

--Boundary-00=_gdMkN+AgbVvFf0o
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit


See attachment.

--HPS

--Boundary-00=_gdMkN+AgbVvFf0o
Content-Type: text/x-patch;
  charset="us-ascii";
  name="cx24116.c.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
	filename="cx24116.c.diff"

--- cx24116.c.orig	2011-03-20 23:11:40.000000000 +0100
+++ cx24116.c	2011-03-20 23:12:35.000000000 +0100
@@ -137,7 +137,7 @@
 /* SNR measurements */
 static int esno_snr;
 module_param(esno_snr, int, 0644);
-MODULE_PARM_DESC(debug, "SNR return units, 0=PERCENTAGE 0-100, "\
+MODULE_PARM_DESC(esno_snr, "SNR return units, 0=PERCENTAGE 0-100, "\
 	"1=ESNO(db * 10) (default:0)");
 
 enum cmds {

--Boundary-00=_gdMkN+AgbVvFf0o--
