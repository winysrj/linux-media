Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:39618 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751023AbdCMNR1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 13 Mar 2017 09:17:27 -0400
Date: Mon, 13 Mar 2017 15:16:48 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: Steve Longerbeam <slongerbeam@gmail.com>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        robh+dt@kernel.org, mark.rutland@arm.com, shawnguo@kernel.org,
        kernel@pengutronix.de, fabio.estevam@nxp.com, mchehab@kernel.org,
        hverkuil@xs4all.nl, nick@shmanahar.org, markus.heiser@darmarIT.de,
        laurent.pinchart+renesas@ideasonboard.com, bparrot@ti.com,
        geert@linux-m68k.org, arnd@arndb.de, sudipm.mukherjee@gmail.com,
        minghsiu.tsai@mediatek.com, tiffany.lin@mediatek.com,
        jean-christophe.trotin@st.com, horms+renesas@verge.net.au,
        niklas.soderlund+renesas@ragnatech.se, robert.jarzmik@free.fr,
        songjun.wu@microchip.com, andrew-ct.chen@mediatek.com,
        gregkh@linuxfoundation.org, shuah@kernel.org,
        sakari.ailus@linux.intel.com, pavel@ucw.cz,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: Re: [PATCH v4 29/36] media: imx: mipi-csi2: enable setting and
 getting of frame rates
Message-ID: <20170313131647.GB10701@valkosipuli.retiisi.org.uk>
References: <1487211578-11360-1-git-send-email-steve_longerbeam@mentor.com>
 <1487211578-11360-30-git-send-email-steve_longerbeam@mentor.com>
 <20170220220409.GX16975@valkosipuli.retiisi.org.uk>
 <20170221001332.GS21222@n2100.armlinux.org.uk>
 <25596b21-70de-5e46-f149-f9ce3a86ecb7@gmail.com>
 <1487667023.2331.8.camel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1487667023.2331.8.camel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Philipp,

On Tue, Feb 21, 2017 at 09:50:23AM +0100, Philipp Zabel wrote:
...
> > > Then there's the issue where, if you have this setup:
> > >
> > >  camera --> csi2 receiver --> csi --> capture
> > >
> > > and the "csi" subdev can skip frames, you need to know (a) at the CSI
> > > sink pad what the frame rate is of the source (b) what the desired
> > > source pad frame rate is, so you can configure the frame skipping.
> > > So, does the csi subdev have to walk back through the media graph
> > > looking for the frame rate?  Does the capture device have to walk back
> > > through the media graph looking for some subdev to tell it what the
> > > frame rate is - the capture device certainly can't go straight to the
> > > sensor to get an answer to that question, because that bypasses the
> > > effect of the CSI frame skipping (which will lower the frame rate.)
> > >
> > > IMHO, frame rate is just another format property, just like the
> > > resolution and data format itself, and v4l2 should be treating it no
> > > differently.
> > >
> > 
> > I agree, frame rate, if indicated/specified by both sides of a link,
> > should match. So maybe this should be part of v4l2 link validation.
> > 
> > This might be a good time to propose the following patch.
> 
> I agree with Steve and Russell. I don't see why the (nominal) frame
> interval should be handled differently than resolution, data format, and
> colorspace information. I think it should just be propagated in the same
> way, and there is no reason to have two connected pads set to a
> different interval. That would make implementing the g/s_frame_interval
> subdev calls mandatory.

The vast majority of existing drivers do not implement them nor the user
space expects having to set them. Making that mandatory would break existing
user space.

In addition, that does not belong to link validation either: link validation
should only include static properties of the link that are required for
correct hardware operation. Frame rate is not such property: hardware that
supports the MC interface generally does not recognise such concept (with
the exception of some sensors). Additionally, it is dynamic: the frame rate
can change during streaming, making its validation at streamon time useless.

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
