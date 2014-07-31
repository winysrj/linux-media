Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oa0-f49.google.com ([209.85.219.49]:56524 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756304AbaGaKVK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 31 Jul 2014 06:21:10 -0400
Received: by mail-oa0-f49.google.com with SMTP id eb12so1859743oac.36
        for <linux-media@vger.kernel.org>; Thu, 31 Jul 2014 03:21:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <2527488.lKHnXpDbSd@avalon>
References: <1401133812-8745-1-git-send-email-laurent.pinchart@ideasonboard.com>
	<CA+2YH7uNcD5v0wvScrJuGXMGe_SS9Vo3nVb75jQVq9R86R4K-Q@mail.gmail.com>
	<CA+2YH7tqrLLWh2xJT-dSqWnXV4VD+jNf-egn3ea+VoEsmvqOog@mail.gmail.com>
	<2527488.lKHnXpDbSd@avalon>
Date: Thu, 31 Jul 2014 12:21:09 +0200
Message-ID: <CA+2YH7vZm3famhSJeCQ0gWr=jAUm24=M40xmXGORSDXXgc-5zQ@mail.gmail.com>
Subject: Re: [PATCH 00/11] OMAP3 ISP BT.656 support
From: Enrico <ebutera@users.sourceforge.net>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Enric Balletbo Serra <eballetbo@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Jul 30, 2014 at 11:01 PM, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
> Hi Enrico,
>
> On Wednesday 23 July 2014 15:57:51 Enrico wrote:
>> On Wed, Jul 23, 2014 at 3:54 PM, Enrico wrote:
>
> [snip]
>
>> > You were right i was using the wrong binary, now the output is:
>> >
>> > ...
>> > - entity 5: OMAP3 ISP CCDC (3 pads, 9 links)
>> >             type V4L2 subdev subtype Unknown flags 0
>> >             device node name /dev/v4l-subdev2
>> >         pad0: Sink
>> >                 [fmt:UYVY2X8/720x625 field:interlaced]
>> > ...
>> >         pad1: Source
>> >                 [fmt:UYVY/720x624 field:interlaced
>> >                  crop.bounds:(0,0)/720x624
>> >                  crop:(0,0)/720x624]
>> > ...
>> > - entity 16: tvp5150 1-005c (1 pad, 1 link)
>> >              type V4L2 subdev subtype Unknown flags 0
>> >              device node name /dev/v4l-subdev8
>> >         pad0: Source
>> >                 [fmt:UYVY2X8/720x625 field:interlaced]
>
> That's surprising. Have you applied the tvp5150 patches from the
> omap3isp/bt656 branch ? The field should be hardcoded to V4L2_FIELD_ALTERNATE
> (reported as "alternate" by media-ctl), as the tvp5150 alternates between the
> top and bottom fields in consecutive frames. The CCDC input should then be
> configured to V4L2_FIELD_ALTERNATE as well, and the CCDC output to
> V4L2_FIELD_ALTERNATE ("alternate"), V4L2_FIELD_INTERLACED_TB ("interlaced-tb")
> or V4L2_FIELD_INTERLACED_BT ("interlaced-bt").

No, i missed those patches i was using only the omap3isp patches you
posted here.
With those patches and configuring the pipleline as you suggested i
could finally capture some good frames with yavta.

But i think there is some race, because it's not very "reliable". This
is what i see:

(with yavta -c50 -f UYVY -s 720x576 --field interlaced-tb /dev/video2)

1) first run, ok

2) if i re-run it soon after it finishes, it just hangs on start (in
VIDIOC_DQBUF).
I have to stop it with ctrl+c and after some seconds it exits, and the
kernel prints the ccdc stop timeout message.

in any case when it doesn't hang i can capture 200 frames with no
errors. And if i wait some seconds before running it again it usually
works (not always).

3) if i add -F to yavta (saving to a tmpfs in ram), it hangs after
capturing some frames (usually between 20 and 30).
yet again, same ctrl+c thing (it exits, ccdc stop timeout...).

Apart from these issues your patches are much better then the old
ones! Any hints on what i can try to fix these issues?

Thanks,

Enrico
