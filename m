Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:40172 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754052Ab2HMXZz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Aug 2012 19:25:55 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH v2] mt9v032: Export horizontal and vertical blanking as V4L2 controls
Date: Tue, 14 Aug 2012 01:26:07 +0200
Message-ID: <1433360.QycaYFLEyB@avalon>
In-Reply-To: <20120813141805.GP29636@valkosipuli.retiisi.org.uk>
References: <1343068502-7431-4-git-send-email-laurent.pinchart@ideasonboard.com> <1505124.16Oe9aIvIj@avalon> <20120813141805.GP29636@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On Monday 13 August 2012 17:18:20 Sakari Ailus wrote:
> Laurent Pinchart wrote:
> > On Saturday 28 July 2012 00:27:23 Sakari Ailus wrote:
> >> On Fri, Jul 27, 2012 at 01:02:04AM +0200, Laurent Pinchart wrote:
> >>> On Thursday 26 July 2012 23:54:01 Sakari Ailus wrote:
> >>>> On Tue, Jul 24, 2012 at 01:10:42AM +0200, Laurent Pinchart wrote:
> >>>>> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> >>>>> ---
> >>>>> 
> >>>>>   drivers/media/video/mt9v032.c |   36 
> >>>>>   ++++++++++++++++++++++++++++---
> >>>>>   1 files changed, 33 insertions(+), 3 deletions(-)
> >>>>> 
> >>>>> Changes since v1:
> >>>>> 
> >>>>> - Make sure the total horizontal time will not go below 660 when
> >>>>>    setting the horizontal blanking control
> >>>>> 
> >>>>> - Restrict the vertical blanking value to 3000 as documented in the
> >>>>>    datasheet. Increasing the exposure time actually extends vertical
> >>>>>    blanking, as long as the user doesn't forget to turn auto-exposure
> >>>>>    off...
> >>>> 
> >>>> Does binning either horizontally or vertically affect the blanking
> >>>> limits? If the process is analogue then the answer is typically "yes".
> >>> 
> >>> The datasheet doesn't specify whether binning and blanking can influence
> >>> each other.
> >> 
> >> Vertical binning is often analogue since digital binning would require as
> >> much temporary memory as the row holds pixels. This means the hardware
> >> already does binning before a/d conversion and there's only need to
> >> actually read half the number of rows, hence the effect on frame length.
> > 
> > That will affect the frame length, but why would it affect vertical
> > blanking ?
>
> Frame length == image height + vertical blanking.
> 
> The SMIA++ driver (at least) associates the blanking controls to the
> pixel array subdev. They might be more naturally placed to the source
> (either binner or scaler) but the width and height (to calculate the
> frame and line length) are related to the dimensions of the pixel array
> crop rectangle.
> 
> So when the binning configuration changes, that changes the limits for
> blanking and thus possibly also blanking itself.

Do the blanking controls expose blanking after binning or before binning ? In 
the later case I don't see how binning would influence them.

> >>>> It's not directly related to this patch, but the effect of the driver
> >>>> just exposing one sub-device really shows better now. Besides lacking
> >>>> the way to specify binning as in the V4L2 subdev API (compose selection
> >>>> target), the user also can't use the crop bounds selection target to
> >>>> get the size of the pixel array.
> >>>> 
> >>>> We could either accept this for the time being and fix it later on of
> >>>> fix it now.
> >>>> 
> >>>> I prefer fixing it right now but admit that this patch isn't breaking
> >>>> anything, it rather is missing quite relevant functionality to control
> >>>> the sensor in a generic way.
> >>> 
> >>> I'd rather apply this patch first, as it doesn't break anything :-)
> >>> Fixing the problem will require discussions, and that will take time.
> >> 
> >> How so? There's nothing special in this sensor as far as I can see.
> >> 
> >>> Binning/skipping is a pretty common feature in sensors. Exposing two
> >>> sub-devices like the SMIA++ driver does is one way to fix the problem,
> >>> but do we really want to do that for the vast majority of sensors ?
> >> 
> >> If we want to expose the sensor's functionality using the V4L2 subdev API
> >> and not a sensor specific API, the answer is "yes". The bottom line is
> >> that we have just one API to configure scaling and cropping and that API
> >> (selections) is the same independently of where the operation is being
> >> performed; whether it's the sensor or the ISP.
> > 
> > If we want to expose two subdevices for every sensor we will need to get
> > both kernelspace (ISP drivers) and userspace ready for this. I'm not
> > against the idea, but we need to plan it properly.
> 
> I fully agree that this has to be planned properly; e.g. libv4l support for
> controlling low level devices required by this is completely missing right
> now.

-- 
Regards,

Laurent Pinchart

