Return-path: <linux-media-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:51350 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751686AbaKKHuF (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Nov 2014 02:50:05 -0500
Message-ID: <5461BF75.8000808@ti.com>
Date: Tue, 11 Nov 2014 13:19:09 +0530
From: Sekhar Nori <nsekhar@ti.com>
MIME-Version: 1.0
To: Prabhakar Lad <prabhakar.csengg@gmail.com>,
	Boris Brezillon <boris.brezillon@free-electrons.com>
CC: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media <linux-media@vger.kernel.org>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	LAK <linux-arm-kernel@lists.infradead.org>,
	linux-api <linux-api@vger.kernel.org>,
	OSUOSL Drivers <devel@driverdev.osuosl.org>,
	LKML <linux-kernel@vger.kernel.org>,
	LDOC <linux-doc@vger.kernel.org>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH v3 06/10] [media] platform: Make use of media_bus_format
 enum
References: <1415369269-5064-1-git-send-email-boris.brezillon@free-electrons.com> <1415369269-5064-7-git-send-email-boris.brezillon@free-electrons.com> <CA+V-a8t79gYYGcgg5wvM-eqW8H2D6WD7xM9t2Px=WHb2rf34ow@mail.gmail.com> <546193CF.8090107@ti.com>
In-Reply-To: <546193CF.8090107@ti.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tuesday 11 November 2014 10:12 AM, Sekhar Nori wrote:
> On Saturday 08 November 2014 02:48 PM, Prabhakar Lad wrote:
>> Hi,
>>
>> Thanks for the patch,
>>
>> On Fri, Nov 7, 2014 at 2:07 PM, Boris Brezillon
>> <boris.brezillon@free-electrons.com> wrote:
>>> In order to have subsytem agnostic media bus format definitions we've
>>> moved media bus definition to include/uapi/linux/media-bus-format.h and
>>> prefixed values with MEDIA_BUS_FMT instead of V4L2_MBUS_FMT.
>>>
>>> Reference new definitions in all platform drivers.
>>>
>>> Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>
>>> ---
>>>  arch/arm/mach-davinci/board-dm355-evm.c            |   2 +-
>>>  arch/arm/mach-davinci/board-dm365-evm.c            |   4 +-
>>>  arch/arm/mach-davinci/dm355.c                      |   7 +-
>>>  arch/arm/mach-davinci/dm365.c                      |   7 +-
>>
>> @Sekhar can you ack for the machine changes for davinci ?
> 
> Heh, I don't have 6/10 in my inbox but have rest of the series. Can you
> forward 6/10 to me?

Based on the patch Prabhakar forwarded, for the mach-davinci changes,
you can add:

Acked-by: Sekhar Nori <nsekhar@ti.com>

Thanks,
Sekhar
