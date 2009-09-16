Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:53107 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753758AbZIPW2o convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Sep 2009 18:28:44 -0400
From: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hverkuil@xs4all.nl>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Date: Wed, 16 Sep 2009 17:28:38 -0500
Subject: RE: RFCv2: Media controller proposal
Message-ID: <A69FA2915331DC488A831521EAE36FE40155157118@dlee06.ent.ti.com>
References: <200909100913.09065.hverkuil@xs4all.nl>
	<200909120039.50343.hverkuil@xs4all.nl>
	<20090916151520.53537714@pedra.chehab.org>
	<200909162121.16606.hverkuil@xs4all.nl>
 <20090916175043.0d462a18@pedra.chehab.org>
In-Reply-To: <20090916175043.0d462a18@pedra.chehab.org>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

>
>> And as I explained above, a v4l2_subdev just implements an interface. It
>has
>> no relation to devices. And yes, I'm beginning to agree with you that
>subdevice
>> was a bad name because it suggested something that it simply isn't.
>>
>> That said, I also see some advantages in doing this. For statistics or
>> histogram sub-devices you can implement a read() call to read the data
>> instead of using ioctl. It is more flexible in that respect.
>
>I think this will be more flexible and will be less complex than creating a
>proxy
>device. For example, as you'll be directly addressing a device, you don't
>need to
>have any locking to avoid the risk that different threads accessing
>different
>sub-devices at the same time would result on a command sending to the wrong
>device.
>So, both kernel driver and userspace app can be simpler.


Not really. User application trying to parse the output of a histogram which
really will about 4K in size as described by Laurent. Imagine application does lot of parsing to decode the values thrown by the sysfs. Again on different platform, they can be different formats. With ioctl, each of these platforms provides api to access them and it is much simpler to use. Same for configuring IPIPE on DM355/DM365 where there are hundreds of parameters and write a lot of code in sysfs to parse each of these variables. I can see it as a nightmare for user space library or application developer.

>
>> This is definitely an interesting topic that can be discussed both during
>> the LPC and here on the list.
>>
>> Regards,
>>
>> 	Hans
>>
>
>
>
>
>Cheers,
>Mauro
>--
>To unsubscribe from this list: send the line "unsubscribe linux-media" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html

