Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:4533 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753296AbaHTW7q (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Aug 2014 18:59:46 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 19/29] mantis: fix sparse warnings
Date: Thu, 21 Aug 2014 00:59:18 +0200
Message-Id: <1408575568-20562-20-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1408575568-20562-1-git-send-email-hverkuil@xs4all.nl>
References: <1408575568-20562-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

drivers/media/pci/mantis/hopper_vp3028.c:37:23: warning: symbol 'hopper_vp3028_config' was not declared. Should it be static?
drivers/media/pci/mantis/mantis_vp1033.c:38:4: warning: symbol 'lgtdqcs001f_inittab' was not declared. Should it be static?
drivers/media/pci/mantis/mantis_vp1033.c:153:23: warning: symbol 'lgtdqcs001f_config' was not declared. Should it be static?
drivers/media/pci/mantis/mantis_vp1034.c:39:23: warning: symbol 'vp1034_mb86a16_config' was not declared. Should it be static?
drivers/media/pci/mantis/mantis_vp1041.c:266:23: warning: symbol 'vp1041_stb0899_config' was not declared. Should it be static?
drivers/media/pci/mantis/mantis_vp1041.c:303:23: warning: symbol 'vp1041_stb6100_config' was not declared. Should it be static?
drivers/media/pci/mantis/mantis_vp2033.c:40:24: warning: symbol 'vp2033_tda1002x_cu1216_config' was not declared. Should it be static?
drivers/media/pci/mantis/mantis_vp2033.c:45:24: warning: symbol 'vp2033_tda10023_cu1216_config' was not declared. Should it be static?
drivers/media/pci/mantis/mantis_vp2040.c:40:24: warning: symbol 'vp2040_tda1002x_cu1216_config' was not declared. Should it be static?
drivers/media/pci/mantis/mantis_vp2040.c:45:24: warning: symbol 'vp2040_tda10023_cu1216_config' was not declared. Should it be static?
drivers/media/pci/mantis/mantis_vp3030.c:38:23: warning: symbol 'mantis_vp3030_config' was not declared. Should it be static?
drivers/media/pci/mantis/mantis_vp3030.c:42:23: warning: symbol 'env57h12d5_config' was not declared. Should it be static?
drivers/media/pci/mantis/mantis_dma.c:167:33: warning: incorrect type in assignment (different base types)
drivers/media/pci/mantis/mantis_dma.c:172:33: warning: incorrect type in assignment (different base types)
drivers/media/pci/mantis/mantis_dma.c:174:25: warning: incorrect type in assignment (different base types)
drivers/media/pci/mantis/mantis_dma.c:178:9: warning: incorrect type in assignment (different base types)
drivers/media/pci/mantis/mantis_dma.c:179:9: warning: incorrect type in assignment (different base types)

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/pci/mantis/hopper_vp3028.c | 2 +-
 drivers/media/pci/mantis/mantis_common.h | 2 +-
 drivers/media/pci/mantis/mantis_vp1033.c | 4 ++--
 drivers/media/pci/mantis/mantis_vp1034.c | 2 +-
 drivers/media/pci/mantis/mantis_vp1041.c | 4 ++--
 drivers/media/pci/mantis/mantis_vp2033.c | 4 ++--
 drivers/media/pci/mantis/mantis_vp2040.c | 4 ++--
 drivers/media/pci/mantis/mantis_vp3030.c | 4 ++--
 8 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/media/pci/mantis/hopper_vp3028.c b/drivers/media/pci/mantis/hopper_vp3028.c
index 68a29f8..1032db6 100644
--- a/drivers/media/pci/mantis/hopper_vp3028.c
+++ b/drivers/media/pci/mantis/hopper_vp3028.c
@@ -34,7 +34,7 @@
 #include "mantis_dvb.h"
 #include "hopper_vp3028.h"
 
