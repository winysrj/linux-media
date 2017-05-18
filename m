Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:40360
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1754612AbdERMiu (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 18 May 2017 08:38:50 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Sean Young <sean@mess.org>, Andi Shyti <andi.shyti@samsung.com>
Subject: [PATCH 4/5] [media] dvb-usb-remote: don't write bogus debug messages
Date: Thu, 18 May 2017 09:38:38 -0300
Message-Id: <5c77b18687e5676dd05e5f83f0f54f8260992f1b.1495110899.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1495110899.git.mchehab@s-opensource.com>
References: <cover.1495110899.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1495110899.git.mchehab@s-opensource.com>
References: <cover.1495110899.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When a REMOTE_KEY_PRESSED event happens, it does the right
thing. However, if debug is enabled, it will print a bogus
message warning that "key repeated".

Fix it.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/usb/dvb-usb/dvb-usb-remote.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/media/usb/dvb-usb/dvb-usb-remote.c b/drivers/media/usb/dvb-usb/dvb-usb-remote.c
index 059ded59208e..f05f1fc80729 100644
--- a/drivers/media/usb/dvb-usb/dvb-usb-remote.c
+++ b/drivers/media/usb/dvb-usb/dvb-usb-remote.c
@@ -131,6 +131,11 @@ static void legacy_dvb_usb_read_remote_control(struct work_struct *work)
 		case REMOTE_KEY_PRESSED:
 			deb_rc("key pressed\n");
 			d->last_event = event;
+			input_event(d->input_dev, EV_KEY, event, 1);
+			input_sync(d->input_dev);
+			input_event(d->input_dev, EV_KEY, d->last_event, 0);
+			input_sync(d->input_dev);
+			break;
 		case REMOTE_KEY_REPEAT:
 			deb_rc("key repeated\n");
 			input_event(d->input_dev, EV_KEY, event, 1);
-- 
2.9.3
