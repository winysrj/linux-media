Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtpfb2-g21.free.fr ([212.27.42.10]:54404 "EHLO
	smtpfb2-g21.free.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750905AbbADMfI (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 4 Jan 2015 07:35:08 -0500
Received: from smtp1-g21.free.fr (smtp1-g21.free.fr [212.27.42.1])
	by smtpfb2-g21.free.fr (Postfix) with ESMTP id E380BCA94D8
	for <linux-media@vger.kernel.org>; Sun,  4 Jan 2015 13:27:46 +0100 (CET)
From: Romain Naour <romain.naour@openwide.fr>
To: linux-media@vger.kernel.org
Cc: Romain Naour <romain.naour@openwide.fr>
Subject: [PATCH 3/3] Make.rules: Handle static/shared only build
Date: Sun,  4 Jan 2015 13:27:37 +0100
Message-Id: <1420374457-8633-4-git-send-email-romain.naour@openwide.fr>
In-Reply-To: <1420374457-8633-1-git-send-email-romain.naour@openwide.fr>
References: <1420374457-8633-1-git-send-email-romain.naour@openwide.fr>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Do not build .a library when disable_static is set
Do not build .so library when disable_shared is set

Signed-off-by: Romain Naour <romain.naour@openwide.fr>
---
 Make.rules | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/Make.rules b/Make.rules
index 3410d7b..4add272 100644
--- a/Make.rules
+++ b/Make.rules
@@ -9,7 +9,13 @@ ifneq ($(lib_name),)
 CFLAGS_LIB ?= -fPIC
 CFLAGS += $(CFLAGS_LIB)
 
-libraries = $(lib_name).so $(lib_name).a
+ifeq ($(disable_static),)
+libraries = $(lib_name).a
+endif
+
+ifeq ($(disable_shared),)
+libraries += $(lib_name).so
+endif
 
 .PHONY: library
 
-- 
1.9.3

