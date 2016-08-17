Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:33692 "EHLO
	mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752834AbcHQT0m (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Aug 2016 15:26:42 -0400
Received: by mail-wm0-f66.google.com with SMTP id o80so302944wme.0
        for <linux-media@vger.kernel.org>; Wed, 17 Aug 2016 12:26:42 -0700 (PDT)
MIME-Version: 1.0
From: =?UTF-8?Q?Alexandre=2DXavier_Labont=C3=A9=2DLamoureux?=
	<axdoomer@gmail.com>
Date: Wed, 17 Aug 2016 15:26:40 -0400
Message-ID: <CAKTMqxu=UuUmzPxhXKBza=1BBgK5DoMxtx4eFqLiEanvL-dqyw@mail.gmail.com>
Subject: Adding Linux support for the Ion Video 2 PC analog video capture
 device (em28xx)
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I have an Ion Video 2 PC and a StarTech svid2usb23 (id: 0xeb1a,
0x5051). I have documented them here:
https://linuxtv.org/wiki/index.php/Ion_Video_2_PC

I can get them to be recognized by patching the em28xx driver. I use
"EM2860_BOARD_TVP5150_REFERENCE_DESIGN".
(The patch can be found here:
https://www.linuxtv.org/wiki/index.php/Ion_Video_2_PC#Making_it_work)

Yet, it almost works, there is only one bug.

When I plug something yellow composite input of the device, it
captures one frame then stops. If I disconnect the composite video so
that there is no video input, then it starts capturing frames again.
So the device doesn't want to capture video when there is input, it
only captures frames when their is nothing connected to it.

I can see that it stops capturing frames by looking at the frame
counter in qv4l2.
I have made a video about this problem: https://youtu.be/z96OfgHGDao?t=40s
You can see what I explained in the previous paragraph at 1:58 in the video.

These are the chips inside the Ion Video 2 PC:
* Empia EM2860
* Empia EMP202
* 5150AM1

What would be the next thing to do to make it work? Thanks.

Best regards,
Alexandre
