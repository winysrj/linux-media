Return-path: <linux-media-owner@vger.kernel.org>
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:43900 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754196AbcIFM20 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 6 Sep 2016 08:28:26 -0400
Date: Tue, 6 Sep 2016 15:28:23 +0300
From: Andrey Utkin <andrey_utkin@fastmail.com>
To: Oliver Collyer <ovcollyer@mac.com>
Cc: linux-media@vger.kernel.org
Subject: Re: uvcvideo error on second capture from USB device, leading to
 V4L2_BUF_FLAG_ERROR
Message-ID: <20160906122823.toxscjyxomrh2col@zver>
References: <C29C248E-5D7A-4E69-A88D-7B971D42E984@mac.com>
 <20160904192538.75czuv7c2imru6ds@zver>
 <AE433005-988F-4352-8CF3-30690C82CAA6@mac.com>
 <20160905201935.wpgtrtt7e4bjjylo@zver>
 <FE81AFD0-C5F1-4FE7-A282-3294E668066C@mac.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <FE81AFD0-C5F1-4FE7-A282-3294E668066C@mac.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Sep 06, 2016 at 01:51:51PM +0300, Oliver Collyer wrote:
> So today I installed Ubuntu 16.04 on another PC (this one a high spec machine with a Rampage V Extreme motherboard) and I reproduced exactly the same errors and trace.
> 
> Rebooting the same PC back into Windows 10 and using the same USB 3.0 port, I had no problems capturing using FFmpeg via DirectShow. I could start and stop the capture repeatedly without any warnings or errors appearing in FFmpeg (built from the same source).
> 
> If the hardware is misbehaving, on both these capture devices, then DS must be handling it better than V4L2. Or there is simply an obscure bug in V4L2 which only manifests itself with certain devices.
> 
> Would providing ssh access to the machine be of interest to anyone who wants to debug this?

I am curious to tinker with this, just not sure about free time for it.
Please go through the following instruction, and then we'll see if ssh
is going to help to debug this.

Also I think it is worth to CC actual manufacturers. There are addresses
for technical support of both devices in public on maker websites.
Please CC them when replying with new logs, to let them catch up.

So, I am still not certain what confuses the device, i.e. where the
faulty usage pattern comes from: ffmpeg or driver. So I'd like you to
check the difference with various userspace applications which involve
streaming from device.

For each of your two devices, alone (not two at same time), do this:

For each command from this list:
"v4l2-compliance -s -d /dev/video0",
"ffmpeg -f v4l2 -i /dev/video0 -vcodec rawvideo -f null -y /dev/null",
"<what you referred to as 'capture API example'>"
(feel free to add more, maybe mplayer invocation or such)

dmesg -C
plug in the device
modprobe uvcvideo module
run the command twice or more in row
save uncut commands output (with command lines) to separate file
rmmod uvcvideo
unplug the device
save "dmesg" output to separate file


Done.

I guess this test makes sense, or am I missing something you've already
told us?

If you go making a script for this, make sure to notice if rmmod fails
for any reason, etc.
