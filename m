Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vk0-f53.google.com ([209.85.213.53]:35115 "EHLO
	mail-vk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757094AbbJIEal (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 9 Oct 2015 00:30:41 -0400
Received: by vkao3 with SMTP id o3so44528852vka.2
        for <linux-media@vger.kernel.org>; Thu, 08 Oct 2015 21:30:39 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 9 Oct 2015 10:00:39 +0530
Message-ID: <CAPrYoTGkiMcHY=59ZRewQrk_SWrc0ekcTQKs=rG0FuX553oOKg@mail.gmail.com>
Subject: VB2 will returning -ERESTARTSYS to userland
From: Chetan Nanda <chetannanda@gmail.com>
To: LMML <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I am working on V4L2 base videodecoder,
I have two threads say A and B. Thread A is for configuration and
Thread B for queuing/de-queuing buffers.

In one usecase,
- Thread B is blocked on VIDIOC_DQBUF,
- and at same time Thread A do the flush and do, STREAMOFF, QBUF, STREAMON.

Once thread A do this, Thread B waked up (as a result of STREAMOFF)
and return -ERESTARTSYS (from wait_interrupt_interruptible) from
DQBUF.

ERESTARTSYS is for kernel internal and should not be passed to
userside, and even ERESTARTSYS is not available at user side.

Shouldn't VB2 catch ERESTARTSYS and return -RESTART or some other error?

Thanks,
Chetan Nanda
