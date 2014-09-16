Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:38802 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752662AbaIPMi2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Sep 2014 08:38:28 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Isaac Nickaein <nickaein.i@gmail.com>
Cc: linux-media@vger.kernel.org
Subject: Re: Framerate is consistently divided by 2.5
Date: Tue, 16 Sep 2014 15:38:30 +0300
Message-ID: <16820941.OvJExUqjyW@avalon>
In-Reply-To: <CA+NJmkdSXNkY70xiZ1m=dB7gTwr8jJ49gVt1B4VgXqqk1yca2g@mail.gmail.com>
References: <CA+NJmkdrRWHvSwHQ248qHqaaGBu8N=4aY7XaPQ4WUeD3QrhjMA@mail.gmail.com> <1918377.tBK2dPDOH0@avalon> <CA+NJmkdSXNkY70xiZ1m=dB7gTwr8jJ49gVt1B4VgXqqk1yca2g@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Isaac,

On Sunday 14 September 2014 01:57:02 Isaac Nickaein wrote:
> Ah sorry for the confusion. The USB camera was not working on the old
> kernel of ARM board. After patching the kernel, I can grab images but
> the framerate is 1/2.5 of expected framerate. The camera works without
> any issue on my PC (with kernel 3.13) though.

The uvcvideo driver drops erroneous frame by default. Could you please try 
turning that off by setting the nodrop module parameter to 1 and check if the 
frame rate changes ? Please use the yavta command line test application 
(http://git.ideasonboard.org/yavta.git) as other applications might not 
correctly handle frames with the error bit set, or might not take them into 
account to compute the frame rate.

The following command line should be all you need (you might want to change 
the resolution and video device to match your system).

yavta -c -f YUYV -s 640x480 /dev/video0

-- 
Regards,

Laurent Pinchart

