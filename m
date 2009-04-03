Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f169.google.com ([209.85.218.169]:50240 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756890AbZDCKrJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 3 Apr 2009 06:47:09 -0400
Received: by bwz17 with SMTP id 17so906240bwz.37
        for <linux-media@vger.kernel.org>; Fri, 03 Apr 2009 03:47:05 -0700 (PDT)
Message-ID: <49D5E8A5.1080608@gmail.com>
Date: Fri, 03 Apr 2009 13:44:53 +0300
From: Darius Augulis <augulis.darius@gmail.com>
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Sascha Hauer <s.hauer@pengutronix.de>,
	paulius.zaleckas@teltonika.lt
Subject: Re: [PATCH V3] Add camera (CSI) driver for MX1
References: <20090403080923.3222.80609.stgit@localhost.localdomain> <Pine.LNX.4.64.0904031204280.4729@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.0904031204280.4729@axis700.grange>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Guennadi Liakhovetski wrote:
> Ok, we're almost there:-) Should be the last iteration.
>
> On Fri, 3 Apr 2009, Darius Augulis wrote:
>
>   
>> From: Paulius Zaleckas <paulius.zaleckas@teltonika.lt>
>>
>> Changelog since V2:
>> - My signed-off line added
>> - Makefile updated
>> - .init and .exit removed from pdata
>> - includes sorted
>> - Video memory limit added
>> - Pointers in free_buffer() fixed
>> - Indentation fixed
>> - Spinlocks added
>> - PM implementation removed
>> - Added missed clk_put()
>> - pdata test added
>> - CSI device renamed
>> - Platform flags fixed
>> - "i.MX" replaced by "MX1" in debug prints
>>     
>
> I usually put such changelogs below the "---" line, so it doesn't appear 
> in the git commit message, and here you just put a short description of 
> the patch.
>
>   
>> Signed-off-by: Darius Augulis <augulis.darius@gmail.com>
>> Signed-off-by: Paulius Zaleckas <paulius.zaleckas@teltonika.lt>
>> ---
>>     
>
> [snip]
>
>   
>> diff --git a/arch/arm/plat-mxc/include/mach/memory.h b/arch/arm/plat-mxc/include/mach/memory.h
>> index e0783e6..7113b3e 100644
>> --- a/arch/arm/plat-mxc/include/mach/memory.h
>> +++ b/arch/arm/plat-mxc/include/mach/memory.h
>> @@ -24,4 +24,12 @@
>>  #define PHYS_OFFSET		UL(0x80000000)
>>  #endif
>>  
>> +#if defined(CONFIG_MX1_VIDEO)
>>     
>
> This #ifdef is not needed any more now, the file is not compiled if 
> CONFIG_MX1_VIDEO is not defined.
>   
this header file is included by arch/arm/include/asm/memory.h
By default dma bufer size is only 2Mbytes. If we remove this ifdef, this 
bufer will be increased to re-defined size.
Therefore I suggest to leave this ifdef.

>   
>> +	/* Make choises, based on platform choice */
>> +	if ((common_flags & SOCAM_VSYNC_ACTIVE_HIGH) &&
>> +		(common_flags & SOCAM_VSYNC_ACTIVE_LOW)) {
>> +			if (pcdev->pdata->flags & MX1_CAMERA_VSYNC_HIGH)
>> +				common_flags &= ~SOCAM_VSYNC_ACTIVE_LOW;
>> +			else
>> +				common_flags &= ~SOCAM_VSYNC_ACTIVE_HIGH;
>> +	}
>> +
>> +	if ((common_flags & SOCAM_PCLK_SAMPLE_RISING) &&
>> +		(common_flags & SOCAM_PCLK_SAMPLE_FALLING)) {
>> +			if (pcdev->pdata->flags & MX1_CAMERA_PCLK_RISING)
>> +				common_flags &= ~SOCAM_PCLK_SAMPLE_FALLING;
>> +			else
>> +				common_flags &= ~SOCAM_PCLK_SAMPLE_RISING;
>> +	}
>> +
>> +	if ((common_flags & SOCAM_DATA_ACTIVE_HIGH) &&
>> +		(common_flags & SOCAM_DATA_ACTIVE_LOW)) {
>> +			if (pcdev->pdata->flags & MX1_CAMERA_DATA_HIGH)
>> +				common_flags &= ~SOCAM_DATA_ACTIVE_LOW;
>> +			else
>> +				common_flags &= ~SOCAM_DATA_ACTIVE_HIGH;
>> +	}
>>     
>
> In all three clauses above pdata can be NULL.
>
> Thanks
> Guennadi
> ---
> Guennadi Liakhovetski, Ph.D.
> Freelance Open-Source Software Developer
>
>   

