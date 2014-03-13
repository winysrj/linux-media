Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:40530 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754129AbaCMRBg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 13 Mar 2014 13:01:36 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: will@williammanley.net
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH] uvcvideo: Work around buggy Logitech C920 firmware
Date: Thu, 13 Mar 2014 18:03:15 +0100
Message-ID: <1832254.8GCCJyof1H@avalon>
In-Reply-To: <1394707700.15658.93976573.78252B46@webmail.messagingengine.com>
References: <1394647711-25291-1-git-send-email-will@williammanley.net> <1854099.LO0jorujWf@avalon> <1394707700.15658.93976573.78252B46@webmail.messagingengine.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Will,

On Thursday 13 March 2014 10:48:20 Will Manley wrote:
> On Thu, 13 Mar 2014, at 10:23, Laurent Pinchart wrote:
> > First of all, could you please CC me in the future for uvcvideo patches ?
> 
> Will do.

Thank you.

> > On Wednesday 12 March 2014 18:08:31 William Manley wrote:
> > > The uvcvideo webcam driver exposes the v4l2 control "Exposure
> > > (Absolute)" which allows the user to control the exposure time of the
> > > webcam, essentially controlling the brightness of the received image. 
> > > By default the webcam automatically adjusts the exposure time
> > > automatically but the if you set the control "Exposure, Auto"="Manual
> > > Mode" the user can fix the exposure time.
> > > 
> > > Unfortunately it seems that the Logitech C920 has a firmware bug where
> > > it will forget that it's in manual mode temporarily during
> > > initialisation. This means that the camera doesn't respect the exposure
> > > time that the user requested if they request it before starting to
> > > stream video. They end up with a video stream which is either too bright
> > > or too dark and must reset the controls after video starts streaming.
> > 
> > I've asked Logitech whether they can confirm this is a known issue. I'm
> > not sure when I'll have a reply though.
> 
> Great :)
> 
> > > This patch works around this camera bug by re-uploading the cached
> > > controls to the camera immediately after initialising the camera.
> > 
> > I'm a bit concerned about this. As you noticed UVC camera are often buggy,
> > and small changes in the driver can fix problems with one model and break
> > others. Sending a bunch of SET_CUR requests at once right after starting
> > the stream is something that has the potential to crash firmwares (yes,
> > they can be that fragile, unfortunately).
> 
> Good point.  I can add a quirk such that it only happens with the C920.
> 
> > I would like to get a better understanding of the problem first. As I
> > don't have a C920, could you please perform two tests for me ?
> > 
> > I would first like to know what the camera reports as its exposure time
> > after starting the stream. If you get the exposure time at that point (by
> > sending a GET_CUR request, bypassing the driver cache), do you get the
> > value you had previously set (which, from your explanation, would be
> > incorrect, as the exposure time has changed based on your findings), or a
> > different value ? Does the camera change the exposure priority control
> > autonomously as well, or just the exposure time ?
> 
> It's a bit of a strange behaviour. I'd already tried littering the code with
> (uncached) GET_CUR requests. It seems that the value changes sometime during
> the call to usb_set_interface in uvc_init_video.

I'll assume this means that the camera reports the updated exposure time in 
response to the GET_CUR request. Does the value of other controls (such as the 
exposure priority control for instance) change as well ?

> Strangely enough though calling uvc_ctrl_restore_values immediately after
> uvc_init_video has no effect. It must be put after the usb_submit_urb loop
> to fix the problem.
> 
> > Then, I would like to know whether the camera sends a control update
> > event when you start the stream, or if it just changes the exposure time
> > without notifying the driver.
> 
> Wireshark tells me that it is sending a control update event, but it seems
> like uvcvideo ignores it. I had to add the flag UVC_CTRL_FLAG_AUTO_UPDATE to
> the uvc_control_info entry for "Exposure (Auto)" for the new value to be
> properly reported to userspace.

Could you send me the USB trace ?

-- 
Regards,

Laurent Pinchart

