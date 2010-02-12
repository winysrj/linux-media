Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:55779 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750963Ab0BLJ2w (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Feb 2010 04:28:52 -0500
Subject: BUG: latest dvb-apps do not compile due to MA's faulty
 implementation of the gotox utility
From: Chicken Shack <chicken.shack@gmx.de>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 12 Feb 2010 10:25:56 +0100
Message-ID: <1265966756.16004.5.camel@brian.bconsult.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

in order to make the latest dvb-apps compile cleanly 2 things need to be
done:

1. the already compiled gotox binary needs to be deleted

2. the following patch needs to be applied:

--- a/util/gotox/Makefile
+++ b/util/gotox/Makefile
@@ -1,5 +1,7 @@
 # Makefile for linuxtv.org dvb-apps/util/gotox
 
+objects  = gotox.o
+
 binaries = gotox
 
 inst_bin = $(binaries)
@@ -13,3 +15,7 @@
 .PHONY: all
 
 all: $(binaries)
+
+$(binaries): $(objects)
+
+include ../../Make.rules


Cheers

CS


