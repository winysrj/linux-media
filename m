Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-gw21.han.skanova.net ([81.236.55.21]:57880 "EHLO
	smtp-gw21.han.skanova.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932075Ab0HDJka (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 Aug 2010 05:40:30 -0400
Message-ID: <4C593586.6030804@pelagicore.com>
Date: Wed, 04 Aug 2010 11:40:22 +0200
From: =?UTF-8?B?UmljaGFyZCBSw7ZqZm9ycw==?=
	<richard.rojfors@pelagicore.com>
MIME-Version: 1.0
To: Pawel Osciak <p.osciak@samsung.com>
CC: 'Linux Media Mailing List' <linux-media@vger.kernel.org>,
	'Mauro Carvalho Chehab' <mchehab@redhat.com>,
	'Douglas Schilling Landgraf' <dougsland@gmail.com>,
	'Samuel Ortiz' <sameo@linux.intel.com>
Subject: Re: [PATCH 1/3 v2] media: Add a cached version of the contiguous
 video buffers
References: <1280848711.19898.161.camel@debian> <000d01cb33aa$606faee0$214f0ca0$%osciak@samsung.com>
In-Reply-To: <000d01cb33aa$606faee0$214f0ca0$%osciak@samsung.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/04/2010 09:55 AM, Pawel Osciak wrote:
> Hi Richard,
>
>> Richard Röjfors wrote:
>> This patch adds another init functions in the videobuf-dma-contig
>> which is named _cached in the end. It creates a buffer factory
>> which allocates buffers using kmalloc and the buffers are cached.
>>
>
> Before I review this in more detail, could you elaborate more on
> this? How large are your buffers, can kmalloc really allocate them
> for you? I am not convinced how this is supposed to work reliably,
> especially in a long-running systems.

The buffers are normally 829440 bytes and yes kmalloc can allocate them.
Normally userspace apps seem to request two buffers of this size.

How do you propose to allocate the buffers? They need to be contiguous
and using uncached memory gave really bad performance.

--Richard
