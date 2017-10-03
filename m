Return-path: <linux-media-owner@vger.kernel.org>
Received: from pandora.armlinux.org.uk ([78.32.30.218]:58220 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751194AbdJCJG0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 3 Oct 2017 05:06:26 -0400
Date: Tue, 3 Oct 2017 10:06:05 +0100
From: Russell King - ARM Linux <linux@armlinux.org.uk>
To: Steve Longerbeam <slongerbeam@gmail.com>
Cc: Philipp Zabel <p.zabel@pengutronix.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org
Subject: Re: [PATCH RFC] media: staging/imx: fix complete handler
Message-ID: <20171003090604.GI20805@n2100.armlinux.org.uk>
References: <E1dy2zX-0003NB-5J@rmk-PC.armlinux.org.uk>
 <9fccea49-c708-325f-bbce-269eecc6f350@gmail.com>
 <20171001233604.GF20805@n2100.armlinux.org.uk>
 <eef28fbb-5145-e934-3c6c-ba777813c34c@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <eef28fbb-5145-e934-3c6c-ba777813c34c@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Oct 02, 2017 at 05:59:30PM -0700, Steve Longerbeam wrote:
> 
> 
> On 10/01/2017 04:36 PM, Russell King - ARM Linux wrote:
> >On Sun, Oct 01, 2017 at 01:16:53PM -0700, Steve Longerbeam wrote:
> >>Right, imx_media_add_vdev_to_pa() has followed a link to an
> >>entity that imx is not aware of.
> >>
> >>The only effect of this patch (besides allowing the driver to load
> >>with smiapp cameras), is that no controls from the unknown entity
> >>will be inherited to the capture device nodes. That's not a big deal
> >>since the controls presumably can still be accessed from the subdev
> >>node.
> >smiapp is just one example I used to illustrate the problem.  The imx
> >media implementation must not claim subdevs exclusively for itself if
> >it's going to be useful, it has to cater for subdevs existing for
> >other hardware attached to it.
> >
> >As you know, the camera that interests me is my IMX219 camera, and it's
> >regressed with your driver because of your insistence that you have sole
> >ownership over subdevs in the imx media stack
> 
> If by "sole ownership", you mean expecting async registration of subdevs
> and setting up the media graph between them, imx-media will only do that
> if those devices and the connections between them are described in the
> device tree. If they are not, i.e. the subdevs and media pads and links are
> created internally by the driver, then imx-media doesn't interfere with
> that.

By "sole ownership" I mean that _at the moment_ imx-media believes
that it has sole right to make use of all subdevs with the exception
of one external subdev, and expects every subdev to have an imx media
subdev structure associated with it.

That's clearly true, because as soon as a multi-subdev device is
attempted to be connected to imx-media, imx-media falls apart because
it's unable to find its private imx media subdev structure for the
additional subdevs.

> >  - I'm having to carry more
> >and more hacks to workaround things that end up broken.  The imx-media
> >stack needs to start playing better with the needs of others, which it
> >can only do by allowing subdevs to be used by others.
> 
> Well, for example imx-media will chain s_stream until reaches your
> IMX219 driver. It's then up to your driver to pass s_stream to the
> subdevs that it owns.

Of course it is.  It's your responsibility to pass appropriate stuff
down the chain as far as you know how to, which is basically up to
the first external subdev facing imx-media.  What happens beyond there
is up to the external drivers.

> >   One way to
> >achieve that change that results in something that works is the patch
> >that I've posted - and tested.
> 
>  Can you change the error message to be more descriptive, something
> like "any controls for unknown subdev %s will not be inherited\n" and maybe
> convert to a warn. After that I will ack it.

No, that's plainly untrue as I said below:

> >It also results in all controls (which are spread over the IMX219's two
> >subdevs) to be visible via the v4l2 video interface - I have all the
> >controls attached to the pixel array subdev as well as the controls
> >attached to the scaling subdev.

Given that I said this, and I can prove that it does happen, I've no
idea why your reply seemed to totally ignore this paragraph.

So I refuse to add a warning message that is incorrect.

-- 
RMK's Patch system: http://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 8.8Mbps down 630kbps up
According to speedtest.net: 8.21Mbps down 510kbps up
