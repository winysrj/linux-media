Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:36264 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1755616AbdCKNl2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 11 Mar 2017 08:41:28 -0500
Date: Sat, 11 Mar 2017 15:41:19 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Steve Longerbeam <slongerbeam@gmail.com>
Cc: robh+dt@kernel.org, mark.rutland@arm.com, shawnguo@kernel.org,
        kernel@pengutronix.de, fabio.estevam@nxp.com,
        linux@armlinux.org.uk, mchehab@kernel.org, hverkuil@xs4all.nl,
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
Subject: Re: [PATCH v5 18/39] [media] v4l: subdev: Add function to validate
 frame interval
Message-ID: <20170311134119.GO3220@valkosipuli.retiisi.org.uk>
References: <1489121599-23206-1-git-send-email-steve_longerbeam@mentor.com>
 <1489121599-23206-19-git-send-email-steve_longerbeam@mentor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1489121599-23206-19-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Steve,

On Thu, Mar 09, 2017 at 08:52:58PM -0800, Steve Longerbeam wrote:
> If the pads on both sides of a link specify a frame interval, then
> those frame intervals should match. Create the exported function
> v4l2_subdev_link_validate_frame_interval() to verify this. This
> function can be called in a subdevice's media_entity_operations
> or v4l2_subdev_pad_ops link_validate callbacks.
> 
> Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>

If your only goal is to configure frame dropping on a sub-device, I suggest
to implement s_frame_interval() on the pads of that sub-device only. The
frames are then dropped according to the configured frame rates between the
sink and source pads. Say, configuring sink for 1/30 s and source 1/15 would
drop half of the incoming frames.

Considering that supporting specific frame interval on most sub-devices adds
no value or is not the interface through which it the frame rate configured,
I think it is overkill to change the link validation to expect otherwise.

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
