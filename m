Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-2.cisco.com ([144.254.224.141]:56748 "EHLO
	ams-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751384Ab1HWNyO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Aug 2011 09:54:14 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: More vb2 notes
Date: Tue, 23 Aug 2011 15:54:12 +0200
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
	"'Pawel Osciak'" <pawel@osciak.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201108231554.12786.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

I've been converting a Cisco internal driver to vb2 and while doing that I
found a few issues.

1) I noticed that struct vb2_buffer doesn't have a list_head that the driver
can use to hook it in its dma queue. That forces you to make your own
buffer struct just to have your own list_head.

I think vb2_buffer should either get a driver_entry or the 'done_entry' field
can be assigned for driver use (since a buffer can't be owned by the driver
and be on the done list at the same time). I abused 'done_entry' for now.

2) videobuf2-dma-sg.c no longer calls dma_(un)map_sg()! The old
videobuf-dma-sg.c did that for you. Is there any reason for this change?
I had to manually add it to my driver.

3) videobuf2-core.c uses this in __fill_v4l2_buffer:

        if (vb->num_planes_mapped == vb->num_planes)
                b->flags |= V4L2_BUF_FLAG_MAPPED;

However, I see no code that ever decreases num_planes_mapped. And I also 
wonder what happens if vb2_mmap is called multiple times: num_planes_mapped
will be increased so vb->num_planes_mapped > vb->num_planes and the MAPPED
flag is no longer set.

This is a particular problem with libv4l2 since that tests for the MAPPED
flag and will refuse e.g. format changes if it is set.

4) It is not clear to me when vb2_queue_release should be called. Is it in 
close() when you close a filehandle that was used for streaming?

Regards,

	Hans
