Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f180.google.com ([209.85.217.180]:64556 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750705AbaDWAS4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Apr 2014 20:18:56 -0400
Received: by mail-lb0-f180.google.com with SMTP id 10so172887lbg.11
        for <linux-media@vger.kernel.org>; Tue, 22 Apr 2014 17:18:54 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 22 Apr 2014 17:18:54 -0700
Message-ID: <CAKZjMP3B5k8MByhVrn=vsWOwnZLDL+YS48VvAWQ+z4=RKduV-Q@mail.gmail.com>
Subject: Question about implementation of __qbuf_dmabuf() in videobuf2-core.c
From: n179911 <n179911@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In __qbuf_dmabuf(), it check the length and size of the buffer being
queued, like this:
http://lxr.free-electrons.com/source/drivers/media/v4l2-core/videobuf2-core.c#L1158

My question is why the range check is liked this:

1158  if (planes[plane].length < planes[plane].data_offset +
1159                     q->plane_sizes[plane]) {
        .....

Isn't  planes[plane].length + planes[plane].data_offset equals to
q->plane_sizes[plane]?

So the check should be?
 if (planes[plane].length < q->plane_sizes[plane] - planes[plane].data_offset)

Please tell me what am I missing?

Thank you
