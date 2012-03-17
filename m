Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:55857 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932067Ab2CQWMe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 17 Mar 2012 18:12:34 -0400
Received: by vcqp1 with SMTP id p1so5320434vcq.19
        for <linux-media@vger.kernel.org>; Sat, 17 Mar 2012 15:12:33 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20120317201719.121f4104@pyx>
References: <1331775148-5001-1-git-send-email-rob.clark@linaro.org>
	<20120317201719.121f4104@pyx>
Date: Sat, 17 Mar 2012 17:12:33 -0500
Message-ID: <CAF6AEGuY7W5TFNBFqsTHbJVmzJAt4UXqqHQqxJrgEZhHVP5t1g@mail.gmail.com>
Subject: Re: [PATCH] RFC: dma-buf: userspace mmap support
From: Rob Clark <rob.clark@linaro.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Tom Cooksey <tom.cooksey@arm.com>, patches@linaro.org,
	dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
	rschultz@google.com, sumit.semwal@linaro.org,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Mar 17, 2012 at 3:17 PM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>> > dma-buf file descriptor.  Userspace access to the buffer should be
>> > bracketed with DMA_BUF_IOCTL_{PREPARE,FINISH}_ACCESS ioctl calls to
>> > give the exporting driver a chance to deal with cache synchronization
>> > and such for cached userspace mappings without resorting to page
>
> There should be flags indicating if this is necessary. We don't want extra
> syscalls on hardware that doesn't need it. The other question is what
> info is needed as you may only want to poke a few pages out of cache and
> the prepare/finish on its own gives no info.

Well, there isn't really a convenient way to know, for some random
code that is just handed a dmabuf fd, what the flags are without
passing around an extra param in userspace.  So I'd tend to say, just
live with the syscall even if it is a no-op (because if you are doing
sw access to the buffer, that is anyways some slow/legacy path).  But
I'm open to suggestions.

As far as just peeking/poking a few pages, that is where some later
ioctls or additional params could come in, to give some hints.  But I
wanted to keep it simple to start.

>> E.g. If another device was writing to the buffer, the prepare ioctl
>> could block until that device had finished accessing that buffer.
>
> How do you avoid deadlocks on this ? We need very clear ways to ensure
> things always complete in some form given multiple buffer
> owner/requestors and the fact this API has no "prepare-multiple-buffers"
> support.

Probably some separate synchronization is needed.. I'm not really sure
if prepare/finish (or map/unmap on kernel side) is a the right way to
handle that.

BR,
-R

> Alan
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel
