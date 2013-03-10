Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:35570 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751713Ab3CJBnq (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 9 Mar 2013 20:43:46 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [REVIEW PATCH 5/5] it913x: fix pid filter
Date: Sun, 10 Mar 2013 03:42:35 +0200
Message-Id: <1362879755-4839-5-git-send-email-crope@iki.fi>
In-Reply-To: <1362879755-4839-1-git-send-email-crope@iki.fi>
References: <1362879755-4839-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I just made commit: "dvb_usb_v2: rework USB streaming logic" that
breaks that driver PID filter.
it913x driver checks use of PID filter directly from DVB USB v2 core
internal variable "adap->pid_filtering" and stores it to own state.
Calling order of .pid_filter_ctrl() and .pid_filter() was changed
and due to that state was updated too late. Update state earlier.

TODO: checking PID filter usage from DVB USB v2 is not very good idea
as PID filter callbacks are called only when PID filter is enabled.

Cc: Malcolm Priestley <tvboxspy@gmail.com>
Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/dvb-usb-v2/it913x.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/usb/dvb-usb-v2/it913x.c b/drivers/media/usb/dvb-usb-v2/it913x.c
index 8338479..e48cdeb 100644
--- a/drivers/media/usb/dvb-usb-v2/it913x.c
+++ b/drivers/media/usb/dvb-usb-v2/it913x.c
@@ -218,6 +218,7 @@ static int it913x_pid_filter_ctrl(struct dvb_usb_adapter *adap, int onoff)
 
 	deb_info(1, "PID_C  (%02x)", onoff);
 
+	st->pid_filter_onoff = adap->pid_filtering;
 	ret = it913x_wr_reg(d, pro, PID_EN, st->pid_filter_onoff);
 
 	mutex_unlock(&d->i2c_mutex);
-- 
1.7.11.7

