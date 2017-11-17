Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.horus.com ([78.46.148.228]:60367 "EHLO mail.horus.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1161094AbdKQRtI (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 17 Nov 2017 12:49:08 -0500
Date: Fri, 17 Nov 2017 18:49:06 +0100
From: Matthias Reichl <hias@horus.com>
To: Sean Young <sean@mess.org>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] media: rc: double keypresses due to timeout expiring to
 early
Message-ID: <20171117174906.fouyirka4tho3guf@camel2.lan>
References: <20171116152700.filid3ask3gowegl@camel2.lan>
 <20171116163920.ouxinvde5ai4fle3@gofer.mess.org>
 <20171116215451.min7sqdo7itiyyif@gofer.mess.org>
 <20171117145249.wc4ql2hw46enxu7d@camel2.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171117145249.wc4ql2hw46enxu7d@camel2.lan>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Nov 17, 2017 at 03:52:50PM +0100, Matthias Reichl wrote:
> Hi Sean!
> 
> On Thu, Nov 16, 2017 at 09:54:51PM +0000, Sean Young wrote:
> > Since commit d57ea877af38 ("media: rc: per-protocol repeat period"),
> > double keypresses are reported on the ite-cir driver. This is due
> > two factors: that commit reduced the timeout used for some protocols
> > (it became protocol dependant) and the high default IR timeout used
> > by the ite-cir driver.
> > 
> > Some of the IR decoders wait for a trailing space, as that is
> > the only way to know if the bit stream has ended (e.g. rc-6 can be
> > 16, 20 or 32 bits). The longer the IR timeout, the longer it will take
> > to receive the trailing space, delaying decoding and pushing it past the
> > keyup timeout.
> > 
> > So, add the IR timeout to the keyup timeout.
> 
> Thanks a lot for the patch, I've asked the people with ite-cir
> receivers to test it.

Just got the first test results from ite-cir + rc-6 remote back,
events were the same as I was seeing with gpio-ir-recv with 200ms
timeout - key repeat event from input layer.

Kernel 4.14 + your patch:
Event: time 1510938801.797335, type 4 (EV_MSC), code 4 (MSC_SCAN), value 800f041f
Event: time 1510938801.797335, type 1 (EV_KEY), code 108 (KEY_DOWN), value 1
Event: time 1510938801.797335, -------------- SYN_REPORT ------------
Event: time 1510938802.034331, type 4 (EV_MSC), code 4 (MSC_SCAN), value 800f041f
Event: time 1510938802.034331, -------------- SYN_REPORT ------------
Event: time 1510938802.301333, type 1 (EV_KEY), code 108 (KEY_DOWN), value 2
Event: time 1510938802.301333, -------------- SYN_REPORT ------------
Event: time 1510938802.408003, type 1 (EV_KEY), code 108 (KEY_DOWN), value 0
Event: time 1510938802.408003, -------------- SYN_REPORT ------------

Kernel 4.13.2:
Event: time 1510938637.791450, type 4 (EV_MSC), code 4 (MSC_SCAN), value 800f041f
Event: time 1510938637.791450, type 1 (EV_KEY), code 108 (KEY_DOWN), value 1
Event: time 1510938637.791450, -------------- SYN_REPORT ------------
Event: time 1510938638.028301, type 4 (EV_MSC), code 4 (MSC_SCAN), value 800f041f
Event: time 1510938638.028301, -------------- SYN_REPORT ------------
Event: time 1510938638.292323, type 1 (EV_KEY), code 108 (KEY_DOWN), value 0
Event: time 1510938638.292323, -------------- SYN_REPORT ------------

so long,

Hias

