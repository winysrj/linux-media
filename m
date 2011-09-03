Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36479 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751442Ab1ICP76 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 3 Sep 2011 11:59:58 -0400
Message-ID: <4E624EF3.3070101@redhat.com>
Date: Sat, 03 Sep 2011 12:59:47 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH] [media] dvb-core, tda18271c2dd: define get_if_frequency()
 callback
References: <1315062777-12049-1-git-send-email-mchehab@redhat.com> <4E6246BB.8000500@iki.fi> <4E6249EF.9080702@iki.fi> <4E624B00.5040202@redhat.com>
In-Reply-To: <4E624B00.5040202@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 03-09-2011 12:42, Mauro Carvalho Chehab escreveu:
> Em 03-09-2011 12:38, Antti Palosaari escreveu:
>> On 09/03/2011 06:24 PM, Antti Palosaari wrote:
>>> On 09/03/2011 06:12 PM, Mauro Carvalho Chehab wrote:
>>>> The DRX-K frontend needs to know the IF frequency in order to work,
>>>> just like all other frontends. However, as it is a multi-standard
>>>> FE, the IF may change if the standard is changed. So, the usual
>>>> procedure of passing it via a config struct doesn't work.
>>>>
>>>> One might code it as two separate IF frequencies, one by each type
>>>> of FE, but, as, on tda18271, the IF changes if the bandwidth for
>>>> DVB-C changes, this also won't work.
>>>>
>>>> So, the better is to just add a new callback for it and require
>>>> it for the tuners that can be used with MFE frontends like drx-k.
>>>>
>>>> It makes sense to add support for it on all existing tuners, and
>>>> remove the IF parameter from the demods, cleaning up the code.
>>>
>>> Is it clear that only used tuner IC defines used IF?
>>>
>>> I have seen some cases where used IF is different depending on other
>>> used hardware, even same tuner IC used. Very good example is to see all
>>> configuration structs of old tda18271 driver. Those are mainly used for
>>> setting different IF than tuner default...
> 
> Not sure if I understood your comments here.
> 
> There are two separate things here:
> 
> 1) digital tuners like tda18271, xc3028, etc allow changing the IF frequency,
> while others, like the analog tuners, have a fixed IF frequency. For digital
> tuners, it makes sense to have ways to configure it, via the tuner's configuration
> file, like the tda18271-fe driver.
> 
> This patch doesn't change anything with that regards.
> 
> 2) Demods need to know what IF is used by the tuner. Currently, the bridge driver
> needs to fill a per-demod configuration struct for it, or pass it via parameter.
> 
> This works fine, when the IF is fixed.
> 
> However, the tda18271 specs recommend different IF values for each bandwidth, and
> between dvb-t and dvb-c.
> 
> It would be possible to workaround that and just use the same IF for everything
> at tda18271, not obeying the recommended values, but this seems a bad idea, as
> the chipset will be used on a non-tested configuration.
> 
> So, instead of fixing the same IF at the tuner, this patch allows the tuner to
> change the IF as needed/desired, and letting the demod to change according with
> the tuner changes.
> 
> I'll put the above comments at the committed patch.
> 
>> Hmm, I think that will actually only reduce defining same IFs to demod which are already set to tuner allowing to remove "redundant" demod definitions. OK, now it looks fine for me.
>>
>> Acked-by: Antti Palosaari <crope@iki.fi>
> 
> Thanks!

Ok, this is the same patch. I just improved the patch description.


