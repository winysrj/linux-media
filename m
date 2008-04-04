Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m34Cv8gx026686
	for <video4linux-list@redhat.com>; Fri, 4 Apr 2008 08:57:08 -0400
Received: from mail.hauppauge.com (mail.hauppauge.com [167.206.143.4])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m34CuqX2031599
	for <video4linux-list@redhat.com>; Fri, 4 Apr 2008 08:56:53 -0400
Message-ID: <47F6258B.7020207@linuxtv.org>
Date: Fri, 04 Apr 2008 08:56:43 -0400
From: Michael Krufky <mkrufky@linuxtv.org>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@infradead.org>
References: <1115343012.20080318233620@a-j.ru>	<1207269838.3365.4.camel@pc08.localdom.local>	<20080403222937.3b234a40@gaivota>	<200804040456.57561@orion.escape-edv.de>	<47F5AB2A.3020908@linuxtv.org>
	<Pine.LNX.4.64.0804040726540.6240@bombadil.infradead.org>
In-Reply-To: <Pine.LNX.4.64.0804040726540.6240@bombadil.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com, linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] TT S-1401 problem with kernel 2.6.24 ???
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

Mauro Carvalho Chehab wrote:
>>> Imho 7186 _must_ be applied to 2.6.24, no matter how large the patch is.
>>>
>> Are you saying that THIS is the patch that needs to be applied to 2.6.24.y ?
>>
>> http://linuxtv.org/hg/v4l-dvb/rev/eb6bc7f18024
>>
>> If so, this patch seems fine for -stable.  We just have to make sure it
>> applies correctly, etc.
> 
> Agreed.
> 
> I don't see why the patch would be rejected for -stable. It is a fix, 
> proofed to work, and simple enough for everybody to understand what it is 
> doing.
> 
> The kernel documents are guidances, not absolute rules. In the end, good 
> sense is the main rule for a patch to be applied or not.
> 
> ---
> 
> Next time, please ask first for us to submit a patch to mainstream or 
> -stable before complaining why it weren't submitted.
> 
> Side note: after reviewing the entire thread, and finally understanding 
> the hole picture, it seems that you've implicitly asked. The better is to 
> send an objective email. Something like:
>  	Subject: [PATCH -stable] Please send patch xxxx to -stable
> 
> Requesting to add a patch in the middle of a thread generally means that 
> the patch won't be handled as so. The better is to send a separate e-mail, 
> with the word [PATCH] at the subject, copying the one who will be 
> responsible for applying it at the tree (the driver maintainer or me), for 
> this to be handled. In the case of patches for -stable, please c/c 
> mkrufky.



Guys,

Please test this patch against 2.6.24.4 -stable.

I don't have this hardware, or any way to test this myself, so I will wait on your feedback before sending this to the -stable team.  (Please try to test it and get back to me quickly -- I'd like to send this over before the 2.6.24.5 review cycle begins)

-Mike

From: Hartmut Hackmann <hartmut.hackmann@t-online.de>
Date: Sat, 9 Feb 2008 23:54:24 -0300

[2.6.24.y PATCH] DVB: tda10086: make the 22kHz tone for DISEQC a config option

Some cards need the diseqc signal modulated, while some just need
the envelope to control the LNB supply.

This fixes Bug 9887

Signed-off-by: Hartmut Hackmann <hartmut.hackmann@t-online.de>
Acked-by: Oliver Endriss <o.endriss@gmx.de>
Signed-off-by: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Michael Krufky <mkrufky@linuxtv.org>
(cherry picked from commit ea75baf4b0f117564bd50827a49c4b14d61d24e9)
---
 drivers/media/dvb/dvb-usb/ttusb2.c        |    1 +
 drivers/media/dvb/frontends/tda10086.c    |   28 ++++++++++++++++++++++------
 drivers/media/dvb/frontends/tda10086.h    |    3 +++
 drivers/media/dvb/ttpci/budget.c          |    1 +
 drivers/media/video/saa7134/saa7134-dvb.c |    5 +++--
 5 files changed, 30 insertions(+), 8 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/ttusb2.c b/drivers/media/dvb/dvb-usb/ttusb2.c
index 88dc436..3b9da9c 100644
--- a/drivers/media/dvb/dvb-usb/ttusb2.c
+++ b/drivers/media/dvb/dvb-usb/ttusb2.c
@@ -144,6 +144,7 @@ static int ttusb2_power_ctrl(struct dvb_usb_device *d, int onoff)
 static struct tda10086_config tda10086_config = {
 	.demod_address = 0x0e,
 	.invert = 0,
+	.diseqc_tone = 1,
 };
 
 static int ttusb2_frontend_attach(struct dvb_usb_adapter *adap)
