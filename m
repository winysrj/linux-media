Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:46720 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751545AbdFGMcG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 7 Jun 2017 08:32:06 -0400
Date: Wed, 7 Jun 2017 15:31:32 +0300
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
Subject: Re: [PATCH v7 16/34] [media] add Omnivision OV5640 sensor driver
Message-ID: <20170607123131.GC1019@valkosipuli.retiisi.org.uk>
References: <1495672189-29164-1-git-send-email-steve_longerbeam@mentor.com>
 <1495672189-29164-17-git-send-email-steve_longerbeam@mentor.com>
 <20170529155511.GI29527@valkosipuli.retiisi.org.uk>
 <c50c3c5f-71cf-fa73-f5a8-a4b5f59a87dc@gmail.com>
 <20170530065632.GK29527@valkosipuli.retiisi.org.uk>
 <ab04379b-d005-1251-343b-5e490ee6e72d@gmail.com>
 <3e953953-7bf4-912f-73f7-db568d5df504@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3e953953-7bf4-912f-73f7-db568d5df504@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Jun 04, 2017 at 11:00:14AM -0700, Steve Longerbeam wrote:
> 
> 
> On 06/03/2017 11:02 AM, Steve Longerbeam wrote:
> >Hi Sakari,
> >
> >
> >On 05/29/2017 11:56 PM, Sakari Ailus wrote:
> >>Hi Steve,
> >>
> >>On Mon, May 29, 2017 at 02:50:34PM -0700, Steve Longerbeam wrote:
> >>>><snip>
> >>>>
> >>>>>+
> >>>>>+static int ov5640_s_ctrl(struct v4l2_ctrl *ctrl)
> >>>>>+{
> >>>>>+    struct v4l2_subdev *sd = ctrl_to_sd(ctrl);
> >>>>>+    struct ov5640_dev *sensor = to_ov5640_dev(sd);
> >>>>>+    int ret = 0;
> >>>>>+
> >>>>>+    mutex_lock(&sensor->lock);
> >>>>Could you use the same lock for the controls as you use for the
> >>>>rest? Just
> >>>>setting handler->lock after handler init does the trick.
> >>>
> >>>Can you please rephrase, I don't follow. "same lock for the controls as
> >>>you use for the rest" - there's only one device lock owned by this
> >>>driver
> >>>and I am already using that same lock.
> >>
> >>There's another in the control handler. You could use your own lock for
> >>the
> >>control handler as well.
> >
> >I still don't understand.
> >
> 
> Hi Sakari, sorry I see what you are referring to now. The lock
> in 'struct v4l2_ctrl_handler' can be overridden by a caller's own
> lock. Yes that's a good idea, I'll do that.

Ack, good! :-)

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
