Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:45514 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754936AbaCDUzZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 4 Mar 2014 15:55:25 -0500
Date: Wed, 05 Mar 2014 04:55:21 +0800
From: kbuild test robot <fengguang.wu@intel.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: linux-media@vger.kernel.org, kbuild-all@01.org
Subject: [linuxtv-media:master 428/499]
 drivers/media/dvb-frontends/drx39xyj/drxj.c:1039:16: sparse: symbol
 'drxj_default_aud_data_g' was not declared. Should it be static?
Message-ID: <53163db9.R+8n3ktQRv5O10lw%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed;
 boundary="=_53163db9.hhZx5fFgp4FUaQBlNYEEe4LNdAjoEkNjQJrT6XjJB5xxAk6X"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.

--=_53163db9.hhZx5fFgp4FUaQBlNYEEe4LNdAjoEkNjQJrT6XjJB5xxAk6X
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

tree:   git://linuxtv.org/media_tree.git master
head:   59432be1c7fbf2a4f608850855ff649bee0f7b3b
commit: 57afe2f0bb0cca758701679f141c9fa92a034415 [428/499] [media] drx-j: Don't use CamelCase
reproduce: make C=1 CF=-D__CHECK_ENDIAN__


sparse warnings: (new ones prefixed by >>)

   drivers/media/dvb-frontends/drx39xyj/drxj.c:651:6: sparse: symbol 'drx_dap_drxj_module_name' was not declared. Should it be static?
   drivers/media/dvb-frontends/drx39xyj/drxj.c:652:6: sparse: symbol 'drx_dap_drxj_version_text' was not declared. Should it be static?
   drivers/media/dvb-frontends/drx39xyj/drxj.c:654:15: sparse: symbol 'drx_dap_drxj_version' was not declared. Should it be static?
>> drivers/media/dvb-frontends/drx39xyj/drxj.c:1039:16: sparse: symbol 'drxj_default_aud_data_g' was not declared. Should it be static?
   drivers/media/dvb-frontends/drx39xyj/drxj.c:4208:1: sparse: symbol 'tuner_i2c_write_read' was not declared. Should it be static?
   drivers/media/dvb-frontends/drx39xyj/drxj.c:10234:27: sparse: cast truncates bits from constant value (ffff00ff becomes ff)
   drivers/media/dvb-frontends/drx39xyj/drxj.c:10251:24: sparse: cast truncates bits from constant value (ffff3fff becomes 3fff)
   drivers/media/dvb-frontends/drx39xyj/drxj.c:11125:31: sparse: cast truncates bits from constant value (ffff00ff becomes ff)
   drivers/media/dvb-frontends/drx39xyj/drxj.c:11167:26: sparse: cast truncates bits from constant value (ffff0000 becomes 0)
   drivers/media/dvb-frontends/drx39xyj/drxj.c:11233:33: sparse: cast truncates bits from constant value (ffff7fff becomes 7fff)
   drivers/media/dvb-frontends/drx39xyj/drxj.c:11777:26: sparse: cast truncates bits from constant value (ffff7fff becomes 7fff)

Please consider folding the attached diff :-)

---
0-DAY kernel build testing backend              Open Source Technology Center
http://lists.01.org/mailman/listinfo/kbuild                 Intel Corporation

--=_53163db9.hhZx5fFgp4FUaQBlNYEEe4LNdAjoEkNjQJrT6XjJB5xxAk6X
Content-Type: text/x-diff;
 charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="make-it-static-57afe2f0bb0cca758701679f141c9fa92a034415.diff"

From: Fengguang Wu <fengguang.wu@intel.com>
Subject: [PATCH linuxtv-media] drx-j: drxj_default_aud_data_g can be static
TO: Mauro Carvalho Chehab <m.chehab@samsung.com>
CC: linux-media@vger.kernel.org
CC: linux-media@vger.kernel.org 
CC: linux-kernel@vger.kernel.org 

CC: Mauro Carvalho Chehab <m.chehab@samsung.com>
CC: linux-media@vger.kernel.org
Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
---
 drxj.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/dvb-frontends/drx39xyj/drxj.c b/drivers/media/dvb-frontends/drx39xyj/drxj.c
index 3a63520..b7a2b84 100644
--- a/drivers/media/dvb-frontends/drx39xyj/drxj.c
+++ b/drivers/media/dvb-frontends/drx39xyj/drxj.c
@@ -1036,7 +1036,7 @@ drx_demod_instance_t drxj_default_demod_g = {
 * This structure is DRXK specific.
 *
 */
-drx_aud_data_t drxj_default_aud_data_g = {
+static drx_aud_data_t drxj_default_aud_data_g = {
 	false,			/* audio_is_active */
 	DRX_AUD_STANDARD_AUTO,	/* audio_standard  */
 

--=_53163db9.hhZx5fFgp4FUaQBlNYEEe4LNdAjoEkNjQJrT6XjJB5xxAk6X--
