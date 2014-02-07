Return-path: <linux-media-owner@vger.kernel.org>
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:57938 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752413AbaBGS72 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 7 Feb 2014 13:59:28 -0500
Date: Fri, 7 Feb 2014 18:59:11 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Jean-Francois Moine <moinejf@free.fr>
Cc: devel@driverdev.osuosl.org, alsa-devel@alsa-project.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	dri-devel@lists.freedesktop.org, Takashi Iwai <tiwai@suse.de>,
	Sascha Hauer <kernel@pengutronix.de>,
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
	Daniel Vetter <daniel@ffwll.ch>
Subject: Re: [PATCH RFC 0/2] drivers/base: simplify simple DT-based
	components
Message-ID: <20140207185911.GG26684@n2100.arm.linux.org.uk>
References: <cover.1391793068.git.moinejf@free.fr> <20140207173326.GD26684@n2100.arm.linux.org.uk> <20140207194204.4d4326bd@armhf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140207194204.4d4326bd@armhf>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Feb 07, 2014 at 07:42:04PM +0100, Jean-Francois Moine wrote:
> On Fri, 7 Feb 2014 17:33:26 +0000
> Russell King - ARM Linux <linux@arm.linux.org.uk> wrote:
> 
> > On Fri, Feb 07, 2014 at 06:11:08PM +0100, Jean-Francois Moine wrote:
> > > This patch series tries to simplify the code of simple devices in case
> > > they are part of componentised subsystems, are declared in a DT, and
> > > are not using the component bin/unbind functions.
> > 
> > I wonder - I said earlier today that this works absolutely fine without
> > modification with DT, so why are you messing about with it adding DT
> > support?
> > 
> > This is totally the wrong approach.  The idea is that this deals with
> > /devices/ and /devices/ only.  It groups up /devices/.
> > 
> > It's up to the add_component callback to the master device to decide
> > how to deal with that.
> > 
> > > Jean-Francois Moine (2):
> > >   drivers/base: permit base components to omit the bind/unbind ops
> > 
> > And this patch has me wondering if you even understand how to use
> > this...  The master bind/unbind callbacks are the ones which establish
> > the "card" based context with the subsystem.
> > 
> > Please, before buggering up this nicely designed implementation, please
> > /first/ look at the imx-drm rework which was posted back in early January
> > which illustrates how this is used in a DT context - which is something
> > I've already pointed you at once today already.
> 
> As I told in a previous mail, your code works fine in my DT-based
> Cubox. I am rewriting the TDA988x as a normal encoder/connector, and,
> yes, the bind/unbind functions are useful in this case.

So, which bit of "I've already got that" was missed?

> But you opened a door. In a DT context, you know that the probe_defer
> mechanism does not work correctly. Your work permits to solve delicate
> cases: your component_add tells exactly when a device is available, and
> the master bind callback is the green signal for the device waiting for
> its resources. Indeed, your system was not created for such a usage,
> but it works as it is (anyway, the component bind/unbind functions may
> be empty...).

Sorry.  Deferred probe does work, it's been tested with imx-drm, not
only from the master component but also the sub-components.  There's
no problem here.

And no component bind/unbind function should ever be empty.

Again, I put it to you that you don't understand this layer.

-- 
FTTC broadband for 0.8mile line: 5.8Mbps down 500kbps up.  Estimation
in database were 13.1 to 19Mbit for a good line, about 7.5+ for a bad.
Estimate before purchase was "up to 13.2Mbit".
