Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:1878 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751152AbZG3O4h (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Jul 2009 10:56:37 -0400
Message-ID: <ecf13427a4977f3ca5e778a6152ad17f.squirrel@webmail.xs4all.nl>
In-Reply-To: <A69FA2915331DC488A831521EAE36FE401450FB11F@dlee06.ent.ti.com>
References: <10799.62.70.2.252.1248852719.squirrel@webmail.xs4all.nl>
    <200907292352.00179.hverkuil@xs4all.nl>
    <A69FA2915331DC488A831521EAE36FE401450FAFD0@dlee06.ent.ti.com>
    <200907300831.39579.hverkuil@xs4all.nl>
    <A69FA2915331DC488A831521EAE36FE401450FB0C7@dlee06.ent.ti.com>
    <de79b8390a2a633a34370bcc666d2914.squirrel@webmail.xs4all.nl>
    <A69FA2915331DC488A831521EAE36FE401450FB11F@dlee06.ent.ti.com>
Date: Thu, 30 Jul 2009 16:56:36 +0200
Subject: RE: How to save number of times using memcpy?
From: "Hans Verkuil" <hverkuil@xs4all.nl>
To: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
Cc: "Laurent Pinchart" <laurent.pinchart@skynet.be>,
	"Mauro Carvalho Chehab" <mchehab@infradead.org>,
	"Dongsoo, Nathaniel Kim" <dongsoo.kim@gmail.com>,
	"v4l2_linux" <linux-media@vger.kernel.org>,
	"Dongsoo Kim" <dongsoo45.kim@samsung.com>,
	=?iso-8859-1?Q?=C3=AB=C2=B0=E2=80=A2=C3=AA=C2=B2=C2=BD=C3=AB=C2=AF=C2?=
	 =?iso-8859-1?Q?=BC?= <kyungmin.park@samsung.com>,
	"jm105.lee@samsung.com" <jm105.lee@samsung.com>,
	=?iso-8859-1?Q?=C3=AC=EF=BF=BD=C2=B4=C3=AC=E2=80=9E=C2=B8=C3=AB=C2=AC?=
	 =?iso-8859-1?Q?=C2=B8?= <semun.lee@samsung.com>,
	=?iso-8859-1?Q?=C3=AB=C5=92=E2=82=AC=C3=AC=EF=BF=BD=C2=B8=C3=AA=C2=B8?=
	 =?iso-8859-1?Q?=C2=B0?= <inki.dae@samsung.com>,
	=?iso-8859-1?Q?=C3=AA=C2=B9=E2=82=AC=C3=AD=CB=9C=E2=80=A2=C3=AC=C2=A4?=
	 =?iso-8859-1?Q?=E2=82=AC?= <riverful.kim@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


> Mauro,
>
> What do you suggest for this? Could we allocate coherent device memory
> using dma_declare_coherent_memory() ? This seems the only way to do it
> unless, video buffer layer does this when initializing the queue.

Or to be able to override the memory allocation in some way. Large
contiguous buffers are hard to get once a system has been running for a
while, so at least some buffers must be allocated up front and not on the
first open() or VIDIOC_REQBUFS call. I'm surprised that this issue hasn't
cropped up before.

Regards,

         Hans

>
> Murali Karicheri
> Software Design Engineer
> Texas Instruments Inc.
> Germantown, MD 20874
> Phone : 301-515-3736
> email: m-karicheri2@ti.com
>
>>-----Original Message-----
>>From: linux-media-owner@vger.kernel.org [mailto:linux-media-
>>owner@vger.kernel.org] On Behalf Of Hans Verkuil
>>Sent: Thursday, July 30, 2009 10:26 AM
>>To: Karicheri, Muralidharan
>>Cc: Laurent Pinchart; Mauro Carvalho Chehab; Dongsoo, Nathaniel Kim;
>>v4l2_linux; Dongsoo Kim; ë°•ê²½ë¯¼; jm105.lee@samsung.com;
>>ì�´ì„¸ë¬¸; ëŒ€ì�¸ê¸°; ê¹€�˜•ì¤€
>>Subject: RE: How to save number of times using memcpy?
>>
>>
>>> Hans,
>>>
>>> I don't see the code you are referring to. Here is the probe() from the
>>> next branch of v4l-dvb. Could you point out the code that does the
>>> allocation of frame buffers ? I had used this code as reference when
>>> developing vpfe capture driver.
>>>
>>> Murali
>>
>>My apologies, I got it mixed up with older versions of this driver. I see
>>that it now uses videobuf-dma-contig. This is going to be a real problem
>>since this makes it impossible (or at least very hard) to allocate memory
>>up front. I'm no expert on videobuf, but this is something that should be
>>addressed, especially in the dma-contig case.
>>
>>Regards,
>>
>>          Hans
>>
>>--
>>Hans Verkuil - video4linux developer - sponsored by TANDBERG
>>
>>--
>>To unsubscribe from this list: send the line "unsubscribe linux-media" in
>>the body of a message to majordomo@vger.kernel.org
>>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
>


-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG

