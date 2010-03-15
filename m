Return-path: <linux-media-owner@vger.kernel.org>
Received: from blu0-omc2-s29.blu0.hotmail.com ([65.55.111.104]:22328 "EHLO
	blu0-omc2-s29.blu0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932356Ab0COW4V convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Mar 2010 18:56:21 -0400
Message-ID: <BLU198-W1965C0C4B67FB6E4D9E8FB12E0@phx.gbl>
From: John Selbie <jselbie@hotmail.com>
To: <laurent.pinchart@ideasonboard.com>,
	<abu_hurayrah@hidayahonline.org>
CC: <linux-media@vger.kernel.org>
Subject: RE: Capturing raw JPEG stream from webcam
Date: Mon, 15 Mar 2010 15:56:20 -0700
In-Reply-To: <201003152100.06497.laurent.pinchart@ideasonboard.com>
References: <4B9AF0A3.4060701@hidayahonline.org>
 <201003151040.04057.laurent.pinchart@ideasonboard.com>
 <4B9E4DBD.8000502@hidayahonline.org>,<201003152100.06497.laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Message bounced the first time because I had HTML on.  Here it is again.
 
I have the same camera (Logi 5000). There's an ordering issue of ioctl
calls that you have to make to get the frame rate set properly. But I'm
away from my home computer and code, so I can't quote the solution to
you yet. I can't speak about gst-launch, but I do I recall fixing
this exact bug in my own code.

I figured out the frame rate issue by examing the code to luvcview.
That sample app can capture jpegs at 640x480x30fps no problem.

I'll post sample code to you later tonight.


----------------------------------------
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
>>>> video4linux questions. My question is how can I capture the raw JPEG
>>>> image stream (e.g., MJPEG) from my webcam, which reports through v4l2
>>>> that it is capable of. I am using the gst-launch cli to gstreamer,
>>>>
>>>> which confirms that my webcam has this capability:
>>>>> image/jpeg, width=(int)640, height=(int)480, framerate=(fraction){
>>>>> 30/1, 25/1, 20/1, 15/1, 10/1, 5/1 }
>>>>
>>>> And, indeed, I can capture using this capability, but the framerate is
>>>> not at the specified rate, but at a much lower value (half or less).
>>>> So, even if I specify 30fps, I get something less. I can capture the
>>>> full 30fps when I use one of the yuv modes, though, so it's clearly
>>>> capable of delivering that framerate.
>>>>
>>>> My webcam is a Logitech QuickCam Pro 5000. The lsusb output is:
>>>>> 046d:08ce Logitech, Inc. QuickCam Pro 5000
>>>>
>>>> An example command line I try is as follows:
>>>>> gst-launch-0.10 v4l2src device=/dev/video0 ! 'image/jpeg, width=640,
>>>>> height=480, framerate=30/1' ! jpegdec ! xvimagesink
>>>
>>> Have you tried disabling auto-exposure ? The camera is allowed to reduce
>>> the frame rate in low-light conditions if auto-exposure is turned on.
>>
>> Thanks for replying. I haven't actually tried this yet (I am currently
>> at work), but I do not think this is the issue, because when I choose
>> the YUV-style modes, I can capture at the full framerates. It's only
>> when I select the image/jpeg mode that I get the lower framerates,
>> despite explicitly requesting the higher ones.
>>
>> I suppose it's not impossible that the camera is opting for different
>> behavior depending on the mode of the request, but I think that is not
>> likely the case. I do appreciate the suggestion, though, and I'll try
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
> More majordomo info at http://vger.kernel.org/majordomo-info.html 		 	   		  
_________________________________________________________________
Lauren found her dream laptop. Find the PC that’s right for you.
http://www.microsoft.com/windows/choosepc/?ocid=ftp_val_wl_290