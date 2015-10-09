Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:48067 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755660AbbJIPlD (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 9 Oct 2015 11:41:03 -0400
Date: Fri, 9 Oct 2015 12:40:56 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Chetan Nanda <chetannanda@gmail.com>
Cc: LMML <linux-media@vger.kernel.org>
Subject: Re: VB2 will returning -ERESTARTSYS to userland
Message-ID: <20151009124056.3c004c92@recife.lan>
In-Reply-To: <CAPrYoTGkiMcHY=59ZRewQrk_SWrc0ekcTQKs=rG0FuX553oOKg@mail.gmail.com>
References: <CAPrYoTGkiMcHY=59ZRewQrk_SWrc0ekcTQKs=rG0FuX553oOKg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 9 Oct 2015 10:00:39 +0530
Chetan Nanda <chetannanda@gmail.com> escreveu:

> Hi,
> 
> I am working on V4L2 base videodecoder,
> I have two threads say A and B. Thread A is for configuration and
> Thread B for queuing/de-queuing buffers.
> 
> In one usecase,
> - Thread B is blocked on VIDIOC_DQBUF,
> - and at same time Thread A do the flush and do, STREAMOFF, QBUF, STREAMON.
> 
> Once thread A do this, Thread B waked up (as a result of STREAMOFF)
> and return -ERESTARTSYS (from wait_interrupt_interruptible) from
> DQBUF.
> 
> ERESTARTSYS is for kernel internal and should not be passed to
> userside, and even ERESTARTSYS is not available at user side.
> 
> Shouldn't VB2 catch ERESTARTSYS and return -RESTART or some other error?

In thesis, the ioctl core should be handling -ERESTARTSYS. Are you
sure that you're seeing ERESTARTSYS on userspace?

> 
> Thanks,
> Chetan Nanda
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
