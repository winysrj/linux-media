Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f177.google.com ([209.85.217.177]:58468 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755385Ab3EQUxi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 17 May 2013 16:53:38 -0400
Received: by mail-lb0-f177.google.com with SMTP id o10so582368lbi.8
        for <linux-media@vger.kernel.org>; Fri, 17 May 2013 13:53:36 -0700 (PDT)
Message-ID: <519698D8.7050107@cogentembedded.com>
Date: Sat, 18 May 2013 00:53:44 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: mchehab@redhat.com, linux-media@vger.kernel.org,
	magnus.damm@gmail.com, linux-sh@vger.kernel.org,
	phil.edworthy@renesas.com, matsu@igel.co.jp,
	vladimir.barinov@cogentembedded.com
Subject: Re: [PATCH v4] V4L2: soc_camera: Renesas R-Car VIN driver
References: <201305150256.36966.sergei.shtylyov@cogentembedded.com> <Pine.LNX.4.64.1305150742470.10596@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1305150742470.10596@axis700.grange>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello.

On 05/15/2013 09:44 AM, Guennadi Liakhovetski wrote:

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
>> *if* statement  and  used 'bool' values instead of 0/1 where necessary, done
>> some reformatting and clarified some comments.]
>> Signed-off-by: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
>>
>> ---
>> This patch is against the 'media_tree.git' repo.
>>
>> Changes since version 3:
> Why aren't you using this:
>
> http://thread.gmane.org/gmane.linux.drivers.video-input-infrastructure/63820
>
> ?
>
> Thanks
> Guennadi

     We have now incorporated the needed changes and I will post the 
updated patch.
I must note that you haven't managed to get rid of all CEU references in 
the shared
soc_scale_crop.c module, both in the variable names and in the comments.

WBR, Sergei

