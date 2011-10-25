Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:35378 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752842Ab1JYH7e (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Oct 2011 03:59:34 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Received: from euspt2 ([210.118.77.13]) by mailout3.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0LTM00F6M3J8FE30@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 25 Oct 2011 08:59:32 +0100 (BST)
Received: from [127.0.0.1] ([106.10.22.71])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LTM00APU3J2IN@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 25 Oct 2011 08:59:32 +0100 (BST)
Date: Tue, 25 Oct 2011 09:59:27 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [PATCH] media: vb2: reset queued list on REQBUFS(0) call
In-reply-to: <CABbt3s68q_jKf9bHPT8kuaB6donrAzmucJJseWNiX88qud273g@mail.gmail.com>
To: Angela Wan <angela.j.wan@gmail.com>
Cc: pawel@osciak.com, linux-media@vger.kernel.org, leiwen@marvell.com,
	ytang5@marvell.com, qingx@marvell.com, jwan@marvell.com,
	Kyungmin Park <kyungmin.park@samsung.com>
Message-id: <4EA66C5F.8080202@samsung.com>
References: <CABbt3s68q_jKf9bHPT8kuaB6donrAzmucJJseWNiX88qud273g@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Queued list was not reset on REQBUFS(0) call. This caused enqueuing
a freed buffer to the driver.

Reported-by: Angela Wan <angela.j.wan@gmail.com>
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
  drivers/media/video/videobuf2-core.c |    1 +
  1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/videobuf2-core.c 
b/drivers/media/video/videobuf2-core.c
index 3015e60..5722b81 100644
--- a/drivers/media/video/videobuf2-core.c
+++ b/drivers/media/video/videobuf2-core.c
@@ -254,6 +254,7 @@ static void __vb2_queue_free(struct vb2_queue *q)

  	q->num_buffers = 0;
  	q->memory = 0;
+	INIT_LIST_HEAD(&q->queued_list);
  }

  /**
-- 
1.7.1


