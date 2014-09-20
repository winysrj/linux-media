Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qa0-f47.google.com ([209.85.216.47]:47905 "EHLO
	mail-qa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755215AbaITNOW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 20 Sep 2014 09:14:22 -0400
Received: by mail-qa0-f47.google.com with SMTP id cm18so3673829qab.20
        for <linux-media@vger.kernel.org>; Sat, 20 Sep 2014 06:14:21 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <16820941.OvJExUqjyW@avalon>
References: <CA+NJmkdrRWHvSwHQ248qHqaaGBu8N=4aY7XaPQ4WUeD3QrhjMA@mail.gmail.com>
 <1918377.tBK2dPDOH0@avalon> <CA+NJmkdSXNkY70xiZ1m=dB7gTwr8jJ49gVt1B4VgXqqk1yca2g@mail.gmail.com>
 <16820941.OvJExUqjyW@avalon>
From: Isaac Nickaein <nickaein.i@gmail.com>
Date: Sat, 20 Sep 2014 16:44:00 +0330
Message-ID: <CA+NJmkf1W-XgWmAOhNQNyKvR3LMgxKtH85b9Xw3BdLgwoS1i_g@mail.gmail.com>
Subject: Re: Framerate is consistently divided by 2.5
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Even with "nodrop=1" the framerate is still stuck at ~12fps when it
should be ~30fps. I ran "/yavta -c -f Y800 -s 1280x960 /dev/video0" to
test the camera fps.

Here is the YAVTA output for nodrop=0: http://pastebin.com/bQZcJ0Fd
Here is the YAVTA output for nodrop=1: http://pastebin.com/cFYFUrvN

I used the following command to change the nodrop parameter (UVC is a
built-in kernel module):

echo 1 > /sys/module/uvcvideo/parameters/nodrop


I also tried enabling log for the uvcvideo module:

echo 0xffff > /sys/module/uvcvideo/parameters/trace

And here is the corresponding part of dmesg: http://pastebin.com/eWL3GbE1

There seems to be some errors in this log (e.g. Stream 1 error event
b5 e5 len 12.), but I'm not sure they could be the cause of issue or
not.


Thanks,
Isaac


On Tue, Sep 16, 2014 at 4:08 PM, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
> Hi Isaac,
>
> On Sunday 14 September 2014 01:57:02 Isaac Nickaein wrote:
>> Ah sorry for the confusion. The USB camera was not working on the old
>> kernel of ARM board. After patching the kernel, I can grab images but
>> the framerate is 1/2.5 of expected framerate. The camera works without
>> any issue on my PC (with kernel 3.13) though.
>
> The uvcvideo driver drops erroneous frame by default. Could you please try
> turning that off by setting the nodrop module parameter to 1 and check if the
> frame rate changes ? Please use the yavta command line test application
> (http://git.ideasonboard.org/yavta.git) as other applications might not
> correctly handle frames with the error bit set, or might not take them into
> account to compute the frame rate.
>
> The following command line should be all you need (you might want to change
> the resolution and video device to match your system).
>
> yavta -c -f YUYV -s 640x480 /dev/video0
>
> --
> Regards,
>
> Laurent Pinchart
>