commit 8513e14457ad05c517f6f6f520c270a6eebf0472
Author: Mauro Carvalho Chehab <mchehab@redhat.com>
Date:   Sat Sep 3 11:40:02 2011 -0300

    [media] dvb-core, tda18271c2dd: define get_if_frequency() callback
    
    Tuners in general convert a high frequency carrier into an Intermediate
    Frequency (IF).
    
    Digital tuners like tda18271, xc3028, etc. generally allow changing the IF
    frequency, although they generally have recommented settings for the IF.
    Analog tuners, have a fixed IF frequency, that depends on the physical
    characteristics of some analog components.
    
    For digital tuners, it makes sense to have ways to configure IF,
    via the tuner's configuration structure, like what's done inside the
    tda18271-fe maps.
    
    The demods need to know what IF is used by the tuner, as it will need
    to convert internally from IF into baseband. Currently, the bridge driver
    needs to fill a per-demod configuration struct for it, or pass it via
    a dvb_attach parameter.
    
    The tda18271 datasheet recommends to use different IF's for different
    delivery system types and for different bandwidths.
    
    The DRX-K demod also needs to know the IF frequency in order to work,
    just like all other demods. However, as it accepts different delivery
    systems (DVB-C and DVB-T), the IF may change if the standard and/or
    bandwidth is changed.
    
    So, the usual procedure of passing it via a config struct doesn't work.
    
    One might try to code it as two separate IF frequencies, or even as a
    table in function of the delivery system and the bandwidth, but this
    will be messy.
    
    So, it is better and simpler to just add a new callback for it and
    require the tuners that can be used with MFE frontends like drx-k
    to implement a new callback to return the used IF.
    
    Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
    Acked-by: Antti Palosaari <crope@iki.fi>

diff --git a/drivers/media/dvb/dvb-core/dvb_frontend.h b/drivers/media/dvb/dvb-core/dvb_frontend.h
index 5590eb6..67bbfa7 100644
--- a/drivers/media/dvb/dvb-core/dvb_frontend.h
+++ b/drivers/media/dvb/dvb-core/dvb_frontend.h
@@ -209,6 +209,7 @@ struct dvb_tuner_ops {
 
 	int (*get_frequency)(struct dvb_frontend *fe, u32 *frequency);
 	int (*get_bandwidth)(struct dvb_frontend *fe, u32 *bandwidth);
+	int (*get_if_frequency)(struct dvb_frontend *fe, u32 *frequency);
 
 #define TUNER_STATUS_LOCKED 1
 #define TUNER_STATUS_STEREO 2
diff --git a/drivers/media/dvb/frontends/drxk_hard.c b/drivers/media/dvb/frontends/drxk_hard.c
index 41b0838..f6431ef 100644
--- a/drivers/media/dvb/frontends/drxk_hard.c
+++ b/drivers/media/dvb/frontends/drxk_hard.c
@@ -6211,6 +6211,14 @@ static int drxk_set_parameters(struct dvb_frontend *fe,
 	u32 IF;
 
 	dprintk(1, "\n");
+
+	if (!fe->ops.tuner_ops.get_if_frequency) {
+		printk(KERN_ERR
+		       "drxk: Error: get_if_frequency() not defined at tuner. Can't work without it!\n");
+		return -EINVAL;
+	}
+
+
 	if (fe->ops.i2c_gate_ctrl)
 		fe->ops.i2c_gate_ctrl(fe, 1);
 	if (fe->ops.tuner_ops.set_params)
@@ -6218,7 +6226,7 @@ static int drxk_set_parameters(struct dvb_frontend *fe,
 	if (fe->ops.i2c_gate_ctrl)
 		fe->ops.i2c_gate_ctrl(fe, 0);
 	state->param = *p;
-	fe->ops.tuner_ops.get_frequency(fe, &IF);
+	fe->ops.tuner_ops.get_if_frequency(fe, &IF);
 	Start(state, 0, IF);
 
 	/* printk(KERN_DEBUG "drxk: %s IF=%d done\n", __func__, IF); */
diff --git a/drivers/media/dvb/frontends/tda18271c2dd.c b/drivers/media/dvb/frontends/tda18271c2dd.c
index 0384e8d..1b1bf20 100644
--- a/drivers/media/dvb/frontends/tda18271c2dd.c
+++ b/drivers/media/dvb/frontends/tda18271c2dd.c
@@ -1195,7 +1195,7 @@ static int GetSignalStrength(s32 *pSignalStrength, u32 RFAgc, u32 IFAgc)
 }
 #endif
 
-static int get_frequency(struct dvb_frontend *fe, u32 *frequency)
+static int get_if_frequency(struct dvb_frontend *fe, u32 *frequency)
 {
 	struct tda_state *state = fe->tuner_priv;
 
@@ -1222,7 +1222,7 @@ static struct dvb_tuner_ops tuner_ops = {
 	.sleep             = sleep,
 	.set_params        = set_params,
 	.release           = release,
-	.get_frequency     = get_frequency,
+	.get_if_frequency  = get_if_frequency,
 	.get_bandwidth     = get_bandwidth,
 };
 
