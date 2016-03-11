Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qg0-f54.google.com ([209.85.192.54]:33626 "EHLO
	mail-qg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935384AbcCKIkI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Mar 2016 03:40:08 -0500
Received: by mail-qg0-f54.google.com with SMTP id t4so92631470qge.0
        for <linux-media@vger.kernel.org>; Fri, 11 Mar 2016 00:40:08 -0800 (PST)
Date: Fri, 11 Mar 2016 10:40:03 +0200
From: Andrey Utkin <andrey.utkin@corp.bluecherry.net>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media <linux-media@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"kernel-mentors@selenic.com" <kernel-mentors@selenic.com>,
	devel@driverdev.osuosl.org,
	kernel-janitors <kernel-janitors@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Andrey Utkin <andrey_utkin@fastmail.com>
Subject: Re: [RFC PATCH v0] Add tw5864 driver
Message-ID: <20160311104003.1cad89f3@zver>
In-Reply-To: <56E27B12.1000803@xs4all.nl>
References: <1451785302-3173-1-git-send-email-andrey.utkin@corp.bluecherry.net>
	<56938969.30104@xs4all.nl>
	<CAM_ZknVgTETBNXu+8N6eJa=cf_Mmj=+tA=ocKB9SJL5rkSyijQ@mail.gmail.com>
	<56B866D9.5070606@xs4all.nl>
	<20160309162924.6e6ebddf@zver>
	<56E27B12.1000803@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 11 Mar 2016 09:00:18 +0100
Hans Verkuil <hverkuil@xs4all.nl> wrote:
> The reason is likely to be the tw5864_queue_setup function which has
> not been updated to handle CREATE_BUFS support correctly. It should
> look like this:
> 
> static int tw5864_queue_setup(struct vb2_queue *q,
> 			      unsigned int *num_buffers,
> 			      unsigned int *num_planes, unsigned int
> sizes[], void *alloc_ctxs[])
> {
> 	struct tw5864_input *dev = vb2_get_drv_priv(q);
> 
> 	if (q->num_buffers + *num_buffers < 12)
> 		*num_buffers = 12 - q->num_buffers;
> 
> 	alloc_ctxs[0] = dev->alloc_ctx;
> 	if (*num_planes)
> 		return sizes[0] < H264_VLC_BUF_SIZE ? -EINVAL : 0;
> 
> 	sizes[0] = H264_VLC_BUF_SIZE;
> 	*num_planes = 1;
> 
> 	return 0;
> }

Thanks for suggestion, but now the failure looks this way:

Streaming ioctls:
        test read/write: OK
                fail: v4l2-test-buffers.cpp(297): g_field() == V4L2_FIELD_ANY
                fail: v4l2-test-buffers.cpp(703): buf.check(q, last_seq)
                fail: v4l2-test-buffers.cpp(976): captureBufs(node, q, m2m_q, frame_count, false)
        test MMAP: FAIL

Will check that later. If you have any suggestions, I would be very
grateful.
