Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:1225 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751091AbaF0Mx7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Jun 2014 08:53:59 -0400
Message-ID: <53AD6949.4070403@xs4all.nl>
Date: Fri, 27 Jun 2014 14:53:29 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Bernhard Praschinger <shadowlord@utanet.at>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>
CC: MJPEG-tools user list <mjpeg-users@lists.sourceforge.net>,
	kernel-janitors@vger.kernel.org, linux-media@vger.kernel.org,
	dan.carpenter@oracle.com
Subject: Re: [Mjpeg-users] [patch] [media] zoran: remove duplicate ZR050_MO_COMP
 define
References: <20140609152135.GQ9600@mwanda> <5399E357.3040203@utanet.at>
In-Reply-To: <5399E357.3040203@utanet.at>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Bernhard,

On 06/12/2014 07:28 PM, Bernhard Praschinger wrote:
> Hallo
>
> More than 15 years have passed since the first working module for a
> zoran chipset based PCI card existed. Well not included into the
> Linux kernel at that time. According to my experience, the driver
> started to make problems when 64 Bit and more than 2GB Ram became
> popular. In May 2011 there was a patch available that made the cards
> working in machines with more than 2GB Ram, and AMD&Intel x64
> architectures. According to my information that patch did not make it
> into the linux kernel (the Patch was for the Linux 2.6.38 Kernel)

As far as I know it works fine on machines with a lot of memory, at
least the last time I tested it it was OK (with a 3.<something> kernel).

> So people spend time looking at code that does not work (well it
> compiles and does not cause troubles), and send patches the world
> will never honor.

I'll honor them. I still have zoran hardware and it is on my todo list
of drivers to update to the latest frameworks.

> I haven't had a question related to a zoran based card's in years. So
> I'm quite sure there are not much users out there that use a zoran
> based video cards in a up to date environment.
>
> Because of that I would really suggest that somebody removes the whole zoran driver from the linux kernel.

It's not blocking new development, so there is no need to remove it.
Besides, I have zoran hardware, so even if it is blocking new developments
I should be able to fix it.

Regards,

	Hans

>
> Dan Carpenter wrote:
>> The ZR050_MO_COMP define is cut and pasted twice so we can delete the
>> second instance.
>>
>> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
>>
>> diff --git a/drivers/media/pci/zoran/zr36050.h b/drivers/media/pci/zoran/zr36050.h
>> index 9f52f0c..ea083ad 100644
>> --- a/drivers/media/pci/zoran/zr36050.h
>> +++ b/drivers/media/pci/zoran/zr36050.h
>> @@ -126,7 +126,6 @@ struct zr36050 {
>>   /* zr36050 mode register bits */
>>
>>   #define ZR050_MO_COMP                0x80
>> -#define ZR050_MO_COMP                0x80
>>   #define ZR050_MO_ATP                 0x40
>>   #define ZR050_MO_PASS2               0x20
>>   #define ZR050_MO_TLM                 0x10
>>
>> ------------------------------------------------------------------------------
>> HPCC Systems Open Source Big Data Platform from LexisNexis Risk Solutions
>> Find What Matters Most in Your Big Data with HPCC Systems
>> Open Source. Fast. Scalable. Simple. Ideal for Dirty Data.
>> Leverages Graph Analysis for Fast Processing & Easy Data Exploration
>> http://p.sf.net/sfu/hpccsystems
>> _______________________________________________
>> Mjpeg-users mailing list
>> Mjpeg-users@lists.sourceforge.net
>> https://lists.sourceforge.net/lists/listinfo/mjpeg-users
>
> Kind Regards
> Bernhard Praschinger
> Docwriter, probably the last mjpegtools maintainer
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
