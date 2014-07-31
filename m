Return-path: <linux-media-owner@vger.kernel.org>
Received: from www.inunum.li ([83.169.19.93]:37003 "EHLO
	lvps83-169-19-93.dedicated.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751013AbaGaMbV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 31 Jul 2014 08:31:21 -0400
Message-ID: <53DA371F.9070907@InUnum.com>
Date: Thu, 31 Jul 2014 14:31:27 +0200
From: Michael Dietschi <michael.dietschi@InUnum.com>
MIME-Version: 1.0
To: Enrico <ebutera@users.sourceforge.net>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: omap3isp with DM3730 not working?!
References: <53D12786.5050906@InUnum.com>	<1915586.ZFV4ecW0Zg@avalon>	<CA+2YH7vhYuvUbFHyyr699zUdJuYWDtzweOGo0hGDHzT-+oFGjw@mail.gmail.com>	<2300187.SbcZEE0rv0@avalon>	<53D90786.9090809@InUnum.com>	<CA+2YH7vrD_N32KsksU2G37BhLPBMHJDbizrVb_N+=mnHC3oNmQ@mail.gmail.com>	<53DA1538.90709@InUnum.com> <CA+2YH7sROaGEtVLBs9N7FdWG5mzPZDtGgOaD2sgea--kqLELQA@mail.gmail.com>
In-Reply-To: <CA+2YH7sROaGEtVLBs9N7FdWG5mzPZDtGgOaD2sgea--kqLELQA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 31.07.2014 12:36, schrieb Enrico:

>
> I think you are missing the ccdc sink pad setup, basically you should
> have something like this:
>
> ....
> - entity 5: OMAP3 ISP CCDC (3 pads, 9 links)
>              type V4L2 subdev subtype Unknown flags 0
>              device node name /dev/v4l-subdev2
>          pad0: Sink
>                  [fmt:UYVY2X8/720x288 field:alternate]
>                  <- "OMAP3 ISP CCP2":1 []
>                  <- "OMAP3 ISP CSI2a":1 []
>                  <- "tvp5150 1-005c":0 [ENABLED]
>          pad1: Source
>                  [fmt:UYVY/720x576 field:interlaced-tb
>                   crop.bounds:(0,0)/720x288
>                   crop:(0,0)/720x288]
>                  -> "OMAP3 ISP CCDC output":0 [ENABLED]
>                  -> "OMAP3 ISP resizer":0 []
>
> with this setup i can correctly capture deinterlaced frames with
> yavta, but have a look at the "[PATCH 00/11] OMAP3 ISP BT.656 support"
> thread, i noticed some problems maybe it's the same for you.
>
> Enrico
>

Hi Enrico,
the setup looks like:

...
- entity 5: OMAP3 ISP CCDC (3 pads, 9 links)

             type V4L2 subdev subtype Unknown flags 0

             device node name /dev/v4l-subdev2

     pad0: Sink

         [fmt:UYVY2X8/720x240 field:alternate]

         <- "OMAP3 ISP CCP2":1 []

         <- "OMAP3 ISP CSI2a":1 []

         <- "tvp5150 3-005c":0 [ENABLED]

     pad1: Source

         [fmt:UYVY/720x240 field:alternate

          crop.bounds:(0,0)/720x240

          crop:(0,0)/720x240]

         -> "OMAP3 ISP CCDC output":0 [ENABLED]

         -> "OMAP3 ISP resizer":0 []

     pad2: Source

         [fmt:unknown/720x239 field:alternate]

         -> "OMAP3 ISP preview":0 []

         -> "OMAP3 ISP AEWB":0 [ENABLED,IMMUTABLE]

         -> "OMAP3 ISP AF":0 [ENABLED,IMMUTABLE]

         -> "OMAP3 ISP histogram":0 [ENABLED,IMMUTABLE]

- entity 6: OMAP3 ISP CCDC output (1 pad, 1 link)

             type Node subtype V4L flags 0

             device node name /dev/video2

     pad0: Sink

         <- "OMAP3 ISP CCDC":1 [ENABLED]

...

- entity 16: tvp5150 3-005c (1 pad, 1 link)

              type V4L2 subdev subtype Unknown flags 0

              device node name /dev/v4l-subdev8

     pad0: Source

         [fmt:UYVY2X8/720x240 field:alternate]

         -> "OMAP3 ISP CCDC":0 [ENABLED]


And I could not find any help in"[PATCH 00/11] OMAP3 ISP BT.656 support"
because it seems that all the mentioned things are already done.

Michael

