Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:44890 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750876Ab3JUHWe (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Oct 2013 03:22:34 -0400
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout1.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MV0002ROCG4YA60@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 21 Oct 2013 08:22:32 +0100 (BST)
Message-id: <5264D638.5010302@samsung.com>
Date: Mon, 21 Oct 2013 09:22:32 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
MIME-version: 1.0
To: Jan Kara <jack@suse.cz>, linux-media@vger.kernel.org
Cc: Pawel Osciak <pawel@osciak.com>
Subject: Re: Handling of user address in vb2_dc_get_userptr()
References: <20131017212331.GA14677@quack.suse.cz>
In-reply-to: <20131017212331.GA14677@quack.suse.cz>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

On 2013-10-17 23:23, Jan Kara wrote:
>    I'm auditing get_user_pages() users and when looking into
> vb2_dc_get_userptr() I was wondering about the following: The address this
> function works with is an arbitrary user-provided address. However the
> function vb2_dc_get_user_pages() uses pfn_to_page() on the pfn obtained
> from VM_IO | VM_PFNMAP vma. That isn't really safe for arbitrary vma of
> this type (such vmas don't have to have struct page associated at all). I
> expect this works because userspace always passes a pointer to either a
> regular vma or VM_FIXMAP vma where struct page is associated with pfn. Am
> I right? Or for on which vmas this code is supposed to work? Thanks in
> advance for clarification.

This is known issue. It has been at least partially addresses by the 
following patch:
https://patchwork.linuxtv.org/patch/18978/

I hope that one day it can be addressed fully by changing the 
dma-mapping API in a way it will let drivers to map particular pfn into 
dma address space.

Best regards
-- 
Marek Szyprowski
Samsung R&D Institute Poland

