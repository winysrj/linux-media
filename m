Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:35943 "EHLO
        lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753014AbcKBMqi (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 2 Nov 2016 08:46:38 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 01/11] pulse8-cec: set all_device_types when restoring config
Date: Wed,  2 Nov 2016 13:46:25 +0100
Message-Id: <20161102124635.11989-2-hverkuil@xs4all.nl>
In-Reply-To: <20161102124635.11989-1-hverkuil@xs4all.nl>
References: <20161102124635.11989-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

When the persistent state is restored, the all_device_types field
was never filled in. Fix this.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/staging/media/pulse8-cec/pulse8-cec.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/staging/media/pulse8-cec/pulse8-cec.c b/drivers/staging/media/pulse8-cec/pulse8-cec.c
index 1732c38..9092494 100644
--- a/drivers/staging/media/pulse8-cec/pulse8-cec.c
+++ b/drivers/staging/media/pulse8-cec/pulse8-cec.c
@@ -375,27 +375,35 @@ static int pulse8_setup(struct pulse8 *pulse8, struct serio *serio,
 	switch (log_addrs->primary_device_type[0]) {
 	case CEC_OP_PRIM_DEVTYPE_TV:
 		log_addrs->log_addr_type[0] = CEC_LOG_ADDR_TYPE_TV;
+		log_addrs->all_device_types[0] = CEC_OP_ALL_DEVTYPE_TV;
 		break;
 	case CEC_OP_PRIM_DEVTYPE_RECORD:
 		log_addrs->log_addr_type[0] = CEC_LOG_ADDR_TYPE_RECORD;
+		log_addrs->all_device_types[0] = CEC_OP_ALL_DEVTYPE_RECORD;
 		break;
 	case CEC_OP_PRIM_DEVTYPE_TUNER:
 		log_addrs->log_addr_type[0] = CEC_LOG_ADDR_TYPE_TUNER;
+		log_addrs->all_device_types[0] = CEC_OP_ALL_DEVTYPE_TUNER;
 		break;
 	case CEC_OP_PRIM_DEVTYPE_PLAYBACK:
 		log_addrs->log_addr_type[0] = CEC_LOG_ADDR_TYPE_PLAYBACK;
+		log_addrs->all_device_types[0] = CEC_OP_ALL_DEVTYPE_PLAYBACK;
 		break;
 	case CEC_OP_PRIM_DEVTYPE_AUDIOSYSTEM:
 		log_addrs->log_addr_type[0] = CEC_LOG_ADDR_TYPE_PLAYBACK;
+		log_addrs->all_device_types[0] = CEC_OP_ALL_DEVTYPE_AUDIOSYSTEM;
 		break;
 	case CEC_OP_PRIM_DEVTYPE_SWITCH:
 		log_addrs->log_addr_type[0] = CEC_LOG_ADDR_TYPE_UNREGISTERED;
+		log_addrs->all_device_types[0] = CEC_OP_ALL_DEVTYPE_SWITCH;
 		break;
 	case CEC_OP_PRIM_DEVTYPE_PROCESSOR:
 		log_addrs->log_addr_type[0] = CEC_LOG_ADDR_TYPE_SPECIFIC;
+		log_addrs->all_device_types[0] = CEC_OP_ALL_DEVTYPE_SWITCH;
 		break;
 	default:
 		log_addrs->log_addr_type[0] = CEC_LOG_ADDR_TYPE_UNREGISTERED;
+		log_addrs->all_device_types[0] = CEC_OP_ALL_DEVTYPE_SWITCH;
 		dev_info(pulse8->dev, "Unknown Primary Device Type: %d\n",
 			 log_addrs->primary_device_type[0]);
 		break;
-- 
2.10.1

