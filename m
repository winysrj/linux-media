Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail3.sea5.speakeasy.net ([69.17.117.5]:44444 "EHLO
	mail3.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752650AbZBUN6O (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 21 Feb 2009 08:58:14 -0500
Date: Sat, 21 Feb 2009 05:58:10 -0800 (PST)
From: Trent Piepho <xyzzy@speakeasy.org>
To: Jean Delvare <khali@linux-fr.org>
cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Subject: Re: Minimum kernel version supported by v4l-dvb
In-Reply-To: <20090221141130.1c4f1265@hyperion.delvare>
Message-ID: <Pine.LNX.4.58.0902210533480.24268@shell2.speakeasy.net>
References: <43235.62.70.2.252.1234947353.squirrel@webmail.xs4all.nl>
 <20090218140105.17c86bcb@hyperion.delvare> <20090220212327.410a298b@pedra.chehab.org>
 <200902210212.53245.hverkuil@xs4all.nl> <20090220231350.5467116a@pedra.chehab.org>
 <Pine.LNX.4.58.0902210343520.24268@shell2.speakeasy.net>
 <20090221141130.1c4f1265@hyperion.delvare>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 21 Feb 2009, Jean Delvare wrote:
> On Sat, 21 Feb 2009 04:06:53 -0800 (PST), Trent Piepho wrote:
> > The new i2c driver interface also supports a ->detect() method and a list
> > of address_data to use it with.  This is much more like the legacy model
> > than using i2c_new_probed_device().
>
> Correct.
>
> > I think a compatability layer than implements attach_adapter,
> > detach_adapter, and detach_client using a new-style driver's detect, probe,
> > remove, and address_data should not be that hard.
>
> Well, that's basically what Hans has been doing with
> v4l2-i2c-drv-legacy.h for months now, isn't it? This is the easy part
> (even though even this wasn't exactly trivial...)

Last time I looked they didn't do this.  They just allowed an i2c driver to
provide both an old-style interface and a probe/remove interface (not
detect, it wasn't around yet).  I think it should be possible for a driver
to provide a probe/remove/detect interface and work on old kernels with a
compat layer than translates the old inform methods into the new methods.


> The hard part is when you want to use pure new-style i2c binding (using
> i2c_new_device() or i2c_new_probed_device()) in the upstream kernel.
> There is simply no equivalent in pre-2.6.22 kernels. So no matter what

Yes, that's the part that seems most difficult.  But maybe it doesn't have
to be such a problem?  If someone writes a new driver and only wants to use
i2c_new_device() style attachment, then they can just use the existing
version system to mark it as 2.6.22+ or 2.6.26+ only.  Don't provide
backward compatibility for the driver and just avoid the problem.  Just
because some new embedded camera doesn't work on 2.6.18 doesn't mean
everyone has to lose 2.6.18 support.

Of course there are the existing drivers like tvaudio and bttv.  In this
case, regardless of compatibility concerns, maybe switching to entirely
i2c_new_device() style attachment isn't the right thing to do?  After all,
if ->detect() should never be used, why is it there and why do sensor
drivers use it?  Don't the myriad versions of tvcards with their various i2c
chips attached seemingly at random have a lot in common with motherboards
and sensor chips?
