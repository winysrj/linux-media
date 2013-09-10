Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oa0-f51.google.com ([209.85.219.51]:42112 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751757Ab3IJOK5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Sep 2013 10:10:57 -0400
Received: by mail-oa0-f51.google.com with SMTP id h1so7747932oag.24
        for <linux-media@vger.kernel.org>; Tue, 10 Sep 2013 07:10:57 -0700 (PDT)
MIME-Version: 1.0
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Date: Tue, 10 Sep 2013 16:10:37 +0200
Message-ID: <CAPybu_2dq6FkWebNw8ySD=4wJu++3z7K6oNDjXEJvcKVvRTVsQ@mail.gmail.com>
Subject: videobuf2: V4L2_BUF_TYPE_VIDEO_CAPTURE and V4L2_BUF_TYPE_VIDEO_OUTPUT
 at the same time?
To: linux-media <linux-media@vger.kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello!

I am writing the driver for a device that can work as an input and as
output at the same time. It is used for debugging of the video
pipeline.

Is it possible to have a vb2 queue that supports capture and out at
the same time?

After a fast look on the code it seems that the code flow is different
depending of the type. if (V4L2_TYPE_IS_OUTPUT()....)  :(

Also it seems that struct video device has only space for one
vb2_queue, so I cant create a video device with two vbuf2 queues.

So is there any way to have a video device with videobuf2 that
supports caputer and output?

Thanks!

-- 
Ricardo Ribalda
