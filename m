Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:33206 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758051Ab2CTOKs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Mar 2012 10:10:48 -0400
Received: by eekc41 with SMTP id c41so31451eek.19
        for <linux-media@vger.kernel.org>; Tue, 20 Mar 2012 07:10:47 -0700 (PDT)
From: Gianluca Gennari <gennarone@gmail.com>
To: linux-media@vger.kernel.org, mchehab@redhat.com
Cc: Gianluca Gennari <gennarone@gmail.com>
Subject: [PATCH] lirc: delete unused init/exit function prototypes
Date: Tue, 20 Mar 2012 15:10:39 +0100
Message-Id: <1332252639-3256-1-git-send-email-gennarone@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The lirc sasem and imon drivers now use the module_usb_driver macro, so the old
init/exit function prototypes are useless.

This patch eliminates this warnings:

media_build/v4l/lirc_imon.c:74:19: warning: 'imon_init' declared 'static' but never defined [-Wunused-function]
media_build/v4l/lirc_imon.c:75:20: warning: 'imon_exit' declared 'static' but never defined [-Wunused-function]
media_build/v4l/lirc_sasem.c:84:19: warning: 'sasem_init' declared 'static' but never defined [-Wunused-function]
media_build/v4l/lirc_sasem.c:85:20: warning: 'sasem_exit' declared 'static' but never defined [-Wunused-function]

Signed-off-by: Gianluca Gennari <gennarone@gmail.com>
---
 drivers/staging/media/lirc/lirc_imon.c  |    4 ----
 drivers/staging/media/lirc/lirc_sasem.c |    4 ----
 2 files changed, 0 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/media/lirc/lirc_imon.c b/drivers/staging/media/lirc/lirc_imon.c
index 5f7f8cd..083219d 100644
--- a/drivers/staging/media/lirc/lirc_imon.c
+++ b/drivers/staging/media/lirc/lirc_imon.c
@@ -70,10 +70,6 @@ static ssize_t vfd_write(struct file *file, const char __user *buf,
 static int ir_open(void *data);
 static void ir_close(void *data);
 
-/* Driver init/exit prototypes */
-static int __init imon_init(void);
-static void __exit imon_exit(void);
-
 /*** G L O B A L S ***/
 #define IMON_DATA_BUF_SZ	35
 
diff --git a/drivers/staging/media/lirc/lirc_sasem.c b/drivers/staging/media/lirc/lirc_sasem.c
index 7855baa..8372d5e 100644
--- a/drivers/staging/media/lirc/lirc_sasem.c
+++ b/drivers/staging/media/lirc/lirc_sasem.c
@@ -80,10 +80,6 @@ static ssize_t vfd_write(struct file *file, const char *buf,
 static int ir_open(void *data);
 static void ir_close(void *data);
 
-/* Driver init/exit prototypes */
-static int __init sasem_init(void);
-static void __exit sasem_exit(void);
-
 /*** G L O B A L S ***/
 #define SASEM_DATA_BUF_SZ	32
 
-- 
1.7.5.4

