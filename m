Return-path: <linux-media-owner@vger.kernel.org>
Received: from hermes.mlbassoc.com ([64.234.241.98]:47260 "EHLO
	mail.chez-thomas.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753261Ab2BDLsa (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 4 Feb 2012 06:48:30 -0500
Message-ID: <4F2D1AFD.1070808@mlbassoc.com>
Date: Sat, 04 Feb 2012 04:48:13 -0700
From: Gary Thomas <gary@mlbassoc.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: Javier Martinez Canillas <martinez.javier@gmail.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Enrico <ebutera@users.berlios.de>
Subject: Re: [PATCH] Adding YUV input support for OMAP3ISP driver
References: <EBE38CF866F2F94F95FA9A8CB3EF2284069CAE@singex1.aptina.com> <4F182013.90401@mlbassoc.com> <CA+2YH7vMFgzwrdBsXzBdYKG5kb8bTwtPnAnp8z_zjFFQenzzFQ@mail.gmail.com> <201201201319.45490.laurent.pinchart@ideasonboard.com> <4F26D3A4.6010907@mlbassoc.com>
In-Reply-To: <4F26D3A4.6010907@mlbassoc.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 2012-01-30 10:30, Gary Thomas wrote:
> On 2012-01-20 05:19, Laurent Pinchart wrote:
>> Hi Enrico,
>>
>> On Thursday 19 January 2012 15:17:57 Enrico wrote:
>>> On Thu, Jan 19, 2012 at 2:52 PM, Gary Thomas<gary@mlbassoc.com> wrote:
>>>> On 2012-01-19 06:35, Gary Thomas wrote:
>>>>> My camera init code is attached. In the previous kernel, the I2C bus was
>>>>> probed implicitly when I initialized the OMAP3ISP. I thought I
>>>>> remembered some discussion about how that worked (maybe changing), so
>>>>> this is probably
>>>>> where the problem starts.
>>>>>
>>>>> If you have an example, I can check my setup against it.
>>>>
>>>> Note: I reworked how the sensor+I2C was initialized to be
>>>> omap3_init_camera(&cobra3530p73_isp_platform_data);
>>>>
>>>> omap_register_i2c_bus(cobra3530p73_isp_platform_data.subdevs->subdevs[0]
>>>> .i2c_adapter_id, 400,
>>>>
>>>> cobra3530p73_isp_platform_data.subdevs->subdevs[0].board_info, 1);
>>>>
>>>> The TVP5150 is now found, but 'media-ctl -p' still dies :-(
>>>
>>> Have a look at [1] (the linux_3.2.bb file to see the list of
>>> patches,inside linux-3.2 directory for the actual patches), it's based
>>> on mainline kernel 3.2 and the bt656 patches i submitted months ago,
>>> it should be easy to adapt it for you board.
>>>
>>> <rant>
>>> Really, there are patches for all these problems since months (from
>>> me, Javier, TI), but because no maintainer cared (apart from Laurent)
>>> they were never reviewed/applied and there is always someone who comes
>>> back with all the usual problems (additional yuv format, bt656 mode,
>>> tvp5150 that doesn't work...).
>>> </rant>
>>
>> I totally understand your feeling.
>>
>> I'd like to get YUV support integrated in the OMAP3 ISP driver. However, I
>> have no YUV image source hardware, so I can only review the patches but not
>> test them.
>>
>> If someone can rebase the existing patches on top of
>> http://git.linuxtv.org/pinchartl/media.git/shortlog/refs/heads/omap3isp-
>> omap3isp-yuv and test them, then I'll review the result.
>>
>
> The attached patches produce a working setup against Laurent's tree above.
> That said, I don't recall exactly where which changes came from (I'm old
> school and not very git savvy, sorry). I've CC'd all the folks I think
> provided at least part of these changes. Perhaps we can all work together
> to come up with a proper set of patches which can be pushed upstream
> for this, once and for all?
>
> Thanks
>

Ping!  Is no one but me interested in getting these changes into
the mainline?

-- 
------------------------------------------------------------
Gary Thomas                 |  Consulting for the
MLB Associates              |    Embedded world
------------------------------------------------------------
