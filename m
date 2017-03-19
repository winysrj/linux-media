Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay1.mentorg.com ([192.94.38.131]:60339 "EHLO
        relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751369AbdCSN6U (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 19 Mar 2017 09:58:20 -0400
Subject: Re: [PATCH v5 00/39] i.MX Media Driver
To: Russell King - ARM Linux <linux@armlinux.org.uk>,
        Steve Longerbeam <steve_longerbeam@mentor.com>
References: <1489121599-23206-1-git-send-email-steve_longerbeam@mentor.com>
 <20170318192258.GL21222@n2100.armlinux.org.uk>
 <aef6c412-5464-726b-42f6-a24b7323aa9c@mentor.com>
 <20170318204324.GM21222@n2100.armlinux.org.uk>
CC: Steve Longerbeam <slongerbeam@gmail.com>, <robh+dt@kernel.org>,
        <mark.rutland@arm.com>, <shawnguo@kernel.org>,
        <kernel@pengutronix.de>, <fabio.estevam@nxp.com>,
        <mchehab@kernel.org>, <hverkuil@xs4all.nl>, <nick@shmanahar.org>,
        <markus.heiser@darmarIT.de>, <p.zabel@pengutronix.de>,
        <laurent.pinchart+renesas@ideasonboard.com>, <bparrot@ti.com>,
        <geert@linux-m68k.org>, <arnd@arndb.de>,
        <sudipm.mukherjee@gmail.com>, <minghsiu.tsai@mediatek.com>,
        <tiffany.lin@mediatek.com>, <jean-christophe.trotin@st.com>,
        <horms+renesas@verge.net.au>,
        <niklas.soderlund+renesas@ragnatech.se>, <robert.jarzmik@free.fr>,
        <songjun.wu@microchip.com>, <andrew-ct.chen@mediatek.com>,
        <gregkh@linuxfoundation.org>, <shuah@kernel.org>,
        <sakari.ailus@linux.intel.com>, <pavel@ucw.cz>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-media@vger.kernel.org>, <devel@driverdev.osuosl.org>
From: Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com>
Message-ID: <4e7f91fa-e1c4-1cbc-2542-2aaf19a35329@mentor.com>
Date: Sun, 19 Mar 2017 15:57:56 +0200
MIME-Version: 1.0
In-Reply-To: <20170318204324.GM21222@n2100.armlinux.org.uk>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Russell,

On 03/18/2017 10:43 PM, Russell King - ARM Linux wrote:
> On Sat, Mar 18, 2017 at 12:58:27PM -0700, Steve Longerbeam wrote:
>> Can you share your gstreamer pipeline? For now, until
>> VIDIOC_ENUM_FRAMESIZES is implemented, try a pipeline that
>> does not attempt to specify a frame rate. I use the attached
>> script for testing, which works for me.
> 
> It's nothing more than
> 
>   gst-launch-1.0 -v v4l2src ! <any needed conversions> ! xvimagesink
> 
> in my case, the conversions are bayer2rgbneon.  However, this only shows
> you the frame rate negotiated on the pads (which is actually good enough
> to show the issue.)

I'm sorry for potential offtopic, but is bayer2rgbneon element found in
any officially supported by GStreamer plugin? Can it be a point of
failure?

--
With best wishes,
Vladimir
