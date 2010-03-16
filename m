Return-path: <linux-media-owner@vger.kernel.org>
Received: from blu0-omc2-s26.blu0.hotmail.com ([65.55.111.101]:63042 "EHLO
	blu0-omc2-s26.blu0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966003Ab0CPGgl convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Mar 2010 02:36:41 -0400
Message-ID: <BLU198-W28D6F46833CDF4EF68E00B12D0@phx.gbl>
From: John Selbie <jselbie@hotmail.com>
To: <laurent.pinchart@ideasonboard.com>,
	<abu_hurayrah@hidayahonline.org>
CC: <linux-media@vger.kernel.org>
Subject: RE: Capturing raw JPEG stream from webcam
Date: Mon, 15 Mar 2010 23:30:30 -0700
In-Reply-To: <201003152100.06497.laurent.pinchart@ideasonboard.com>
References: <4B9AF0A3.4060701@hidayahonline.org>
 <201003151040.04057.laurent.pinchart@ideasonboard.com>
 <4B9E4DBD.8000502@hidayahonline.org>,<201003152100.06497.laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Hi Basil:

I ran the following command line with my Logitech 5000:
 
gst-launch-0.10 v4l2src device=/dev/video0 ! 'image/jpeg, width=640, height=480, framerate=30/1' ! multifilesink location=frame%.4d.jpg

I let it run for 5 seconds or so and then cancel it.  When done I had a bit more than 150+ frames on disk.  Clearly, I'm getting 30 frames per second.

I ran your command line below and compared with the equivalent command line of luvcview.  The weird thing is that luvcview shows nice smooth video with no blur (jpg was the format).  gst-launch at the same configuration just "seems" like a slower frame rate.  Then I dropped down the frame rate of both gst-launch and luvcview to 15fps.  gst-launch looked more like 7-8 fps.  luvcview looked fine.  Switching gst-launch to YUV was a noticeable improvement.

My guess is jpeg decoding mixed with xvimagesink is the issue.  More debuging.  Switching to YUV or the file renderer produces better results.  More debugging is needed.

Might be better to move this thread of discussion over to the GStreamer list.


> From: laurent.pinchart@ideasonboard.com
> To: abu_hurayrah@hidayahonline.org
> Subject: Re: Capturing raw JPEG stream from webcam
> Date: Mon, 15 Mar 2010 21:00:05 +0100
> CC: linux-media@vger.kernel.org
> 
> Hi Basil,
> 
> On Monday 15 March 2010 16:09:49 Basil Mohamed Gohar wrote:
>> On 03/15/2010 05:40 AM, Laurent Pinchart wrote:
>>> On Saturday 13 March 2010 02:55:47 Basil Mohamed Gohar wrote:
>>>> I originally posted this to the video4linux mailing list, but I've since
>>>> discovered that this is the appropriate place (or so I understand) for
>>>> video4linux questions.  My question is how can I capture the raw JPEG
>>>> image stream (e.g., MJPEG) from my webcam, which reports through v4l2
>>>> that it is capable of.  I am using the gst-launch cli to gstreamer,
>>>> 
>>>> which confirms that my webcam has this capability:
>>>>> image/jpeg, width=(int)640, height=(int)480, framerate=(fraction){
>>>>> 30/1, 25/1, 20/1, 15/1, 10/1, 5/1 }
>>>> 
>>>> And, indeed, I can capture using this capability, but the framerate is
>>>> not at the specified rate, but at a much lower value (half or less).
>>>> So, even if I specify 30fps, I get something less.  I can capture the
>>>> full 30fps when I use one of the yuv modes, though, so it's clearly
>>>> capable of delivering that framerate.
>>>> 
>>>> My webcam is a Logitech QuickCam Pro 5000.  The lsusb output is:
>>>>> 046d:08ce Logitech, Inc. QuickCam Pro 5000
>>>> 
>>>> An example command line I try is as follows:
>>>>> gst-launch-0.10 v4l2src device=/dev/video0 ! 'image/jpeg, width=640,
>>>>> height=480, framerate=30/1' ! jpegdec ! xvimagesink
>>> 
>>> Have you tried disabling auto-exposure ? The camera is allowed to reduce
>>> the frame rate in low-light conditions if auto-exposure is turned on.
>> 
>> Thanks for replying.  I haven't actually tried this yet (I am currently
>> at work), but I do not think this is the issue, because when I choose
>> the YUV-style modes, I can capture at the full framerates.  It's only
>> when I select the image/jpeg mode that I get the lower framerates,
>> despite explicitly requesting the higher ones.
>> 
>> I suppose it's not impossible that the camera is opting for different
>> behavior depending on the mode of the request, but I think that is not
>> likely the case.  I do appreciate the suggestion, though, and I'll try
>> it when I get home.
> 
> It could, but that indeed seems unlikely. The USB descriptors advertise 30fps 
> in MJPEG mode. Unless the information is wrong (in which case this would be a 
> firmware bug), 30fps should be achievable.
> 
>> Meanwhile, does anyone else have any other ideas?
> 
> -- 
> Regards,
> 
> Laurent Pinchart
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
 		 	   		  
_________________________________________________________________
Hotmail® has ever-growing storage! Don’t worry about storage limits.
http://windowslive.com/Tutorial/Hotmail/Storage?ocid=TXT_TAGLM_WL_HM_Tutorial_Storage_062009