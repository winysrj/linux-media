Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-gw11.han.skanova.net ([81.236.55.20]:36794 "EHLO
	smtp-gw11.han.skanova.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756983Ab0HDKDo (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 Aug 2010 06:03:44 -0400
Message-ID: <4C593AF7.3060506@pelagicore.com>
Date: Wed, 04 Aug 2010 12:03:35 +0200
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
References: <1280848711.19898.161.camel@debian> <000d01cb33aa$606faee0$214f0ca0$%osciak@samsung.com> <4C593586.6030804@pelagicore.com> <000e01cb33ba$796f44e0$6c4dcea0$%osciak@samsung.com>
In-Reply-To: <000e01cb33ba$796f44e0$6c4dcea0$%osciak@samsung.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/04/2010 11:50 AM, Pawel Osciak wrote:
>>
>> How do you propose to allocate the buffers? They need to be contiguous
>> and using uncached memory gave really bad performance.
>
> 829440 bytes is a quite a lot and one can't reliably depend on kmalloc
> to be able to allocate such big chunks of contiguous memory. Were you
> testing this on a freshly rebooted system?

The systems have been running for a while, but not days.
I don't see why would dma_alloc_coherent work better than kmalloc?

I suppose bootmem could be used, or allocate the buffers at startup before memory gets fragmented.

--Richard
