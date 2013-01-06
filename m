Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58609 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753067Ab3AFR1Z (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 6 Jan 2013 12:27:25 -0500
Date: Sun, 6 Jan 2013 15:26:50 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: LMML <linux-media@vger.kernel.org>,
	Nickolai Zeldovich <nickolai@csail.mit.edu>
Subject: Fw: [PATCH] drivers/media/usb/dvb-usb/dib0700_core.c: fix left
 shift
Message-ID: <20130106152650.2a89b31d@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Not sure what happened, but this patch didn't arrive linux-media.

Let me forward.

Regards,
Mauro

Forwarded message:

Date: Sat,  5 Jan 2013 14:13:05 -0500
From: Nickolai Zeldovich <nickolai@csail.mit.edu>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Nickolai Zeldovich <nickolai@csail.mit.edu>, linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
Subject: [PATCH] drivers/media/usb/dvb-usb/dib0700_core.c: fix left shift


Fix bug introduced in 7757ddda6f4febbc52342d82440dd4f7a7d4f14f, where
instead of bit-negating the bitmask, the bit position was bit-negated
instead.

Signed-off-by: Nickolai Zeldovich <nickolai@csail.mit.edu>
---
 drivers/media/usb/dvb-usb/dib0700_core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/usb/dvb-usb/dib0700_core.c b/drivers/media/usb/dvb-usb/dib0700_core.c
index 19b5ed2..92e195a 100644
--- a/drivers/media/usb/dvb-usb/dib0700_core.c
+++ b/drivers/media/usb/dvb-usb/dib0700_core.c
@@ -587,7 +587,7 @@ int dib0700_streaming_ctrl(struct dvb_usb_adapter *adap, int onoff)
 		if (onoff)
 			st->channel_state |=	1 << (adap->id);
 		else
-			st->channel_state |=	1 << ~(adap->id);
+			st->channel_state &=  ~(1 << (adap->id));
 	} else {
 		if (onoff)
 			st->channel_state |=	1 << (adap->fe_adap[0].stream.props.endpoint-2);
-- 
1.7.10.4



-- 

Cheers,
Mauro
