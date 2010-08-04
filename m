Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:9429 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757428Ab0HDJwO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 Aug 2010 05:52:14 -0400
Received: from eu_spt1 (mailout2.w1.samsung.com [210.118.77.12])
 by mailout2.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0L6M00HE1GQY4D@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 04 Aug 2010 10:52:10 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0L6M00KTBGQYPM@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 04 Aug 2010 10:52:10 +0100 (BST)
Date: Wed, 04 Aug 2010 11:50:30 +0200
From: Pawel Osciak <p.osciak@samsung.com>
Subject: RE: [PATCH 1/3 v2] media: Add a cached version of the contiguous video
 buffers
In-reply-to: <4C593586.6030804@pelagicore.com>
To: =?utf-8?Q?'Richard_R=C3=B6jfors'?= <richard.rojfors@pelagicore.com>
Cc: 'Linux Media Mailing List' <linux-media@vger.kernel.org>,
	'Mauro Carvalho Chehab' <mchehab@redhat.com>,
	'Douglas Schilling Landgraf' <dougsland@gmail.com>,
	'Samuel Ortiz' <sameo@linux.intel.com>
Message-id: <000e01cb33ba$796f44e0$6c4dcea0$%osciak@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-language: pl
Content-transfer-encoding: 8BIT
References: <1280848711.19898.161.camel@debian>
 <000d01cb33aa$606faee0$214f0ca0$%osciak@samsung.com>
 <4C593586.6030804@pelagicore.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> Richard Röjfors <richard.rojfors@pelagicore.com> wrote:
>On 08/04/2010 09:55 AM, Pawel Osciak wrote:
>> Hi Richard,
>>
>>> Richard Röjfors wrote:
>>> This patch adds another init functions in the videobuf-dma-contig
>>> which is named _cached in the end. It creates a buffer factory
>>> which allocates buffers using kmalloc and the buffers are cached.
>>>
>>
>> Before I review this in more detail, could you elaborate more on
>> this? How large are your buffers, can kmalloc really allocate them
>> for you? I am not convinced how this is supposed to work reliably,
>> especially in a long-running systems.
>
>The buffers are normally 829440 bytes and yes kmalloc can allocate them.
>Normally userspace apps seem to request two buffers of this size.
>
>How do you propose to allocate the buffers? They need to be contiguous
>and using uncached memory gave really bad performance.

829440 bytes is a quite a lot and one can't reliably depend on kmalloc
to be able to allocate such big chunks of contiguous memory. Were you
testing this on a freshly rebooted system?

What you are asking for is actually a memory management holy grail, there
is no ideal solution for contiguous memory allocation. There are and have
been attempts at creating such an allocator, but there is no such thing
in the kernel as of yet. One very recent proposal for a contiguous memory
allocator can be found on this list, look for  "The Contiguous Memory
Allocator" topic from Jul, 26th.

One solution to have cached buffers is to use bootmem allocation and
map those areas as cached manually.

Best regards
--
Pawel Osciak
Linux Platform Group
Samsung Poland R&D Center





