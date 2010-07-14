Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:33095 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756717Ab0GNQUJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 14 Jul 2010 12:20:09 -0400
From: Sergio Aguirre <saaguirre@ti.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, Sergio Aguirre <saaguirre@ti.com>
Subject: [media-ctl PATCH 3/3] Be able to add more CFLAGS
Date: Wed, 14 Jul 2010 11:17:26 -0500
Message-Id: <1279124246-12187-4-git-send-email-saaguirre@ti.com>
In-Reply-To: <1279124246-12187-1-git-send-email-saaguirre@ti.com>
References: <1279124246-12187-1-git-send-email-saaguirre@ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This allows the gcc compilation to build with extra parameters.

For example, if we want to build with -static, we just do:

make CFLAGS=-static

Signed-off-by: Sergio Aguirre <saaguirre@ti.com>
---
 Makefile |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Makefile b/Makefile
index 300ed7e..bd53626 100644
--- a/Makefile
+++ b/Makefile
@@ -3,7 +3,7 @@ HDIR ?= /usr/include
 
 CC   := $(CROSS_COMPILE)gcc
 
-CFLAGS = -O2 -Wall -fpic -I$(HDIR)
+CFLAGS += -O2 -Wall -fpic -I$(HDIR)
 OBJS = media.o main.o options.o subdev.o
 
 all: media-ctl
-- 
1.6.3.3

