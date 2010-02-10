Return-path: <linux-media-owner@vger.kernel.org>
Received: from tichy.grunau.be ([85.131.189.73]:49934 "EHLO tichy.grunau.be"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753069Ab0BJSfJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Feb 2010 13:35:09 -0500
Received: from localhost (p5DDC401F.dip0.t-ipconnect.de [93.220.64.31])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by tichy.grunau.be (Postfix) with ESMTPSA id 773EB90076
	for <linux-media@vger.kernel.org>; Wed, 10 Feb 2010 19:35:09 +0100 (CET)
Date: Wed, 10 Feb 2010 19:36:44 +0100
From: Janne Grunau <j@jannau.net>
To: linux-media@vger.kernel.org
Subject: [PATCH 3 of 7] czap: reformat and extend usage string
Message-ID: <20100210183644.GN8026@aniel.lan>
References: <patchbomb.1265826616@aniel.lan>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="PuGuTyElPB9bOcsM"
Content-Disposition: inline
In-Reply-To: <patchbomb.1265826616@aniel.lan>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--PuGuTyElPB9bOcsM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

 util/szap/czap.c |  16 +++++++++++++---
 1 files changed, 13 insertions(+), 3 deletions(-)



--PuGuTyElPB9bOcsM
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: inline; filename="dvb-apps-3.patch"

# HG changeset patch
# User Janne Grunau <j@jannau.net>
# Date 1265823779 -3600
# Node ID c1e4c34da4fd395755d98dbbdd7af2950d723a9d
# Parent  d79f9e2901a05fbee905998294d9cb1ae46a422d
czap: reformat and extend usage string

diff -r d79f9e2901a0 -r c1e4c34da4fd util/szap/czap.c
--- a/util/szap/czap.c	Wed Feb 10 17:45:30 2010 +0100
+++ b/util/szap/czap.c	Wed Feb 10 18:42:59 2010 +0100
@@ -241,9 +241,19 @@
 }
 
 
-static const char *usage = "\nusage: %s [-a adapter_num] [-f frontend_id] [-d demux_id] [-c conf_file] [ -H ] {<channel name>| -n channel_num} [-x]\n"
-	"   or: %s [-c conf_file]  -l\n\n";
-
+static const char *usage =
+    "\nusage: %s [options]  -l\n"
+    "         list known channels\n"
+    "       %s [options] {-n channel-number|channel_name}\n"
+    "         zap to channel via number or full name (case insensitive)\n"
+    "     -a number : use given adapter (default 0)\n"
+    "     -f number : use given frontend (default 0)\n"
+    "     -d number : use given demux (default 0)\n"
+    "     -c file   : read channels list from 'file'\n"
+    "     -x        : exit after tuning\n"
+    "     -H        : human readable output\n"
+    "     -r        : set up /dev/dvb/adapterX/dvr0 for TS recording\n"
+;
 
 int main(int argc, char **argv)
 {

--PuGuTyElPB9bOcsM--
