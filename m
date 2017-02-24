Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:53812
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751218AbdBXJoG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 24 Feb 2017 04:44:06 -0500
Date: Fri, 24 Feb 2017 06:43:59 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Alexandre-Xavier L-L <axdoomer@gmail.com>
Cc: linux-media@vger.kernel.org
Subject: Re: How broken is the em28xx driver?
Message-ID: <20170224064359.51e0ce11@vento.lan>
In-Reply-To: <CAKTMqxtM8c7Nv=UQf45zida-u8dEQtHYYHzsGpsqjBn7YB6ZEw@mail.gmail.com>
References: <CAKTMqxtM8c7Nv=UQf45zida-u8dEQtHYYHzsGpsqjBn7YB6ZEw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Alexandre,

Em Fri, 24 Feb 2017 04:09:42 -0500
Alexandre-Xavier L-L <axdoomer@gmail.com> escreveu:

> Hi everyone,
> 
> Is it just me or every device that I try doesn't work. Here's a list,
> they all use the em28xx driver.
> 
> Ion video 2 pc
> Plextor ConvertX PX-AV100U
> Startech SVID2USB23
> 
> Video of the results: https://www.youtube.com/watch?v=wgQKziHupkI
> 
> I have even tried a August VGB100 which doesn't use the em28xx driver
> and it doesn't work too.
> 
> I have already posted on the mailing list about these issues relating
> to the interlaced signal, but it's the first time that I try with a
> progressive signal. Although the results are better, I cannot qualify
> it as something that is working.
> 
> Is the development of the em28xx driver still going on? I would like
> to know which alternative driver that I could use or which would be
> the step that I could do to fix the driver (I don't have a lot of
> knowledge about it). I can even mail one of my devices to somebody who
> is willing to fix the em28xx driver.
> 
> Sorry if I insulted anyone by saying that the em28xx is broken, but I
> have the impression that it doesn't work and that it won't ever work
> with any device because they may be too much defects that prevent it
> from working correctly. It could have worked before (I have seen a
> video from 2013 where it did), but maybe there were regressions and no
> one noticed it broke. I can't install old git releases because they
> are not compatible with newer kernels.

The em28xx driver works fine. It is actually one of the drivers I
use most when testing something, as I have a lot of those devices
(although I don't have the specific models you have).

That said, the green bar on your video usually happens on two
situations:

1) If you have a PAL input, but you're capturing video at NTSC;
2) When there's not enough bandwidth at the USB bus for the video.

Analog TV capture, at 640x480, usually consumes 60% of the available
bandwidth for ISOC frames on a USB 2.0 bus. Maybe you don't have
enough bandwidth, or your USB controller is broken.

Ah, one last thing that occurs to me: some domestic RF generators
found on video games and on other CEC electronics sometimes produce 
outputs that don't quite follow the TV standard defined by ITU-R, 
causing troubles for analog TV decoders to identify it. Maybe
that's the case. If so, try to capture from some other video
source.

Thanks,
Mauro
