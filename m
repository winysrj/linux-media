Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-out.m-online.net ([212.18.0.10]:47791 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756864AbZFVOg2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Jun 2009 10:36:28 -0400
Received: from mail01.m-online.net (mail.m-online.net [192.168.3.149])
	by mail-out.m-online.net (Postfix) with ESMTP id 44A621C000B0
	for <linux-media@vger.kernel.org>; Mon, 22 Jun 2009 16:36:31 +0200 (CEST)
Received: from localhost (dynscan2.mnet-online.de [192.168.1.215])
	by mail.m-online.net (Postfix) with ESMTP id 3F848903CD
	for <linux-media@vger.kernel.org>; Mon, 22 Jun 2009 16:36:31 +0200 (CEST)
Received: from mail.mnet-online.de ([192.168.3.149])
	by localhost (dynscan2.mnet-online.de [192.168.1.215]) (amavisd-new, port 10024)
	with ESMTP id SFjhWBT7ui4W for <linux-media@vger.kernel.org>;
	Mon, 22 Jun 2009 16:36:26 +0200 (CEST)
Received: from gauss.x.fun (ppp-88-217-107-241.dynamic.mnet-online.de [88.217.107.241])
	by mail.nefkom.net (Postfix) with ESMTP
	for <linux-media@vger.kernel.org>; Mon, 22 Jun 2009 16:36:26 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by gauss.x.fun (Postfix) with ESMTP id EE0001FC9AA
	for <linux-media@vger.kernel.org>; Mon, 22 Jun 2009 16:36:25 +0200 (CEST)
From: Matthias Schwarzott <zzam@gentoo.org>
To: linux-media@vger.kernel.org
Subject: lsmod path hardcoded in v4l/Makefile
Date: Mon, 22 Jun 2009 16:36:24 +0200
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_pb5PKLuGMmQpqz9"
Message-Id: <200906221636.25006.zzam@gentoo.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--Boundary-00=_pb5PKLuGMmQpqz9
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi list!

It seems the path to lsmod tool is hardcoded in the Makefile for out-of-tree 
building of v4l-dvb.
Now at least gentoo has moved lsmod from /sbin to /bin.
Additionally it is bad style (or at least I am told so), to not rely on $PATH 
but hardcode pathes for tools that should be in $PATH.

So the attached patch removes the hardcoded /sbin from the lsmod call.

Signed-off-by: Matthias Schwarzott <zzam@gentoo.org>

Regards
Matthias

--Boundary-00=_pb5PKLuGMmQpqz9
Content-Type: text/x-diff;
  charset="iso 8859-15";
  name="v4l-dvb-lsmod-path.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="v4l-dvb-lsmod-path.diff"

diff -r 65ec132f20df v4l/Makefile
--- a/v4l/Makefile	Wed May 27 15:53:00 2009 -0300
+++ b/v4l/Makefile	Thu May 28 10:05:04 2009 +0200
@@ -196,7 +196,7 @@
   inst-m	:= $(obj-m)
 endif
 
-v4l_modules := $(shell /sbin/lsmod|cut -d' ' -f1 ) $(patsubst %.ko,%,$(inst-m))
+v4l_modules := $(shell lsmod|cut -d' ' -f1 ) $(patsubst %.ko,%,$(inst-m))
 
 #################################################
 # locales seem to cause trouble sometimes.

--Boundary-00=_pb5PKLuGMmQpqz9--
