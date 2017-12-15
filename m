Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f42.google.com ([74.125.82.42]:35673 "EHLO
        mail-wm0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756221AbdLOTwx (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 15 Dec 2017 14:52:53 -0500
Received: by mail-wm0-f42.google.com with SMTP id f9so19798526wmh.0
        for <linux-media@vger.kernel.org>; Fri, 15 Dec 2017 11:52:53 -0800 (PST)
Date: Fri, 15 Dec 2017 20:52:45 +0100
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: Antti Palosaari <crope@iki.fi>
Cc: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com, zzam@gentoo.org
Subject: Re: [PATCH] [media] tda18212: fix use-after-free in
 tda18212_remove()
Message-ID: <20171215205245.183898c6@macbox>
In-Reply-To: <bafe7ab3-d9ba-58ae-049f-3386ff58a6a1@iki.fi>
References: <20171215164337.3236-1-d.scheller.oss@gmail.com>
        <3c5e3614-ee61-f69a-283f-2c1b16aa2cbc@iki.fi>
        <20171215190008.1dde2633@macbox>
        <9d4e4ccd-9d96-b2eb-6b49-7f50dc08e109@iki.fi>
        <20171215194044.12dc4469@macbox>
        <bafe7ab3-d9ba-58ae-049f-3386ff58a6a1@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 15 Dec 2017 21:06:32 +0200
Antti Palosaari <crope@iki.fi> wrote:

> On 12/15/2017 08:40 PM, Daniel Scheller wrote:
> > On Fri, 15 Dec 2017 20:12:18 +0200
> > Antti Palosaari <crope@iki.fi> wrote:
> >>
> >> em28xx does it currently just correct.
> >> 1) unregister frontend  
> > 
> > Note that this is a call to em28xx_unregister_dvb(), which in turn
> > does dvb_unregister_frontend() and then dvb_frontend_detach() (at
> > this stage, fe resources are gone).
> >   
> >> 2) remove I2C SEC
> >> 3) remove I2C tuner
> >> 4) remove I2C demod (frees shared frontend data)  
> > 
> > Yes, but ie. EM2874_BOARD_KWORLD_UB435Q_V3 is a combination of a
> > "legacy" demod frontend - lgdt3305 actually - plus the tda18212
> > i2cclient (just like in ddb with stv0367+tda18212 or
> > cxd2841er+tda18212), I'm sure this will yield the same report.
> > 
> > Maybe another approach: Implement the tuner_ops.release callback,
> > and then move the memset+NULL assignment right there (instead of
> > just removing it), but this likely will cause issues when the i2c
> > client is removed before detach if we don't keep track of this ie
> > somewhere in tda18212_dev (new state var - if _remove is called,
> > check if the tuner was released, and if not, call release
> > (memset/set NULL), then free). Still with the two other drivers in
> > mind though. If they're wrong aswell, I'll rather fix up ddbridge
> > of course.  
> 
> Whole memset thing could be removed from tda18212, there is something 
> likely wrong if those are needed. But it is another issue.

On a side note: After some few more glances, there are many other
drivers in media/tuners/ that would require such treatment (tbh I just
peeked into tda18212 when investigating the KASAN report).

> Your main issue is somehow to get order of demod/tuner destroy
> correct. I don't even like idea whole shared frontend data is owned
> by the demod driver instance, but currently it is there and due to
> that this should be released lastly. General design goal is also do
> things like register things in order and unregister just
> reverse-order.

Fully agreeing on the last bit. I'll see how to improve on this in
ddbridge. Yet, very likely other drivers (and I have a feeling there
are quite some) with this issue (wrong teardown order) remain.

It might indeed be better if in frontend_ops, tuner_ops would be a ptr
to some struct that is managed by the tuner driver itself, that would
save from such issues.

Anyway, thank you very much for your input! (and apologies for any
noise or nonsense)

Best regards,
Daniel Scheller
-- 
https://github.com/herrnst
