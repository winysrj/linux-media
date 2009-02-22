Return-path: <linux-media-owner@vger.kernel.org>
Received: from zone0.gcu-squad.org ([212.85.147.21]:4778 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752617AbZBVKJz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 22 Feb 2009 05:09:55 -0500
Date: Sun, 22 Feb 2009 11:09:42 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Trent Piepho <xyzzy@speakeasy.org>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Subject: Re: Minimum kernel version supported by v4l-dvb
Message-ID: <20090222110942.5f554a12@hyperion.delvare>
In-Reply-To: <Pine.LNX.4.58.0902210533480.24268@shell2.speakeasy.net>
References: <43235.62.70.2.252.1234947353.squirrel@webmail.xs4all.nl>
 <20090218140105.17c86bcb@hyperion.delvare>
 <20090220212327.410a298b@pedra.chehab.org>
 <200902210212.53245.hverkuil@xs4all.nl>
 <20090220231350.5467116a@pedra.chehab.org>
 <Pine.LNX.4.58.0902210343520.24268@shell2.speakeasy.net>
 <20090221141130.1c4f1265@hyperion.delvare>
 <Pine.LNX.4.58.0902210533480.24268@shell2.speakeasy.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Trent,

On Sat, 21 Feb 2009 05:58:10 -0800 (PST), Trent Piepho wrote:
> On Sat, 21 Feb 2009, Jean Delvare wrote:
> > Well, that's basically what Hans has been doing with
> > v4l2-i2c-drv-legacy.h for months now, isn't it? This is the easy part
> > (even though even this wasn't exactly trivial...)
> 
> Last time I looked they didn't do this.  They just allowed an i2c driver to
> provide both an old-style interface and a probe/remove interface (not
> detect, it wasn't around yet).  I think it should be possible for a driver
> to provide a probe/remove/detect interface and work on old kernels with a
> compat layer than translates the old inform methods into the new methods.

Ah, yes, my bad. Now I remember: I tried to extent Hans' code to add
support for the detect() function, but failed. But maybe someone more
familiar with it (either you or Hans) may succeed where I failed.

> > The hard part is when you want to use pure new-style i2c binding (using
> > i2c_new_device() or i2c_new_probed_device()) in the upstream kernel.
> > There is simply no equivalent in pre-2.6.22 kernels. So no matter what
> 
> Yes, that's the part that seems most difficult.  But maybe it doesn't have
> to be such a problem?  If someone writes a new driver and only wants to use
> i2c_new_device() style attachment, then they can just use the existing
> version system to mark it as 2.6.22+ or 2.6.26+ only.  Don't provide
> backward compatibility for the driver and just avoid the problem.  Just
> because some new embedded camera doesn't work on 2.6.18 doesn't mean
> everyone has to lose 2.6.18 support.

You are right in theory, but in practice there are corner cases where
it isn't that easy. The new binding model wasn't created for my own
fun, it was created because it solves problems. For example, before
Hans converted the zoran driver, i2c chips were sometimes misdetected
when one had several different supported adapters in the same system.
This no longer happens after the conversion. So we are left with two
choices:
* Convert the zoran driver and lose support for kernels < 2.6.22.
* Don't convert the zoran driver and live with the bug forever.
I'd rather go with the first option.

Another example: I am converting the ir-kbd-i2c driver to the new-style
binding model at the moment. This driver was using the legacy binding
model in an unusual way: the addresses being probed depended on the
underlying adapter. This is something the detect() callback in the new
binding model doesn't handle. While you can check for the underlying
adapter in the detect() callback, this happens _after_ the addresses
have been probed. So we could do it, however this would mean probing
all possible addresses on all adapters. As you know, excessive probing
can confuse some chips, so this is quite risky. Using the pure
new-style binding model (no detect()) OTOH fits perfectly.

More generally, the point of the new-style model (without detect()) is
to avoid probes as much as possible. This makes module loading less
risky _and_ significantly faster on some models. Restricting these
benefits to new drivers doesn't sound exactly right.

I guess we're back to the key point I was making in the beginning:
backwards compatibility is nice when it comes at a reasonable price.
When you start degrading the design of the upstream code in order to
make backwards compatibility easier or even possible at all,
something's wrong.

> Of course there are the existing drivers like tvaudio and bttv.  In this
> case, regardless of compatibility concerns, maybe switching to entirely
> i2c_new_device() style attachment isn't the right thing to do?  After all,
> if ->detect() should never be used, why is it there and why do sensor
> drivers use it?  Don't the myriad versions of tvcards with their various i2c
> chips attached seemingly at random have a lot in common with motherboards
> and sensor chips?

You are right, the detect() callback is there to be used in some cases,
and I have no problem with it being used for the bttv driver or any
other v4l driver where it makes sense. But it shouldn't be forgotten
that this approach has roughly the same problems as the legacy model
was, which means that it should ideally only be used when the
alternatives do not work.

Thanks,
-- 
Jean Delvare
