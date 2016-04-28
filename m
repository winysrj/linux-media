Return-path: <linux-media-owner@vger.kernel.org>
Received: from aer-iport-3.cisco.com ([173.38.203.53]:19612 "EHLO
	aer-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751801AbcD1Nmg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 28 Apr 2016 09:42:36 -0400
Subject: Re: [PATCH v2] media: vb2-dma-contig: configure DMA max segment size
 properly
To: Marek Szyprowski <m.szyprowski@samsung.com>,
	linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
References: <57220299.3000807@xs4all.nl>
 <1461849603-6313-1-git-send-email-m.szyprowski@samsung.com>
 <57221022.5040606@cisco.com>
 <cc31e0a1-f655-2107-a024-58fdf5ba45e4@samsung.com>
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Krzysztof Kozlowski <k.kozlowski@samsung.com>,
	Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
From: Hans Verkuil <hansverk@cisco.com>
Message-ID: <57221348.9020306@cisco.com>
Date: Thu, 28 Apr 2016 15:42:32 +0200
MIME-Version: 1.0
In-Reply-To: <cc31e0a1-f655-2107-a024-58fdf5ba45e4@samsung.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 04/28/2016 03:39 PM, Marek Szyprowski wrote:
> Hello,
> 
> 
> On 2016-04-28 15:29, Hans Verkuil wrote:
>> On 04/28/2016 03:20 PM, Marek Szyprowski wrote:
>>> This patch lets vb2-dma-contig memory allocator to configure DMA max
>>> segment size properly for the client device. Setting it is needed to let
>>> DMA-mapping subsystem to create a single, contiguous mapping in DMA
>>> address space. This is essential for all devices, which use dma-contig
>>> videobuf2 memory allocator and shared buffers (in USERPTR or DMAbuf modes
>>> of operations).
>>>
>>> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
>> Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
>>
>> Should this go in for 4.7? (might be too late) Should this go into older
>> kernels as well?

Oops, typo. I meant 4.6, not 4.7. I gather that committing this for 4.6 is not
necessary, so I just queue it up for 4.7.

Regards,

	Hans