> 
> In the meanwhile I ran some tests with gpio-ir-recv and timeout
> set to 200ms with a rc-5 remote (that's as close to the original
> setup as I can test right now).
> 
> While the patch fixes the additional key down/up event on longer
> presses, I still get a repeated key event on a short button
> press - which makes it hard to do a single click with the
> remote.
> 
> Test on kernel 4.14 with your patch:
> 1510927844.292126: event type EV_MSC(0x04): scancode = 0x1015
> 1510927844.292126: event type EV_KEY(0x01) key_down: KEY_ENTER(0x001c)
> 1510927844.292126: event type EV_SYN(0x00).
> 1510927844.498773: event type EV_MSC(0x04): scancode = 0x1015
> 1510927844.498773: event type EV_SYN(0x00).
> 1510927844.795410: event type EV_KEY(0x01) key_down: KEY_ENTER(0x001c)
> 1510927844.795410: event type EV_SYN(0x00).
> 1510927844.875412: event type EV_KEY(0x01) key_up: KEY_ENTER(0x001c)
> 1510927844.875412: event type EV_SYN(0x00).
> 
> Same signal received on kernel 4.9:
> 1510927844.280350: event type EV_MSC(0x04): scancode = 0x1015
> 1510927844.280350: event type EV_KEY(0x01) key_down: KEY_OK(0x0160)
> 1510927844.280350: event type EV_SYN(0x00).
> 1510927844.506477: event type EV_MSC(0x04): scancode = 0x1015
> 1510927844.506477: event type EV_SYN(0x00).
> 1510927844.763111: event type EV_KEY(0x01) key_up: KEY_OK(0x0160)
> 1510927844.763111: event type EV_SYN(0x00).
> 
> If I understand it correctly it's the input layer repeat (500ms delay)
> kicking in, because time between initial scancode and timeout is
> now signal time + 200ms + 164ms + 200ms (about 570-580ms).
> On older kernels this was signal time + 200ms + 250ms, so typically
> just below the 500ms default repeat delay.
> 
> I'm still trying to wrap my head around the timeout code in the
> rc layer. One problem seems to be that we apply the rather large
> timeout twice. Maybe detecting scancodes generated via timeout
> (sth like timestamp - last_timestamp > protocol_repeat_period)
> and in that case immediately signalling keyup could help? Could well
> be that I'm missing somehting important and this is a bad idea.
> I guess I'd better let you figure something out :)
> 
> so long,
> 
> Hias
> 
> > 
> > Cc: <stable@vger.kernel.org> # 4.14
> > Reported-by: Matthias Reichl <hias@horus.com>
> > Signed-off-by: Sean Young <sean@mess.org>
> > ---
> >  drivers/media/rc/rc-main.c | 6 ++++--
> >  1 file changed, 4 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
> > index 17950e29d4e3..fae721534517 100644
> > --- a/drivers/media/rc/rc-main.c
> > +++ b/drivers/media/rc/rc-main.c
> > @@ -672,7 +672,8 @@ void rc_repeat(struct rc_dev *dev)
> >  	input_event(dev->input_dev, EV_MSC, MSC_SCAN, dev->last_scancode);
> >  	input_sync(dev->input_dev);
> >  
> > -	dev->keyup_jiffies = jiffies + msecs_to_jiffies(timeout);
> > +	dev->keyup_jiffies = jiffies + msecs_to_jiffies(timeout) +
> > +					nsecs_to_jiffies(dev->timeout);
> >  	mod_timer(&dev->timer_keyup, dev->keyup_jiffies);
> >  
> >  out:
> > @@ -744,7 +745,8 @@ void rc_keydown(struct rc_dev *dev, enum rc_proto protocol, u32 scancode,
> >  
> >  	if (dev->keypressed) {
> >  		dev->keyup_jiffies = jiffies +
> > -			msecs_to_jiffies(protocols[protocol].repeat_period);
> > +			msecs_to_jiffies(protocols[protocol].repeat_period) +
> > +			nsecs_to_jiffies(dev->timeout);
> >  		mod_timer(&dev->timer_keyup, dev->keyup_jiffies);
> >  	}
> >  	spin_unlock_irqrestore(&dev->keylock, flags);
> > -- 
> > 2.14.3
> > 
