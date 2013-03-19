Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50103 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932942Ab3CSQt7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Mar 2013 12:49:59 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Doron Cohen <doronc@siano-ms.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 44/46] [media] siano: remove a bogus printk line
Date: Tue, 19 Mar 2013 13:49:33 -0300
Message-Id: <1363711775-2120-45-git-send-email-mchehab@redhat.com>
In-Reply-To: <1363711775-2120-1-git-send-email-mchehab@redhat.com>
References: <1363711775-2120-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The logic that detects the types of sms devices is bogus. It returns
	[ 4645.187790] smsusb_init_device: line: 372: Unspecified sms device type!

For several devices, including the one I have (SMS_RIO). In a matter
of fact, the right thing to do there is to print an error only if
the device is really unknown (SMS_UNKNOWN_TYPE).

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/usb/siano/smsusb.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/media/usb/siano/smsusb.c b/drivers/media/usb/siano/smsusb.c
index def5e41..01a0f39 100644
--- a/drivers/media/usb/siano/smsusb.c
+++ b/drivers/media/usb/siano/smsusb.c
@@ -368,14 +368,10 @@ static int smsusb_init_device(struct usb_interface *intf, int board_id)
 		params.setmode_handler = smsusb1_setmode;
 		params.detectmode_handler = smsusb1_detectmode;
 		break;
-	default:
+	case SMS_UNKNOWN_TYPE:
 		sms_err("Unspecified sms device type!");
 		/* fall-thru */
-	case SMS_NOVA_A0:
-	case SMS_NOVA_B0:
-	case SMS_VEGA:
-	case SMS_VENICE:
-	case SMS_DENVER_1530:
+	default:
 		dev->buffer_size = USB2_BUFFER_SIZE;
 		dev->response_alignment =
 		    le16_to_cpu(dev->udev->ep_in[1]->desc.wMaxPacketSize) -
-- 
1.8.1.4

