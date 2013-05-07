Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:61716 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751395Ab3EGF2m (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 7 May 2013 01:28:42 -0400
MIME-version: 1.0
Content-type: text/plain; charset=EUC-KR
Received: from epcpsbgr5.samsung.com
 (u145.gpu120.samsung.co.kr [203.254.230.145])
 by mailout4.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTP id <0MME0027IXURD8E0@mailout4.samsung.com> for
 linux-media@vger.kernel.org; Tue, 07 May 2013 14:28:40 +0900 (KST)
Content-transfer-encoding: 8BIT
Message-id: <51889111.60202@samsung.com>
Date: Tue, 07 May 2013 14:28:49 +0900
From: =?EUC-KR?B?sei9wr/s?= <sw0312.kim@samsung.com>
Reply-to: sw0312.kim@samsung.com
To: Seung-Woo Kim <sw0312.kim@samsung.com>
Cc: linux-media@vger.kernel.org, mchehab@redhat.com,
	m.szyprowski@samsung.com, hans.verkuil@cisco.com, pawel@osciak.com,
	kyungmin.park@samsung.com, Seung-Woo Kim <sw0312.kim@samsung.com>
Subject: Re: [RFC][PATCH 0/2] media: fix polling not to wait if a buffer is
 available
References: <1364798447-32224-1-git-send-email-sw0312.kim@samsung.com>
In-reply-to: <1364798447-32224-1-git-send-email-sw0312.kim@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Ping this patch-set.

The first patch for vb2 was acked by Marek.

any suggestion for the second patch?

Regards,
- Seung-Woo Kim

On 2013³â 04¿ù 01ÀÏ 15:40, Seung-Woo Kim wrote:
> As poll behavior described in following link, polling needs to just return if
> already some buffer is in done list.
> Link: http://www.spinics.net/lists/linux-media/msg34759.html
> 
> But in current vb2 and v4l2_m2m, poll function always calls poll_wait(), so it
> needs to wait until next vb2_buffer_done() or queue is cancelled.
> 
> So I add check routine for done_list before calling poll_wait().
> But I'm not sure that locking for done_lock of queue is also needed in this
> case or not because done_list of queue is checked without locking in some
> other parts of vb2.
> 
> Seung-Woo Kim (2):
>   media: vb2: return for polling if a buffer is available
>   media: v4l2-mem2mem: return for polling if a buffer is available
> 
>  drivers/media/v4l2-core/v4l2-mem2mem.c   |    6 ++++--
>  drivers/media/v4l2-core/videobuf2-core.c |    3 ++-
>  2 files changed, 6 insertions(+), 3 deletions(-)
> 

-- 
Seung-Woo Kim
Samsung Software R&D Center
--

