Return-path: <linux-media-owner@vger.kernel.org>
Received: from hidayahonline.org ([67.19.146.138]:44671 "EHLO
	mail.hidayahonline.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965070Ab0COPJy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Mar 2010 11:09:54 -0400
Message-ID: <4B9E4DBD.8000502@hidayahonline.org>
Date: Mon, 15 Mar 2010 11:09:49 -0400
From: Basil Mohamed Gohar <abu_hurayrah@hidayahonline.org>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: Capturing raw JPEG stream from webcam
References: <4B9AF0A3.4060701@hidayahonline.org> <201003151040.04057.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201003151040.04057.laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/15/2010 05:40 AM, Laurent Pinchart wrote:
> Hi Basil,
>   
Hi Laurent!
> On Saturday 13 March 2010 02:55:47 Basil Mohamed Gohar wrote:
>   
>> I originally posted this to the video4linux mailing list, but I've since
>> discovered that this is the appropriate place (or so I understand) for
>> video4linux questions.  My question is how can I capture the raw JPEG
>> image stream (e.g., MJPEG) from my webcam, which reports through v4l2
>> that it is capable of.  I am using the gst-launch cli to gstreamer,
>>
>> which confirms that my webcam has this capability:
>>     
>>> image/jpeg, width=(int)640, height=(int)480, framerate=(fraction){
>>> 30/1, 25/1, 20/1, 15/1, 10/1, 5/1 }
>>>       
>> And, indeed, I can capture using this capability, but the framerate is
>> not at the specified rate, but at a much lower value (half or less).
>> So, even if I specify 30fps, I get something less.  I can capture the
>> full 30fps when I use one of the yuv modes, though, so it's clearly
>> capable of delivering that framerate.
>>
>> My webcam is a Logitech QuickCam Pro 5000.  The lsusb output is:
>>     
>>> 046d:08ce Logitech, Inc. QuickCam Pro 5000
>>>       
>> An example command line I try is as follows:
>>     
>>> gst-launch-0.10 v4l2src device=/dev/video0 ! 'image/jpeg, width=640,
>>> height=480, framerate=30/1' ! jpegdec ! xvimagesink
>>>       
> Have you tried disabling auto-exposure ? The camera is allowed to reduce the 
> frame rate in low-light conditions if auto-exposure is turned on.
>
>   
Thanks for replying.  I haven't actually tried this yet (I am currently
at work), but I do not think this is the issue, because when I choose
the YUV-style modes, I can capture at the full framerates.  It's only
when I select the image/jpeg mode that I get the lower framerates,
despite explicitly requesting the higher ones.

I suppose it's not impossible that the camera is opting for different
behavior depending on the mode of the request, but I think that is not
likely the case.  I do appreciate the suggestion, though, and I'll try
it when I get home.

Meanwhile, does anyone else have any other ideas?
