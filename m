Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtpfb1-g21.free.fr ([212.27.42.9]:34989 "EHLO
	smtpfb1-g21.free.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752124AbbADM1u (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 4 Jan 2015 07:27:50 -0500
Received: from smtp1-g21.free.fr (smtp1-g21.free.fr [212.27.42.1])
	by smtpfb1-g21.free.fr (Postfix) with ESMTP id 70EBF77DB6E
	for <linux-media@vger.kernel.org>; Sun,  4 Jan 2015 13:27:46 +0100 (CET)
From: Romain Naour <romain.naour@openwide.fr>
To: linux-media@vger.kernel.org
Cc: Simon Dawson <spdawson@gmail.com>
Subject: [PATCH 2/3] When building for avr32, the build fails as follows.
Date: Sun,  4 Jan 2015 13:27:36 +0100
Message-Id: <1420374457-8633-3-git-send-email-romain.naour@openwide.fr>
In-Reply-To: <1420374457-8633-1-git-send-email-romain.naour@openwide.fr>
References: <1420374457-8633-1-git-send-email-romain.naour@openwide.fr>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Simon Dawson <spdawson@gmail.com>

  cc1: error: unrecognized command line option "-Wno-packed-bitfield-compat"

An example of an autobuild failure arising from this is the following.

  http://autobuild.buildroot.net/results/92e/92e472004812a3616f62d766a9ea07a997a66e89/

Clearly, not all toolchains provide a gcc that understands
the -Wno-packed-bitfield-compat flag; remove usage of this flag.

Signed-off-by: Simon Dawson <spdawson@gmail.com>
---
 util/scan/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/util/scan/Makefile b/util/scan/Makefile
index d48c478..88667c5 100644
--- a/util/scan/Makefile
+++ b/util/scan/Makefile
@@ -14,7 +14,7 @@ inst_bin = $(binaries)
 
 removing = atsc_psip_section.c atsc_psip_section.h
 
-CPPFLAGS += -Wno-packed-bitfield-compat -D__KERNEL_STRICT_NAMES
+CPPFLAGS += -D__KERNEL_STRICT_NAMES
 
 .PHONY: all
 
-- 
1.9.3

