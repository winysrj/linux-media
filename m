Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:54921 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030228Ab2CWTBk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Mar 2012 15:01:40 -0400
Received: by wibhq7 with SMTP id hq7so2359084wib.1
        for <linux-media@vger.kernel.org>; Fri, 23 Mar 2012 12:01:39 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 23 Mar 2012 13:01:38 -0600
Message-ID: <CAGD8Z75ELkV6wJOfuCFU3Z2dS=z5WbV-7izazaG7SVtfPMcn=A@mail.gmail.com>
Subject: Re: Using MT9P031 digital sensor
From: Joshua Hintze <joshua.hintze@gmail.com>
To: laurent.pinchart@ideasonboard.com, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Sorry to bring up this old message list. I was curious when you spoke
about the ISP preview engine being able to adjust the white balance.

When I enumerate the previewer's available controls all I see is...

root@overo:~# ./yavta -l /dev/v4l-subdev3
--- User Controls (class 0x00980001) ---
control 0x00980900 `Brightness' min 0 max 255 step 1 default 0 current 0.
control 0x00980901 `Contrast' min 0 max 255 step 1 default 16 current 16.
2 controls found.


Is this what you are referring to? Are there other settings I can
adjust to get the white balance and focus better using the  OMAP3 ISP
AWEB/OMAP3 ISP AF?

Thanks,

Josh




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
--
To unsubscribe from this list: send the line "unsubscribe linux-media" in
the body of a message to majord...@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
