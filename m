Return-path: <mchehab@pedra>
Received: from mail2.matrix-vision.com ([85.214.244.251]:46374 "EHLO
	mail2.matrix-vision.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752795Ab1FUHj0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Jun 2011 03:39:26 -0400
From: Michael Jones <michael.jones@matrix-vision.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org
Subject: [PATCH 2/2] allow using autoconf 2.61+
Date: Tue, 21 Jun 2011 09:39:17 +0200
Message-Id: <1308641957-7805-3-git-send-email-michael.jones@matrix-vision.de>
In-Reply-To: <1308641957-7805-1-git-send-email-michael.jones@matrix-vision.de>
References: <1308641957-7805-1-git-send-email-michael.jones@matrix-vision.de>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Autoconf v2.61 seems to work just fine.  Allow it.

Signed-off-by: Michael Jones <michael.jones@matrix-vision.de>
---

 configure.in |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/configure.in b/configure.in
index 3f4f35b..fd4c70c 100644
--- a/configure.in
+++ b/configure.in
@@ -1,4 +1,4 @@
-AC_PREREQ([2.65])
+AC_PREREQ([2.61])
 AC_INIT([media-ctl], [0.0.1], [laurent.pinchart@ideasonboard.com])
 AC_CONFIG_SRCDIR([src/main.c])
 AC_CONFIG_AUX_DIR([config])
-- 
1.7.5.4


MATRIX VISION GmbH, Talstrasse 16, DE-71570 Oppenweiler
Registergericht: Amtsgericht Stuttgart, HRB 271090
Geschaeftsfuehrer: Gerhard Thullner, Werner Armingeon, Uwe Furtner
