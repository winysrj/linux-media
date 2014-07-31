Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oa0-f50.google.com ([209.85.219.50]:42868 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750710AbaGaNPh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 31 Jul 2014 09:15:37 -0400
Received: by mail-oa0-f50.google.com with SMTP id g18so1999148oah.9
        for <linux-media@vger.kernel.org>; Thu, 31 Jul 2014 06:15:34 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <53DA371F.9070907@InUnum.com>
References: <53D12786.5050906@InUnum.com>
	<1915586.ZFV4ecW0Zg@avalon>
	<CA+2YH7vhYuvUbFHyyr699zUdJuYWDtzweOGo0hGDHzT-+oFGjw@mail.gmail.com>
	<2300187.SbcZEE0rv0@avalon>
	<53D90786.9090809@InUnum.com>
	<CA+2YH7vrD_N32KsksU2G37BhLPBMHJDbizrVb_N+=mnHC3oNmQ@mail.gmail.com>
	<53DA1538.90709@InUnum.com>
	<CA+2YH7sROaGEtVLBs9N7FdWG5mzPZDtGgOaD2sgea--kqLELQA@mail.gmail.com>
	<53DA371F.9070907@InUnum.com>
Date: Thu, 31 Jul 2014 15:15:34 +0200
Message-ID: <CA+2YH7tpTs_snyqZQQGXCg8b5mAYejyRceJy5QzuaEV2sgD-cQ@mail.gmail.com>
Subject: Re: omap3isp with DM3730 not working?!
From: Enrico <ebutera@users.sourceforge.net>
To: Michael Dietschi <michael.dietschi@inunum.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Jul 31, 2014 at 2:31 PM, Michael Dietschi
<michael.dietschi@inunum.com> wrote:
> Am 31.07.2014 12:36, schrieb Enrico:
>
>
>>
>> I think you are missing the ccdc sink pad setup, basically you should
>> have something like this:
>>
>> ....
>> - entity 5: OMAP3 ISP CCDC (3 pads, 9 links)
>>              type V4L2 subdev subtype Unknown flags 0
>>              device node name /dev/v4l-subdev2
>>          pad1: Source
>>                  [fmt:UYVY/720x576 field:interlaced-tb
>>                   crop.bounds:(0,0)/720x288
>>                   crop:(0,0)/720x288]
>>                  -> "OMAP3 ISP CCDC output":0 [ENABLED]
>>                  -> "OMAP3 ISP resizer":0 []
>>
>     pad1: Source
>
>         [fmt:UYVY/720x240 field:alternate
>
>          crop.bounds:(0,0)/720x240
>
>          crop:(0,0)/720x240]

It seems you are missing this:

media-ctl --set-format '"OMAP3 ISP CCDC":1 [UYVY 720x480 field:interlaced-tb]'

and add --field interlaced-tb to yavta.

Enrico
