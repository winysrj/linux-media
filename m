Return-path: <mchehab@gaivota>
Received: from mx1.redhat.com ([209.132.183.28]:3565 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753599Ab0L0Q1h convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 27 Dec 2010 11:27:37 -0500
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id oBRGRaF3006598
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Mon, 27 Dec 2010 11:27:36 -0500
Received: from gaivota (vpn-11-243.rdu.redhat.com [10.11.11.243])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id oBRGNDpG028091
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <linux-media@vger.kernel.org>; Mon, 27 Dec 2010 11:27:34 -0500
Date: Mon, 27 Dec 2010 14:22:46 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 4/8] [media] dib7000m/dib7000p: Add support for
 TRANSMISSION_MODE_4K
Message-ID: <20101227142246.543c10d2@gaivota>
In-Reply-To: <cover.1293466891.git.mchehab@redhat.com>
References: <cover.1293466891.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Fixes several warnings:

drivers/media/dvb/frontends/dib7000m.c: In function ‘dib7000m_set_channel’:
drivers/media/dvb/frontends/dib7000m.c:808:3: warning: case value ‘255’ not in enumerated type ‘fe_transmit_mode_t’
drivers/media/dvb/frontends/dib7000m.c:869:3: warning: case value ‘255’ not in enumerated type ‘fe_transmit_mode_t’
drivers/media/dvb/frontends/dib7000m.c: In function ‘dib7000m_tune’:
drivers/media/dvb/frontends/dib7000m.c:1023:3: warning: case value ‘255’ not in enumerated type ‘fe_transmit_mode_t’
drivers/media/dvb/frontends/dib7000m.c:1033:3: warning: case value ‘255’ not in enumerated type ‘fe_transmit_mode_t’
drivers/media/dvb/frontends/dib7000m.c:1043:3: warning: case value ‘255’ not in enumerated type ‘fe_transmit_mode_t’
drivers/media/dvb/frontends/dib7000p.c: In function ‘dib7000p_set_channel’:
drivers/media/dvb/frontends/dib7000p.c:720:3: warning: case value ‘255’ not in enumerated type ‘fe_transmit_mode_t’
drivers/media/dvb/frontends/dib7000p.c:773:3: warning: case value ‘255’ not in enumerated type ‘fe_transmit_mode_t’
drivers/media/dvb/frontends/dib7000p.c: In function ‘dib7000p_tune’:
drivers/media/dvb/frontends/dib7000p.c:997:3: warning: case value ‘255’ not in enumerated type ‘fe_transmit_mode_t’
drivers/media/dvb/frontends/dib7000p.c:1007:3: warning: case value ‘255’ not in enumerated type ‘fe_transmit_mode_t’
drivers/media/dvb/frontends/dib7000p.c:1017:3: warning: case value ‘255’ not in enumerated type ‘fe_transmit_mode_t’

The drivers were prepared to support 4K carriers, but as the define were added
later, they were using a "magic" value of 255.

