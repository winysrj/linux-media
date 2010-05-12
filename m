Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:61480 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751560Ab0ELGmM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 12 May 2010 02:42:12 -0400
Received: from eu_spt2 (mailout1.w1.samsung.com [210.118.77.11])
 by mailout1.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0L2A00IU9NY99I@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 12 May 2010 07:42:09 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0L2A00K40NY97U@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 12 May 2010 07:42:09 +0100 (BST)
Date: Wed, 12 May 2010 08:41:37 +0200
From: Pawel Osciak <p.osciak@samsung.com>
Subject: RE: [PATCH 1/7] v4l: videobuf: rename videobuf_alloc to
 videobuf_alloc_vb
In-reply-to: <1273584994-14211-2-git-send-email-laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: 'Pawel Osciak' <p.osciak@samsung.com>, kyungmin.park@samsung.com
Message-id: <000001caf19e$2bc3a7d0$834af770$%osciak@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-language: pl
Content-transfer-encoding: 7BIT
References: <1273584994-14211-1-git-send-email-laurent.pinchart@ideasonboard.com>
 <1273584994-14211-2-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro:

in case you decide to merge this patch and the following one, please add

Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>

after my sign-off. Thanks!


> Laurent Pinchart <laurent.pinchart@ideasonboard.com> wrote:
>Subject: [PATCH 1/7] v4l: videobuf: rename videobuf_alloc to
>videobuf_alloc_vb
>
>From: Pawel Osciak <p.osciak@samsung.com>
>
>These functions allocate videobuf_buffer structures only. Renaming in order
>to prevent confusion with functions allocating actual video buffer memory.
>
>Signed-off-by: Pawel Osciak <p.osciak@samsung.com>
>
>Rename the functions in videobuf-core.h videobuf-dma-sg.c as well.
>
>Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
>---
> drivers/media/video/videobuf-core.c       |   14 +++++++-------
> drivers/media/video/videobuf-dma-contig.c |    4 ++--
> drivers/media/video/videobuf-dma-sg.c     |    6 +++---
> drivers/media/video/videobuf-vmalloc.c    |    4 ++--
> include/media/videobuf-core.h             |    4 ++--
> 5 files changed, 16 insertions(+), 16 deletions(-)


Best regards
--
Pawel Osciak
Linux Platform Group
Samsung Poland R&D Center