-struct zl10353_config hopper_vp3028_config = {
+static struct zl10353_config hopper_vp3028_config = {
 	.demod_address	= 0x0f,
 };
 
diff --git a/drivers/media/pci/mantis/mantis_common.h b/drivers/media/pci/mantis/mantis_common.h
index f2410cf..8ff448b 100644
--- a/drivers/media/pci/mantis/mantis_common.h
+++ b/drivers/media/pci/mantis/mantis_common.h
@@ -127,7 +127,7 @@ struct mantis_pci {
 	u32			last_block;
 	u8			*buf_cpu;
 	dma_addr_t		buf_dma;
-	u32			*risc_cpu;
+	__le32			*risc_cpu;
 	dma_addr_t		risc_dma;
 
 	struct tasklet_struct	tasklet;
diff --git a/drivers/media/pci/mantis/mantis_vp1033.c b/drivers/media/pci/mantis/mantis_vp1033.c
index 115003e..12a6adb 100644
--- a/drivers/media/pci/mantis/mantis_vp1033.c
+++ b/drivers/media/pci/mantis/mantis_vp1033.c
@@ -35,7 +35,7 @@
 #include "mantis_vp1033.h"
 #include "mantis_reg.h"
 
-u8 lgtdqcs001f_inittab[] = {
+static u8 lgtdqcs001f_inittab[] = {
 	0x01, 0x15,
 	0x02, 0x30,
 	0x03, 0x00,
@@ -150,7 +150,7 @@ static int lgtdqcs001f_set_symbol_rate(struct dvb_frontend *fe,
 	return 0;
 }
 
-struct stv0299_config lgtdqcs001f_config = {
+static struct stv0299_config lgtdqcs001f_config = {
 	.demod_address		= 0x68,
 	.inittab		= lgtdqcs001f_inittab,
 	.mclk			= 88000000UL,
diff --git a/drivers/media/pci/mantis/mantis_vp1034.c b/drivers/media/pci/mantis/mantis_vp1034.c
index 430ae84..7c1bd16 100644
--- a/drivers/media/pci/mantis/mantis_vp1034.c
+++ b/drivers/media/pci/mantis/mantis_vp1034.c
@@ -36,7 +36,7 @@
 #include "mantis_vp1034.h"
 #include "mantis_reg.h"
 
-struct mb86a16_config vp1034_mb86a16_config = {
+static struct mb86a16_config vp1034_mb86a16_config = {
 	.demod_address	= 0x08,
 	.set_voltage	= vp1034_set_voltage,
 };
diff --git a/drivers/media/pci/mantis/mantis_vp1041.c b/drivers/media/pci/mantis/mantis_vp1041.c
index 07a2074..7082fcb 100644
--- a/drivers/media/pci/mantis/mantis_vp1041.c
+++ b/drivers/media/pci/mantis/mantis_vp1041.c
@@ -263,7 +263,7 @@ static const struct stb0899_s1_reg vp1041_stb0899_s1_init_3[] = {
 	{ 0xffff			, 0xff },
 };
 
-struct stb0899_config vp1041_stb0899_config = {
+static struct stb0899_config vp1041_stb0899_config = {
 	.init_dev		= vp1041_stb0899_s1_init_1,
 	.init_s2_demod		= stb0899_s2_init_2,
 	.init_s1_demod		= vp1041_stb0899_s1_init_3,
@@ -300,7 +300,7 @@ struct stb0899_config vp1041_stb0899_config = {
 	.tuner_set_rfsiggain	= NULL,
 };
 
-struct stb6100_config vp1041_stb6100_config = {
+static struct stb6100_config vp1041_stb6100_config = {
 	.tuner_address	= 0x60,
 	.refclock	= 27000000,
 };
diff --git a/drivers/media/pci/mantis/mantis_vp2033.c b/drivers/media/pci/mantis/mantis_vp2033.c
index 1ca6837..8d48b5a 100644
--- a/drivers/media/pci/mantis/mantis_vp2033.c
+++ b/drivers/media/pci/mantis/mantis_vp2033.c
@@ -37,12 +37,12 @@
 #define MANTIS_MODEL_NAME	"VP-2033"
 #define MANTIS_DEV_TYPE		"DVB-C"
 
-struct tda1002x_config vp2033_tda1002x_cu1216_config = {
+static struct tda1002x_config vp2033_tda1002x_cu1216_config = {
 	.demod_address = 0x18 >> 1,
 	.invert = 1,
 };
 
-struct tda10023_config vp2033_tda10023_cu1216_config = {
+static struct tda10023_config vp2033_tda10023_cu1216_config = {
 	.demod_address = 0x18 >> 1,
 	.invert = 1,
 };
diff --git a/drivers/media/pci/mantis/mantis_vp2040.c b/drivers/media/pci/mantis/mantis_vp2040.c
index d480741..8dd17d7 100644
--- a/drivers/media/pci/mantis/mantis_vp2040.c
+++ b/drivers/media/pci/mantis/mantis_vp2040.c
@@ -37,12 +37,12 @@
 #define MANTIS_MODEL_NAME	"VP-2040"
 #define MANTIS_DEV_TYPE		"DVB-C"
 
-struct tda1002x_config vp2040_tda1002x_cu1216_config = {
+static struct tda1002x_config vp2040_tda1002x_cu1216_config = {
 	.demod_address	= 0x18 >> 1,
 	.invert		= 1,
 };
 
-struct tda10023_config vp2040_tda10023_cu1216_config = {
+static struct tda10023_config vp2040_tda10023_cu1216_config = {
 	.demod_address	= 0x18 >> 1,
 	.invert		= 1,
 };
diff --git a/drivers/media/pci/mantis/mantis_vp3030.c b/drivers/media/pci/mantis/mantis_vp3030.c
index c09308cd..5c1dd92 100644
--- a/drivers/media/pci/mantis/mantis_vp3030.c
+++ b/drivers/media/pci/mantis/mantis_vp3030.c
@@ -35,11 +35,11 @@
 #include "mantis_dvb.h"
 #include "mantis_vp3030.h"
 
-struct zl10353_config mantis_vp3030_config = {
+static struct zl10353_config mantis_vp3030_config = {
 	.demod_address		= 0x0f,
 };
 
-struct tda665x_config env57h12d5_config = {
+static struct tda665x_config env57h12d5_config = {
 	.name			= "ENV57H12D5 (ET-50DT)",
 	.addr			= 0x60,
 	.frequency_min		=  47000000,
-- 
2.1.0.rc1

