Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:59760 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751072AbdBUQP2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 21 Feb 2017 11:15:28 -0500
Date: Tue, 21 Feb 2017 18:15:19 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Russell King - ARM Linux <linux@armlinux.org.uk>
Cc: Steve Longerbeam <slongerbeam@gmail.com>, robh+dt@kernel.org,
        mark.rutland@arm.com, shawnguo@kernel.org, kernel@pengutronix.de,
        fabio.estevam@nxp.com, mchehab@kernel.org, hverkuil@xs4all.nl,
        nick@shmanahar.org, markus.heiser@darmarIT.de,
        p.zabel@pengutronix.de, laurent.pinchart+renesas@ideasonboard.com,
        bparrot@ti.com, geert@linux-m68k.org, arnd@arndb.de,
        sudipm.mukherjee@gmail.com, minghsiu.tsai@mediatek.com,
        tiffany.lin@mediatek.com, jean-christophe.trotin@st.com,
        horms+renesas@verge.net.au, niklas.soderlund+renesas@ragnatech.se,
        robert.jarzmik@free.fr, songjun.wu@microchip.com,
        andrew-ct.chen@mediatek.com, gregkh@linuxfoundation.org,
        shuah@kernel.org, sakari.ailus@linux.intel.com, pavel@ucw.cz,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: Re: [PATCH v4 29/36] media: imx: mipi-csi2: enable setting and
 getting of frame rates
Message-ID: <20170221161518.GM16975@valkosipuli.retiisi.org.uk>
References: <1487211578-11360-1-git-send-email-steve_longerbeam@mentor.com>
 <1487211578-11360-30-git-send-email-steve_longerbeam@mentor.com>
 <20170220220409.GX16975@valkosipuli.retiisi.org.uk>
 <20170221001332.GS21222@n2100.armlinux.org.uk>
 <20170221123756.GI16975@valkosipuli.retiisi.org.uk>
 <20170221132132.GU21222@n2100.armlinux.org.uk>
 <20170221153834.GL16975@valkosipuli.retiisi.org.uk>
 <20170221160332.GW21222@n2100.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170221160332.GW21222@n2100.armlinux.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Feb 21, 2017 at 04:03:32PM +0000, Russell King - ARM Linux wrote:
> On Tue, Feb 21, 2017 at 05:38:34PM +0200, Sakari Ailus wrote:
> > Hi Russell,
> > 
> > On Tue, Feb 21, 2017 at 01:21:32PM +0000, Russell King - ARM Linux wrote:
> > > On Tue, Feb 21, 2017 at 02:37:57PM +0200, Sakari Ailus wrote:
> > > > Hi Russell,
> > > > 
> > > > On Tue, Feb 21, 2017 at 12:13:32AM +0000, Russell King - ARM Linux wrote:
> > > > > On Tue, Feb 21, 2017 at 12:04:10AM +0200, Sakari Ailus wrote:
> > > > > > On Wed, Feb 15, 2017 at 06:19:31PM -0800, Steve Longerbeam wrote:
> > > > > > > From: Russell King <rmk+kernel@armlinux.org.uk>
> > > > > > > 
> > > > > > > Setting and getting frame rates is part of the negotiation mechanism
> > > > > > > between subdevs.  The lack of support means that a frame rate at the
> > > > > > > sensor can't be negotiated through the subdev path.
> > > > > > 
> > > > > > Just wondering --- what do you need this for?
> > > > > 
> > > > > The v4l2 documentation contradicts the media-ctl implementation.
> > > > > 
> > > > > While v4l2 documentation says:
> > > > > 
> > > > >   These ioctls are used to get and set the frame interval at specific
> > > > >   subdev pads in the image pipeline. The frame interval only makes sense
> > > > >   for sub-devices that can control the frame period on their own. This
> > > > >   includes, for instance, image sensors and TV tuners. Sub-devices that
> > > > >   don't support frame intervals must not implement these ioctls.
> > > > > 
> > > > > However, when trying to configure the pipeline using media-ctl, eg:
> > > > > 
> > > > > media-ctl -d /dev/media1 --set-v4l2 '"imx219 pixel 0-0010":0[crop:(0,0)/3264x2464]'
> > > > > media-ctl -d /dev/media1 --set-v4l2 '"imx219 0-0010":1[fmt:SRGGB10/3264x2464@1/30]'
> > > > > media-ctl -d /dev/media1 --set-v4l2 '"imx219 0-0010":0[fmt:SRGGB8/816x616@1/30]'
> > > > > media-ctl -d /dev/media1 --set-v4l2 '"imx6-mipi-csi2":1[fmt:SRGGB8/816x616@1/30]'
> > > > > Unable to setup formats: Inappropriate ioctl for device (25)
> > > > > media-ctl -d /dev/media1 --set-v4l2 '"ipu1_csi0_mux":2[fmt:SRGGB8/816x616@1/30]'
> > > > > media-ctl -d /dev/media1 --set-v4l2 '"ipu1_csi0":2[fmt:SRGGB8/816x616@1/30]'
> > > > > 
> > > > > The problem there is that the format setting for the csi2 does not get
> > > > > propagated forward:
> > > > 
> > > > The CSI-2 receivers typically do not implement frame interval IOCTLs as they
> > > > do not control the frame interval. Some sensors or TV tuners typically do,
> > > > so they implement these IOCTLs.
> > > 
> > > No, TV tuners do not.  The frame rate for a TV tuner is set by the
> > > broadcaster, not by the tuner.  The tuner can't change that frame rate.
> > > The tuner may opt to "skip" fields or frames.  That's no different from
> > > what the CSI block in my example below is capable of doing.
> > > 
> > > Treating a tuner differently from the CSI block is inconsistent and
> > > completely wrong.
> > 
> > I agree tuners in that sense are somewhat similar, and they are not treated
> > differently because they are tuners (and not CSI-2 receivers). Neither can
> > control the frame rate of the incoming video stream.
> > 
> > Conceivably a tuner could implement G_FRAME_INTERVAL IOCTL, but based on a
> > quick glance none appears to. Neither do CSI-2 receivers. Only sensor
> > drivers do currently.
> 
> Please look again.  I am being very careful with "CSI" vs "CSI-2" in my
> emails, you are conflating the two.
> 
> In all my emails so far, "CSI" refers to a block of hardware that is
> responsible for receiving an image stream from some kind of source.  It
> contains hardware that supports frame skipping.

Ah, I missed the difference. Thanks for pointing it out.

Still, that does not change how the skipping would work nor how I proposed
it would be configured from the user space.

> 
> "CSI-2" refers to a different block of hardware that is responsible for
> receiving a serially encoded stream from a MIPI-CSI-2 compliant source
> and providing it to the "CSI" block.
> 
> I would have thought my diagram that I drew would have made it clear that
> they were different blocks of hardware, but I guess in this case, the old
> saying "a picture is worth 1000 words" is simply not true.
> 
> > Images are transmitted as series of lines, with each line ending in a
> > horizontal blanking period, and each frame ending with a similar period of
> 
> I'm sorry, are you seriously teaching me to suck rocks?  I am insulted.
> 
> I've been involved in TV and video for many years, I don't need you to
> tell me how video is transmitted.
> 
> Sorry, you've just lost my interest in further discussion.

There's no need to feel insulted; that certainly was not the intention.

I've proposed you a solution, please comment on that.

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
