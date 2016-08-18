Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f52.google.com ([74.125.82.52]:36607 "EHLO
        mail-wm0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754464AbcHSA6n (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 18 Aug 2016 20:58:43 -0400
Received: by mail-wm0-f52.google.com with SMTP id q128so15863659wma.1
        for <linux-media@vger.kernel.org>; Thu, 18 Aug 2016 17:58:42 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160818062921.0d98f3bb@vento.lan>
References: <CAKTMqxu=UuUmzPxhXKBza=1BBgK5DoMxtx4eFqLiEanvL-dqyw@mail.gmail.com>
 <20160818062921.0d98f3bb@vento.lan>
From: =?UTF-8?Q?Alexandre=2DXavier_Labont=C3=A9=2DLamoureux?=
        <axdoomer@gmail.com>
Date: Thu, 18 Aug 2016 15:12:51 -0400
Message-ID: <CAKTMqxvkrYNFCWuu84556JkmwgTY3vk7Xx3N+hrmpcvnRRWp4w@mail.gmail.com>
Subject: Re: Adding Linux support for the Ion Video 2 PC analog video capture
 device (em28xx)
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro!

Thank you for your help.

I made the change that you suggested. It fixed the video freeze. I
still have issues though. There is a huge green bar at the bottom of
the screen and the colors don't work correctly.

On my Atari Flashback, the screen is in black and white:
http://imgur.com/a/U6Shv

I tried on my Nintendo 64 to see if I would get the same result, what
I got is a disco effect: https://youtu.be/WLlqJ7T3y4g
As you can see, it goes through the whole range of color hues. The
frame rate is low, but that's my screen recorder's fault.

What should I do next?

Best regards,
Alexandre-Xavier

On Thu, Aug 18, 2016 at 5:29 AM, Mauro Carvalho Chehab
<mchehab@s-opensource.com> wrote:
> Em Wed, 17 Aug 2016 15:26:40 -0400
> Alexandre-Xavier Labont=C3=A9-Lamoureux  <axdoomer@gmail.com> escreveu:
>
>> Hi,
>>
>> I have an Ion Video 2 PC and a StarTech svid2usb23 (id: 0xeb1a,
>> 0x5051). I have documented them here:
>> https://linuxtv.org/wiki/index.php/Ion_Video_2_PC
>>
>> I can get them to be recognized by patching the em28xx driver. I use
>> "EM2860_BOARD_TVP5150_REFERENCE_DESIGN".
>> (The patch can be found here:
>> https://www.linuxtv.org/wiki/index.php/Ion_Video_2_PC#Making_it_work)
>>
>> Yet, it almost works, there is only one bug.
>>
>> When I plug something yellow composite input of the device, it
>> captures one frame then stops. If I disconnect the composite video so
>> that there is no video input, then it starts capturing frames again.
>> So the device doesn't want to capture video when there is input, it
>> only captures frames when their is nothing connected to it.
>>
>> I can see that it stops capturing frames by looking at the frame
>> counter in qv4l2.
>> I have made a video about this problem: https://youtu.be/z96OfgHGDao?t=
=3D40s
>> You can see what I explained in the previous paragraph at 1:58 in the vi=
deo.
>>
>> These are the chips inside the Ion Video 2 PC:
>> * Empia EM2860
>> * Empia EMP202
>> * 5150AM1
>>
>> What would be the next thing to do to make it work? Thanks.
>
> It seems that you're using some game console to generate images.
> Those usually output video in progressive mode, instead of using
> interlaced mode. Maybe that's the cause of the issues you're
> having.
>
> You could try to write a quick hack by patching em28xx_v4l2_init, at
> drivers/media/usb/em28xx/em28xx-video.c.
>
> Seek for those lines:
>
>         if (dev->board.is_webcam)
>                 v4l2->progressive =3D true;
>
> And comment the first one. If this works, then we may add a modprobe
> parameter (like saa7134) or something else to fix it.
>
> Thanks,
> Mauro
