Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBN3lbvH021386
	for <video4linux-list@redhat.com>; Mon, 22 Dec 2008 22:47:37 -0500
Received: from mail-ew0-f21.google.com (mail-ew0-f21.google.com
	[209.85.219.21])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id mBN3lNlP026547
	for <video4linux-list@redhat.com>; Mon, 22 Dec 2008 22:47:23 -0500
Received: by ewy14 with SMTP id 14so2410223ewy.3
	for <video4linux-list@redhat.com>; Mon, 22 Dec 2008 19:47:23 -0800 (PST)
Date: Tue, 23 Dec 2008 12:50:09 +0900
From: Dmitri Belimov <d.belimov@gmail.com>
To: video4linux-list@redhat.com, linux-dvb@linuxtv.org
Message-ID: <20081223125009.3e04e7ba@glory.loctelecom.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: 
Subject: [PATCH 1/3] Add support DVB-T for the Beholder H6 card.
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Hi all

Fix I2C bridge error in zl10353. If no tunner attached to internal I2C bus of zl10353 chip. When
set enable bridge from internal I2C bus to the main I2C bus (saa7134) the main I2C bus stopped
very hardly. No any communication. In our next board we solder additional resistors to internal I2C bus.

diff -r 6032ecd6ad7e linux/drivers/media/dvb/frontends/zl10353.c
--- a/linux/drivers/media/dvb/frontends/zl10353.c	Sat Aug 30 11:07:04 2008 -0300
+++ b/linux/drivers/media/dvb/frontends/zl10353.c	Tue Oct 07 09:06:25 2008 +1000
@@ -595,7 +595,14 @@
 
 static int zl10353_i2c_gate_ctrl(struct dvb_frontend* fe, int enable)
 {
+	struct zl10353_state *state = fe->demodulator_priv;
 	u8 val = 0x0a;
+
+	if (state->config.no_tuner) {
+		/* No tuner attached to the internal I2C bus */
+		/* If set enable I2C bridge, the main I2C bus stopped hardly */
+		return 0;
+	}
 
 	if (enable)
 		val |= 0x10;

Signed-off-by: Beholder Intl. Ltd. Dmitry Belimov <d.belimov@gmail.com>


With my best regards, Dmitry.

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
