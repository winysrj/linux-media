Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:49291 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751733Ab1KHMdc (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 8 Nov 2011 07:33:32 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Javier Martinez Canillas <martinez.javier@gmail.com>
Subject: Re: Using MT9P031 digital sensor
Date: Tue, 8 Nov 2011 13:33:30 +0100
Cc: Gary Thomas <gary@mlbassoc.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
References: <4EB04001.9050803@mlbassoc.com> <4EB91E7C.4050302@mlbassoc.com> <CAAwP0s0joZbNLDzR-WkwFBgOpyZ+=hvbMROQs+LTTyNCpfccTw@mail.gmail.com>
In-Reply-To: <CAAwP0s0joZbNLDzR-WkwFBgOpyZ+=hvbMROQs+LTTyNCpfccTw@mail.gmail.com>
MIME-Version: 1.0
Message-Id: <201111081333.31121.laurent.pinchart@ideasonboard.com>
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Javier,

On Tuesday 08 November 2011 13:30:08 Javier Martinez Canillas wrote:
> On Tue, Nov 8, 2011 at 1:20 PM, Gary Thomas <gary@mlbassoc.com> wrote:
> > On 2011-11-04 04:37, Laurent Pinchart wrote:
> >> On Tuesday 01 November 2011 19:52:49 Gary Thomas wrote:
> >>> I'm trying to use the MT9P031 digital sensor with the Media Controller
> >>> Framework.  media-ctl tells me that the sensor is set to capture using
> >>> SGRBG12  2592x1944
> >>> 
> >>> Questions:
> >>> * What pixel format in ffmpeg does this correspond to?
> >> 
> >> I don't know if ffmpeg supports Bayer formats. The corresponding fourcc
> >> in V4L2 is BA12.
> > 
> > ffmpeg doesn't seem to support these formats
> > 
> >> If your sensor is hooked up to the OMAP3 ISP, you can then configure the
> >> pipeline to include the preview engine and the resizer, and capture YUV
> >> data at the resizer output.
> > 
> > I am using the OMAP3 ISP, but it's a bit unclear to me how to set up the
> > pipeline
> 
> I'm also using another sensor mtv9034 with OMAP3 ISP, so maybe I can help
> you.
> 
> > using media-ctl (I looked for documentation on this tool, but came up dry
> > - is there any?)
> > 
> > Do you have an example of how to configure this using the OMAP3 ISP?
> 
> This is how I configure the pipeline to connect the CCDC with the
> Previewer and Resizer:

Thanks for the instructions. I would add that you should start with

media-ctl -r

to reset all links to the disabled state. This will make sure the below link 
setup commands start with a consistent device state.

> ./media-ctl -l '"mt9v032 3-005c":0->"OMAP3 ISP CCDC":0[1]'
> ./media-ctl -l '"OMAP3 ISP CCDC":2->"OMAP3 ISP preview":0[1]'
> ./media-ctl -l '"OMAP3 ISP preview":1->"OMAP3 ISP resizer":0[1]'
> ./media-ctl -l '"OMAP3 ISP resizer":1->"OMAP3 ISP resizer output":0[1]'
> ./media-ctl -f '"mt9v032 3-005c":0[SGRBG10 752x480]'
> ./media-ctl -f  '"OMAP3 ISP CCDC":0 [SGRBG10 752x480]'
> ./media-ctl -f  '"OMAP3 ISP CCDC":1 [SGRBG10 752x480]'
> ./media-ctl -f  '"OMAP3 ISP preview":0 [SGRBG10 752x479]'
> ./media-ctl -f  '"OMAP3 ISP resizer":0 [YUYV 734x471]'
> ./media-ctl -f  '"OMAP3 ISP resizer":1 [YUYV 640x480]'
> 
> Hope it helps,

-- 
Regards,

Laurent Pinchart
