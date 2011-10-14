Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:49174 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751488Ab1JNXxg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Oct 2011 19:53:36 -0400
Received: by ggnb1 with SMTP id b1so907770ggn.19
        for <linux-media@vger.kernel.org>; Fri, 14 Oct 2011 16:53:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4E98C48A.6070009@mlbassoc.com>
References: <4E98C09B.2060800@mlbassoc.com>
	<4E98C48A.6070009@mlbassoc.com>
Date: Sat, 15 Oct 2011 01:53:34 +0200
Message-ID: <CA+2YH7vDNGhop61YYKRDGycj-LKOidAFu2cG01qpia3jk3fHEw@mail.gmail.com>
Subject: Re: OMAP3 ISP - interlaced data incorrect
From: Enrico <ebutera@users.berlios.de>
To: Gary Thomas <gary@mlbassoc.com>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Oct 15, 2011 at 1:23 AM, Gary Thomas <gary@mlbassoc.com> wrote:
> To be clear, moving from film to video, there would be no change of data
> within a single frame between the two interleaved halves.  I'm sure this
> was even true of old cameras, which were not digital capture devices being
> used to send interleaved analogue data.
>
>> You can see some of this in the [otherwise quite good] sequence of images
>> http://www.mlbassoc.com/misc/nemo-swapped-00001.png
>> ...
>> http://www.mlbassoc.com/misc/nemo-swapped-00062.png
>> * Frames being skipped &/or very stale data being reused - I think this is
>> a [user]
>> software problem. The ISP driver assumes that it always has an empty
>> buffer to
>> move captured data into. Depending on the [user] program which is
>> consuming the
>> data, this may or not be true. In the case of ffmpeg, if I capture raw
>> images,
>> ffmpeg can almost always keep up and there is always a free buffer.
>> However, if
>> I have ffmpeg turn the raw frames into compressed video (mp4), nearly 1/2
>> of
>> the time, the ISP will run dry on buffers. I think I know how to fix this
>> (untested)
>> but it shows that some of the issues may be with the userland code we rely
>> on.
>
> In the case of ffmpeg capturing raw data, there were no times that the ISP
> driver
> wanted a buffer and failed to get one, at least when storing the frames in a
> RAM
> disk.  If stored to a physical device like MMC card, this might not be true.
>
> However, when ffmpeg is used to create an MP4 image, even to RAM disk,
> nearly 1/2
> of the time the ISP goes wanting, which certainly can't be good!

That is to be expected, it's not good but the worst thing that could
happen is that you will lose some frames, not fields (unless you are
losing interrupts too). So you will get laggy video, but with no
ghosting.

But i can't remember what the isp buffer code do when "out of buffer"
so i'm assuming it will do a sane thing (drop the current frame).

Enrico
