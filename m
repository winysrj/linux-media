Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qa0-f46.google.com ([209.85.216.46]:64481 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751690Ab2JHM4M (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Oct 2012 08:56:12 -0400
Received: by mail-qa0-f46.google.com with SMTP id c26so2044261qad.19
        for <linux-media@vger.kernel.org>; Mon, 08 Oct 2012 05:56:11 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 8 Oct 2012 20:56:11 +0800
Message-ID: <CAPgLHd99=Guh7C7yTT_FkcTjGj7yNd1nAURqYChk9A30WgHTDA@mail.gmail.com>
Subject: [PATCH] [media] staging :go700: use module_i2c_driver to simplify the code
From: Wei Yongjun <weiyj.lk@gmail.com>
To: mchehab@infradead.org, gregkh@linuxfoundation.org
Cc: yongjun_wei@trendmicro.com.cn, linux-media@vger.kernel.org,
	devel@driverdev.osuosl.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Use the module_i2c_driver() macro to make the code smaller
and a bit simpler.

dpatch engine is used to auto generate this patch.
(https://github.com/weiyj/dpatch)

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/staging/media/go7007/wis-uda1342.c    | 13 +------------
 drivers/staging/media/go7007/wis-tw9903.c     | 13 +------------
 drivers/staging/media/go7007/wis-tw2804.c     | 13 +------------
 drivers/staging/media/go7007/wis-sony-tuner.c | 13 +------------
 drivers/staging/media/go7007/wis-saa7115.c    | 13 +------------
 drivers/staging/media/go7007/wis-saa7113.c    | 13 +------------
 drivers/staging/media/go7007/wis-ov7640.c     | 13 +------------
 drivers/staging/media/go7007/s2250-board.c    | 13 +------------
 8 files changed, 8 insertions(+), 96 deletions(-)

diff --git a/drivers/staging/media/go7007/wis-uda1342.c b/drivers/staging/media/go7007/wis-uda1342.c
index 0127be2..05ac798 100644
--- a/drivers/staging/media/go7007/wis-uda1342.c
+++ b/drivers/staging/media/go7007/wis-uda1342.c
@@ -98,17 +98,6 @@ static struct i2c_driver wis_uda1342_driver = {
 	.id_table	= wis_uda1342_id,
 };
 
-static int __init wis_uda1342_init(void)
-{
-	return i2c_add_driver(&wis_uda1342_driver);
-}
-
-static void __exit wis_uda1342_cleanup(void)
-{
-	i2c_del_driver(&wis_uda1342_driver);
-}
-
-module_init(wis_uda1342_init);
-module_exit(wis_uda1342_cleanup);
+module_i2c_driver(wis_uda1342_driver);
 
 MODULE_LICENSE("GPL v2");

diff --git a/drivers/staging/media/go7007/wis-tw9903.c b/drivers/staging/media/go7007/wis-tw9903.c
index 9230f4a..94071de 100644
--- a/drivers/staging/media/go7007/wis-tw9903.c
+++ b/drivers/staging/media/go7007/wis-tw9903.c
@@ -325,17 +325,6 @@ static struct i2c_driver wis_tw9903_driver = {
 	.id_table	= wis_tw9903_id,
 };
 
-static int __init wis_tw9903_init(void)
-{
-	return i2c_add_driver(&wis_tw9903_driver);
-}
-
-static void __exit wis_tw9903_cleanup(void)
-{
-	i2c_del_driver(&wis_tw9903_driver);
-}
-
-module_init(wis_tw9903_init);
-module_exit(wis_tw9903_cleanup);
+module_i2c_driver(wis_tw9903_driver);
 
 MODULE_LICENSE("GPL v2");

diff --git a/drivers/staging/media/go7007/wis-tw2804.c b/drivers/staging/media/go7007/wis-tw2804.c
index 9134f03..d6410ee 100644
--- a/drivers/staging/media/go7007/wis-tw2804.c
+++ b/drivers/staging/media/go7007/wis-tw2804.c
@@ -341,17 +341,6 @@ static struct i2c_driver wis_tw2804_driver = {
 	.id_table	= wis_tw2804_id,
 };
 
-static int __init wis_tw2804_init(void)
-{
-	return i2c_add_driver(&wis_tw2804_driver);
-}
-
-static void __exit wis_tw2804_cleanup(void)
-{
-	i2c_del_driver(&wis_tw2804_driver);
-}
-
-module_init(wis_tw2804_init);
-module_exit(wis_tw2804_cleanup);
+module_i2c_driver(wis_tw2804_driver);
 
 MODULE_LICENSE("GPL v2");

diff --git a/drivers/staging/media/go7007/wis-sony-tuner.c b/drivers/staging/media/go7007/wis-sony-tuner.c
index 8f1b7d4..1291ab7 100644
--- a/drivers/staging/media/go7007/wis-sony-tuner.c
+++ b/drivers/staging/media/go7007/wis-sony-tuner.c
@@ -704,17 +704,6 @@ static struct i2c_driver wis_sony_tuner_driver = {
 	.id_table	= wis_sony_tuner_id,
 };
 
-static int __init wis_sony_tuner_init(void)
-{
-	return i2c_add_driver(&wis_sony_tuner_driver);
-}
-
-static void __exit wis_sony_tuner_cleanup(void)
-{
-	i2c_del_driver(&wis_sony_tuner_driver);
-}
-
-module_init(wis_sony_tuner_init);
-module_exit(wis_sony_tuner_cleanup);
+module_i2c_driver(wis_sony_tuner_driver);
 
 MODULE_LICENSE("GPL v2");

diff --git a/drivers/staging/media/go7007/wis-saa7115.c b/drivers/staging/media/go7007/wis-saa7115.c
index 46cff59..47a3146 100644
--- a/drivers/staging/media/go7007/wis-saa7115.c
+++ b/drivers/staging/media/go7007/wis-saa7115.c
@@ -453,17 +453,6 @@ static struct i2c_driver wis_saa7115_driver = {
 	.id_table	= wis_saa7115_id,
 };
 
-static int __init wis_saa7115_init(void)
-{
-	return i2c_add_driver(&wis_saa7115_driver);
-}
-
-static void __exit wis_saa7115_cleanup(void)
-{
-	i2c_del_driver(&wis_saa7115_driver);
-}
-
-module_init(wis_saa7115_init);
-module_exit(wis_saa7115_cleanup);
+module_i2c_driver(wis_saa7115_driver);
 
 MODULE_LICENSE("GPL v2");

diff --git a/drivers/staging/media/go7007/wis-saa7113.c b/drivers/staging/media/go7007/wis-saa7113.c
index 05e0e10..f6b6ae8 100644
--- a/drivers/staging/media/go7007/wis-saa7113.c
+++ b/drivers/staging/media/go7007/wis-saa7113.c
@@ -320,17 +320,6 @@ static struct i2c_driver wis_saa7113_driver = {
 	.id_table	= wis_saa7113_id,
 };
 
-static int __init wis_saa7113_init(void)
-{
-	return i2c_add_driver(&wis_saa7113_driver);
-}
-
-static void __exit wis_saa7113_cleanup(void)
-{
-	i2c_del_driver(&wis_saa7113_driver);
-}
-
-module_init(wis_saa7113_init);
-module_exit(wis_saa7113_cleanup);
+module_i2c_driver(wis_saa7113_driver);
 
 MODULE_LICENSE("GPL v2");

diff --git a/drivers/staging/media/go7007/wis-ov7640.c b/drivers/staging/media/go7007/wis-ov7640.c
index 6bc9470..3aaeb91 100644
--- a/drivers/staging/media/go7007/wis-ov7640.c
+++ b/drivers/staging/media/go7007/wis-ov7640.c
@@ -92,17 +92,6 @@ static struct i2c_driver wis_ov7640_driver = {
 	.id_table	= wis_ov7640_id,
 };
 
-static int __init wis_ov7640_init(void)
-{
-	return i2c_add_driver(&wis_ov7640_driver);
-}
-
-static void __exit wis_ov7640_cleanup(void)
-{
-	i2c_del_driver(&wis_ov7640_driver);
-}
-
-module_init(wis_ov7640_init);
-module_exit(wis_ov7640_cleanup);
+module_i2c_driver(wis_ov7640_driver);
 
 MODULE_LICENSE("GPL v2");

diff --git a/drivers/staging/media/go7007/s2250-board.c b/drivers/staging/media/go7007/s2250-board.c
index 014d384..b397410 100644
--- a/drivers/staging/media/go7007/s2250-board.c
+++ b/drivers/staging/media/go7007/s2250-board.c
@@ -688,15 +688,4 @@ static struct i2c_driver s2250_driver = {
 	.id_table	= s2250_id,
 };
 
-static __init int init_s2250(void)
-{
-	return i2c_add_driver(&s2250_driver);
-}
-
-static __exit void exit_s2250(void)
-{
-	i2c_del_driver(&s2250_driver);
-}
-
-module_init(init_s2250);
-module_exit(exit_s2250);
+module_i2c_driver(s2250_driver);


