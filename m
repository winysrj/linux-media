Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:57231 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751471Ab2AFMea (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 6 Jan 2012 07:34:30 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: James <angweiyang@gmail.com>
Subject: Re: Using OMAP3 ISP live display and snapshot sample applications
Date: Fri, 6 Jan 2012 13:34:49 +0100
Cc: linux-media@vger.kernel.org
References: <CAOy7-nNSu2v9VS9Bh5O5StvEAvoxA4DqN7KdSGfZZSje1_Fgnw@mail.gmail.com> <201201031217.20473.laurent.pinchart@ideasonboard.com> <CAOy7-nNH7ffkvi42=Zccx==SwwZJHPh9bw5gEBhbPqb+vRMt-Q@mail.gmail.com>
In-Reply-To: <CAOy7-nNH7ffkvi42=Zccx==SwwZJHPh9bw5gEBhbPqb+vRMt-Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201201061334.49420.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi James,

On Wednesday 04 January 2012 08:07:23 James wrote:
> On Tue, Jan 3, 2012 at 7:17 PM, Laurent Pinchart wrote:
> > On Tuesday 03 January 2012 10:40:10 James wrote:
> >> Hi Laurent,
> >> 
> >> Happy New Year!!
> > 
> > Thank you. Happy New Year to you as well. May 2012 bring you a workable
> > OMAP3 ISP solution ;-)
> 
> Yeah! that's on #1 of my 2012 wishlist!! (^^)
> 
> But, it start off with a disappointment on the quest to get
> "gst-launch v4l2src" to work..
> http://patches.openembedded.org/patch/8895/
> 
> Saw reported success in get v4l2src to work with MT9V032 by applying
> the hack but no luck with my Y12 monochrome sensor. (-.-)"
> 
> >> I saw that there is a simple viewfinder in your repo for OMAP3 and
> >> wish to know more about it.
> >> 
> >> http://git.ideasonboard.org/?p=omap3-isp-live.git;a=summary
> >> 
> >> I intend to test it with my 12-bit (Y12) monochrome camera sensor
> >> driver, running on top of Gumstix's (Steve v3.0) kernel.
> >> 
> >> Is it workable at the moment?
> > 
> > The application is usable but supports raw Bayer sensors only at the
> > moment. It requires a frame buffer and an omap_vout device (both should
> > be located automatically) and configures the OMAP3 ISP pipeline
> > automatically to produce the display resolution.
> 
> Will there be a need to patch for Y12 support or workable out-of-the-box?

It will work out of the box when someone implements support for Y12 :-)

> Likely your previous notes, I know that 12-bit Y12 to the screen is an
> overkill but will it be able to capture Y12 from CCDC output and then
> output to the screen?
> 
> Y12 sensor-> CCDC -> CCDC output -> screen

The omap_vout driver supports V4L2_PIX_FMT_RGB565, V4L2_PIX_FMT_RGB32, 
V4L2_PIX_FMT_RGB24, V4L2_PIX_FMT_YUYV and V4L2_PIX_FMT_UYVY only. To display 
Y12 data you will need to convert them to 10 bits in the CCDC (that's already 
implemented) and then to YUYV in the preview engine (that's not implemented 
yet).

> I've one board connected to a LCD monitor via a DVI chip using GS's
> Tobi board as reference and another via 4.3" LG LCD Touchscreen using
> GS's Chestnut board as reference.
> 
> Many thanks in adv

-- 
Regards,

Laurent Pinchart
