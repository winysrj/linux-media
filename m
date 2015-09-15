Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:16599 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751480AbbIOI1B (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Sep 2015 04:27:01 -0400
Subject: Re: [RFC RESEND 07/11] vb2: dma-contig: Remove redundant sgt_base
 field
To: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Cc: pawel@osciak.com, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, sumit.semwal@linaro.org,
	robdclark@gmail.com, daniel.vetter@ffwll.ch, labbott@redhat.com
References: <1441972234-8643-1-git-send-email-sakari.ailus@linux.intel.com>
 <1441972234-8643-8-git-send-email-sakari.ailus@linux.intel.com>
 <55F30F50.6090902@xs4all.nl>
From: Sakari Ailus <sakari.ailus@linux.intel.com>
Message-ID: <55F7D652.9020903@linux.intel.com>
Date: Tue, 15 Sep 2015 11:26:58 +0300
MIME-Version: 1.0
In-Reply-To: <55F30F50.6090902@xs4all.nl>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Hans Verkuil wrote:
> On 09/11/2015 01:50 PM, Sakari Ailus wrote:
>> The struct vb2_dc_buf contains two struct sg_table fields: sgt_base and
>> dma_sgt. The former is used by DMA-BUF buffers whereas the latter is used
>> by USERPTR.
>>
>> Unify the two, leaving dma_sgt.
>>
>> MMAP buffers do not need cache flushing since they have been allocated
>> using dma_alloc_coherent().
> 
> I would have to see this again after it is rebased on 4.3-rc1. That will contain
> Jan Kara's vb2 changes which might well affect this patch.

Ok. I'll do that.

> 
> Are there use-cases where we want to allocate non-coherent memory? I know we
> don't support this today, but is this something we might want in the future?

Yes. Not all hardware supports coherent memory access, not even on x86.
Or coherent memory (sometimes uncached!) may be slower than non-coherent
access, including the time it takes to flush the cache first.

-- 
Kind regards,

Sakari Ailus
sakari.ailus@linux.intel.com
