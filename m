Return-path: <linux-media-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:45690 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756753Ab0GNQUJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 14 Jul 2010 12:20:09 -0400
From: Sergio Aguirre <saaguirre@ti.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, Sergio Aguirre <saaguirre@ti.com>
Subject: [media-ctl PATCH 2/3] Just include kernel headers
Date: Wed, 14 Jul 2010 11:17:25 -0500
Message-Id: <1279124246-12187-3-git-send-email-saaguirre@ti.com>
In-Reply-To: <1279124246-12187-1-git-send-email-saaguirre@ti.com>
References: <1279124246-12187-1-git-send-email-saaguirre@ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

We shouldn't require full kernel source for this.

Signed-off-by: Sergio Aguirre <saaguirre@ti.com>
---
 Makefile |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/Makefile b/Makefile
index bf4cf55..300ed7e 100644
--- a/Makefile
+++ b/Makefile
@@ -1,11 +1,9 @@
-SRCARCH ?= arm
 CROSS_COMPILE ?= arm-none-linux-gnueabi-
-KDIR ?= /usr/src/linux
+HDIR ?= /usr/include
 
-KINC := -I$(KDIR)/include -I$(KDIR)/arch/$(SRCARCH)/include
 CC   := $(CROSS_COMPILE)gcc
 
-CFLAGS = -O2 -Wall -fpic -I. $(KINC)
+CFLAGS = -O2 -Wall -fpic -I$(HDIR)
 OBJS = media.o main.o options.o subdev.o
 
 all: media-ctl
-- 
1.6.3.3

