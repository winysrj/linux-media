Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:47068 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1754562AbeASLTV (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 19 Jan 2018 06:19:21 -0500
Date: Fri, 19 Jan 2018 13:19:18 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>,
        laurent.pinchart@ideasonboard.com, magnus.damm@gmail.com,
        geert@glider.be, mchehab@kernel.org, festevam@gmail.com,
        robh+dt@kernel.org, mark.rutland@arm.com, pombredanne@nexb.com,
        linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org,
        linux-sh@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 6/9] media: i2c: ov772x: Remove soc_camera dependencies
Message-ID: <20180119111917.76wosrokgracbdrz@valkosipuli.retiisi.org.uk>
References: <1516139101-7835-1-git-send-email-jacopo+renesas@jmondi.org>
 <1516139101-7835-7-git-send-email-jacopo+renesas@jmondi.org>
 <d67c21e5-2488-977b-39d8-561048409209@xs4all.nl>
 <00f1dd19-6420-26ab-0529-a97f2b0de682@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <00f1dd19-6420-26ab-0529-a97f2b0de682@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Fri, Jan 19, 2018 at 11:47:33AM +0100, Hans Verkuil wrote:
> On 01/19/18 11:24, Hans Verkuil wrote:
> > On 01/16/18 22:44, Jacopo Mondi wrote:
> >> Remove soc_camera framework dependencies from ov772x sensor driver.
> >> - Handle clock and gpios
> >> - Register async subdevice
> >> - Remove soc_camera specific g/s_mbus_config operations
> >> - Change image format colorspace from JPEG to SRGB as the two use the
> >>   same colorspace information but JPEG makes assumptions on color
> >>   components quantization that do not apply to the sensor
> >> - Remove sizes crop from get_selection as driver can't scale
> >> - Add kernel doc to driver interface header file
> >> - Adjust build system
> >>
> >> This commit does not remove the original soc_camera based driver as long
> >> as other platforms depends on soc_camera-based CEU driver.
> >>
> >> Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
> >> Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > 
> > Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
> 
> Un-acked.
> 
> I just noticed that this sensor driver has no enum_frame_interval and
> g/s_parm support. How would a driver ever know the frame rate of the
> sensor without that?

s/_parm/_frame_interval/ ?

We should have wrappers for this or rather to convert g/s_parm users to
g/s_frame_interval so drivers don't need to implement both.

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
