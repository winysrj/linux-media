Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:39206 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729872AbeKXGhu (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 24 Nov 2018 01:37:50 -0500
Date: Fri, 23 Nov 2018 14:52:05 -0500
From: Sasha Levin <sashal@kernel.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: stable@vger.kernel.org,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH for v4.9] Revert "media: videobuf2-core: don't call memop
 'finish' when queueing"
Message-ID: <20181123195205.GL1917@sasha-vm>
References: <d9f73b7c-fc28-77ff-8c28-a565e2879efe@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <d9f73b7c-fc28-77ff-8c28-a565e2879efe@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Nov 22, 2018 at 12:43:56PM +0100, Hans Verkuil wrote:
>This reverts commit 9ac47200b51cb09d2f15dbefa67e0412741d98aa.
>
>This commit fixes a bug in upstream commit a136f59c0a1f ("vb2: Move
>buffer cache synchronisation to prepare from queue") which isn't
>present in 4.9.
>
>So as a result you get an UNBALANCED message in the kernel log if
>this patch is applied:
>
>vb2:   counters for queue ffffffc0f3687478, buffer 3: UNBALANCED!
>vb2:     buf_init: 1 buf_cleanup: 1 buf_prepare: 805 buf_finish: 805
>vb2:     buf_queue: 806 buf_done: 806
>vb2:     alloc: 0 put: 0 prepare: 806 finish: 805 mmap: 0
>vb2:     get_userptr: 0 put_userptr: 0
>vb2:     attach_dmabuf: 1 detach_dmabuf: 1 map_dmabuf: 805 unmap_dmabuf: 805
>vb2:     get_dmabuf: 0 num_users: 1609 vaddr: 0 cookie: 805
>
>Reverting this patch solves this regression.
>
>Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

I've queued both reverts to their respective branches, thank you.

--
Thanks,
Sasha
