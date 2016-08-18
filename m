Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:37177
	"EHLO s-opensource.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753831AbcHRJ33 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Aug 2016 05:29:29 -0400
Date: Thu, 18 Aug 2016 06:29:21 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Alexandre-Xavier =?UTF-8?B?TGFib250w6ktTGFtb3VyZXV4?=
	<axdoomer@gmail.com>
Cc: linux-media@vger.kernel.org
Subject: Re: Adding Linux support for the Ion Video 2 PC analog video
 capture device (em28xx)
Message-ID: <20160818062921.0d98f3bb@vento.lan>
In-Reply-To: <CAKTMqxu=UuUmzPxhXKBza=1BBgK5DoMxtx4eFqLiEanvL-dqyw@mail.gmail.com>
References: <CAKTMqxu=UuUmzPxhXKBza=1BBgK5DoMxtx4eFqLiEanvL-dqyw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 17 Aug 2016 15:26:40 -0400
Alexandre-Xavier Labonté-Lamoureux  <axdoomer@gmail.com> escreveu:

> Hi,
> 
> I have an Ion Video 2 PC and a StarTech svid2usb23 (id: 0xeb1a,
> 0x5051). I have documented them here:
> https://linuxtv.org/wiki/index.php/Ion_Video_2_PC
> 
> I can get them to be recognized by patching the em28xx driver. I use
> "EM2860_BOARD_TVP5150_REFERENCE_DESIGN".
> (The patch can be found here:
> https://www.linuxtv.org/wiki/index.php/Ion_Video_2_PC#Making_it_work)
> 
> Yet, it almost works, there is only one bug.
> 
> When I plug something yellow composite input of the device, it
> captures one frame then stops. If I disconnect the composite video so
> that there is no video input, then it starts capturing frames again.
> So the device doesn't want to capture video when there is input, it
> only captures frames when their is nothing connected to it.
> 
> I can see that it stops capturing frames by looking at the frame
> counter in qv4l2.
> I have made a video about this problem: https://youtu.be/z96OfgHGDao?t=40s
> You can see what I explained in the previous paragraph at 1:58 in the video.
> 
> These are the chips inside the Ion Video 2 PC:
> * Empia EM2860
> * Empia EMP202
> * 5150AM1
> 
> What would be the next thing to do to make it work? Thanks.

It seems that you're using some game console to generate images.
Those usually output video in progressive mode, instead of using
interlaced mode. Maybe that's the cause of the issues you're
having.

You could try to write a quick hack by patching em28xx_v4l2_init, at 
drivers/media/usb/em28xx/em28xx-video.c.

Seek for those lines:

        if (dev->board.is_webcam)
                v4l2->progressive = true;

And comment the first one. If this works, then we may add a modprobe
parameter (like saa7134) or something else to fix it.

Thanks,
Mauro
