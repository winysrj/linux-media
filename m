Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp208.alice.it ([82.57.200.104]:57315 "EHLO smtp208.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752137Ab2LJVho (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Dec 2012 16:37:44 -0500
From: Antonio Ospite <ospite@studenti.unina.it>
To: linux-media@vger.kernel.org
Cc: Antonio Ospite <ospite@studenti.unina.it>,
	Antti Palosaari <crope@iki.fi>
Subject: [PATCHv2 5/9] [media] m920x: avoid repeating RC state parsing at each keycode
Date: Mon, 10 Dec 2012 22:37:13 +0100
Message-Id: <1355175437-21623-6-git-send-email-ospite@studenti.unina.it>
In-Reply-To: <1355175437-21623-1-git-send-email-ospite@studenti.unina.it>
References: <1352158096-17737-1-git-send-email-ospite@studenti.unina.it>
 <1355175437-21623-1-git-send-email-ospite@studenti.unina.it>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Parsing the RC press state is invariant wrt. the keycode, take it out of
the keycode scanning loop.

Signed-off-by: Antonio Ospite <ospite@studenti.unina.it>
---
 drivers/media/usb/dvb-usb/m920x.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/usb/dvb-usb/m920x.c b/drivers/media/usb/dvb-usb/m920x.c
index 581c5de..5f6ca75 100644
--- a/drivers/media/usb/dvb-usb/m920x.c
+++ b/drivers/media/usb/dvb-usb/m920x.c
@@ -197,10 +197,11 @@ static int m920x_rc_query(struct dvb_usb_device *d, u32 *event, int *state)
 	if ((ret = m920x_read(d->udev, M9206_CORE, 0x0, M9206_RC_KEY, rc_state + 1, 1)) != 0)
 		goto out;
 
+	m920x_parse_rc_state(d, rc_state[0], state);
+
 	for (i = 0; i < d->props.rc.legacy.rc_map_size; i++)
 		if (rc5_data(&d->props.rc.legacy.rc_map_table[i]) == rc_state[1]) {
 			*event = d->props.rc.legacy.rc_map_table[i].keycode;
-			m920x_parse_rc_state(d, rc_state[0], state);
 			goto out;
 		}
 
-- 
1.7.10.4

