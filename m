Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:35195 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750991AbdFCTiF (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 3 Jun 2017 15:38:05 -0400
Subject: Re: [PATCH v7 16/34] [media] add Omnivision OV5640 sensor driver
To: Sakari Ailus <sakari.ailus@iki.fi>, Pavel Machek <pavel@ucw.cz>
Cc: robh+dt@kernel.org, mark.rutland@arm.com, shawnguo@kernel.org,
        kernel@pengutronix.de, fabio.estevam@nxp.com,
        linux@armlinux.org.uk, mchehab@kernel.org, hverkuil@xs4all.nl,
        nick@shmanahar.org, markus.heiser@darmarIT.de,
        p.zabel@pengutronix.de, laurent.pinchart+renesas@ideasonboard.com,
        bparrot@ti.com, geert@linux-m68k.org, arnd@arndb.de,
        sudipm.mukherjee@gmail.com, minghsiu.tsai@mediatek.com,
        tiffany.lin@mediatek.com, jean-christophe.trotin@st.com,
        horms+renesas@verge.net.au, niklas.soderlund+renesas@ragnatech.se,
        robert.jarzmik@free.fr, songjun.wu@microchip.com,
        andrew-ct.chen@mediatek.com, gregkh@linuxfoundation.org,
        shuah@kernel.org, sakari.ailus@linux.intel.com,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>
References: <1495672189-29164-1-git-send-email-steve_longerbeam@mentor.com>
 <1495672189-29164-17-git-send-email-steve_longerbeam@mentor.com>
 <20170531195821.GA16962@amd>
 <20170601082659.GJ1019@valkosipuli.retiisi.org.uk>
From: Steve Longerbeam <slongerbeam@gmail.com>
Message-ID: <755909bf-d1de-e0f3-1569-0d4b16e26817@gmail.com>
Date: Sat, 3 Jun 2017 12:38:01 -0700
MIME-Version: 1.0
In-Reply-To: <20170601082659.GJ1019@valkosipuli.retiisi.org.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 06/01/2017 01:26 AM, Sakari Ailus wrote:
> Hi Pavel,
> 
> On Wed, May 31, 2017 at 09:58:21PM +0200, Pavel Machek wrote:
>> Hi!
>>
>>> +/* min/typical/max system clock (xclk) frequencies */
>>> +#define OV5640_XCLK_MIN  6000000
>>> +#define OV5640_XCLK_MAX 24000000
>>> +
>>> +/*
>>> + * FIXME: there is no subdev API to set the MIPI CSI-2
>>> + * virtual channel yet, so this is hardcoded for now.
>>> + */
>>> +#define OV5640_MIPI_VC	1
>>
>> Can the FIXME be fixed?
> 
> Yes, but it's quite a bit of work. It makes sense to use a static virtual
> channel for now. A patchset which is however incomplete can be found here:
> 
> <URL:https://git.linuxtv.org/sailus/media_tree.git/log/?h=vc>
> 
> For what it's worth, all other devices use virtual channel zero for image
> data and so should this one.


Actually no. The CSI2IPU gasket in i.MX6 quad sends virtual channel 0
streams to IPU1-CSI0. But input to IPU1-CSI0 is also muxed with parallel
bus cameras. So if vc0 were chosen instead, platforms that support
parallel cameras to IPU1-CSI0 (SabreLite, SabreSD) would not be able
to use them concurrently with a MIPI CSI-2 source to IPU1-CSI1. So I
prefer to use static channel 1 to support those platforms.

I could convert this to a module parameter however, until a virtual
channel selection subdev API becomes available, at which point that
would have to be stripped.


> 
>>
>>> +/*
>>> + * image size under 1280 * 960 are SUBSAMPLING
>>
>> -> Image
>>
>>> + * image size upper 1280 * 960 are SCALING
>>
>> above?
>>


done.

>>> +/*
>>> + * FIXME: all of these register tables are likely filled with
>>> + * entries that set the register to their power-on default values,
>>> + * and which are otherwise not touched by this driver. Those entries
>>> + * should be identified and removed to speed register load time
>>> + * over i2c.
>>> + */
>>
>> load->loading? Can the FIXME be fixed?

That's a lot of work, and risky work at that. If someone could take
this on (strip out power-on default values from the tables), I'd
be grateful, but I don't have the time. For now at least, these
registers sets work fine.


>>
>>> +	/* Auto/manual exposure */
>>> +	ctrls->auto_exp = v4l2_ctrl_new_std_menu(hdl, ops,
>>> +						 V4L2_CID_EXPOSURE_AUTO,
>>> +						 V4L2_EXPOSURE_MANUAL, 0,
>>> +						 V4L2_EXPOSURE_AUTO);
>>> +	ctrls->exposure = v4l2_ctrl_new_std(hdl, ops,
>>> +					    V4L2_CID_EXPOSURE_ABSOLUTE,
>>> +					    0, 65535, 1, 0);
>>
>> Is exposure_absolute supposed to be in microseconds...?
> 
> Yes.

According to the docs V4L2_CID_EXPOSURE_ABSOLUTE is in 100 usec units.

  OTOH V4L2_CID_EXPOSURE has no defined unit, so it's a better fit IMO.
> Way more drivers appear to be using EXPOSURE than EXPOSURE_ABSOLUTE, too.

Done, switched to V4L2_CID_EXPOSURE. It's true, this control is not
taking 100 usec units, so unit-less is better.


Steve
