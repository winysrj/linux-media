Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-68.nebula.fi ([83.145.220.68]:58069 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751841Ab1LRR74 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 18 Dec 2011 12:59:56 -0500
Date: Sun, 18 Dec 2011 19:59:52 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [Q] video configuration order
Message-ID: <20111218175951.GK3677@valkosipuli.localdomain>
References: <Pine.LNX.4.64.1109162112120.16135@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1109162112120.16135@axis700.grange>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

I remember reading this long time ago but I didn't have anything to add to
it.

On Fri, Sep 16, 2011 at 11:27:35PM +0200, Guennadi Liakhovetski wrote:
> Hi all
> 
> I've been re-thinking (yes, again...) our classical 2-step geometry 
> configuration (let's leave COMPOSE and friends aside for now) per S_FMT 
> and S_CROP, and came to the conclusion, that passing the pixel format with 
> the scaling configuration (S_FMT) is a bad idea.
> 
> Let's take CAPTURE as an example, and let's use the "sensor" terminology, 
> even though the same basically applies to other video data sources.
> 
> Considering just the two geometries - a cropped window on the sensor and 
> an output frame, it is logical to first configure the input, and then the 
> output, because at least on the hardware, where you have to write scaling 
> factors into registers, and not just output sizes, you would have to 
> recalculate those factors, if cropping were to be applied after scaling. 
> In other words, output depends on the input, but not the other way 
> round:-)
> 
> But S_FMT also passes the pixel format with it, and if you change the 
> pixel format, your cropping capabilities might change too. This might not 
> be very obvious for raw sensors, but it is quite possible for various 
> video data processing devices, like resizers, etc.
> 
> Therefore, I think, the best order would be:
> 
> (1) set pixel format (fourcc / mediabus code)
> (2) set crop
> (3) set scale
> 
> I know we cannot change this in V4L2 anymore, so, this might be something 
> for V4L3;-) But what we could do is at least redesign our subdevice APIs 
> to separate the .s_fmt() method into two operations.

Depending on the device, there often are multiple scalers and cropping can
also be done in multiple cases --- e.g. on SMIA sensor and OMAP 3 ISP there
are almost ten different places you can do it, even if the drivers don't
support much of it. Most of the time you can just advertise the resolutions
which are available on all formats and still be safe.

What comes to subdevs, my current proposal on selection ioctl on subdevs
suggests compose rectangle to define the scaling factor on the sink pad. If
it was the source pad, you could differentiate the differing scaling 
functionality to two different pads. This could be considered a hack,
though.

The same RFC suggests source format is set last, which might indeed not
reflect most of the hardware behaves. If the order is changed, e.g. that the
source pixelcode is set after choosing sink dimensions and pixelcode, this
will get messy --- the user still might want to query the source format,
including dimensions and pixelcode. I don't think it should be done.

> Below is the specific example, that brought me to this, it might be 
> helpful for those, wishing to even better understand the sources of this 
> problem, others can skip the rest:-)
> 
> The problem occurred to me, when I was working on the 
> sh_mobile_ceu_camera.c driver. The CEU can scale some pixel formats 
> (several YUV / NV1x formats), and cannot scale others (this actually holds 
> for all bridges), but it can crop anything. As I'm extending soc-camera to 
> work in both "V4L2" and "MC" modes, I want to still be able to configure 
> the sensor behind the CEU from just the classical S_FMT / S_CROP ioctl()s. 
> In this mode I have to decide, where to do the cropping and scaling - on 
> the sensor or on the CEU. One thing I want to avoid, is applying CEU 
> cropping on top of sensor scaling - this gets messy very quickly.
> 
> So, I only consider CEU cropping, when the sensor is not scaling. Given 
> this, if the user has requested one of pixel codes, that the CEU cannot 
> scale (e.g., a Bayer format), and I have configured sensor 1:1 scaling and 
> crop on the CEU, and then the user issues an S_FMT, I now also lose the 
> ability to ask the sensor to scale, because for that I would have to drop 
> the CEU cropping and the resulting cropping rectangle can change _a lot_ 
> as a result of an S_FMT ioctl(), which, as we know, is not something, that 
> the user expects;-) This leads me to the conclusion, that I also should 
> not do CEU cropping for those, not natively supported by the CEU, formats.
> 
> This is where we come to cropping behaviour depending on the pixel format 
> and the need to set that format before cropping and before scaling.

If I understood you correctly, the CEU does both media bus code conversion
and scaling? I don't consider cropping since it isn't affected by format.

Could you consider exposing the CEU as two different subdevs, one which
performrs mbus code conversion, and another which performs cropping and
scaling?

I don't know how that would work with SoC camera but complex functionality
may require more complex pipeline configuration.

Kind regards,

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	jabber/XMPP/Gmail: sailus@retiisi.org.uk
