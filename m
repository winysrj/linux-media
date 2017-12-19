Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:43956 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751035AbdLSNv6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Dec 2017 08:51:58 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: jacopo mondi <jacopo@jmondi.org>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        magnus.damm@gmail.com, geert@glider.be, mchehab@kernel.org,
        hverkuil@xs4all.nl, linux-renesas-soc@vger.kernel.org,
        linux-media@vger.kernel.org, linux-sh@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 03/10] v4l: platform: Add Renesas CEU driver
Date: Tue, 19 Dec 2017 15:52:08 +0200
Message-ID: <6915240.yOBMs0BCUv@avalon>
In-Reply-To: <20171219132854.rw5mgjylz2uxoewz@valkosipuli.retiisi.org.uk>
References: <1510743363-25798-1-git-send-email-jacopo+renesas@jmondi.org> <1605194.apxP3rZ1bD@avalon> <20171219132854.rw5mgjylz2uxoewz@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On Tuesday, 19 December 2017 15:28:55 EET Sakari Ailus wrote:
> On Tue, Dec 19, 2017 at 03:07:41PM +0200, Laurent Pinchart wrote:
> > On Tuesday, 19 December 2017 13:57:42 EET jacopo mondi wrote:

[snip]

> >> Ok, actually parse_dt() and parse_platform_data() behaves differently.
> >> The former returns error if no subdevices are connected to CEU, the
> >> latter returns 0. That's wrong.
> >> 
> >> I wonder what's the correct behavior here. Other mainline drivers I
> >> looked into (pxa_camera and atmel-isc) behaves differently from each
> >> other, so I guess this is up to each platform to decide.
> > 
> > No, what it means is that we've failed to standardize it, not that it
> > shouldn't be standardized :-)
> > 
> >> Also, the CEU can accept one single input (and I made it clear
> >> in DT bindings documentation saying it accepts a single endpoint,
> >> while I'm parsing all the available ones in driver, I will fix this)
> >> but as it happens on Migo-R, there could be HW hacks to share the input
> >> lines between multiple subdevices. Should I accept it from dts as well?
> >> 
> >> So:
> >> 1) Should we fail to probe if no subdevices are connected?
> > 
> > While the CEU itself would be fully functional without a subdev, in
> > practice it would be of no use. I would thus fail probing.
> > 
> >> 2) Should we accept more than 1 subdevice from dts as it happens right
> >> now for platform data?
> > 
> > We need to support multiple connected devices, as some of the boards
> > require that. What I'm not sure about is whether the multiplexer on the
> > Migo-R board should be modeled as a subdevice. We could in theory connect
> > multiple sensors to the CEU input signals without any multiplexer as long
> > as all but one are in reset with their outputs in a high impedance state.
> > As that wouldn' require a multiplexer we would need to support multiple
> > endpoints in the CEU port. We could then support Migo-R the same way,
> > making the multiplexer transparent.
> > 
> > Sakari, what would you do here ?
> 
> We do have:
> 
> drivers/media/platform/video-mux.c
> 
> What is not addressed right now are the CSI-2 bus parameters, if the mux is
> just a passive switch. This could be done using the frame descriptors.

We're talking about a parallel bus here so that shouldn't be a problem.

Our issue is that the same GPIO controls both the switch and the power down 
signal of one of the sensors. The hardware has been designed to be as 
transparent as possible, but that creates issues as Linux doesn't support 
share GPIOs.

-- 
Regards,

Laurent Pinchart
