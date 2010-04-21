Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:30723 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753523Ab0DUJ3e (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 21 Apr 2010 05:29:34 -0400
Subject: Re: [PATCH 1/3] MFD: WL1273 FM Radio: MFD driver for the FM radio.
From: m7aalton <matti.j.aaltonen@nokia.com>
Reply-To: matti.j.aaltonen@nokia.com
To: ext Jonathan Corbet <corbet@lwn.net>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"Valentin Eduardo (Nokia-D/Helsinki)" <eduardo.valentin@nokia.com>
In-Reply-To: <20100420133334.75184ea5@bike.lwn.net>
References: <1271776807-2710-1-git-send-email-matti.j.aaltonen@nokia.com>
	 <1271776807-2710-2-git-send-email-matti.j.aaltonen@nokia.com>
	 <20100420133334.75184ea5@bike.lwn.net>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 21 Apr 2010 12:29:00 +0300
Message-ID: <1271842140.4927.20.camel@masi.mnp.nokia.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello.

Thanks for the comments.

On Tue, 2010-04-20 at 21:33 +0200, ext Jonathan Corbet wrote:
> On Tue, 20 Apr 2010 18:20:05 +0300
> "Matti J. Aaltonen" <matti.j.aaltonen@nokia.com> wrote:
> 
> > This is a parent driver for two child drivers: the V4L2 driver and
> > the ALSA codec driver. The MFD part provides the I2C communication
> > to the device and the state handling.
> 
> So I was taking a quick look at this; it mostly looks OK (though I wonder
> about all those symbol exports - does all that stuff need to be in the

Some functions get called from both child drivers/modules, but some
stuff could probably be moved from the core to either of the children.
Should I actually do that?

> core?).  One thing caught my eye, though:
> 
> > +int wl1273_fm_rds_off(struct wl1273_core *core)
> > +{
> > +	struct device *dev = &core->i2c_dev->dev;
> > +	int r;
> > +
> > +	if (core->mode == WL1273_MODE_TX)
> > +		return 0;
> > +
> > +	wait_for_completion_timeout(&core->busy, msecs_to_jiffies(1000));
> The use of a completion here looks like a mistake to me.  This isn't a
> normal pattern, and I'm not quite sure what you're trying to do.  Here,
> also, you're ignoring the return value, so you don't know if completion
> was signaled or not.

Yes that wait_for_completion is a mistake.

> 
> If you look in functions like:
> 
> > +int wl1273_fm_set_rx_freq(struct wl1273_core *core, unsigned int freq)
> > +{
> 
> [...]
> 
> > +	INIT_COMPLETION(core->busy);
> > +	r = wl1273_fm_write_cmd(core, WL1273_TUNER_MODE_SET,
> > +				TUNER_MODE_PRESET);
> > +	if (r) {
> > +		complete(&core->busy);
> > +		goto err;
> > +	}
> 
> What will prevent multiple threads from doing INIT_COMPLETION()
> simultaneously?  It  looks racy to me.  What happens if multiple
> threads try to wait simultaneously on the completion?
> 
> OK, looking further, you're not using it for mutual exclusion.  In fact,
> you're not using anything for mutual exclusion; how do you prevent
> concurrent access to the hardware registers?

I have mutexes everywhere that function is called from. My aim was to
have the mutexes in the interface functions. So that the radio use is
serialized on as high a level as possible.

> What I would suggest you do is remove the completion in favor of a wait
> queue which the interrupt handler can use to signal that something has
> completed.  You can then use wait_event() to wait for a wakeup and test
> that the specific condition you are waiting for has come to pass.

Do you agree with my explanation? Or should I switch to using wait
queue?

Cheers,
Matti

> jon


