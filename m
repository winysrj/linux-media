Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:1387 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750938AbZG3O0G (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Jul 2009 10:26:06 -0400
Message-ID: <de79b8390a2a633a34370bcc666d2914.squirrel@webmail.xs4all.nl>
In-Reply-To: <A69FA2915331DC488A831521EAE36FE401450FB0C7@dlee06.ent.ti.com>
References: <10799.62.70.2.252.1248852719.squirrel@webmail.xs4all.nl>
    <200907292352.00179.hverkuil@xs4all.nl>
    <A69FA2915331DC488A831521EAE36FE401450FAFD0@dlee06.ent.ti.com>
    <200907300831.39579.hverkuil@xs4all.nl>
    <A69FA2915331DC488A831521EAE36FE401450FB0C7@dlee06.ent.ti.com>
Date: Thu, 30 Jul 2009 16:26:05 +0200
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
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


> Hans,
>
> I don't see the code you are referring to. Here is the probe() from the
> next branch of v4l-dvb. Could you point out the code that does the
> allocation of frame buffers ? I had used this code as reference when
> developing vpfe capture driver.
>
> Murali

My apologies, I got it mixed up with older versions of this driver. I see
that it now uses videobuf-dma-contig. This is going to be a real problem
since this makes it impossible (or at least very hard) to allocate memory
up front. I'm no expert on videobuf, but this is something that should be
addressed, especially in the dma-contig case.

Regards,

          Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG

