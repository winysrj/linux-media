Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:41140 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751328AbaG3VBf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 30 Jul 2014 17:01:35 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Enrico <ebutera@users.sourceforge.net>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Enric Balletbo Serra <eballetbo@gmail.com>
Subject: Re: [PATCH 00/11] OMAP3 ISP BT.656 support
Date: Wed, 30 Jul 2014 23:01:54 +0200
Message-ID: <2527488.lKHnXpDbSd@avalon>
In-Reply-To: <CA+2YH7tqrLLWh2xJT-dSqWnXV4VD+jNf-egn3ea+VoEsmvqOog@mail.gmail.com>
References: <1401133812-8745-1-git-send-email-laurent.pinchart@ideasonboard.com> <CA+2YH7uNcD5v0wvScrJuGXMGe_SS9Vo3nVb75jQVq9R86R4K-Q@mail.gmail.com> <CA+2YH7tqrLLWh2xJT-dSqWnXV4VD+jNf-egn3ea+VoEsmvqOog@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Enrico,

On Wednesday 23 July 2014 15:57:51 Enrico wrote:
> On Wed, Jul 23, 2014 at 3:54 PM, Enrico wrote:

[snip]

> > You were right i was using the wrong binary, now the output is:
> > 
> > ...
> > - entity 5: OMAP3 ISP CCDC (3 pads, 9 links)
> >             type V4L2 subdev subtype Unknown flags 0
> >             device node name /dev/v4l-subdev2
> >         pad0: Sink
> >                 [fmt:UYVY2X8/720x625 field:interlaced]
> > ...
> >         pad1: Source
> >                 [fmt:UYVY/720x624 field:interlaced
> >                  crop.bounds:(0,0)/720x624
> >                  crop:(0,0)/720x624]
> > ...
> > - entity 16: tvp5150 1-005c (1 pad, 1 link)
> >              type V4L2 subdev subtype Unknown flags 0
> >              device node name /dev/v4l-subdev8
> >         pad0: Source
> >                 [fmt:UYVY2X8/720x625 field:interlaced]

That's surprising. Have you applied the tvp5150 patches from the 
omap3isp/bt656 branch ? The field should be hardcoded to V4L2_FIELD_ALTERNATE 
(reported as "alternate" by media-ctl), as the tvp5150 alternates between the 
top and bottom fields in consecutive frames. The CCDC input should then be 
configured to V4L2_FIELD_ALTERNATE as well, and the CCDC output to 
V4L2_FIELD_ALTERNATE ("alternate"), V4L2_FIELD_INTERLACED_TB ("interlaced-tb") 
or V4L2_FIELD_INTERLACED_BT ("interlaced-bt").

> > but i still get the same error:
> > 
> > root@igep00x0:~/field# ./yavta -f UYVY -n4 -s 720x624 -c100 /dev/video2
> > Device /dev/video2 opened.
> > Device `OMAP3 ISP CCDC output' on `media' is a video output (without
> > mplanes) device.
> > Video format set: UYVY (59565955) 720x624 (stride 1440) field none
> > buffer size 898560
> > Video format: UYVY (59565955) 720x624 (stride 1440) field none buffer
> > size 898560
> > 4 buffers requested.
> > length: 898560 offset: 0 timestamp type/source: mono/EoF
> > Buffer 0/0 mapped at address 0xb6d95000.
> > length: 898560 offset: 901120 timestamp type/source: mono/EoF
> > Buffer 1/0 mapped at address 0xb6cb9000.
> > length: 898560 offset: 1802240 timestamp type/source: mono/EoF
> > Buffer 2/0 mapped at address 0xb6bdd000.
> > length: 898560 offset: 2703360 timestamp type/source: mono/EoF
> > Buffer 3/0 mapped at address 0xb6b01000.
> > Unable to start streaming: Invalid argument (22).
> > 4 buffers released.
> 
> Same error adding field parameter to yavta:
> ./yavta -f UYVY -n4 -s 720x624 -c100 --field interlaced /dev/video2


-- 
Regards,

Laurent Pinchart

