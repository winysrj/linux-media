Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay6-d.mail.gandi.net ([217.70.183.198]:54227 "EHLO
        relay6-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750876AbeAUJb0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 21 Jan 2018 04:31:26 -0500
Date: Sun, 21 Jan 2018 10:31:17 +0100
From: jacopo mondi <jacopo@jmondi.org>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Sakari Ailus <sakari.ailus@iki.fi>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        magnus.damm@gmail.com, geert@glider.be, mchehab@kernel.org,
        festevam@gmail.com, robh+dt@kernel.org, mark.rutland@arm.com,
        pombredanne@nexb.com, linux-renesas-soc@vger.kernel.org,
        linux-media@vger.kernel.org, linux-sh@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 6/9] media: i2c: ov772x: Remove soc_camera dependencies
Message-ID: <20180121093117.GK24926@w540>
References: <1516139101-7835-1-git-send-email-jacopo+renesas@jmondi.org>
 <00f1dd19-6420-26ab-0529-a97f2b0de682@xs4all.nl>
 <20180119111917.76wosrokgracbdrz@valkosipuli.retiisi.org.uk>
 <2694661.NEH0HeGgLD@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <2694661.NEH0HeGgLD@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Hans, Laurent, Sakari,

On Fri, Jan 19, 2018 at 02:23:21PM +0200, Laurent Pinchart wrote:
> Hello,
>
> On Friday, 19 January 2018 13:19:18 EET Sakari Ailus wrote:
> > On Fri, Jan 19, 2018 at 11:47:33AM +0100, Hans Verkuil wrote:
> > > On 01/19/18 11:24, Hans Verkuil wrote:
> > >> On 01/16/18 22:44, Jacopo Mondi wrote:
> > >>> Remove soc_camera framework dependencies from ov772x sensor driver.
> > >>> - Handle clock and gpios
> > >>> - Register async subdevice
> > >>> - Remove soc_camera specific g/s_mbus_config operations
> > >>> - Change image format colorspace from JPEG to SRGB as the two use the
> > >>>   same colorspace information but JPEG makes assumptions on color
> > >>>   components quantization that do not apply to the sensor
> > >>> - Remove sizes crop from get_selection as driver can't scale
> > >>> - Add kernel doc to driver interface header file
> > >>> - Adjust build system
> > >>>
> > >>> This commit does not remove the original soc_camera based driver as
> > >>> long as other platforms depends on soc_camera-based CEU driver.
> > >>>
> > >>> Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
> > >>> Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > >>
> > >> Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
> > >
> > > Un-acked.
> > >
> > > I just noticed that this sensor driver has no enum_frame_interval and
> > > g/s_parm support. How would a driver ever know the frame rate of the
> > > sensor without that?

Does it make any difference if I point out that this series hasn't
removed any of that code, and the driver was not supporting that
already? Or was it handled through soc_camera?

> >
> > s/_parm/_frame_interval/ ?
> >
> > We should have wrappers for this or rather to convert g/s_parm users to
> > g/s_frame_interval so drivers don't need to implement both.
>
> There are two ways to set the frame interval, either explicitly through the
> s_frame_interval operation, or implicitly through control of the pixel clock,
> horizontal blanking and vertical blanking (which in turn can be influenced by
> the exposure time).
>
> Having two ways to perform the same operation seems sub-optimal to me, but I
> could understand if they covered different use cases. As far as I know we
> don't document the use cases for those methods. What's your opinion on that ?
>

-If- I have to implement that in this series to have it accepted,
please let me know which one of the two is the preferred one :)

Thanks
   j


> --
> Regards,
>
> Laurent Pinchart
>
