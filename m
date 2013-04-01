Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:59399 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751729Ab3DAGkm (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 1 Apr 2013 02:40:42 -0400
Received: from epcpsbgr4.samsung.com
 (u144.gpu120.samsung.co.kr [203.254.230.144])
 by mailout1.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTP id <0MKK001DVD7FYME0@mailout1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 01 Apr 2013 15:40:41 +0900 (KST)
From: Seung-Woo Kim <sw0312.kim@samsung.com>
To: linux-media@vger.kernel.org
Cc: mchehab@redhat.com, m.szyprowski@samsung.com,
	hans.verkuil@cisco.com, pawel@osciak.com,
	kyungmin.park@samsung.com, sw0312.kim@samsung.com
Subject: [RFC][PATCH 0/2] media: fix polling not to wait if a buffer is
 available
Date: Mon, 01 Apr 2013 15:40:45 +0900
Message-id: <1364798447-32224-1-git-send-email-sw0312.kim@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As poll behavior described in following link, polling needs to just return if
already some buffer is in done list.
Link: http://www.spinics.net/lists/linux-media/msg34759.html

But in current vb2 and v4l2_m2m, poll function always calls poll_wait(), so it
needs to wait until next vb2_buffer_done() or queue is cancelled.

So I add check routine for done_list before calling poll_wait().
But I'm not sure that locking for done_lock of queue is also needed in this
case or not because done_list of queue is checked without locking in some
other parts of vb2.

Seung-Woo Kim (2):
  media: vb2: return for polling if a buffer is available
  media: v4l2-mem2mem: return for polling if a buffer is available

 drivers/media/v4l2-core/v4l2-mem2mem.c   |    6 ++++--
 drivers/media/v4l2-core/videobuf2-core.c |    3 ++-
 2 files changed, 6 insertions(+), 3 deletions(-)

-- 
1.7.4.1

