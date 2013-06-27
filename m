Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f54.google.com ([209.85.215.54]:61790 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754142Ab3F0X7O (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 27 Jun 2013 19:59:14 -0400
Received: by mail-la0-f54.google.com with SMTP id ec20so1489801lab.41
        for <linux-media@vger.kernel.org>; Thu, 27 Jun 2013 16:59:12 -0700 (PDT)
Message-ID: <51CCD1B7.3040009@cogentembedded.com>
Date: Fri, 28 Jun 2013 03:58:47 +0400
From: Vladimir Barinov <vladimir.barinov@cogentembedded.com>
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
	mchehab@redhat.com, linux-media@vger.kernel.org,
	magnus.damm@gmail.com, linux-sh@vger.kernel.org,
	phil.edworthy@renesas.com, matsu@igel.co.jp
Subject: Re: [PATCH v7] V4L2: soc_camera: Renesas R-Car VIN driver
References: <201306220052.30572.sergei.shtylyov@cogentembedded.com> <Pine.LNX.4.64.1306260925210.8856@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1306260925210.8856@axis700.grange>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

Guennadi Liakhovetski wrote:
> Hi Sergei
>
> On Sat, 22 Jun 2013, Sergei Shtylyov wrote:
>
>   
>> From: Vladimir Barinov <vladimir.barinov@cogentembedded.com>
>>
>> Add Renesas R-Car VIN (Video In) V4L2 driver.
>>
>> Based on the patch by Phil Edworthy <phil.edworthy@renesas.com>.
>>
>> Signed-off-by: Vladimir Barinov <vladimir.barinov@cogentembedded.com>
>> [Sergei: removed deprecated IRQF_DISABLED flag, reordered/renamed 'enum chip_id'
>> values, reordered rcar_vin_id_table[] entries,  removed senseless parens from
>> to_buf_list() macro, used ALIGN() macro in rcar_vin_setup(), added {} to the
>> *if* statement  and used 'bool' values instead of 0/1 where necessary, removed
>> unused macros, done some reformatting and clarified some comments.]
>> Signed-off-by: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
>>     
>
> Reviewing this iteration of the patch is still on my todo, in the meantime 
> you might verify whether it works on top of the for-3.11-3 branch of my
>
> http://git.linuxtv.org/gliakhovetski/v4l-dvb.git
>
> git-tree, or "next" after it's been pulled by Mauro and pushed upstream. 
> With that branch you shouldn't need any additional patches andy more.
>   
Actually we need to apply/merge more patches here that enables VIN 
support on separate platform (like pinctrl/clock/setup/) :)

Despite of above the rcar_vin driver works fine on Marzen board in 
v4l-dvb.git after adding soc_camera_host_ops clock_start/clock_stop.

Regards,
Vladimir
