Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f172.google.com ([209.85.217.172]:65114 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751518AbbBKJMm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Feb 2015 04:12:42 -0500
MIME-Version: 1.0
In-Reply-To: <54DB1A3C.3050207@samsung.com>
References: <1423498466-16718-1-git-send-email-ricardo.ribalda@gmail.com>
 <54DB0D84.7020600@samsung.com> <CAPybu_37FJhAKYYKuyMqTexYgFspwhnBs8bMxHGpG7XiVejaJw@mail.gmail.com>
 <54DB1A3C.3050207@samsung.com>
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Date: Wed, 11 Feb 2015 10:12:20 +0100
Message-ID: <CAPybu_1WkQrH=ubuR1Y2HdgGP8iU0_38c1RtRkt1jKEN3bg3Vw@mail.gmail.com>
Subject: Re: [PATCH 1/3] media/videobuf2-dma-sg: Fix handling of sg_table structure
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Pawel Osciak <pawel@osciak.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media <linux-media@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello again

On Wed, Feb 11, 2015 at 10:00 AM, Marek Szyprowski
<m.szyprowski@samsung.com> wrote:

> Well, this int return value seems to be misleading, but according to
> Documentation/DMA-API.txt, the only error value is zero:
>
> "As with the other mapping interfaces, dma_map_sg() can fail. When it
> does, 0 is returned and a driver must take appropriate action. It is
> critical that the driver do something, in the case of a block driver
> aborting the request or even oopsing is better than doing nothing and
> corrupting the filesystem."
>
> I've also checked various dma-mapping implementation for different
> architectures and they follow this convention.
>
> Maybe one should add some comments to include/linux/dma_mapping.h to
> clarify this and avoid further confusion.
>
>

Or maybe change it to unsigned int...

Let me redo the patch and resend. I will also try to ping whoever is
the maintainer of dma_mapping

Thanks!



-- 
Ricardo Ribalda
