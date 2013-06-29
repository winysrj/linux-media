Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f178.google.com ([209.85.217.178]:49692 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752186Ab3F2L2c (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 29 Jun 2013 07:28:32 -0400
Received: by mail-lb0-f178.google.com with SMTP id y6so1465223lbh.9
        for <linux-media@vger.kernel.org>; Sat, 29 Jun 2013 04:28:30 -0700 (PDT)
Message-ID: <51CEC4C4.9080803@cogentembedded.com>
Date: Sat, 29 Jun 2013 15:28:04 +0400
From: Vladimir Barinov <vladimir.barinov@cogentembedded.com>
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
	mchehab@redhat.com, linux-media@vger.kernel.org,
	magnus.damm@gmail.com, linux-sh@vger.kernel.org,
	phil.edworthy@renesas.com, matsu@igel.co.jp
Subject: Re: [PATCH v7] V4L2: soc_camera: Renesas R-Car VIN driver
References: <201306220052.30572.sergei.shtylyov@cogentembedded.com> <Pine.LNX.4.64.1306260925210.8856@axis700.grange> <51CCD1B7.3040009@cogentembedded.com> <51CDC3BE.1040603@cogentembedded.com> <Pine.LNX.4.64.1306291247440.8358@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1306291247440.8358@axis700.grange>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

Guennadi Liakhovetski wrote:
> Hi Sergei
>
> On Fri, 28 Jun 2013, Sergei Shtylyov wrote:
>
>   
>> Hello.
>>
>> On 06/28/2013 03:58 AM, Vladimir Barinov wrote:
>>
>>     
>>>>> From: Vladimir Barinov <vladimir.barinov@cogentembedded.com>
>>>>>           
>>>>> Add Renesas R-Car VIN (Video In) V4L2 driver.
>>>>>           
>>>>> Based on the patch by Phil Edworthy <phil.edworthy@renesas.com>.
>>>>>           
>>>>> Signed-off-by: Vladimir Barinov <vladimir.barinov@cogentembedded.com>
>>>>> [Sergei: removed deprecated IRQF_DISABLED flag, reordered/renamed
>>>>> 'enum chip_id'
>>>>> values, reordered rcar_vin_id_table[] entries,  removed senseless
>>>>> parens from
>>>>> to_buf_list() macro, used ALIGN() macro in rcar_vin_setup(), added {}
>>>>> to the
>>>>> *if* statement  and used 'bool' values instead of 0/1 where
>>>>> necessary, removed
>>>>> unused macros, done some reformatting and clarified some comments.]
>>>>> Signed-off-by: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
>>>>>           
>>>> Reviewing this iteration of the patch is still on my todo, in the
>>>> meantime you might verify whether it works on top of the for-3.11-3
>>>> branch of my
>>>>         
>>>> http://git.linuxtv.org/gliakhovetski/v4l-dvb.git
>>>>         
>>>> git-tree, or "next" after it's been pulled by Mauro and pushed
>>>> upstream. With that branch you shouldn't need any additional patches
>>>> andy more.
>>>>         
>>> Actually we need to apply/merge more patches here that enables VIN
>>> support on separate platform (like pinctrl/clock/setup/) :)
>>>       
>>> Despite of above the rcar_vin driver works fine on Marzen board in
>>> v4l-dvb.git after adding soc_camera_host_ops clock_start/clock_stop.
>>>       
>>    Guennadi, does that mean that we should rebase the driver to the branch
>> that you've named now?
>>     
>
> IIUC, your last couple of versions were already developed on top of 
> v4l2-clk + v4l2-asybc + soc_scale_crop patches, right? But those patches 
> were out of tree, and thus unstable. Whereas now they've hit Mauro's tree 
> at git.linuxtv.org and are about to be pulled into "next." So, you don't 
> need anymore to apply any external patches, you will be able to just 
> develop on top of "next." I presume, this should make your work easier, 
>   
Correct, I was meaning about clock/mux/setup patches against platform 
code (arch/arm/mash-shmobile)
> not harder. Just please make sure to double-check your stack on top of 
> "next" to make sure it still works. And let's try to get your driver ready 
> for 3.12.
>   
Ok

Regards,
Vladimir
