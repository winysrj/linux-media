Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:50001 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752848Ab1H3F0n (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 30 Aug 2011 01:26:43 -0400
Received: from euspt2 (mailout1.w1.samsung.com [210.118.77.11])
 by mailout1.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0LQQ00K4J74GUN@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 30 Aug 2011 06:26:40 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LQQ00I0H74G5Y@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 30 Aug 2011 06:26:40 +0100 (BST)
Date: Tue, 30 Aug 2011 07:24:02 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: RE: videobuf2 user pointer vma release seqeuence
In-reply-to: <CAOQL7V_6bjnsG9QwhwA7+DNOfq3ugSH47ybiHg=jKw0mB__TUw@mail.gmail.com>
To: "'Tang, Yu'" <ytang5@gmail.com>, linux-media@vger.kernel.org,
	pawel@osciak.com, g.liakhovetski@gmx.de
Message-id: <00c901cc66d5$07692420$163b6c60$%szyprowski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-language: pl
Content-transfer-encoding: 7BIT
References: <CAOQL7V_6bjnsG9QwhwA7+DNOfq3ugSH47ybiHg=jKw0mB__TUw@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

On Tuesday, August 30, 2011 3:50 AM Tang, Yu wrote:

> As we are trying to adapt to videobuf2, we found here is the potential
> issue with user pointer VMA release sequence. It is not aligned with 
> munmap syscalls behavior, (mm/mmap, remove_vma). 
>
> In the current vb2_put_vma implementation, it will release the file first,
> then release VMA. If the file handle is closed, and vma is munmap by user
> space, then the file ref count could reach 0 and be freed before the VMA 
> vm_ops->vm_close is called while vm_close is typically assume the file is
> valid when it's called. 
>
> If it's agreed as valid concern, I will submit the fix as below soon. 
> Thanks!

You are definitely right! Thanks for pointing this bug! I will add your
patch to my videobuf2 fixes branch.

Best regards
-- 
Marek Szyprowski
Samsung Poland R&D Center



