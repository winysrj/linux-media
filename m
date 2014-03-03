Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:49465 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753873AbaCCKIH (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 Mar 2014 05:08:07 -0500
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 64/79] [media] drx-j: Fix qam/256 mode
Date: Mon,  3 Mar 2014 07:06:58 -0300
Message-Id: <1393841233-24840-65-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1393841233-24840-1-git-send-email-m.chehab@samsung.com>
References: <1393841233-24840-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

QAM/256 currently doesn't work, as the code is only called if
channel->mirror is DRX_MIRROR_AUTO, but a prevous if prevents
this condition to happen.

While here, returns -EINVAL to not supported QAM modes and
simplify the code, reducing the number of indents.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/dvb-frontends/drx39xyj/drxj.c | 205 +++++++++++++++-------------
 1 file changed, 113 insertions(+), 92 deletions(-)

diff --git a/drivers/media/dvb-frontends/drx39xyj/drxj.c b/drivers/media/dvb-frontends/drx39xyj/drxj.c
index 6fe65f4bd912..8f2f2653af2c 100644
--- a/drivers/media/dvb-frontends/drx39xyj/drxj.c
+++ b/drivers/media/dvb-frontends/drx39xyj/drxj.c
@@ -10415,107 +10415,122 @@ set_qam_channel(struct drx_demod_instance *demod,
 	switch (channel->constellation) {
 	case DRX_CONSTELLATION_QAM16:
 	case DRX_CONSTELLATION_QAM32:
-	case DRX_CONSTELLATION_QAM64:
 	case DRX_CONSTELLATION_QAM128:
+		return -EINVAL;
+	case DRX_CONSTELLATION_QAM64:
 	case DRX_CONSTELLATION_QAM256:
+		if (ext_attr->standard != DRX_STANDARD_ITU_B)
+			return -EINVAL;
+
 		ext_attr->constellation = channel->constellation;
 		if (channel->mirror == DRX_MIRROR_AUTO)
 			ext_attr->mirror = DRX_MIRROR_NO;
 		else
 			ext_attr->mirror = channel->mirror;
+
 		rc = set_qam(demod, channel, tuner_freq_offset, QAM_SET_OP_ALL);
 		if (rc != 0) {
 			pr_err("error %d\n", rc);
 			goto rw_error;
 		}
 
-		if ((ext_attr->standard == DRX_STANDARD_ITU_B) &&
-		    (channel->constellation == DRX_CONSTELLATION_QAM64)) {
-			rc = qam64auto(demod, channel, tuner_freq_offset, &lock_status);
+		if (channel->constellation == DRX_CONSTELLATION_QAM64)
+			rc = qam64auto(demod, channel, tuner_freq_offset,
+				       &lock_status);
+		else
+			rc = qam256auto(demod, channel, tuner_freq_offset,
+					&lock_status);
+		if (rc != 0) {
+			pr_err("error %d\n", rc);
+			goto rw_error;
+		}
+		break;
+	case DRX_CONSTELLATION_AUTO:	/* for channel scan */
+		if (ext_attr->standard == DRX_STANDARD_ITU_B) {
+			u16 qam_ctl_ena = 0;
+
+			auto_flag = true;
+
+			/* try to lock default QAM constellation: QAM256 */
+			channel->constellation = DRX_CONSTELLATION_QAM256;
+			ext_attr->constellation = DRX_CONSTELLATION_QAM256;
+			if (channel->mirror == DRX_MIRROR_AUTO)
+				ext_attr->mirror = DRX_MIRROR_NO;
+			else
+				ext_attr->mirror = channel->mirror;
+			rc = set_qam(demod, channel, tuner_freq_offset,
+				     QAM_SET_OP_ALL);
 			if (rc != 0) {
 				pr_err("error %d\n", rc);
 				goto rw_error;
 			}
-		}
-
-		if ((ext_attr->standard == DRX_STANDARD_ITU_B) &&
-		    (channel->mirror == DRX_MIRROR_AUTO) &&
-		    (channel->constellation == DRX_CONSTELLATION_QAM256)) {
-			rc = qam256auto(demod, channel, tuner_freq_offset, &lock_status);
+			rc = qam256auto(demod, channel, tuner_freq_offset,
+					&lock_status);
 			if (rc != 0) {
 				pr_err("error %d\n", rc);
 				goto rw_error;
 			}
-		}
-		break;
-	case DRX_CONSTELLATION_AUTO:	/* for channel scan */
-		if (ext_attr->standard == DRX_STANDARD_ITU_B) {
-			auto_flag = true;
-			/* try to lock default QAM constellation: QAM64 */
-			channel->constellation = DRX_CONSTELLATION_QAM256;
-			ext_attr->constellation = DRX_CONSTELLATION_QAM256;
+
+			if (lock_status >= DRX_LOCKED) {
+				channel->constellation = DRX_CONSTELLATION_AUTO;
+				break;
+			}
+
+			/* QAM254 not locked. Try QAM64 constellation */
+			channel->constellation = DRX_CONSTELLATION_QAM64;
+			ext_attr->constellation = DRX_CONSTELLATION_QAM64;
 			if (channel->mirror == DRX_MIRROR_AUTO)
 				ext_attr->mirror = DRX_MIRROR_NO;
 			else
 				ext_attr->mirror = channel->mirror;
-			rc = set_qam(demod, channel, tuner_freq_offset, QAM_SET_OP_ALL);
+
+			rc = DRXJ_DAP.read_reg16func(demod->my_i2c_dev_addr,
+						     SCU_RAM_QAM_CTL_ENA__A,
+						     &qam_ctl_ena, 0);
 			if (rc != 0) {
 				pr_err("error %d\n", rc);
 				goto rw_error;
 			}
-			rc = qam256auto(demod, channel, tuner_freq_offset, &lock_status);
+			rc = DRXJ_DAP.write_reg16func(demod->my_i2c_dev_addr,
+						      SCU_RAM_QAM_CTL_ENA__A,
+						      qam_ctl_ena & ~SCU_RAM_QAM_CTL_ENA_ACQ__M, 0);
 			if (rc != 0) {
 				pr_err("error %d\n", rc);
 				goto rw_error;
 			}
+			rc = DRXJ_DAP.write_reg16func(demod->my_i2c_dev_addr,
+						      SCU_RAM_QAM_FSM_STATE_TGT__A,
+						      0x2, 0);
+			if (rc != 0) {
+				pr_err("error %d\n", rc);
+				goto rw_error;
+			}	/* force to rate hunting */
 
-			if (lock_status < DRX_LOCKED) {
-				/* QAM254 not locked -> try to lock QAM64 constellation */
-				channel->constellation =
-				    DRX_CONSTELLATION_QAM64;
-				ext_attr->constellation =
-				    DRX_CONSTELLATION_QAM64;
-				if (channel->mirror == DRX_MIRROR_AUTO)
-					ext_attr->mirror = DRX_MIRROR_NO;
-				else
-					ext_attr->mirror = channel->mirror;
-				{
-					u16 qam_ctl_ena = 0;
-					rc = DRXJ_DAP.read_reg16func(demod->my_i2c_dev_addr, SCU_RAM_QAM_CTL_ENA__A, &qam_ctl_ena, 0);
-					if (rc != 0) {
-						pr_err("error %d\n", rc);
-						goto rw_error;
-					}
-					rc = DRXJ_DAP.write_reg16func(demod->my_i2c_dev_addr, SCU_RAM_QAM_CTL_ENA__A, qam_ctl_ena & ~SCU_RAM_QAM_CTL_ENA_ACQ__M, 0);
-					if (rc != 0) {
-						pr_err("error %d\n", rc);
-						goto rw_error;
-					}
-					rc = DRXJ_DAP.write_reg16func(demod->my_i2c_dev_addr, SCU_RAM_QAM_FSM_STATE_TGT__A, 0x2, 0);
-					if (rc != 0) {
-						pr_err("error %d\n", rc);
-						goto rw_error;
-					}	/* force to rate hunting */
+			rc = set_qam(demod, channel, tuner_freq_offset,
+				     QAM_SET_OP_CONSTELLATION);
+			if (rc != 0) {
+				pr_err("error %d\n", rc);
+				goto rw_error;
+			}
+			rc = DRXJ_DAP.write_reg16func(demod->my_i2c_dev_addr,
+						      SCU_RAM_QAM_CTL_ENA__A,
+						      qam_ctl_ena, 0);
+			if (rc != 0) {
+				pr_err("error %d\n", rc);
+				goto rw_error;
+			}
 
-					rc = set_qam(demod, channel, tuner_freq_offset, QAM_SET_OP_CONSTELLATION);
-					if (rc != 0) {
-						pr_err("error %d\n", rc);
-						goto rw_error;
-					}
-					rc = DRXJ_DAP.write_reg16func(demod->my_i2c_dev_addr, SCU_RAM_QAM_CTL_ENA__A, qam_ctl_ena, 0);
-					if (rc != 0) {
-						pr_err("error %d\n", rc);
-						goto rw_error;
-					}
-				}
-				rc = qam64auto(demod, channel, tuner_freq_offset, &lock_status);
-				if (rc != 0) {
-					pr_err("error %d\n", rc);
-					goto rw_error;
-				}
+			rc = qam64auto(demod, channel, tuner_freq_offset,
+				       &lock_status);
+			if (rc != 0) {
+				pr_err("error %d\n", rc);
+				goto rw_error;
 			}
+
 			channel->constellation = DRX_CONSTELLATION_AUTO;
 		} else if (ext_attr->standard == DRX_STANDARD_ITU_C) {
+			u16 qam_ctl_ena = 0;
+
 			channel->constellation = DRX_CONSTELLATION_QAM64;
 			ext_attr->constellation = DRX_CONSTELLATION_QAM64;
 			auto_flag = true;
@@ -10524,43 +10539,49 @@ set_qam_channel(struct drx_demod_instance *demod,
 				ext_attr->mirror = DRX_MIRROR_NO;
 			else
 				ext_attr->mirror = channel->mirror;
-			{
-				u16 qam_ctl_ena = 0;
-				rc = DRXJ_DAP.read_reg16func(demod->my_i2c_dev_addr, SCU_RAM_QAM_CTL_ENA__A, &qam_ctl_ena, 0);
-				if (rc != 0) {
-					pr_err("error %d\n", rc);
-					goto rw_error;
-				}
-				rc = DRXJ_DAP.write_reg16func(demod->my_i2c_dev_addr, SCU_RAM_QAM_CTL_ENA__A, qam_ctl_ena & ~SCU_RAM_QAM_CTL_ENA_ACQ__M, 0);
-				if (rc != 0) {
-					pr_err("error %d\n", rc);
-					goto rw_error;
-				}
-				rc = DRXJ_DAP.write_reg16func(demod->my_i2c_dev_addr, SCU_RAM_QAM_FSM_STATE_TGT__A, 0x2, 0);
-				if (rc != 0) {
-					pr_err("error %d\n", rc);
-					goto rw_error;
-				}	/* force to rate hunting */
+			rc = DRXJ_DAP.read_reg16func(demod->my_i2c_dev_addr,
+						     SCU_RAM_QAM_CTL_ENA__A,
+						     &qam_ctl_ena, 0);
+			if (rc != 0) {
+				pr_err("error %d\n", rc);
+				goto rw_error;
+			}
+			rc = DRXJ_DAP.write_reg16func(demod->my_i2c_dev_addr,
+						      SCU_RAM_QAM_CTL_ENA__A,
+						      qam_ctl_ena & ~SCU_RAM_QAM_CTL_ENA_ACQ__M, 0);
+			if (rc != 0) {
+				pr_err("error %d\n", rc);
+				goto rw_error;
+			}
+			rc = DRXJ_DAP.write_reg16func(demod->my_i2c_dev_addr,
+						      SCU_RAM_QAM_FSM_STATE_TGT__A,
+						      0x2, 0);
+			if (rc != 0) {
+				pr_err("error %d\n", rc);
+				goto rw_error;
+			}	/* force to rate hunting */
 
-				rc = set_qam(demod, channel, tuner_freq_offset, QAM_SET_OP_CONSTELLATION);
-				if (rc != 0) {
-					pr_err("error %d\n", rc);
-					goto rw_error;
-				}
-				rc = DRXJ_DAP.write_reg16func(demod->my_i2c_dev_addr, SCU_RAM_QAM_CTL_ENA__A, qam_ctl_ena, 0);
-				if (rc != 0) {
-					pr_err("error %d\n", rc);
-					goto rw_error;
-				}
+			rc = set_qam(demod, channel, tuner_freq_offset,
+				     QAM_SET_OP_CONSTELLATION);
+			if (rc != 0) {
+				pr_err("error %d\n", rc);
+				goto rw_error;
 			}
-			rc = qam64auto(demod, channel, tuner_freq_offset, &lock_status);
+			rc = DRXJ_DAP.write_reg16func(demod->my_i2c_dev_addr,
+						      SCU_RAM_QAM_CTL_ENA__A,
+						      qam_ctl_ena, 0);
+			if (rc != 0) {
+				pr_err("error %d\n", rc);
+				goto rw_error;
+			}
+			rc = qam64auto(demod, channel, tuner_freq_offset,
+				       &lock_status);
 			if (rc != 0) {
 				pr_err("error %d\n", rc);
 				goto rw_error;
 			}
 			channel->constellation = DRX_CONSTELLATION_AUTO;
 		} else {
-			channel->constellation = DRX_CONSTELLATION_AUTO;
 			return -EINVAL;
 		}
 		break;
-- 
1.8.5.3

