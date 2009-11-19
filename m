Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:52144 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753817AbZKSPDg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Nov 2009 10:03:36 -0500
From: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: Kuninori Morimoto <morimoto.kuninori@renesas.com>,
	Linux-V4L2 <linux-media@vger.kernel.org>
Date: Thu, 19 Nov 2009 09:03:30 -0600
Subject: RE: [PATCH] soc-camera: Add mt9t112 camera support
Message-ID: <A69FA2915331DC488A831521EAE36FE40155A51397@dlee06.ent.ti.com>
References: <uzl6ig9iy.wl%morimoto.kuninori@renesas.com>
 <A69FA2915331DC488A831521EAE36FE40155A51366@dlee06.ent.ti.com>
 <Pine.LNX.4.64.0911191546210.6767@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.0911191546210.6767@axis700.grange>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Guennadi,

I am not sure what you mean by ATM sensor. Is it not a
Aptina/Micron sensor giving Raw Bayer RGB or Yuv data?
Not sure what prevents it from interfacing with VPFE.
In otherwords, how is this different from mt9t031/mt9t001
in terms of hardware signals available to interface to
a SOC?

Murali Karicheri
Software Design Engineer
Texas Instruments Inc.
Germantown, MD 20874
phone: 301-407-9583
email: m-karicheri2@ti.com

>-----Original Message-----
>From: linux-media-owner@vger.kernel.org [mailto:linux-media-
>owner@vger.kernel.org] On Behalf Of Guennadi Liakhovetski
>Sent: Thursday, November 19, 2009 9:55 AM
>To: Karicheri, Muralidharan
>Cc: Kuninori Morimoto; Linux-V4L2
>Subject: RE: [PATCH] soc-camera: Add mt9t112 camera support
>
>On Thu, 19 Nov 2009, Karicheri, Muralidharan wrote:
>
>> Hi,
>>
>> Please make this a generic driver so that it can be used across
>> other SoCs as well. BTW, on which SoC have you tested this driver?
>> There seems to be a lot of soc-camera specific stuffs here.
>> Example, probe() is getting a pointer to struct soc_camera_device *icd.
>> I have been working with Guennadi to make the MT9T031.c driver work for
>> TI's VPFE on DMxxx SOCs. since this is a new driver, I would like to see
>> it de-coupled from soc-camera framework and implemented as a generic
>> v4l2-subdevice driver.
>
>Murali, yes, our aim is to make sensor drivers universally usable, using
>the v4l2-subdev API. But ATM sensor drivers, written and tested to work
>with soc-camera hosts, cannot be absolutely soc-camera free. Although, we
>can (and shall) try to make them at least partially usable outside of the
>soc-camera framework, as I have done with the mt9t031 driver. ATM this
>driver would refuse to work with a non soc-camera host, or even
>misfunction, if that host driver is using i2c client platform data for
>something else. Yes, we'll fix this, but don't expect it to become
>absolutely soc-camera free for now.
>
>Thanks
>Guennadi
>---
>Guennadi Liakhovetski, Ph.D.
>Freelance Open-Source Software Developer
>http://www.open-technology.de/
>--
>To unsubscribe from this list: send the line "unsubscribe linux-media" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html

