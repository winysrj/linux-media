Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55955 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933145Ab3CSQuZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Mar 2013 12:50:25 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Doron Cohen <doronc@siano-ms.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 46/46] [media] siano: Remove bogus complain about MSG_SMS_DVBT_BDA_DATA
Date: Tue, 19 Mar 2013 13:49:35 -0300
Message-Id: <1363711775-2120-47-git-send-email-mchehab@redhat.com>
In-Reply-To: <1363711775-2120-1-git-send-email-mchehab@redhat.com>
References: <1363711775-2120-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When the driver is tuned into chanel, and it is removed/reinserted,
the message stream data may be arriving during device probe:

	[ 5680.162004] smscore_set_device_mode: set device mode to 6
	[ 5680.162267] smscore_onresponse: message MSG_SMS_DVBT_BDA_DATA(693) not handled.
	[ 5680.162391] smscore_onresponse: message MSG_SMS_DVBT_BDA_DATA(693) not handled.
	[ 5680.162641] smscore_onresponse: message MSG_SMS_DVBT_BDA_DATA(693) not handled.
	[ 5680.162891] smscore_onresponse: message MSG_SMS_DVBT_BDA_DATA(693) not handled.
	[ 5680.163016] smscore_onresponse: message MSG_SMS_DVBT_BDA_DATA(693) not handled.
	[ 5680.163266] smscore_onresponse: message MSG_SMS_DVBT_BDA_DATA(693) not handled.
	[ 5680.163516] smscore_onresponse: message MSG_SMS_DVBT_BDA_DATA(693) not handled.
	[ 5680.163640] smscore_onresponse: message MSG_SMS_DVBT_BDA_DATA(693) not handled.
	[ 5680.163891] smscore_onresponse: message MSG_SMS_DVBT_BDA_DATA(693) not handled.
	[ 5680.164016] smscore_onresponse: message MSG_SMS_DVBT_BDA_DATA(693) not handled.
	[ 5680.164265] smscore_onresponse: message MSG_SMS_DVBT_BDA_DATA(693) not handled.
	[ 5680.164515] smscore_onresponse: message MSG_SMS_DVBT_BDA_DATA(693) not handled.
	[ 5680.164519] smscore_onresponse: Firmware id 6 prots 0x40 ver 8.1
	[ 5680.164766] smscore_onresponse: message MSG_SMS_DVBT_BDA_DATA(693) not handled.
	[ 5680.166018] smscore_onresponse: message MSG_SMS_DVBT_BDA_DATA(693) not handled.
	[ 5680.166438] DVB: registering new adapter (Siano Rio Digital Receiver)

Instead of complaining, just silently discard those messages, instead of
complaining.

A proper fix is to put the device on suspend/power down mode when the module
is removed.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/common/siano/smscoreapi.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/media/common/siano/smscoreapi.c b/drivers/media/common/siano/smscoreapi.c
index 244928b..c260974 100644
--- a/drivers/media/common/siano/smscoreapi.c
+++ b/drivers/media/common/siano/smscoreapi.c
@@ -1606,6 +1606,15 @@ void smscore_onresponse(struct smscore_device_t *coredev,
 				- sizeof(struct SmsMsgHdr_ST));
 			break;
 
+		case MSG_SMS_DVBT_BDA_DATA:
+			/*
+			 * It can be received here, if the frontend is
+			 * tuned into a valid channel and the proper firmware
+			 * is loaded. That happens when the module got removed
+			 * and re-inserted, without powering the device off
+			 */
+			break;
+
 		default:
 			sms_debug("message %s(%d) not handled.",
 				  smscore_translate_msg(phdr->msgType),
-- 
1.8.1.4