diff --git a/drivers/media/dvb/frontends/tda10086.c b/drivers/media/dvb/frontends/tda10086.c
index 9d26ace..0d2b69a 100644
--- a/drivers/media/dvb/frontends/tda10086.c
+++ b/drivers/media/dvb/frontends/tda10086.c
@@ -106,9 +106,12 @@ static int tda10086_write_mask(struct tda10086_state *state, int reg, int mask,
 static int tda10086_init(struct dvb_frontend* fe)
 {
 	struct tda10086_state* state = fe->demodulator_priv;
+	u8 t22k_off = 0x80;
 
 	dprintk ("%s\n", __FUNCTION__);
 
+	if (state->config->diseqc_tone)
+		t22k_off = 0;
 	// reset
 	tda10086_write_byte(state, 0x00, 0x00);
 	msleep(10);
@@ -158,7 +161,7 @@ static int tda10086_init(struct dvb_frontend* fe)
 	tda10086_write_byte(state, 0x3d, 0x80);
 
 	// setup SEC
-	tda10086_write_byte(state, 0x36, 0x80); // all SEC off, no 22k tone
+	tda10086_write_byte(state, 0x36, t22k_off); // all SEC off, 22k tone
 	tda10086_write_byte(state, 0x34, (((1<<19) * (22000/1000)) / (SACLK/1000)));      // } tone frequency
 	tda10086_write_byte(state, 0x35, (((1<<19) * (22000/1000)) / (SACLK/1000)) >> 8); // }
 
@@ -180,16 +183,20 @@ static void tda10086_diseqc_wait(struct tda10086_state *state)
 static int tda10086_set_tone (struct dvb_frontend* fe, fe_sec_tone_mode_t tone)
 {
 	struct tda10086_state* state = fe->demodulator_priv;
+	u8 t22k_off = 0x80;
 
 	dprintk ("%s\n", __FUNCTION__);
 
+	if (state->config->diseqc_tone)
+		t22k_off = 0;
+
 	switch (tone) {
 	case SEC_TONE_OFF:
-		tda10086_write_byte(state, 0x36, 0x80);
+		tda10086_write_byte(state, 0x36, t22k_off);
 		break;
 
 	case SEC_TONE_ON:
-		tda10086_write_byte(state, 0x36, 0x81);
+		tda10086_write_byte(state, 0x36, 0x01 + t22k_off);
 		break;
 	}
 
@@ -202,9 +209,13 @@ static int tda10086_send_master_cmd (struct dvb_frontend* fe,
 	struct tda10086_state* state = fe->demodulator_priv;
 	int i;
 	u8 oldval;
+	u8 t22k_off = 0x80;
 
 	dprintk ("%s\n", __FUNCTION__);
 
+	if (state->config->diseqc_tone)
+		t22k_off = 0;
+
 	if (cmd->msg_len > 6)
 		return -EINVAL;
 	oldval = tda10086_read_byte(state, 0x36);
@@ -212,7 +223,8 @@ static int tda10086_send_master_cmd (struct dvb_frontend* fe,
 	for(i=0; i< cmd->msg_len; i++) {
 		tda10086_write_byte(state, 0x48+i, cmd->msg[i]);
 	}
-	tda10086_write_byte(state, 0x36, 0x88 | ((cmd->msg_len - 1) << 4));
+	tda10086_write_byte(state, 0x36, (0x08 + t22k_off)
+					| ((cmd->msg_len - 1) << 4));
 
 	tda10086_diseqc_wait(state);
 
@@ -225,16 +237,20 @@ static int tda10086_send_burst (struct dvb_frontend* fe, fe_sec_mini_cmd_t minic
 {
 	struct tda10086_state* state = fe->demodulator_priv;
 	u8 oldval = tda10086_read_byte(state, 0x36);
+	u8 t22k_off = 0x80;
 
 	dprintk ("%s\n", __FUNCTION__);
 
+	if (state->config->diseqc_tone)
+		t22k_off = 0;
+
 	switch(minicmd) {
 	case SEC_MINI_A:
-		tda10086_write_byte(state, 0x36, 0x84);
+		tda10086_write_byte(state, 0x36, 0x04 + t22k_off);
 		break;
 
 	case SEC_MINI_B:
-		tda10086_write_byte(state, 0x36, 0x86);
+		tda10086_write_byte(state, 0x36, 0x06 + t22k_off);
 		break;
 	}
 
diff --git a/drivers/media/dvb/frontends/tda10086.h b/drivers/media/dvb/frontends/tda10086.h
index ed584a8..eeceaee 100644
--- a/drivers/media/dvb/frontends/tda10086.h
+++ b/drivers/media/dvb/frontends/tda10086.h
@@ -33,6 +33,9 @@ struct tda10086_config
 
 	/* does the "inversion" need inverted? */
 	u8 invert;
+
+	/* do we need the diseqc signal with carrier? */
+	u8 diseqc_tone;
 };
 
 #if defined(CONFIG_DVB_TDA10086) || (defined(CONFIG_DVB_TDA10086_MODULE) && defined(MODULE))
diff --git a/drivers/media/dvb/ttpci/budget.c b/drivers/media/dvb/ttpci/budget.c
index 9268a82..14b00f5 100644
--- a/drivers/media/dvb/ttpci/budget.c
+++ b/drivers/media/dvb/ttpci/budget.c
@@ -351,6 +351,7 @@ static struct s5h1420_config s5h1420_config = {
 static struct tda10086_config tda10086_config = {
 	.demod_address = 0x0e,
 	.invert = 0,
+	.diseqc_tone = 1,
 };
 
 static u8 read_pwm(struct budget* budget)
diff --git a/drivers/media/video/saa7134/saa7134-dvb.c b/drivers/media/video/saa7134/saa7134-dvb.c
index e1ab099..506de4d 100644
--- a/drivers/media/video/saa7134/saa7134-dvb.c
+++ b/drivers/media/video/saa7134/saa7134-dvb.c
@@ -826,6 +826,7 @@ static struct tda1004x_config ads_tech_duo_config = {
 static struct tda10086_config flydvbs = {
 	.demod_address = 0x0e,
 	.invert = 0,
+	.diseqc_tone = 0,
 };
 
 /* ==================================================================

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
