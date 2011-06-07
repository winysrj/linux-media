Return-path: <mchehab@pedra>
Received: from bear.ext.ti.com ([192.94.94.41]:40365 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750899Ab1FGJsd (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 7 Jun 2011 05:48:33 -0400
Received: from dbdp20.itg.ti.com ([172.24.170.38])
	by bear.ext.ti.com (8.13.7/8.13.7) with ESMTP id p579mUMI010308
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Tue, 7 Jun 2011 04:48:32 -0500
Received: from dbde70.ent.ti.com (localhost [127.0.0.1])
	by dbdp20.itg.ti.com (8.13.8/8.13.8) with ESMTP id p579mTQx012851
	for <linux-media@vger.kernel.org>; Tue, 7 Jun 2011 15:18:29 +0530 (IST)
Message-ID: <4DEDF5A3.1090708@ti.com>
Date: Tue, 7 Jun 2011 15:25:47 +0530
From: Archit Taneja <archit@ti.com>
MIME-Version: 1.0
To: "Hiremath, Vaibhav" <hvaibhav@ti.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [PATCH 1/2] OMAP_VOUT: CLEANUP: Move some functions and macros
 from omap_vout
References: <1306479677-23540-1-git-send-email-archit@ti.com> <1306479677-23540-2-git-send-email-archit@ti.com> <19F8576C6E063C45BE387C64729E739404E2EEF11C@dbde02.ent.ti.com>
In-Reply-To: <19F8576C6E063C45BE387C64729E739404E2EEF11C@dbde02.ent.ti.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi,

On Tuesday 07 June 2011 02:35 PM, Hiremath, Vaibhav wrote:
>> -----Original Message-----
>> From: Taneja, Archit
>> Sent: Friday, May 27, 2011 12:31 PM
>> To: linux-media@vger.kernel.org
>> Cc: Hiremath, Vaibhav; Taneja, Archit
>> Subject: [PATCH 1/2] OMAP_VOUT: CLEANUP: Move some functions and macros
>> from omap_vout
>>
> [Hiremath, Vaibhav] You may want to give patch revision here.

I don't think it makes sense to give the old revisions anymore, this 
patch set had been dormant since last year. I'll add revisions for the 
later versions of this set.

> Cosmetic comment -
>
> Consider changing the subject line to something -
>
> OMAP_VOUT: CLEANUP: Move generic functions and macros to common files
>
>
>> Move some inline functions from omap_vout.c to omap_voutdef.h and
>> independent
>> functions like omap_vout_alloc_buffer/omap_vout_free_buffer to
>> omap_voutlib.c.
>>
> [Hiremath, Vaibhav] Ditto here, word "some" doesn't convey anything.

Okay.

>

<snip>

>>
>>   /*
>> - * Return true if rotation is 90 or 270
>> - */
>> -static inline int rotate_90_or_270(const struct omap_vout_device *vout)
>> -{
>> -	return (vout->rotation == dss_rotation_90_degree ||
>> -			vout->rotation == dss_rotation_270_degree);
>> -}
>> -
>> -/*
>> - * Return true if rotation is enabled
>> - */
>> -static inline int rotation_enabled(const struct omap_vout_device *vout)
>> -{
>> -	return vout->rotation || vout->mirror;
>> -}
>> -
> [Hiremath, Vaibhav] As part of this cleanup I would suggest to rename these API's to self descriptive, something like -
>
> rotation_enabled =>  is_rotation_enabled
> rotate_90_or_270 =>  is_rotation_90_or_270

This patch just moves these functions. Moving it to another file and 
then changing the names in the same patch will make things messy. I'll 
do this in a separate patch in the same patch set.

>
>
>> -/*

<snip>

>> diff --git a/drivers/media/video/omap/omap_voutlib.h
>> b/drivers/media/video/omap/omap_voutlib.h
>> index a60b16e..1d722be 100644
>> --- a/drivers/media/video/omap/omap_voutlib.h
>> +++ b/drivers/media/video/omap/omap_voutlib.h
>> @@ -30,5 +30,7 @@ extern int omap_vout_new_window(struct v4l2_rect *crop,
>>   extern void omap_vout_new_format(struct v4l2_pix_format *pix,
>>   		struct v4l2_framebuffer *fbuf, struct v4l2_rect *crop,
>>   		struct v4l2_window *win);
>> +extern unsigned long omap_vout_alloc_buffer(u32 buf_size, u32
>> *phys_addr);
>> +extern void omap_vout_free_buffer(unsigned long virtaddr, u32 buf_size);
>>   #endif	/* #ifndef OMAP_VOUTLIB_H */
>>
> [Hiremath, Vaibhav] We do not need to use externs here; this should be another cleanup candidate which can be done with this patch series.

Will fix this.

Archit
