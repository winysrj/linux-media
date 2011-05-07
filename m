Return-path: <mchehab@gaivota>
Received: from blu0-omc2-s33.blu0.hotmail.com ([65.55.111.108]:59606 "EHLO
	blu0-omc2-s33.blu0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753499Ab1EGGzX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 7 May 2011 02:55:23 -0400
Message-ID: <BLU157-w490B704529846014C4C669D8820@phx.gbl>
From: Manoel PN <pinusdtv@hotmail.com>
To: <linux-media@vger.kernel.org>, Mauro Chehab <mchehab@redhat.com>,
	Mauro Chehab <mchehab@infradead.org>, <mpnbol@bol.com.br>
Subject: =?windows-1256?Q?[PATCH]_dv?= =?windows-1256?Q?b-usb.h_fu?=
 =?windows-1256?Q?nction_rc5?= =?windows-1256?Q?=5Fscan=FE?=
Date: Sat, 7 May 2011 09:49:13 +0300
Content-Type: text/plain; charset="windows-1256"
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>



Hi,

The function "rc5_scan" in "dvb_usb.h" is returning invalid value.
The value should be returned "u16" but is returning "u8".

See example below in "drivers/media/dvb/dvb-usb/opera1.c".


/*------------------------------------------------------*/

drivers/media/dvb/dvb-usb/opera1.c

static int opera1_rc_query(struct dvb_usb_device *dev, u32 * event, int *state)
{

.
.
.

        send_key = (send_key & 0xffff) | 0x0100;

        for (i = 0; i < ARRAY_SIZE(rc_map_opera1_table); i++) {
            if (rc5_scan(&rc_map_opera1_table[i]) == (send_key & 0xffff)) {
                *state = REMOTE_KEY_PRESSED;
                *event = rc_map_opera1_table[i].keycode;
                opst->last_key_pressed =
                    rc_map_opera1_table[i].keycode;
                break;
            }
            opst->last_key_pressed = 0;
        }

}

/*------------------------------------------------------*/


Signed-off-by: Manoel Pinheiro


diff --git a/drivers/media/dvb/dvb-usb/dvb-usb.h b/drivers/media/dvb/dvb-usb/dvb-usb.h
index 76a8096..7d35d07 100644
--- a/drivers/media/dvb/dvb-usb/dvb-usb.h
+++ b/drivers/media/dvb/dvb-usb/dvb-usb.h
@@ -85,7 +85,7 @@ static inline u8 rc5_data(struct rc_map_table *key)
     return key->scancode & 0xff;
 }

-static inline u8 rc5_scan(struct rc_map_table *key)
+static inline u16 rc5_scan(struct rc_map_table *key)
 {
     return key->scancode & 0xffff;
 }

 		 	   		  
