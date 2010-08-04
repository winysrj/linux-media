Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:12663 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932199Ab0HDKgl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 Aug 2010 06:36:41 -0400
Received: from eu_spt2 (mailout2.w1.samsung.com [210.118.77.12])
 by mailout2.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0L6M00HBAIT24D@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 04 Aug 2010 11:36:38 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0L6M00E9CIT1SW@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 04 Aug 2010 11:36:38 +0100 (BST)
Date: Wed, 04 Aug 2010 12:34:57 +0200
From: Pawel Osciak <p.osciak@samsung.com>
Subject: RE: [PATCH 1/3 v2] media: Add a cached version of the contiguous video
 buffers
In-reply-to: <4C593AF7.3060506@pelagicore.com>
To: =?utf-8?Q?'Richard_R=C3=B6jfors'?= <richard.rojfors@pelagicore.com>
Cc: 'Linux Media Mailing List' <linux-media@vger.kernel.org>,
	'Mauro Carvalho Chehab' <mchehab@redhat.com>,
	'Douglas Schilling Landgraf' <dougsland@gmail.com>,
	'Samuel Ortiz' <sameo@linux.intel.com>
Message-id: <001201cb33c0$af683290$0e3897b0$%osciak@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-language: pl
Content-transfer-encoding: 8BIT
References: <1280848711.19898.161.camel@debian>
 <000d01cb33aa$606faee0$214f0ca0$%osciak@samsung.com>
 <4C593586.6030804@pelagicore.com>
 <000e01cb33ba$796f44e0$6c4dcea0$%osciak@samsung.com>
 <4C593AF7.3060506@pelagicore.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

>Richard Röjfors <richard.rojfors@pelagicore.com> wrote:
>On 08/04/2010 11:50 AM, Pawel Osciak wrote:
>>>
>>> How do you propose to allocate the buffers? They need to be contiguous
>>> and using uncached memory gave really bad performance.
>>
>> 829440 bytes is a quite a lot and one can't reliably depend on kmalloc
>> to be able to allocate such big chunks of contiguous memory. Were you
>> testing this on a freshly rebooted system?
>
>The systems have been running for a while, but not days.
>I don't see why would dma_alloc_coherent work better than kmalloc?
>

In principle it wouldn't. It's just it's much less intensively used and
allocates from a special area. Not really a bullet-proof solution either
though, I agree.


Best regards
--
Pawel Osciak
Linux Platform Group
Samsung Poland R&D Center





