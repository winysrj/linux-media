Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qg0-f50.google.com ([209.85.192.50]:36031 "EHLO
	mail-qg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751565AbcDUVFW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Apr 2016 17:05:22 -0400
Received: by mail-qg0-f50.google.com with SMTP id d90so19910337qgd.3
        for <linux-media@vger.kernel.org>; Thu, 21 Apr 2016 14:05:22 -0700 (PDT)
Received: from ?IPv6:2001:4830:1600:505::2? (cl-1286.qas-01.us.sixxs.net. [2001:4830:1600:505::2])
        by smtp.googlemail.com with ESMTPSA id 77sm1194914qgi.33.2016.04.21.14.05.20
        for <linux-media@vger.kernel.org>
        (version=TLSv1/SSLv3 cipher=OTHER);
        Thu, 21 Apr 2016 14:05:20 -0700 (PDT)
To: linux-media@vger.kernel.org
From: Dominic Chen <d.c.ddcc@gmail.com>
Subject: [PATCH/RFC] dvb-core: drop stubs for llseek()
Message-ID: <c9979b23-4aae-34bb-7423-1630c7df7cf7@gmail.com>
Date: Thu, 21 Apr 2016 17:05:24 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Since the default behavior in vfs_llseek() is now no_llseek(), and
filp->f_pos / ppos are not actually used anywhere in dvb, drop the
inconsistent llseek() stubs.

Signed-off-by: Dominic Chen <d.c.ddcc@gmail.com>
---
 drivers/media/dvb-core/dmxdev.c         | 2 --
 drivers/media/dvb-core/dvb_ca_en50221.c | 1 -
 drivers/media/dvb-core/dvb_frontend.c   | 1 -
 drivers/media/dvb-core/dvb_net.c        | 1 -
 drivers/media/dvb-core/dvbdev.c         | 1 -
 5 files changed, 6 deletions(-)

diff --git a/drivers/media/dvb-core/dmxdev.c
b/drivers/media/dvb-core/dmxdev.c
index a168cbe..25494bf 100644
--- a/drivers/media/dvb-core/dmxdev.c
+++ b/drivers/media/dvb-core/dmxdev.c
@@ -1135,7 +1135,6 @@ static const struct file_operations dvb_demux_fops = {
     .open = dvb_demux_open,
     .release = dvb_demux_release,
     .poll = dvb_demux_poll,
-    .llseek = default_llseek,
 };
 
 static const struct dvb_device dvbdev_demux = {
@@ -1211,7 +1210,6 @@ static const struct file_operations dvb_dvr_fops = {
     .open = dvb_dvr_open,
     .release = dvb_dvr_release,
     .poll = dvb_dvr_poll,
-    .llseek = default_llseek,
 };
 
 static const struct dvb_device dvbdev_dvr = {
diff --git a/drivers/media/dvb-core/dvb_ca_en50221.c
b/drivers/media/dvb-core/dvb_ca_en50221.c
index f82cd1f..e736fb9 100644
--- a/drivers/media/dvb-core/dvb_ca_en50221.c
+++ b/drivers/media/dvb-core/dvb_ca_en50221.c
@@ -1636,7 +1636,6 @@ static const struct file_operations dvb_ca_fops = {
     .open = dvb_ca_en50221_io_open,
     .release = dvb_ca_en50221_io_release,
     .poll = dvb_ca_en50221_io_poll,
-    .llseek = noop_llseek,
 };
 
 static const struct dvb_device dvbdev_ca = {
diff --git a/drivers/media/dvb-core/dvb_frontend.c
b/drivers/media/dvb-core/dvb_frontend.c
index c014261..e29543c 100644
--- a/drivers/media/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb-core/dvb_frontend.c
@@ -2600,7 +2600,6 @@ static const struct file_operations
dvb_frontend_fops = {
     .poll        = dvb_frontend_poll,
     .open        = dvb_frontend_open,
     .release    = dvb_frontend_release,
-    .llseek        = noop_llseek,
 };
 
 int dvb_frontend_suspend(struct dvb_frontend *fe)
diff --git a/drivers/media/dvb-core/dvb_net.c
b/drivers/media/dvb-core/dvb_net.c
index ce6a711..d4af8d0 100644
--- a/drivers/media/dvb-core/dvb_net.c
+++ b/drivers/media/dvb-core/dvb_net.c
@@ -1457,7 +1457,6 @@ static const struct file_operations dvb_net_fops = {
     .unlocked_ioctl = dvb_net_ioctl,
     .open =    dvb_generic_open,
     .release = dvb_net_close,
-    .llseek = noop_llseek,
 };
 
 static const struct dvb_device dvbdev_net = {
diff --git a/drivers/media/dvb-core/dvbdev.c
b/drivers/media/dvb-core/dvbdev.c
index e1684c5..bc8086d 100644
--- a/drivers/media/dvb-core/dvbdev.c
+++ b/drivers/media/dvb-core/dvbdev.c
@@ -101,7 +101,6 @@ static const struct file_operations dvb_device_fops =
 {
     .owner =    THIS_MODULE,
     .open =        dvb_device_open,
-    .llseek =    noop_llseek,
 };
 
 static struct cdev dvb_device_cdev;
-- 
1.9.1

