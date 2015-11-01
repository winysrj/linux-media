Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io0-f169.google.com ([209.85.223.169]:33217 "EHLO
	mail-io0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751123AbbKATV2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 1 Nov 2015 14:21:28 -0500
Received: by iodd200 with SMTP id d200so125007137iod.0
        for <linux-media@vger.kernel.org>; Sun, 01 Nov 2015 11:21:28 -0800 (PST)
MIME-Version: 1.0
Date: Sun, 1 Nov 2015 21:21:27 +0200
Message-ID: <CAJ2oMhJOu8Ltra-bbb6FW3gLrCab1yKKu_zdSTNmqT5ecMkELQ@mail.gmail.com>
Subject: videobuf & read/write operation
From: Ran Shalit <ranshalit@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

I'm trying to understand how to imeplement v4l driver using videobuf.
The videobuf documentation if very helpful.
When the documentation refers to " I/O stream" , does it also include
the read/write operation or only streaming I/O method ?

In case I am using only read/write, do I need to implement all these 4  APIs:

struct videobuf_queue_ops {
 int (*buf_setup)(struct videobuf_queue *q,
 unsigned int *count, unsigned int *size);
 int (*buf_prepare)(struct videobuf_queue *q,
 struct videobuf_buffer *vb,
enum v4l2_field field);
 void (*buf_queue)(struct videobuf_queue *q,
 struct videobuf_buffer *vb);
 void (*buf_release)(struct videobuf_queue *q,
 struct videobuf_buffer *vb);
};

Are these APIs relevant for both read/write and streaminf I/O ?

Best Regards,
Ran