Cc: Patrick Boettcher <pb@linuxtv.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/dvb/frontends/dib7000m.c b/drivers/media/dvb/frontends/dib7000m.c
index 0f09fd3..c7f5ccf 100644
--- a/drivers/media/dvb/frontends/dib7000m.c
+++ b/drivers/media/dvb/frontends/dib7000m.c
@@ -805,7 +805,7 @@ static void dib7000m_set_channel(struct dib7000m_state *state, struct dvb_fronte
 	value = 0;
 	switch (ch->u.ofdm.transmission_mode) {
 		case TRANSMISSION_MODE_2K: value |= (0 << 7); break;
-		case /* 4K MODE */ 255: value |= (2 << 7); break;
+		case TRANSMISSION_MODE_4K: value |= (2 << 7); break;
 		default:
 		case TRANSMISSION_MODE_8K: value |= (1 << 7); break;
 	}
@@ -866,7 +866,7 @@ static void dib7000m_set_channel(struct dib7000m_state *state, struct dvb_fronte
 	/* P_dvsy_sync_wait */
 	switch (ch->u.ofdm.transmission_mode) {
 		case TRANSMISSION_MODE_8K: value = 256; break;
-		case /* 4K MODE */ 255: value = 128; break;
+		case TRANSMISSION_MODE_4K: value = 128; break;
 		case TRANSMISSION_MODE_2K:
 		default: value = 64; break;
 	}
@@ -1020,7 +1020,7 @@ static int dib7000m_tune(struct dvb_frontend *demod, struct dvb_frontend_paramet
 	value = (6 << 8) | 0x80;
 	switch (ch->u.ofdm.transmission_mode) {
 		case TRANSMISSION_MODE_2K: value |= (7 << 12); break;
-		case /* 4K MODE */ 255: value |= (8 << 12); break;
+		case TRANSMISSION_MODE_4K: value |= (8 << 12); break;
 		default:
 		case TRANSMISSION_MODE_8K: value |= (9 << 12); break;
 	}
@@ -1030,7 +1030,7 @@ static int dib7000m_tune(struct dvb_frontend *demod, struct dvb_frontend_paramet
 	value = (0 << 4);
 	switch (ch->u.ofdm.transmission_mode) {
 		case TRANSMISSION_MODE_2K: value |= 0x6; break;
-		case /* 4K MODE */ 255: value |= 0x7; break;
+		case TRANSMISSION_MODE_4K: value |= 0x7; break;
 		default:
 		case TRANSMISSION_MODE_8K: value |= 0x8; break;
 	}
@@ -1040,7 +1040,7 @@ static int dib7000m_tune(struct dvb_frontend *demod, struct dvb_frontend_paramet
 	value = (0 << 4);
 	switch (ch->u.ofdm.transmission_mode) {
 		case TRANSMISSION_MODE_2K: value |= 0x6; break;
-		case /* 4K MODE */ 255: value |= 0x7; break;
+		case TRANSMISSION_MODE_4K: value |= 0x7; break;
 		default:
 		case TRANSMISSION_MODE_8K: value |= 0x8; break;
 	}
diff --git a/drivers/media/dvb/frontends/dib7000p.c b/drivers/media/dvb/frontends/dib7000p.c
index 3aed0d4..6aa02cb 100644
--- a/drivers/media/dvb/frontends/dib7000p.c
+++ b/drivers/media/dvb/frontends/dib7000p.c
@@ -717,7 +717,7 @@ static void dib7000p_set_channel(struct dib7000p_state *state, struct dvb_fronte
 	value = 0;
 	switch (ch->u.ofdm.transmission_mode) {
 		case TRANSMISSION_MODE_2K: value |= (0 << 7); break;
-		case /* 4K MODE */ 255: value |= (2 << 7); break;
+		case TRANSMISSION_MODE_4K: value |= (2 << 7); break;
 		default:
 		case TRANSMISSION_MODE_8K: value |= (1 << 7); break;
 	}
@@ -770,7 +770,7 @@ static void dib7000p_set_channel(struct dib7000p_state *state, struct dvb_fronte
 	/* P_dvsy_sync_wait */
 	switch (ch->u.ofdm.transmission_mode) {
 		case TRANSMISSION_MODE_8K: value = 256; break;
-		case /* 4K MODE */ 255: value = 128; break;
+		case TRANSMISSION_MODE_4K: value = 128; break;
 		case TRANSMISSION_MODE_2K:
 		default: value = 64; break;
 	}
@@ -994,7 +994,7 @@ static int dib7000p_tune(struct dvb_frontend *demod, struct dvb_frontend_paramet
 	tmp = (6 << 8) | 0x80;
 	switch (ch->u.ofdm.transmission_mode) {
 		case TRANSMISSION_MODE_2K: tmp |= (7 << 12); break;
-		case /* 4K MODE */ 255: tmp |= (8 << 12); break;
+		case TRANSMISSION_MODE_4K: tmp |= (8 << 12); break;
 		default:
 		case TRANSMISSION_MODE_8K: tmp |= (9 << 12); break;
 	}
@@ -1004,7 +1004,7 @@ static int dib7000p_tune(struct dvb_frontend *demod, struct dvb_frontend_paramet
 	tmp = (0 << 4);
 	switch (ch->u.ofdm.transmission_mode) {
 		case TRANSMISSION_MODE_2K: tmp |= 0x6; break;
-		case /* 4K MODE */ 255: tmp |= 0x7; break;
+		case TRANSMISSION_MODE_4K: tmp |= 0x7; break;
 		default:
 		case TRANSMISSION_MODE_8K: tmp |= 0x8; break;
 	}
@@ -1014,7 +1014,7 @@ static int dib7000p_tune(struct dvb_frontend *demod, struct dvb_frontend_paramet
 	tmp = (0 << 4);
 	switch (ch->u.ofdm.transmission_mode) {
 		case TRANSMISSION_MODE_2K: tmp |= 0x6; break;
-		case /* 4K MODE */ 255: tmp |= 0x7; break;
+		case TRANSMISSION_MODE_4K: tmp |= 0x7; break;
 		default:
 		case TRANSMISSION_MODE_8K: tmp |= 0x8; break;
 	}
-- 
1.7.3.4


