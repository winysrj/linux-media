Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oa0-f44.google.com ([209.85.219.44]:50128 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752054AbaGWNyU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Jul 2014 09:54:20 -0400
Received: by mail-oa0-f44.google.com with SMTP id eb12so1652955oac.31
        for <linux-media@vger.kernel.org>; Wed, 23 Jul 2014 06:54:19 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <2638081.aLalCDHyz1@avalon>
References: <1401133812-8745-1-git-send-email-laurent.pinchart@ideasonboard.com>
	<5099401.EbLZaQU31t@avalon>
	<CA+2YH7vNd4kC3=82M=UhHmNcXFGxBaiLUVbSkoXRvT8tfZkfcA@mail.gmail.com>
	<2638081.aLalCDHyz1@avalon>
Date: Wed, 23 Jul 2014 15:54:19 +0200
Message-ID: <CA+2YH7uNcD5v0wvScrJuGXMGe_SS9Vo3nVb75jQVq9R86R4K-Q@mail.gmail.com>
Subject: Re: [PATCH 00/11] OMAP3 ISP BT.656 support
From: Enrico <ebutera@users.sourceforge.net>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Enric Balletbo Serra <eballetbo@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Jul 22, 2014 at 6:32 PM, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
> Hi Enrico,
>
> On Tuesday 22 July 2014 18:26:52 Enrico wrote:
>> On Tue, Jul 22, 2014 at 6:04 PM, Laurent Pinchart wrote:
>> > Hi Enrico,
>> >
>> > You will need to upgrade media-ctl and yavta to versions that support
>> > interlaced formats. media-ctl has been moved to v4l-utils
>> > (http://git.linuxtv.org/cgit.cgi/v4l-utils.git/) and yavta is hosted at
>> > git://git.ideasonboard.org/yavta.git. You want to use the master branch
>> > for both trees.
>>
>> It seems that in v4l-utils there is no field support in media-ctl, am i
>> wrong?
>
> Oops, my bad, you're absolutely right.
>
>> I forgot to add that i'm using yavta master and media-ctl "field"
>> branch (from ideasonboard).
>
> Could you please try media-ctl from
>
>         git://linuxtv.org/pinchartl/v4l-utils.git field
>
> The IOB repository is deprecated, although the version of media-ctl present
> there might work, I'd like to rule out that issue.
>
> The media-ctl output you've posted doesn't show field information, so you're
> probably running either the wrong media-ctl version or the wrong kernel
> version.

You were right i was using the wrong binary, now the output is:

...
- entity 5: OMAP3 ISP CCDC (3 pads, 9 links)
            type V4L2 subdev subtype Unknown flags 0
            device node name /dev/v4l-subdev2
        pad0: Sink
                [fmt:UYVY2X8/720x625 field:interlaced]
...
        pad1: Source
                [fmt:UYVY/720x624 field:interlaced
                 crop.bounds:(0,0)/720x624
                 crop:(0,0)/720x624]

...

- entity 16: tvp5150 1-005c (1 pad, 1 link)
             type V4L2 subdev subtype Unknown flags 0
             device node name /dev/v4l-subdev8
        pad0: Source
                [fmt:UYVY2X8/720x625 field:interlaced]


but i still get the same error:

root@igep00x0:~/field# ./yavta -f UYVY -n4 -s 720x624 -c100 /dev/video2
Device /dev/video2 opened.
Device `OMAP3 ISP CCDC output' on `media' is a video output (without
mplanes) device.
Video format set: UYVY (59565955) 720x624 (stride 1440) field none
buffer size 898560
Video format: UYVY (59565955) 720x624 (stride 1440) field none buffer
size 898560
4 buffers requested.
length: 898560 offset: 0 timestamp type/source: mono/EoF
Buffer 0/0 mapped at address 0xb6d95000.
length: 898560 offset: 901120 timestamp type/source: mono/EoF
Buffer 1/0 mapped at address 0xb6cb9000.
length: 898560 offset: 1802240 timestamp type/source: mono/EoF
Buffer 2/0 mapped at address 0xb6bdd000.
length: 898560 offset: 2703360 timestamp type/source: mono/EoF
Buffer 3/0 mapped at address 0xb6b01000.
Unable to start streaming: Invalid argument (22).
4 buffers released.


And ccdc pad1: Source (entity 5) is strange, i think it should be
field:none (because ccdc output is deinterlaced).

Enrico
