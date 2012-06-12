Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:51810 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751840Ab2FLNyO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 12 Jun 2012 09:54:14 -0400
Received: by yenm10 with SMTP id m10so3394922yen.19
        for <linux-media@vger.kernel.org>; Tue, 12 Jun 2012 06:54:13 -0700 (PDT)
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: <linux-media@vger.kernel.org>,
	Ezequiel Garcia <elezegarcia@gmail.com>
Subject: [PATCH] em28xx: Make a few drxk_config structs static
Date: Tue, 12 Jun 2012 10:53:41 -0300
Message-Id: <1339509222-2714-1-git-send-email-elezegarcia@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Ezequiel Garcia <elezegarcia@gmail.com>
---
 drivers/media/video/em28xx/em28xx-dvb.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/media/video/em28xx/em28xx-dvb.c b/drivers/media/video/em28xx/em28xx-dvb.c
index 16410ac..241a71a 100644
--- a/drivers/media/video/em28xx/em28xx-dvb.c
+++ b/drivers/media/video/em28xx/em28xx-dvb.c
@@ -310,14 +310,14 @@ static struct drxd_config em28xx_drxd = {
 	.disable_i2c_gate_ctrl = 1,
 };
 
-struct drxk_config terratec_h5_drxk = {
+static struct drxk_config terratec_h5_drxk = {
 	.adr = 0x29,
 	.single_master = 1,
 	.no_i2c_bridge = 1,
 	.microcode_name = "dvb-usb-terratec-h5-drxk.fw",
 };
 
-struct drxk_config hauppauge_930c_drxk = {
+static struct drxk_config hauppauge_930c_drxk = {
 	.adr = 0x29,
 	.single_master = 1,
 	.no_i2c_bridge = 1,
@@ -325,13 +325,13 @@ struct drxk_config hauppauge_930c_drxk = {
 	.chunk_size = 56,
 };
 
-struct drxk_config maxmedia_ub425_tc_drxk = {
+static struct drxk_config maxmedia_ub425_tc_drxk = {
 	.adr = 0x29,
 	.single_master = 1,
 	.no_i2c_bridge = 1,
 };
 
-struct drxk_config pctv_520e_drxk = {
+static struct drxk_config pctv_520e_drxk = {
 	.adr = 0x29,
 	.single_master = 1,
 	.microcode_name = "dvb-demod-drxk-pctv.fw",
-- 
1.7.3.4

