Return-path: <linux-media-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:49394 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751855AbZG3Oa1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Jul 2009 10:30:27 -0400
From: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Laurent Pinchart <laurent.pinchart@skynet.be>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	"Dongsoo, Nathaniel Kim" <dongsoo.kim@gmail.com>,
	v4l2_linux <linux-media@vger.kernel.org>,
	Dongsoo Kim <dongsoo45.kim@samsung.com>,
	=?Windows-1252?B?w6vCsOKAosOqwrLCvcOrwq/CvA==?=
	<kyungmin.park@samsung.com>,
	"jm105.lee@samsung.com" <jm105.lee@samsung.com>,
	=?Windows-1252?B?w6zvv73CtMOs4oCewrjDq8Kswri=?=
	<semun.lee@samsung.com>,
	=?Windows-1252?B?w6vFkuKCrMOs77+9wrjDqsK4wrC=?=
	<inki.dae@samsung.com>,
	=?Windows-1252?B?w6rCueKCrMOty5zigKLDrMKk4oKs?=
	<riverful.kim@samsung.com>
Date: Thu, 30 Jul 2009 09:30:11 -0500
Subject: RE: How to save number of times using memcpy?
Message-ID: <A69FA2915331DC488A831521EAE36FE401450FB11F@dlee06.ent.ti.com>
References: <10799.62.70.2.252.1248852719.squirrel@webmail.xs4all.nl>
    <200907292352.00179.hverkuil@xs4all.nl>
    <A69FA2915331DC488A831521EAE36FE401450FAFD0@dlee06.ent.ti.com>
    <200907300831.39579.hverkuil@xs4all.nl>
    <A69FA2915331DC488A831521EAE36FE401450FB0C7@dlee06.ent.ti.com>
 <de79b8390a2a633a34370bcc666d2914.squirrel@webmail.xs4all.nl>
In-Reply-To: <de79b8390a2a633a34370bcc666d2914.squirrel@webmail.xs4all.nl>
Content-Language: en-US
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro,

What do you suggest for this? Could we allocate coherent device memory using dma_declare_coherent_memory() ? This seems the only way to do it unless, video buffer layer does this when initializing the queue.

Murali Karicheri
Software Design Engineer
Texas Instruments Inc.
Germantown, MD 20874
Phone : 301-515-3736
email: m-karicheri2@ti.com

>-----Original Message-----
>From: linux-media-owner@vger.kernel.org [mailto:linux-media-
>owner@vger.kernel.org] On Behalf Of Hans Verkuil
>Sent: Thursday, July 30, 2009 10:26 AM
>To: Karicheri, Muralidharan
>Cc: Laurent Pinchart; Mauro Carvalho Chehab; Dongsoo, Nathaniel Kim;
>v4l2_linux; Dongsoo Kim; ë°•ê²½ë¯¼; jm105.lee@samsung.com;
>ì�´ì„¸ë¬¸; ëŒ€ì�¸ê¸°; ê¹€�˜•ì¤€
>Subject: RE: How to save number of times using memcpy?
>
>
>> Hans,
>>
>> I don't see the code you are referring to. Here is the probe() from the
>> next branch of v4l-dvb. Could you point out the code that does the
>> allocation of frame buffers ? I had used this code as reference when
>> developing vpfe capture driver.
>>
>> Murali
>
>My apologies, I got it mixed up with older versions of this driver. I see
>that it now uses videobuf-dma-contig. This is going to be a real problem
>since this makes it impossible (or at least very hard) to allocate memory
>up front. I'm no expert on videobuf, but this is something that should be
>addressed, especially in the dma-contig case.
>
>Regards,
>
>          Hans
>
>--
>Hans Verkuil - video4linux developer - sponsored by TANDBERG
>
>--
>To unsubscribe from this list: send the line "unsubscribe linux-media" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html

