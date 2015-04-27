Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:38008 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964944AbbD0V3z (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 27 Apr 2015 17:29:55 -0400
Received: by wiun10 with SMTP id n10so6279280wiu.1
        for <linux-media@vger.kernel.org>; Mon, 27 Apr 2015 14:29:54 -0700 (PDT)
Message-ID: <553EAA50.4010405@gmail.com>
Date: Mon, 27 Apr 2015 22:29:52 +0100
From: Jemma Denson <jdenson@gmail.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Patrick Boettcher <patrick.boettcher@posteo.de>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PULL] For 4.2 (or even 4.1?) add support for cx24120/Technisat
 SkyStar S2
References: <20150420092720.3cb092ba@dibcom294.coe.adi.dibcom.com> <20150427171628.5ba22752@recife.lan>
In-Reply-To: <20150427171628.5ba22752@recife.lan>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

(Resending to fix reply-all)

Hi Mauro,

Thanks for taking the time to look into this. I'll let Patrick respond 
to the first part regards the pull request - I'll just respond to the 
points you've made about the driver itself.

On 27/04/15 21:16, Mauro Carvalho Chehab wrote:
 > +
 > +
 > +/* Write multiple registers */
 > +static int cx24120_writeregN(struct cx24120_state *state,
 > +            u8 reg, const u8 *values, u16 len, u8 incr)
 > +{
 > +    int ret;
 > +    u8 buf[5]; /* maximum 4 data bytes at once - flexcop limitation
 > +            (very limited i2c-interface this one) */
 > Hmm... if the limit is at flexcop, then the best is to not be add such
 > restriction here, but at the flexcop code, and passing the max limit that
 > used for the I2C transfer as a parameter at the attach structure, just
 > like other frontend and tuner drivers do.
I had considered doing that - the cx24116 driver does have i2c_wr_max as 
part of it's config struct. The only reason I didn't however was that I 
did consider that it's now quite unlikely this demod would be used in 
anything else so it could probably safely stay fixed for a while yet.

As you say though it would be nicer as a config item, and it shouldn't 
be too much to add in so I'll look into doing it that way.
 >
 > Also, this limit is hardcoded here. Please use a define instead.
So, if I do have this as a config item then this and the following 
hardcoded values should all disappear...
 >
 >> +
 >> +    struct i2c_msg msg = {
 >> +        .addr = state->config->i2c_addr,
 >> +        .flags = 0,
 >> +        .buf = buf,
 >> +        .len = len };
 >> +
 >> +    while (len) {
 >> +        buf[0] = reg;
 >> +        msg.len = len > 4 ? 4 : len;
 > Again, don't hardcode the max buf size here.

 >
 > +
 > +    /* Wait for tuning */
 > +    while (delay_cnt >= 0) {
 > +        cx24120_read_status(fe, &status);
 > +        if (status & FE_HAS_LOCK)
 > +            goto tuned;
 > +        msleep(20);
 > +        delay_cnt -= 20;
 > +    }
 > I don't see any need for waiting for tune here. This is generally done in
 > userspace and at the kthread inside dvb_frontend.c.
 >
 > Any reason why this has to be done here?

Some point after tuning the cx24120_set_clock_ratios function needs to 
be called and the firmware command CMD_CLOCK_SET sent. The ratios sent 
to this command depend on delivery system, fec & pilot - the latter two 
only available to read after tuning. If this isn't done then the mpeg 
stream doesn't appear.

Is there a better point to set the ratios? Or for another way of asking 
that, is there some other function that will always get hit after tuning?

 > +
 > +/* Calculate vco from config */
 > +static u64 cx24120_calculate_vco(struct cx24120_state *state)
 > +{
 > +    u32 vco;
 > +    u64 inv_vco, res, xxyyzz;
 > +    u32 xtal_khz = state->config->xtal_khz;
 > +
 > +    xxyyzz = 0x400000000ULL;
 > xxyyzz? Weird name for a var.
Yes... one of the oddities left from the dissasembled driver I hadn't 
ironed out yet! I'll look into what it's supposed to be doing and rename 
that to something far more sensible.


As time allows I'll get this fixed up as required - would it be best if 
I send patches to here made against Patrick's tree? I presume also one 
patch for each of the coding styles, and then one patch for each of the 
other issues?


Jemma.


