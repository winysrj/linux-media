Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f169.google.com ([209.85.216.169]:34920 "EHLO
        mail-qt0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751312AbdBYAIB (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 24 Feb 2017 19:08:01 -0500
Received: by mail-qt0-f169.google.com with SMTP id x35so29379775qtc.2
        for <linux-media@vger.kernel.org>; Fri, 24 Feb 2017 16:08:01 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20170224064359.51e0ce11@vento.lan>
References: <CAKTMqxtM8c7Nv=UQf45zida-u8dEQtHYYHzsGpsqjBn7YB6ZEw@mail.gmail.com>
 <20170224064359.51e0ce11@vento.lan>
From: Alexandre-Xavier L-L <axdoomer@gmail.com>
Date: Fri, 24 Feb 2017 19:08:00 -0500
Message-ID: <CAKTMqxv=hGzOmtMnf80t7eUyX8N6TXWz9Yoa2cqD5fmNQibhbQ@mail.gmail.com>
Subject: Re: How broken is the em28xx driver?
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

You're right, I forgot to set the region.

I discovered that the Ion Video 2 PC does work with my portable DVD
player and my ATSC TV broadcast to analog NTSC box for antenna
television. I see interlacing in the video, but I don't know if the
signal sent to the Ion Video 2 PC is interlaced, because it may just
be an interlaced video converted to progressive without any filters.

It still doesn't work with old video game consoles, but it's a bug
with the em28xx driver because it works on Windows. The way to "fix"
it is to comment the line that you've told me about a while ago in
"em28xx-video.c":

//if (dev->board.is_webcam)
    v4l2->progressive = true;

This would make the video work, but only in the upper half of the
screen (with a green bar at the bottom half). From what I understand,
one of the two interlaced fields is not displayed.

Do you know how to fix this issue?

Thank you,
Alexandre-Xavier


On Fri, Feb 24, 2017 at 4:43 AM, Mauro Carvalho Chehab
<mchehab@s-opensource.com> wrote:
> Hi Alexandre,
>
> Em Fri, 24 Feb 2017 04:09:42 -0500
> Alexandre-Xavier L-L <axdoomer@gmail.com> escreveu:
>
>> Hi everyone,
>>
>> Is it just me or every device that I try doesn't work. Here's a list,
>> they all use the em28xx driver.
>>
>> Ion video 2 pc
>> Plextor ConvertX PX-AV100U
>> Startech SVID2USB23
>>
>> Video of the results: https://www.youtube.com/watch?v=wgQKziHupkI
>>
>> I have even tried a August VGB100 which doesn't use the em28xx driver
>> and it doesn't work too.
>>
>> I have already posted on the mailing list about these issues relating
>> to the interlaced signal, but it's the first time that I try with a
>> progressive signal. Although the results are better, I cannot qualify
>> it as something that is working.
>>
>> Is the development of the em28xx driver still going on? I would like
>> to know which alternative driver that I could use or which would be
>> the step that I could do to fix the driver (I don't have a lot of
>> knowledge about it). I can even mail one of my devices to somebody who
>> is willing to fix the em28xx driver.
>>
>> Sorry if I insulted anyone by saying that the em28xx is broken, but I
>> have the impression that it doesn't work and that it won't ever work
>> with any device because they may be too much defects that prevent it
>> from working correctly. It could have worked before (I have seen a
>> video from 2013 where it did), but maybe there were regressions and no
>> one noticed it broke. I can't install old git releases because they
>> are not compatible with newer kernels.
>
> The em28xx driver works fine. It is actually one of the drivers I
> use most when testing something, as I have a lot of those devices
> (although I don't have the specific models you have).
>
> That said, the green bar on your video usually happens on two
> situations:
>
> 1) If you have a PAL input, but you're capturing video at NTSC;
> 2) When there's not enough bandwidth at the USB bus for the video.
>
> Analog TV capture, at 640x480, usually consumes 60% of the available
> bandwidth for ISOC frames on a USB 2.0 bus. Maybe you don't have
> enough bandwidth, or your USB controller is broken.
>
> Ah, one last thing that occurs to me: some domestic RF generators
> found on video games and on other CEC electronics sometimes produce
> outputs that don't quite follow the TV standard defined by ITU-R,
> causing troubles for analog TV decoders to identify it. Maybe
> that's the case. If so, try to capture from some other video
> source.
>
> Thanks,
> Mauro
