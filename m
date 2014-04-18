Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qa0-f44.google.com ([209.85.216.44]:62968 "EHLO
	mail-qa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751185AbaDRNtf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Apr 2014 09:49:35 -0400
Received: by mail-qa0-f44.google.com with SMTP id hw13so1588793qab.31
        for <linux-media@vger.kernel.org>; Fri, 18 Apr 2014 06:49:34 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5351106E.4080700@xs4all.nl>
References: <1394454049-12879-1-git-send-email-hverkuil@xs4all.nl>
	<1394454049-12879-4-git-send-email-hverkuil@xs4all.nl>
	<20140416192343.30a5a8fc@samsung.com>
	<534F0553.2000808@xs4all.nl>
	<20140416231730.6252aae7@samsung.com>
	<534FA3BF.2010308@xs4all.nl>
	<20140417101310.0111d236@samsung.com>
	<5351106E.4080700@xs4all.nl>
Date: Fri, 18 Apr 2014 09:49:34 -0400
Message-ID: <CAGoCfix1j8kLQQe3yMDj+bqi=Pyj_K+en31a-h32+HMzVU1arQ@mail.gmail.com>
Subject: Re: [REVIEW PATCH 3/3] saa7134: convert to vb2
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans Verkuil <hans.verkuil@cisco.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> This was a bit confusing following the previous paragraph. I meant to say that the
> *saa7134* userptr implementation is not USERPTR at all but PAGE_ALIGNED_USERPTR.
>
> A proper USERPTR implementation (like in bttv) can use any malloc()ed pointer as
> it should, but saa7134 can't as it requires the application to align the pointer
> to a page boundary, which is non-standard.

It's probably worth mentioning at this point that there's a bug in
videobuf2_vmalloc() where it forces the buffer provided by userptr
mode to be page aligned.  This causes issues if you hand it a buffer
that isn't actually page aligned, as it writes to an arbitrary offset
into the buffer instead of the start of the buffer you provided.

I've had the following patch in my private tree for months, but had
been hesitant to submit it since I didn't know if it would effect
other implementations.  I wasn't sure if USERPTR mode required the
buffers to be page aligned and I was violating the spec.

Devin

From: Devin Heitmueller <dheitmueller@kernellabs.com>
Date: Fri, 17 May 2013 19:53:02 +0000 (-0400)
Subject: Fix alignment bug when using VB2 with userptr mode

Fix alignment bug when using VB2 with userptr mode

If we pass in a USERPTR buffer that isn't page aligned, the driver
will align it (and not tell userland).  The result is that the driver
thinks the video starts in one place while userland thinks it starts
in another.  This manifests itself as the video being horizontally
shifted and there being garbage from the start of the field up to
that point.

This problem was seen with both the em28xx and uvc drivers when
testing on the Davinci platform (where the buffers allocated are
not necessarily page aligned).
---

diff --git a/linux/drivers/media/v4l2-core/videobuf2-vmalloc.c
b/linux/drivers/media/v4l2-core/videobuf2-vmalloc.c
index 94efa04..ad7ce7c 100644
--- a/linux/drivers/media/v4l2-core/videobuf2-vmalloc.c
+++ b/linux/drivers/media/v4l2-core/videobuf2-vmalloc.c
@@ -82,7 +82,7 @@ static void *vb2_vmalloc_get_userptr(void
*alloc_ctx, unsigned long vaddr,
  return NULL;

  buf->write = write;
- offset = vaddr & ~PAGE_MASK;
+ offset = 0;
  buf->size = size;

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
