Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:47429 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752259Ab1K3XtO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 30 Nov 2011 18:49:14 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Gary Thomas <gary@mlbassoc.com>
Subject: Re: Using MT9P031 digital sensor
Date: Thu, 1 Dec 2011 00:49:20 +0100
Cc: Javier Martinez Canillas <martinez.javier@gmail.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
References: <4EB04001.9050803@mlbassoc.com> <4ED6445A.2070908@mlbassoc.com> <4ED66147.8090109@mlbassoc.com>
In-Reply-To: <4ED66147.8090109@mlbassoc.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201112010049.20499.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Gary,

On Wednesday 30 November 2011 18:00:55 Gary Thomas wrote:
> On 2011-11-30 07:57, Gary Thomas wrote:
> > On 2011-11-30 07:30, Laurent Pinchart wrote:
> >> On Wednesday 30 November 2011 15:13:18 Gary Thomas wrote:

[snip]

> >>> This sort of works(*), but I'm still having issues (at least I can move
> >>> frames!) When I configure the pipeline like this:
> >>> media-ctl -r
> >>> media-ctl -l '"mt9p031 3-005d":0->"OMAP3 ISP CCDC":0[1]'
> >>> media-ctl -l '"OMAP3 ISP CCDC":2->"OMAP3 ISP preview":0[1]'
> >>> media-ctl -l '"OMAP3 ISP preview":1->"OMAP3 ISP resizer":0[1]'
> >>> media-ctl -l '"OMAP3 ISP resizer":1->"OMAP3 ISP resizer output":0[1]'
> >>> media-ctl -f '"mt9p031 3-005d":0[SGRBG12 2592x1944]'
> >>> media-ctl -f '"OMAP3 ISP CCDC":0 [SGRBG12 2592x1944]'
> >>> media-ctl -f '"OMAP3 ISP CCDC":1 [SGRBG10 2592x1944]'
> >>> media-ctl -f '"OMAP3 ISP preview":0 [SGRBG10 2592x1943]'
> >>> media-ctl -f '"OMAP3 ISP resizer":0 [YUYV 2574x1935]'
> >>> media-ctl -f '"OMAP3 ISP resizer":1 [YUYV 660x496]'
> >>> the resulting frames are 666624 bytes each instead of 654720
> >>> 
> >>> When I tried to grab from the previewer, the frames were 9969120
> >>> instead of 9961380
> >>> 
> >>> Any ideas what resolution is actually being moved through?
> >> 
> >> Because the OMAP3 ISP has alignment requirements. Both the preview
> >> engine and the resizer output line lenghts must be multiple of 32
> >> bytes. The driver adds padding at end of lines when the output width
> >> isn't a multiple of 16 pixels.
> > 
> > Any guess which resolution(s) I should change and to what?
> 
> I changed the resizer output to be 672x496 and was able to capture video
> using ffmpeg.
> 
> I don't know what to expect with this sensor (I've never seen it in use
> before), but the image seems to have color balance issues - it's awash in
> a green hue.  It may be the poor lighting in my office...  I did try the 9
> test patterns which I was able to select via
>    # v4l2-ctl -d /dev/v4l-subdev8 --set-ctrl=test_pattern=N
> and these looked OK.  You can see them at
> http://www.mlbassoc.com/misc/mt9p031_images/

Neither the sensor nor the OMAP3 ISP implement automatic white balance. The 
ISP preview engine can be used to modify the white balance, and the statistics 
engine can be used to extract data useful to compute the white balance 
parameters, but linking the two needs to be performed in userspace.

> >> So this means that your original problem comes from the BT656 patches.
> > 
> > Yes, it does look that way. Now that I have something that moves data, I
> > can compare how the ISP is setup between the two versions and come up
> > with a fix.
> 
> This is next on my plate, but it may take a while to figure it out.
> 
> Is there some recent tree which will have this digital (mt9p031) part
> working that also has the BT656 support in it?  I'd like to try that
> rather than spending time figuring out why an older tree isn't working.

No, I haven't had time to create one, sorry. It shouldn't be difficult to 
rebase the BT656 patches on top of the latest OMAP3 ISP and MT9P031 code.

-- 
Regards,

Laurent Pinchart
