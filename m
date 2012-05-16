Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:42560 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966987Ab2EPKom (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 16 May 2012 06:44:42 -0400
Received: by wibhn6 with SMTP id hn6so577188wib.1
        for <linux-media@vger.kernel.org>; Wed, 16 May 2012 03:44:41 -0700 (PDT)
From: Gianluca Gennari <gennarone@gmail.com>
To: linux-media@vger.kernel.org, mchehab@redhat.com
Cc: hans.verkuil@cisco.com, Gianluca Gennari <gennarone@gmail.com>
Subject: [PATCH 2/2] media_build: disable VIDEO_SMIAPP driver on kernels older than 2.6.34
Date: Wed, 16 May 2012 12:44:10 +0200
Message-Id: <1337165050-31638-3-git-send-email-gennarone@gmail.com>
In-Reply-To: <1337165050-31638-1-git-send-email-gennarone@gmail.com>
References: <1337165050-31638-1-git-send-email-gennarone@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The new 'smiapp' driver requires 'gpio_request_one':

media_build/v4l/smiapp-core.c:2333: error: implicit declaration of function 'gpio_request_one'

that was first introduced in kernel 2.6.34, so let's disable it on older kernels.

Signed-off-by: Gianluca Gennari <gennarone@gmail.com
---
 v4l/versions.txt |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/v4l/versions.txt b/v4l/versions.txt
index 5a8952f..a8170c2 100644
--- a/v4l/versions.txt
+++ b/v4l/versions.txt
@@ -43,6 +43,8 @@ VIDEO_TVP7002
 VIDEO_DT3155
 # Needs include/linux/lcm.h
 VIDEO_APTINA_PLL
+# Requires gpio_request_one introduced in 2.6.34
+VIDEO_SMIAPP
 
 [2.6.33]
 VIDEO_AK881X
-- 
1.7.0.4

