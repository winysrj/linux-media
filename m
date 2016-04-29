Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:33707 "EHLO
	mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750714AbcD2So3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Apr 2016 14:44:29 -0400
Received: by mail-wm0-f66.google.com with SMTP id r12so7009419wme.0
        for <linux-media@vger.kernel.org>; Fri, 29 Apr 2016 11:44:28 -0700 (PDT)
Subject: Re: [RFC PATCH 00/24] Make Nokia N900 cameras working
To: Sebastian Reichel <sre@kernel.org>, sakari.ailus@iki.fi
References: <20160420081427.GZ32125@valkosipuli.retiisi.org.uk>
 <1461532104-24032-1-git-send-email-ivo.g.dimitrov.75@gmail.com>
 <20160427030850.GA17034@earth> <572048AC.7050700@gmail.com>
 <572062EF.7060502@gmail.com> <20160427164256.GA8156@earth>
 <1461777170.18568.2.camel@Nokia-N900> <20160429000551.GA29312@earth>
 <20160429174559.GA6431@earth>
Cc: pavel@ucw.cz, pali.rohar@gmail.com, linux-media@vger.kernel.org
From: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
Message-ID: <5723AB89.8060704@gmail.com>
Date: Fri, 29 Apr 2016 21:44:25 +0300
MIME-Version: 1.0
In-Reply-To: <20160429174559.GA6431@earth>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 29.04.2016 20:45, Sebastian Reichel wrote:
> Hi,
>
> On Fri, Apr 29, 2016 at 02:05:52AM +0200, Sebastian Reichel wrote:
>> On Wed, Apr 27, 2016 at 08:12:50PM +0300, Ивайло Димитров wrote:
>>>> The zImage + initrd works with the steps you described below.
>>>
>>> Great!
>>
>> I also got it working with the previously referenced branch with the
>> following built as modules:
>>
>> CONFIG_VIDEOBUF2_CORE=m
>> CONFIG_VIDEOBUF2_MEMOPS=m
>> CONFIG_VIDEOBUF2_DMA_CONTIG=m
>> CONFIG_VIDEO_OMAP3=m
>> CONFIG_VIDEO_BUS_SWITCH=m
>> CONFIG_VIDEO_SMIAPP_PLL=m
>> CONFIG_VIDEO_SMIAPP=m
>> CONFIG_VIDEO_SMIAREGS=m
>> CONFIG_VIDEO_ET8EK8=m
>
> Ok, I found the problem. CONFIG_VIDEO_OMAP3=y does not work,
> due to missing -EPROBE_DEFER handling for vdds_csib. I added
> it and just got a test image with builtin CONFIG_VIDEO_OMAP3.
> The below patch fixes the problem.
>

Cool :)

vdd-csiphy1/2 will need the same handling, but lets have what is done so 
far rolling, those can be fixed later on.

> commit 9d8333b29207de3a9b6ac99db2dfd91e2f8c0216
> Author: Sebastian Reichel <sre@kernel.org>
> Date:   Fri Apr 29 19:23:02 2016 +0200
>
>      omap3isp: handle -EPROBE_DEFER for vdds_csib
>
>      omap3isp may be initialized before the regulator's driver has been
>      loaded resulting in vdds_csib=NULL. Fix this by handling -EPROBE_DEFER
>      for vdds_csib.
>
>      Signed-Off-By: Sebastian Reichel <sre@kernel.org>
>
> diff --git a/drivers/media/platform/omap3isp/ispccp2.c b/drivers/media/platform/omap3isp/ispccp2.c
> index 833eed411886..2d1463a72d6a 100644
> --- a/drivers/media/platform/omap3isp/ispccp2.c
> +++ b/drivers/media/platform/omap3isp/ispccp2.c
> @@ -1167,6 +1167,8 @@ int omap3isp_ccp2_init(struct isp_device *isp)
>   	if (isp->revision == ISP_REVISION_2_0) {
>   		ccp2->vdds_csib = devm_regulator_get(isp->dev, "vdds_csib");
>   		if (IS_ERR(ccp2->vdds_csib)) {
> +			if (PTR_ERR(ccp2->vdds_csib) == -EPROBE_DEFER)
> +				return -EPROBE_DEFER;
>   			dev_dbg(isp->dev,
>   				"Could not get regulator vdds_csib\n");
>   			ccp2->vdds_csib = NULL;
>

Sakari, how we're going to proceed, it seems there are a couple of 
patches in the series which can be directly upstreamed, how's that gonna 
happen? IOW - I don't know how this RFC stuff works, are there any docs 
I can use to educate myself?

Thanks,
Ivo
