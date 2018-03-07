Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:49211 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754364AbeCGKNm (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 7 Mar 2018 05:13:42 -0500
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Yasunari Takiguchi <Yasunari.Takiguchi@sony.com>
Subject: [PATCH 2/3] media: cxd2880: don't return unitialized values
Date: Wed,  7 Mar 2018 05:13:35 -0500
Message-Id: <9ca4897be5adef66b8fe384b4365ce385e83582f.1520417613.git.mchehab@s-opensource.com>
In-Reply-To: <e61591875b7b626085c079499ac1c4663bfe510e.1520417613.git.mchehab@s-opensource.com>
References: <e61591875b7b626085c079499ac1c4663bfe510e.1520417613.git.mchehab@s-opensource.com>
In-Reply-To: <e61591875b7b626085c079499ac1c4663bfe510e.1520417613.git.mchehab@s-opensource.com>
References: <e61591875b7b626085c079499ac1c4663bfe510e.1520417613.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

drivers/media/dvb-frontends/cxd2880/cxd2880_devio_spi.c:59 cxd2880_io_spi_read_reg() error: uninitialized symbol 'ret'.
drivers/media/dvb-frontends/cxd2880/cxd2880_devio_spi.c:111 cxd2880_io_spi_write_reg() error: uninitialized symbol 'ret'.
drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd.c:2985 cxd2880_tnrdmd_set_cfg() error: uninitialized symbol 'ret'.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/dvb-frontends/cxd2880/cxd2880_devio_spi.c | 4 ++--
 drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd.c    | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/dvb-frontends/cxd2880/cxd2880_devio_spi.c b/drivers/media/dvb-frontends/cxd2880/cxd2880_devio_spi.c
index d2e37c95d748..aba59400859e 100644
--- a/drivers/media/dvb-frontends/cxd2880/cxd2880_devio_spi.c
+++ b/drivers/media/dvb-frontends/cxd2880/cxd2880_devio_spi.c
@@ -16,7 +16,7 @@ static int cxd2880_io_spi_read_reg(struct cxd2880_io *io,
 				   u8 sub_address, u8 *data,
 				   u32 size)
 {
-	int ret;
+	int ret = 0;
 	struct cxd2880_spi *spi = NULL;
 	u8 send_data[6];
 	u8 *read_data_top = data;
@@ -64,7 +64,7 @@ static int cxd2880_io_spi_write_reg(struct cxd2880_io *io,
 				    u8 sub_address,
 				    const u8 *data, u32 size)
 {
-	int ret;
+	int ret = 0;
 	struct cxd2880_spi *spi = NULL;
 	u8 send_data[BURST_WRITE_MAX + 4];
 	const u8 *write_data_top = data;
diff --git a/drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd.c b/drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd.c
index 25851bbb846e..4cf2d7cfd3f5 100644
--- a/drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd.c
+++ b/drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd.c
@@ -2503,7 +2503,7 @@ int cxd2880_tnrdmd_set_cfg(struct cxd2880_tnrdmd *tnr_dmd,
 			   enum cxd2880_tnrdmd_cfg_id id,
 			   int value)
 {
-	int ret;
+	int ret = 0;
 	u8 data[2] = { 0 };
 	u8 need_sub_setting = 0;
 
-- 
2.14.3
