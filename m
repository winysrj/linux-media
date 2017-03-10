Return-path: <linux-media-owner@vger.kernel.org>
Received: from pandora.armlinux.org.uk ([78.32.30.218]:34144 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935124AbdCJJeu (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 10 Mar 2017 04:34:50 -0500
Date: Fri, 10 Mar 2017 09:33:38 +0000
From: Russell King - ARM Linux <linux@armlinux.org.uk>
To: Steve Longerbeam <slongerbeam@gmail.com>
Cc: Sakari Ailus <sakari.ailus@iki.fi>, mark.rutland@arm.com,
        andrew-ct.chen@mediatek.com, minghsiu.tsai@mediatek.com,
        sakari.ailus@linux.intel.com, nick@shmanahar.org,
        songjun.wu@microchip.com, hverkuil@xs4all.nl,
        Steve Longerbeam <steve_longerbeam@mentor.com>, pavel@ucw.cz,
        robert.jarzmik@free.fr, devel@driverdev.osuosl.org,
        markus.heiser@darmarIT.de,
        laurent.pinchart+renesas@ideasonboard.com, shuah@kernel.org,
        geert@linux-m68k.org, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org, kernel@pengutronix.de, arnd@arndb.de,
        mchehab@kernel.org, bparrot@ti.com, robh+dt@kernel.org,
        horms+renesas@verge.net.au, tiffany.lin@mediatek.com,
        linux-arm-kernel@lists.infradead.org,
        niklas.soderlund+renesas@ragnatech.se, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, jean-christophe.trotin@st.com,
        p.zabel@pengutronix.de, fabio.estevam@nxp.com, shawnguo@kernel.org,
        sudipm.mukherjee@gmail.com
Subject: Re: [PATCH v4 13/36] [media] v4l2: add a frame timeout event
Message-ID: <20170310093338.GP21222@n2100.armlinux.org.uk>
References: <1487211578-11360-1-git-send-email-steve_longerbeam@mentor.com>
 <1487211578-11360-14-git-send-email-steve_longerbeam@mentor.com>
 <20170302155342.GJ3220@valkosipuli.retiisi.org.uk>
 <4b2bcee1-8da0-776e-4455-8d8e7a7abf0a@gmail.com>
 <20170303114506.GM3220@valkosipuli.retiisi.org.uk>
 <59663ea1-b277-1543-e770-6a102ac733a4@gmail.com>
 <20170304105600.GS3220@valkosipuli.retiisi.org.uk>
 <03c9b05c-d3ba-c890-f9fa-ad5e1a49430c@gmail.com>
 <20170305224114.GV21222@n2100.armlinux.org.uk>
 <b739319b-61d7-3d9d-a64f-7650ab5cd4b0@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b739319b-61d7-3d9d-a64f-7650ab5cd4b0@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Mar 09, 2017 at 06:38:18PM -0800, Steve Longerbeam wrote:
> On 03/05/2017 02:41 PM, Russell King - ARM Linux wrote:
> >I'm not sure that statement is entirely accurate.  With the IMX219
> >camera, I _could_ (with previous iterations of the iMX capture code)
> >stop it streaming, wait a while, and restart it, and everything
> >continues to work.
> 
> Hi Russell, did you see the "EOF timeout" kernel error message when you
> stopped the IMX219 from streaming? Only a "EOF timeout" message
> indicates the unrecoverable case.

I really couldn't tell you anymore - I can't go back and test at all,
because:

(a) your v4 patch set never worked for me
(b) I've now moved forward to v4.11-rc1, which conflicts with your v4
    and older patch sets.

In any case, I'm in complete disagreement with many of the points that
Sakari has been bringing up, and I'm finding the direction that things
are progressing to be abhorrent.

I've discussed with Mauro about (eg) the application interface, and
unsurprisingly to me, Mauro immediately said about control inheritence
to the main v4l2 device, contradicting what Sakari has been saying.
The subdev API is supposed to be there to allow for finer control, it's
not a "one or the other" thing.  The controls are still supposed to be
exposed through the main v4l2 subdev device.

Since the v4l2 stuff is becoming abhorrent, and I've also come to
realise that I'm going to have to write an entirely new userspace
application to capture, debayer and encode efficiently, I'm finding
that I've little motivation to take much of a further interest in
iMX6 capture, or indeed continue my reverse engineering efforts of
the IMX219 sensor.

-- 
RMK's Patch system: http://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line: currently at 9.6Mbps down 400kbps up
according to speedtest.net.
