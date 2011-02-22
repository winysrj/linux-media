Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:40040 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751759Ab1BVCwN (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Feb 2011 21:52:13 -0500
Message-ID: <4D6324DB.5030801@redhat.com>
Date: Mon, 21 Feb 2011 23:52:11 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 0/4] Some fixes for tuner, tvp5150 and em28xx
References: <20110221231741.71a2149e@pedra>
In-Reply-To: <20110221231741.71a2149e@pedra>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 21-02-2011 23:17, Mauro Carvalho Chehab escreveu:
> This series contain a minor cleanup for tuner and tvp5150, and two fixes
> for em28xx controls. Before the em28xx patches, s_ctrl were failing on
> qv4l2, because it were returning a positive value of 1 for some calls.
> 
> It also contains a fix for control get/set, as it will now check if the
> control exists before actually calling subdev for get/set.
> 
> Mauro Carvalho Chehab (4):
...
>   [media] em28xx: Fix return value for s_ctrl
>   [media] em28xx: properly handle subdev controls

Hans,

I discovered the issue with em28xx that I commented you on IRC.

There were, in fact, 3 issues. 

One is clearly a driver problem, corrected by "em28xx: properly
handle subdev controls".

The second one being partially qv4l2 and partially driver issue,
fixed by "em28xx: Fix return value for s_ctrl". Basically, V4L2
API and ioctl man page says that an error is indicated by -1 value,
being 0 or positive value a non-error. Well, qv4l2 understands a
positive value as -EBUSY. The driver were returning a non-standard
value of 1 for s_ctrl. I fixed the driver part.

The last issue is with v4l2-ctl and qv4l2. Also, the latest version
of xawtv had the same issue, probably due to some changes I did at
console/v4l-info.c.

What happens is that em28xx doesn't implement the control BASE+4,
due to one simple reason: it is not currently defined. The ctrl
loop were understanding the -EINVAL return of BASE+4 as the end of
the user controls. So, on xawtv, only the 3 image controls were
returned. I didn't dig into v4l2-ctl, but there, it doesn't show
the first 3 controls. It shows only the audio controls:

                         volume (int)  : min=0 max=65535 step=655 default=58880 value=58880 flags=slider
                        balance (int)  : min=0 max=65535 step=655 default=32768 value=32768 flags=slider
                           bass (int)  : min=0 max=65535 step=655 default=32768 value=32768 flags=slider
                         treble (int)  : min=0 max=65535 step=655 default=32768 value=32768 flags=slider
                           mute (bool) : default=0 value=0
                       loudness (bool) : default=0 value=0

The xawtv fix is at:
	http://git.linuxtv.org/xawtv3.git?a=commitdiff;h=fda070af9cfd75b360db1339bde3c6d3c64ed627

A similar fix is needed for v4l2-ctl and qv4l2.

The em28xx logs after the fix are:

