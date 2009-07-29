Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:53489 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753321AbZG2WzA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Jul 2009 18:55:00 -0400
From: Laurent Pinchart <laurent.pinchart@skynet.be>
To: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
Subject: Re: How to save number of times using memcpy?
Date: Thu, 30 Jul 2009 00:56:31 +0200
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	"Dongsoo, Nathaniel Kim" <dongsoo.kim@gmail.com>,
	"v4l2_linux" <linux-media@vger.kernel.org>,
	Dongsoo Kim <dongsoo45.kim@samsung.com>,
	=?euc-kr?q?=B9=DA=B0=E6=B9=CE?= <kyungmin.park@samsung.com>,
	"jm105.lee@samsung.com" <jm105.lee@samsung.com>,
	=?euc-kr?q?=C0=CC=BC=BC=B9=AE?= <semun.lee@samsung.com>,
	=?euc-kr?q?=B4=EB=C0=CE=B1=E2?= <inki.dae@samsung.com>,
	=?euc-kr?q?=B1=E8=C7=FC=C1=D8?= <riverful.kim@samsung.com>
References: <5e9665e10907271756l114f6e6ekeefa04d976b95c66@mail.gmail.com> <200907292106.11862.laurent.pinchart@skynet.be> <A69FA2915331DC488A831521EAE36FE401450FAF9A@dlee06.ent.ti.com>
In-Reply-To: <A69FA2915331DC488A831521EAE36FE401450FAF9A@dlee06.ent.ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="euc-kr"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907300056.32787.laurent.pinchart@skynet.be>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wednesday 29 July 2009 23:37:16 Karicheri, Muralidharan wrote:
> Laurent,
>
> Ok, now I understand how /dev/mem works. This should works as well. But one
> of our apps engineer mentioned some problems in using /dev/mem related to
> mmap. Did you encounter any issues while using this method?

I haven't tried to myself, it's just an idea that I'm throwing in the 
discussion.

> The driver is basically written to allocate multiple pools and buffers per
> pool to satisfies various memory allocation requirements inside our TI SDK.

Are you referring to the cmemk driver ? It seems to really be a quick hack to 
short-circuit all the Linux kernel memory management infrastructure and let 
userspace allocate physical memory from a private pool of reserved SDRAM. I'd 
be quite surprised if something like that ever ends up in mainline.

Regards,

Laurent Pinchart

