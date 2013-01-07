Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59393 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754961Ab3AGSot (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 7 Jan 2013 13:44:49 -0500
Received: from int-mx11.intmail.prod.int.phx2.redhat.com (int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r07IinSE011219
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Mon, 7 Jan 2013 13:44:49 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH RFCv8 2/2] dvb: the core logic to handle the DVBv5 QoS properties
Date: Mon,  7 Jan 2013 16:44:15 -0200
Message-Id: <1357584255-6500-2-git-send-email-mchehab@redhat.com>
In-Reply-To: <1357584255-6500-1-git-send-email-mchehab@redhat.com>
References: <1357584255-6500-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add the logic to poll, reset counters and report the QoS stats
to the end user.

The idea is that the core will periodically poll the frontend for
the stats. The frontend may return -EBUSY, if the previous collect
didn't finish, or it may fill the cached data.

The value returned to the end user is always the cached data.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/dvb-core/dvb_frontend.c | 36 +++++++++++++++++++++++++++++++++++
 drivers/media/dvb-core/dvb_frontend.h | 12 ++++++++++++
 2 files changed, 48 insertions(+)

diff --git a/drivers/media/dvb-core/dvb_frontend.c b/drivers/media/dvb-core/dvb_frontend.c
index dd35fa9..f8be7be 100644
--- a/drivers/media/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb-core/dvb_frontend.c
@@ -260,6 +260,9 @@ static int dvb_frontend_get_event(struct dvb_frontend *fe,
 			return ret;
 	}
 
+	if (fe->ops.get_qos_stats)
+		fe->ops.get_qos_stats(fe);
+
 	mutex_lock(&events->mtx);
 	*event = events->events[events->eventr];
 	events->eventr = (events->eventr + 1) % MAX_EVENT;
@@ -1053,6 +1056,15 @@ static struct dtv_cmds_h dtv_cmds[DTV_MAX_COMMAND + 1] = {
 	_DTV_CMD(DTV_ATSCMH_SCCC_CODE_MODE_B, 0, 0),
 	_DTV_CMD(DTV_ATSCMH_SCCC_CODE_MODE_C, 0, 0),
 	_DTV_CMD(DTV_ATSCMH_SCCC_CODE_MODE_D, 0, 0),
+
+	/* Statistics API */
+	_DTV_CMD(DTV_QOS_ENUM, 0, 0),
+	_DTV_CMD(DTV_QOS_SIGNAL_STRENGTH, 0, 0),
+	_DTV_CMD(DTV_QOS_CNR, 0, 0),
+	_DTV_CMD(DTV_QOS_BIT_ERROR_COUNT, 0, 0),
+	_DTV_CMD(DTV_QOS_TOTAL_BITS_COUNT, 0, 0),
+	_DTV_CMD(DTV_QOS_ERROR_BLOCK_COUNT, 0, 0),
+	_DTV_CMD(DTV_QOS_TOTAL_BLOCKS_COUNT, 0, 0),
 };
 
 static void dtv_property_dump(struct dvb_frontend *fe, struct dtv_property *tvp)
@@ -1443,6 +1455,25 @@ static int dtv_property_process_get(struct dvb_frontend *fe,
 		tvp->u.data = c->lna;
 		break;
 
+	/* Fill quality measures */
+	case DTV_QOS_SIGNAL_STRENGTH:
+		tvp->u.st = c->strength;
+		break;
+	case DTV_QOS_CNR:
+		tvp->u.st = c->cnr;
+		break;
+	case DTV_QOS_BIT_ERROR_COUNT:
+		tvp->u.st = c->bit_error;
+		break;
+	case DTV_QOS_TOTAL_BITS_COUNT:
+		tvp->u.st = c->bit_count;
+		break;
+	case DTV_QOS_ERROR_BLOCK_COUNT:
+		tvp->u.st = c->block_error;
+		break;
+	case DTV_QOS_TOTAL_BLOCKS_COUNT:
+		tvp->u.st = c->block_count;
+		break;
 	default:
 		return -EINVAL;
 	}
@@ -1705,6 +1736,8 @@ static int dtv_property_process_set(struct dvb_frontend *fe,
 		break;
 	case DTV_DELIVERY_SYSTEM:
 		r = set_delivery_system(fe, tvp->u.data);
+		if (r >= 0 && fe->ops.reset_qos_counters)
+			fe->ops.reset_qos_counters(fe);
 		break;
 	case DTV_VOLTAGE:
 		c->voltage = tvp->u.data;
@@ -2305,6 +2338,9 @@ static int dvb_frontend_ioctl_legacy(struct file *file,
 		if (err)
 			break;
 		err = dtv_set_frontend(fe);
+		if (err >= 0 && fe->ops.reset_qos_counters)
+			fe->ops.reset_qos_counters(fe);
+
 		break;
 	case FE_GET_EVENT:
 		err = dvb_frontend_get_event (fe, parg, file->f_flags);
diff --git a/drivers/media/dvb-core/dvb_frontend.h b/drivers/media/dvb-core/dvb_frontend.h
index 97112cd..7bb49f1 100644
--- a/drivers/media/dvb-core/dvb_frontend.h
+++ b/drivers/media/dvb-core/dvb_frontend.h
@@ -315,6 +315,10 @@ struct dvb_frontend_ops {
 
 	int (*set_property)(struct dvb_frontend* fe, struct dtv_property* tvp);
 	int (*get_property)(struct dvb_frontend* fe, struct dtv_property* tvp);
+
+	/* QoS statistics callbacks */
+	int (*get_qos_stats)(struct dvb_frontend *fe);
+	int (*reset_qos_counters)(struct dvb_frontend *fe);
 };
 
 #ifdef __DVB_CORE__
@@ -393,6 +397,14 @@ struct dtv_frontend_properties {
 	u8			atscmh_sccc_code_mode_d;
 
 	u32			lna;
+
+	/* QoS statistics data */
+	struct dtv_fe_stats 	strength;
+	struct dtv_fe_stats	cnr;
+	struct dtv_fe_stats	bit_error;
+	struct dtv_fe_stats	bit_count;
+	struct dtv_fe_stats	block_error;
+	struct dtv_fe_stats	block_count;
 };
 
 struct dvb_frontend {
-- 
1.7.11.7

