Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-gw21.han.skanova.net ([81.236.55.21]:47928 "EHLO
	smtp-gw21.han.skanova.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932679Ab0HDLho (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 Aug 2010 07:37:44 -0400
Message-ID: <4C5950FF.4010705@pelagicore.com>
Date: Wed, 04 Aug 2010 13:37:35 +0200
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
References: <1280848711.19898.161.camel@debian> <000d01cb33aa$606faee0$214f0ca0$%osciak@samsung.com> <4C593586.6030804@pelagicore.com> <000e01cb33ba$796f44e0$6c4dcea0$%osciak@samsung.com> <4C593AF7.3060506@pelagicore.com> <001201cb33c0$af683290$0e3897b0$%osciak@samsung.com>
In-Reply-To: <001201cb33c0$af683290$0e3897b0$%osciak@samsung.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/04/2010 12:34 PM, Pawel Osciak wrote:
>> Richard Röjfors<richard.rojfors@pelagicore.com>  wrote:
>> On 08/04/2010 11:50 AM, Pawel Osciak wrote:
>>>>
>>>> How do you propose to allocate the buffers? They need to be contiguous
>>>> and using uncached memory gave really bad performance.
>>>
>>> 829440 bytes is a quite a lot and one can't reliably depend on kmalloc
>>> to be able to allocate such big chunks of contiguous memory. Were you
>>> testing this on a freshly rebooted system?
>>
>> The systems have been running for a while, but not days.
>> I don't see why would dma_alloc_coherent work better than kmalloc?
>>
>
> In principle it wouldn't. It's just it's much less intensively used and
> allocates from a special area. Not really a bullet-proof solution either
> though, I agree.

So what is your proposal given the current situation?
Using dma_alloc_noncoherent instead of kmalloc and use dma_cache_sync
instead of dma_sync_single_for_cpu?

--Richard
