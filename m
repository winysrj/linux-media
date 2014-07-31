Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f171.google.com ([209.85.214.171]:64988 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932310AbaGaKgL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 31 Jul 2014 06:36:11 -0400
Received: by mail-ob0-f171.google.com with SMTP id wm4so1423422obc.2
        for <linux-media@vger.kernel.org>; Thu, 31 Jul 2014 03:36:08 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <53DA1538.90709@InUnum.com>
References: <53D12786.5050906@InUnum.com>
	<1915586.ZFV4ecW0Zg@avalon>
	<CA+2YH7vhYuvUbFHyyr699zUdJuYWDtzweOGo0hGDHzT-+oFGjw@mail.gmail.com>
	<2300187.SbcZEE0rv0@avalon>
	<53D90786.9090809@InUnum.com>
	<CA+2YH7vrD_N32KsksU2G37BhLPBMHJDbizrVb_N+=mnHC3oNmQ@mail.gmail.com>
	<53DA1538.90709@InUnum.com>
Date: Thu, 31 Jul 2014 12:36:08 +0200
Message-ID: <CA+2YH7sROaGEtVLBs9N7FdWG5mzPZDtGgOaD2sgea--kqLELQA@mail.gmail.com>
Subject: Re: omap3isp with DM3730 not working?!
From: Enrico <ebutera@users.sourceforge.net>
To: Michael Dietschi <michael.dietschi@inunum.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Jul 31, 2014 at 12:06 PM, Michael Dietschi
<michael.dietschi@inunum.com> wrote:
> Am 30.07.2014 17:21, schrieb Enrico:
>
>> Standard question: are you using media-ctl from
>> git://linuxtv.org/pinchartl/v4l-utils.git field branch and latest
>> yavta from git://git.ideasonboard.org/yavta.git ?
>>
>> Enrico
>
> No, not exactly. I used older versions which came with Yocto Poky Daisy. But
> I also tried with these newer ones and get the same:
>
> root@overo:~$  ./media-ctl -v -r -l '"tvp5150 3-005c":0->"OMAP3 ISP
> CCDC":0[1], "OMAP3 ISP CCDC":1->"OMAP3 ISP CCDC output":0[1]'
>
>
> root@overo:~$  ./media-ctl -v -f '"tvp5150 3-005c":0 [UYVY2X8 720x576],
> "OMAP3 ISP CCDC":1 [UYVY2X8 720x576]'
>
> root@overo:~$  ./yavta -f UYVY -s 720x576 --capture=1 --file=image.raw
> /dev/video2
>

I think you are missing the ccdc sink pad setup, basically you should
have something like this:

....
- entity 5: OMAP3 ISP CCDC (3 pads, 9 links)
            type V4L2 subdev subtype Unknown flags 0
            device node name /dev/v4l-subdev2
        pad0: Sink
                [fmt:UYVY2X8/720x288 field:alternate]
                <- "OMAP3 ISP CCP2":1 []
                <- "OMAP3 ISP CSI2a":1 []
                <- "tvp5150 1-005c":0 [ENABLED]
        pad1: Source
                [fmt:UYVY/720x576 field:interlaced-tb
                 crop.bounds:(0,0)/720x288
                 crop:(0,0)/720x288]
                -> "OMAP3 ISP CCDC output":0 [ENABLED]
                -> "OMAP3 ISP resizer":0 []

with this setup i can correctly capture deinterlaced frames with
yavta, but have a look at the "[PATCH 00/11] OMAP3 ISP BT.656 support"
thread, i noticed some problems maybe it's the same for you.

Enrico
