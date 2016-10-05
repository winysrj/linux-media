Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:51865
        "EHLO s-opensource.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751479AbcJEJE7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 5 Oct 2016 05:04:59 -0400
Date: Wed, 5 Oct 2016 06:04:50 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Jiri Kosina <jikos@kernel.org>
Cc: Patrick Boettcher <patrick.boettcher@posteo.de>,
        =?UTF-8?B?SsO2cmc=?= Otte <jrg.otte@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andy Lutomirski <luto@kernel.org>,
        Michael Krufky <mkrufky@linuxtv.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Problem with VMAP_STACK=y
Message-ID: <20161005060450.1b0f2152@vento.lan>
In-Reply-To: <alpine.LNX.2.00.1610050947380.31629@cbobk.fhfr.pm>
References: <CADDKRnB1=-zj8apQ3vBfbxVZ8Dc4DJbD1MHynC9azNpfaZeF6Q@mail.gmail.com>
        <alpine.LRH.2.00.1610041519160.1123@gjva.wvxbf.pm>
        <CADDKRnA1qjyejvmmKQ9MuxH6Dkc7Uhwq4BSFVsOS3U-eBWP9GA@mail.gmail.com>
        <alpine.LNX.2.00.1610050925470.31629@cbobk.fhfr.pm>
        <20161005093417.6e82bd97@vdr>
        <alpine.LNX.2.00.1610050947380.31629@cbobk.fhfr.pm>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 5 Oct 2016 09:50:42 +0200 (CEST)
Jiri Kosina <jikos@kernel.org> escreveu:

> On Wed, 5 Oct 2016, Patrick Boettcher wrote:
> 
> > > > Thanks for the quick response.
> > > > Drivers are:
> > > > dvb_core, dvb_usb, dbv_usb_cynergyT2    
> > > 
> > > This dbv_usb_cynergyT2 is not from Linus' tree, is it? I don't seem
> > > to be able to find it, and the only google hit I am getting is your
> > > very mail to LKML :)  
> > 
> > It's a typo, it should say dvb_usb_cinergyT2.  
> 
> Ah, thanks. Same issues there in
> 
> 	cinergyt2_frontend_attach()
> 	cinergyt2_rc_query()
> 
> I think this would require more in-depth review of all the media drivers 
> and having all this fixed for 4.9. It should be pretty straightforward; 
> all the instances I've seen so far should be just straightforward 
> conversion to kmalloc() + kfree(), as the buffer is not being embedded in 
> any structure etc.

What we're doing on most cases is to put a buffer (usually with 80
chars for USB drivers) inside the "state" struct (on DVB drivers),
in order to avoid doing kmalloc/kfree all the times. One such patch is 
changeset c4a98793a63c4.

I'm enclosing a non-tested patch fixing it for the cinergyT2-core.c
driver.

Thanks,
Mauro

[PATCH] cinergyT2-core: don't do DMA on stack

The USB control messages require DMA to work. We cannot pass
a stack-allocated buffer, as it is not warranted that the
stack would be into a DMA enabled area.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>

diff --git a/drivers/media/usb/dvb-usb/cinergyT2-core.c b/drivers/media/usb/dvb-usb/cinergyT2-core.c
index 9fd1527494eb..2787acc74fcc 100644
--- a/drivers/media/usb/dvb-usb/cinergyT2-core.c
+++ b/drivers/media/usb/dvb-usb/cinergyT2-core.c
@@ -41,6 +41,7 @@ DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);
 
 struct cinergyt2_state {
 	u8 rc_counter;
+	unsigned char data[64];
 };
 
 /* We are missing a release hook with usb_device data */
@@ -50,29 +51,34 @@ static struct dvb_usb_device_properties cinergyt2_properties;
 
 static int cinergyt2_streaming_ctrl(struct dvb_usb_adapter *adap, int enable)
 {
-	char buf[] = { CINERGYT2_EP1_CONTROL_STREAM_TRANSFER, enable ? 1 : 0 };
-	char result[64];
-	return dvb_usb_generic_rw(adap->dev, buf, sizeof(buf), result,
-				sizeof(result), 0);
+	struct dvb_usb_device *d = adap->dev;
+	struct cinergyt2_state *st = d->priv;
+
+	st->data[0] = CINERGYT2_EP1_CONTROL_STREAM_TRANSFER;
+	st->data[1] = enable ? 1 : 0;
+
+	return dvb_usb_generic_rw(d, st->data, 2, st->data, 64, 0);
 }
 
 static int cinergyt2_power_ctrl(struct dvb_usb_device *d, int enable)
 {
-	char buf[] = { CINERGYT2_EP1_SLEEP_MODE, enable ? 0 : 1 };
-	char state[3];
-	return dvb_usb_generic_rw(d, buf, sizeof(buf), state, sizeof(state), 0);
+	struct cinergyt2_state *st = d->priv;
+
+	st->data[0] = CINERGYT2_EP1_SLEEP_MODE;
+	st->data[1] = enable ? 1 : 0;
+
+	return dvb_usb_generic_rw(d, st->data, 2, st->data, 3, 0);
 }
 
 static int cinergyt2_frontend_attach(struct dvb_usb_adapter *adap)
 {
-	char query[] = { CINERGYT2_EP1_GET_FIRMWARE_VERSION };
-	char state[3];
+	struct dvb_usb_device *d = adap->dev;
+	struct cinergyt2_state *st = d->priv;
 	int ret;
 
 	adap->fe_adap[0].fe = cinergyt2_fe_attach(adap->dev);
 
-	ret = dvb_usb_generic_rw(adap->dev, query, sizeof(query), state,
-				sizeof(state), 0);
+	ret = dvb_usb_generic_rw(d, st->data, 1, st->data, 3, 0);
 	if (ret < 0) {
 		deb_rc("cinergyt2_power_ctrl() Failed to retrieve sleep "
 			"state info\n");
@@ -141,13 +147,14 @@ static int repeatable_keys[] = {
 static int cinergyt2_rc_query(struct dvb_usb_device *d, u32 *event, int *state)
 {
 	struct cinergyt2_state *st = d->priv;
-	u8 key[5] = {0, 0, 0, 0, 0}, cmd = CINERGYT2_EP1_GET_RC_EVENTS;
 	int i;
 
 	*state = REMOTE_NO_KEY_PRESSED;
 
-	dvb_usb_generic_rw(d, &cmd, 1, key, sizeof(key), 0);
-	if (key[4] == 0xff) {
+	st->data[0] = CINERGYT2_EP1_SLEEP_MODE;
+
+	dvb_usb_generic_rw(d, st->data, 1, st->data, 5, 0);
+	if (st->data[4] == 0xff) {
 		/* key repeat */
 		st->rc_counter++;
 		if (st->rc_counter > RC_REPEAT_DELAY) {
@@ -166,13 +173,13 @@ static int cinergyt2_rc_query(struct dvb_usb_device *d, u32 *event, int *state)
 	}
 
 	/* hack to pass checksum on the custom field */
-	key[2] = ~key[1];
-	dvb_usb_nec_rc_key_to_event(d, key, event, state);
-	if (key[0] != 0) {
+	st->data[2] = ~st->data[1];
+	dvb_usb_nec_rc_key_to_event(d, st->data, event, state);
+	if (st->data[0] != 0) {
 		if (*event != d->last_event)
 			st->rc_counter = 0;
 
-		deb_rc("key: %*ph\n", 5, key);
+		deb_rc("key: %*ph\n", 5, st->data);
 	}
 	return 0;
 }