em28xx #0 video: VIDIOC_QUERYCTRL id=0x980900, type=1, name=Brightness, min/max=0/255, step=1, default=128, flags=0x00000000
em28xx #0 video: VIDIOC_QUERYCTRL id=0x980901, type=1, name=Contrast, min/max=0/255, step=1, default=128, flags=0x00000000
em28xx #0 video: VIDIOC_QUERYCTRL id=0x980902, type=1, name=Saturation, min/max=0/255, step=1, default=128, flags=0x00000000
em28xx #0 video: VIDIOC_QUERYCTRL id=0x980903, type=1, name=Hue, min/max=-128/127, step=1, default=0, flags=0x00000000
em28xx #0 video: VIDIOC_QUERYCTRL id=0x980904
em28xx #0 video: VIDIOC_QUERYCTRL error -22
em28xx #0 video: VIDIOC_QUERYCTRL id=0x980905, type=1, name=Volume, min/max=0/65535, step=655, default=58880, flags=0x00000020
em28xx #0 video: VIDIOC_QUERYCTRL id=0x980906, type=1, name=Balance, min/max=0/65535, step=655, default=32768, flags=0x00000020
em28xx #0 video: VIDIOC_QUERYCTRL id=0x980907, type=1, name=Bass, min/max=0/65535, step=655, default=32768, flags=0x00000020
em28xx #0 video: VIDIOC_QUERYCTRL id=0x980908, type=1, name=Treble, min/max=0/65535, step=655, default=32768, flags=0x00000020
em28xx #0 video: VIDIOC_QUERYCTRL id=0x980909, type=2, name=Mute, min/max=0/1, step=1, default=0, flags=0x00000000
em28xx #0 video: VIDIOC_QUERYCTRL id=0x98090a, type=2, name=Loudness, min/max=0/1, step=1, default=0, flags=0x00000000
em28xx #0 video: VIDIOC_QUERYCTRL id=0x98090b
em28xx #0 video: VIDIOC_QUERYCTRL error -22
em28xx #0 video: VIDIOC_QUERYCTRL id=0x98090c
em28xx #0 video: VIDIOC_QUERYCTRL error -22
em28xx #0 video: VIDIOC_QUERYCTRL id=0x98090d
em28xx #0 video: VIDIOC_QUERYCTRL error -22
em28xx #0 video: VIDIOC_QUERYCTRL id=0x98090e
em28xx #0 video: VIDIOC_QUERYCTRL error -22
em28xx #0 video: VIDIOC_QUERYCTRL id=0x98090f
em28xx #0 video: VIDIOC_QUERYCTRL error -22
em28xx #0 video: VIDIOC_QUERYCTRL id=0x980910
em28xx #0 video: VIDIOC_QUERYCTRL error -22
em28xx #0 video: VIDIOC_QUERYCTRL id=0x980911
em28xx #0 video: VIDIOC_QUERYCTRL error -22
em28xx #0 video: VIDIOC_QUERYCTRL id=0x980912
em28xx #0 video: VIDIOC_QUERYCTRL error -22
em28xx #0 video: VIDIOC_QUERYCTRL id=0x980913
em28xx #0 video: VIDIOC_QUERYCTRL error -22
em28xx #0 video: VIDIOC_QUERYCTRL id=0x980914
em28xx #0 video: VIDIOC_QUERYCTRL error -22
em28xx #0 video: VIDIOC_QUERYCTRL id=0x980915
em28xx #0 video: VIDIOC_QUERYCTRL error -22
em28xx #0 video: VIDIOC_QUERYCTRL id=0x980916
em28xx #0 video: VIDIOC_QUERYCTRL error -22
em28xx #0 video: VIDIOC_QUERYCTRL id=0x980917
em28xx #0 video: VIDIOC_QUERYCTRL error -22
em28xx #0 video: VIDIOC_QUERYCTRL id=0x980918
em28xx #0 video: VIDIOC_QUERYCTRL error -22
em28xx #0 video: VIDIOC_QUERYCTRL id=0x980919
em28xx #0 video: VIDIOC_QUERYCTRL error -22
em28xx #0 video: VIDIOC_QUERYCTRL id=0x98091a
em28xx #0 video: VIDIOC_QUERYCTRL error -22
em28xx #0 video: VIDIOC_QUERYCTRL id=0x98091b
em28xx #0 video: VIDIOC_QUERYCTRL error -22
em28xx #0 video: VIDIOC_QUERYCTRL id=0x98091c
em28xx #0 video: VIDIOC_QUERYCTRL error -22
em28xx #0 video: VIDIOC_QUERYCTRL id=0x98091d
em28xx #0 video: VIDIOC_QUERYCTRL error -22
em28xx #0 video: VIDIOC_QUERYCTRL id=0x98091e
em28xx #0 video: VIDIOC_QUERYCTRL error -22
em28xx #0 video: VIDIOC_QUERYCTRL id=0x98091f
em28xx #0 video: VIDIOC_QUERYCTRL error -22
em28xx #0 video: VIDIOC_QUERYCTRL id=0x980920
em28xx #0 video: VIDIOC_QUERYCTRL error -22
em28xx #0 video: VIDIOC_QUERYCTRL id=0x980921
em28xx #0 video: VIDIOC_QUERYCTRL error -22
em28xx #0 video: VIDIOC_QUERYCTRL id=0x8000000
em28xx #0 video: VIDIOC_QUERYCTRL error -22

And v4l-info now reports everything:

controls
    VIDIOC_QUERYCTRL(BASE+0)
	id                      : 9963776
	type                    : INTEGER
	name                    : "Brightness"
	minimum                 : 0
	maximum                 : 255
	step                    : 1
	default_value           : 128
	flags                   : 0
    VIDIOC_QUERYCTRL(BASE+1)
	id                      : 9963777
	type                    : INTEGER
	name                    : "Contrast"
	minimum                 : 0
	maximum                 : 255
	step                    : 1
	default_value           : 128
	flags                   : 0
    VIDIOC_QUERYCTRL(BASE+2)
	id                      : 9963778
	type                    : INTEGER
	name                    : "Saturation"
	minimum                 : 0
	maximum                 : 255
	step                    : 1
	default_value           : 128
	flags                   : 0
    VIDIOC_QUERYCTRL(BASE+3)
	id                      : 9963779
	type                    : INTEGER
	name                    : "Hue"
	minimum                 : -128
	maximum                 : 127
	step                    : 1
	default_value           : 0
	flags                   : 0
    VIDIOC_QUERYCTRL(BASE+5)
	id                      : 9963781
	type                    : INTEGER
	name                    : "Volume"
	minimum                 : 0
	maximum                 : 65535
	step                    : 655
	default_value           : 58880
	flags                   : 32
    VIDIOC_QUERYCTRL(BASE+6)
	id                      : 9963782
	type                    : INTEGER
	name                    : "Balance"
	minimum                 : 0
	maximum                 : 65535
	step                    : 655
	default_value           : 32768
	flags                   : 32
    VIDIOC_QUERYCTRL(BASE+7)
	id                      : 9963783
	type                    : INTEGER
	name                    : "Bass"
	minimum                 : 0
	maximum                 : 65535
	step                    : 655
	default_value           : 32768
	flags                   : 32
    VIDIOC_QUERYCTRL(BASE+8)
	id                      : 9963784
	type                    : INTEGER
	name                    : "Treble"
	minimum                 : 0
	maximum                 : 65535
	step                    : 655
	default_value           : 32768
	flags                   : 32
    VIDIOC_QUERYCTRL(BASE+9)
	id                      : 9963785
	type                    : BOOLEAN
	name                    : "Mute"
	minimum                 : 0
	maximum                 : 1
	step                    : 1
	default_value           : 0
	flags                   : 0
    VIDIOC_QUERYCTRL(BASE+10)
	id                      : 9963786
	type                    : BOOLEAN
	name                    : "Loudness"
	minimum                 : 0
	maximum                 : 1
	step                    : 1
	default_value           : 0
	flags                   : 0
