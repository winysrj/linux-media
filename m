Return-path: <linux-media-owner@vger.kernel.org>
Received: from web32107.mail.mud.yahoo.com ([68.142.207.121]:24186 "HELO
	web32107.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752486AbZCBOuI convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 2 Mar 2009 09:50:08 -0500
Message-ID: <26939.71342.qm@web32107.mail.mud.yahoo.com>
Date: Mon, 2 Mar 2009 06:50:04 -0800 (PST)
From: Agustin <gatoguan-os@yahoo.com>
Reply-To: gatoguan-os@yahoo.com
Subject: Re: [PATCH/RFC 1/4] ipu_idmac: code clean-up and robustness improvements
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Linux Arm Kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Dan Williams <dan.j.williams@intel.com>
In-Reply-To: <Pine.LNX.4.64.0902282253210.20549@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--- On 28/2/09, Guennadi Liakhovetski wrote:
> On Sat, 28 Feb 2009, Agustin wrote:
>> 
>> Hi Guennadi,
>> 
>> I am having trouble while probing ipu idmac:
>> 
>> At boot:
>> ipu-core: probe of ipu-core failed with error -22
>> 
>> Which is apparently happening at ipu_idmac:1706:
>>    1695 static int __init ipu_probe(struct platform_device *pdev)
>>    ...
>>    1703         mem_ipu = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>>    1704         mem_ic  = platform_get_resource(pdev, IORESOURCE_MEM, 1);
>>    1705         if (!pdata || !mem_ipu || !mem_ic)
>>    1706                 return -EINVAL;
>> 
>> Later on, I get error 16, "Device or resource busy" on
VIDIOC_S_FMT, apparently because mx3_camera can't get its dma channel.
>> 
>> Any clue?
>
>Are you sure it is failing here, have you verified with a printk? If it is 
>indeed this place, then you probably didn't register all required 
>resources in your platfom code. Look at my platform-bindings patch.
>
>Thanks
>Guennadi

Thanks, I was missing "mx3_ipu_data" struct at devices.c file. It happened because I had git-pulled Valentin's older patch from mxc-master which made your patch fail a few chunks, then the code was very similar when I checked it visually.

Now let's see if I can get back on track with my new hardware design and take those pics...

Regards,
--Agustín.

