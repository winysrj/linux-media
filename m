Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp205.alice.it ([82.57.200.101]:59983 "EHLO smtp205.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752024Ab2LJVho (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Dec 2012 16:37:44 -0500
From: Antonio Ospite <ospite@studenti.unina.it>
To: linux-media@vger.kernel.org
Cc: Antonio Ospite <ospite@studenti.unina.it>,
	Antti Palosaari <crope@iki.fi>
Subject: [PATCHv2 4/9] [media] m920x: factor out a m920x_parse_rc_state() function
Date: Mon, 10 Dec 2012 22:37:12 +0100
Message-Id: <1355175437-21623-5-git-send-email-ospite@studenti.unina.it>
In-Reply-To: <1355175437-21623-1-git-send-email-ospite@studenti.unina.it>
References: <1352158096-17737-1-git-send-email-ospite@studenti.unina.it>
 <1355175437-21623-1-git-send-email-ospite@studenti.unina.it>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is in preparation to using RC core infrastructure for some devices,
the RC button state parsing logic can be shared berween rc.legacy and
rc.core callbacks as it is independent from the mechanism used for RC
handling.

Signed-off-by: Antonio Ospite <ospite@studenti.unina.it>
---
 drivers/media/usb/dvb-usb/m920x.c |   81 ++++++++++++++++++++-----------------
 1 file changed, 44 insertions(+), 37 deletions(-)

diff --git a/drivers/media/usb/dvb-usb/m920x.c b/drivers/media/usb/dvb-usb/m920x.c
index 23416fb..581c5de 100644
--- a/drivers/media/usb/dvb-usb/m920x.c
+++ b/drivers/media/usb/dvb-usb/m920x.c
@@ -140,9 +140,50 @@ static int m920x_init_ep(struct usb_interface *intf)
 				 alt->desc.bAlternateSetting);
 }
 
-static int m920x_rc_query(struct dvb_usb_device *d, u32 *event, int *state)
+static inline void m920x_parse_rc_state(struct dvb_usb_device *d, u8 rc_state,
+					int *state)
 {
 	struct m920x_state *m = d->priv;
+
+	switch (rc_state) {
+	case 0x80:
+		*state = REMOTE_NO_KEY_PRESSED;
+		break;
+
+	case 0x88: /* framing error or "invalid code" */
+	case 0x99:
+	case 0xc0:
+	case 0xd8:
+		*state = REMOTE_NO_KEY_PRESSED;
+		m->rep_count = 0;
+		break;
+
+	case 0x93:
+	case 0x92:
+	case 0x83: /* pinnacle PCTV310e */
+	case 0x82:
+		m->rep_count = 0;
+		*state = REMOTE_KEY_PRESSED;
+		break;
+
+	case 0x91:
+	case 0x81: /* pinnacle PCTV310e */
+		/* prevent immediate auto-repeat */
+		if (++m->rep_count > 2)
+			*state = REMOTE_KEY_REPEAT;
+		else
+			*state = REMOTE_NO_KEY_PRESSED;
+		break;
+
+	default:
+		deb("Unexpected rc state %02x\n", rc_state);
+		*state = REMOTE_NO_KEY_PRESSED;
+		break;
+	}
+}
+
+static int m920x_rc_query(struct dvb_usb_device *d, u32 *event, int *state)
+{
 	int i, ret = 0;
 	u8 *rc_state;
 
@@ -159,42 +200,8 @@ static int m920x_rc_query(struct dvb_usb_device *d, u32 *event, int *state)
 	for (i = 0; i < d->props.rc.legacy.rc_map_size; i++)
 		if (rc5_data(&d->props.rc.legacy.rc_map_table[i]) == rc_state[1]) {
 			*event = d->props.rc.legacy.rc_map_table[i].keycode;
-
-			switch(rc_state[0]) {
-			case 0x80:
-				*state = REMOTE_NO_KEY_PRESSED;
-				goto out;
-
-			case 0x88: /* framing error or "invalid code" */
-			case 0x99:
-			case 0xc0:
-			case 0xd8:
-				*state = REMOTE_NO_KEY_PRESSED;
-				m->rep_count = 0;
-				goto out;
-
-			case 0x93:
-			case 0x92:
-			case 0x83: /* pinnacle PCTV310e */
-			case 0x82:
-				m->rep_count = 0;
-				*state = REMOTE_KEY_PRESSED;
-				goto out;
-
-			case 0x91:
-			case 0x81: /* pinnacle PCTV310e */
-				/* prevent immediate auto-repeat */
-				if (++m->rep_count > 2)
-					*state = REMOTE_KEY_REPEAT;
-				else
-					*state = REMOTE_NO_KEY_PRESSED;
-				goto out;
-
-			default:
-				deb("Unexpected rc state %02x\n", rc_state[0]);
-				*state = REMOTE_NO_KEY_PRESSED;
-				goto out;
-			}
+			m920x_parse_rc_state(d, rc_state[0], state);
+			goto out;
 		}
 
 	if (rc_state[1] != 0)
-- 
1.7.10.4

