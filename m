Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:49334 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753873AbaCCKHx (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 Mar 2014 05:07:53 -0500
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 19/79] [media] drx-j: make a few functions static
Date: Mon,  3 Mar 2014 07:06:13 -0300
Message-Id: <1393841233-24840-20-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1393841233-24840-1-git-send-email-m.chehab@samsung.com>
References: <1393841233-24840-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

drivers/media/dvb-frontends/drx39xyj/drx_driver.c:181:7: warning: no previous prototype for 'get_scan_context' [-Wmissing-prototypes]
 void *get_scan_context(pdrx_demod_instance_t demod, void *scan_context)

drivers/media/dvb-frontends/drx39xyj/drx_driver.c: At top level:
drivers/media/dvb-frontends/drx39xyj/drx_driver.c:842:5: warning: no previous prototype for 'ctrl_dump_registers' [-Wmissing-prototypes]
 int ctrl_dump_registers(pdrx_demod_instance_t demod,

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/dvb-frontends/drx39xyj/drx_driver.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/dvb-frontends/drx39xyj/drx_driver.c b/drivers/media/dvb-frontends/drx39xyj/drx_driver.c
index e8d1a26bf581..db92b4f9b650 100644
--- a/drivers/media/dvb-frontends/drx39xyj/drx_driver.c
+++ b/drivers/media/dvb-frontends/drx39xyj/drx_driver.c
@@ -178,7 +178,7 @@ static drx_scan_func_t get_scan_function(pdrx_demod_instance_t demod)
 * \param scan_context: Context Pointer.
 * \return drx_scan_func_t.
 */
-void *get_scan_context(pdrx_demod_instance_t demod, void *scan_context)
+static void *get_scan_context(pdrx_demod_instance_t demod, void *scan_context)
 {
 	pdrx_common_attr_t common_attr = (pdrx_common_attr_t) (NULL);
 
@@ -839,7 +839,7 @@ ctrl_program_tuner(pdrx_demod_instance_t demod, pdrx_channel_t channel)
 * \retval DRX_STS_INVALID_ARG: Wrong parameters.
 *
 */
-int ctrl_dump_registers(pdrx_demod_instance_t demod,
+static int ctrl_dump_registers(pdrx_demod_instance_t demod,
 			      p_drx_reg_dump_t registers)
 {
 	u16 i = 0;
-- 
1.8.5.3

