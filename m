Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gh0-f174.google.com ([209.85.160.174]:55033 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751344Ab2E2MFJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 29 May 2012 08:05:09 -0400
Received: by ghrr11 with SMTP id r11so1664928ghr.19
        for <linux-media@vger.kernel.org>; Tue, 29 May 2012 05:05:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201205281222.57917.hverkuil@xs4all.nl>
References: <1338050460-5902-1-git-send-email-elezegarcia@gmail.com>
	<201205261905.25626.hverkuil@xs4all.nl>
	<CALF0-+XFR4jnDCatk3vu2tB=iA-p=Ai_bwwgOZGTzNNrsicxfA@mail.gmail.com>
	<201205281222.57917.hverkuil@xs4all.nl>
Date: Tue, 29 May 2012 09:05:08 -0300
Message-ID: <CALF0-+VHtPuHCzpAydFjaUnp+JkpJOXxJTJoQEURwvBkmA3vgA@mail.gmail.com>
Subject: Re: [RFC/PATCH] media: Add stk1160 new driver
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: mchehab@redhat.com, linux-media@vger.kernel.org,
	hdegoede@redhat.com, snjw23@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, May 28, 2012 at 7:22 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>
> In practice it seems that the easiest approach is not to clean up anything in the
> disconnect, just take the lock, do the bare minimum necessary for the disconnect,
> unregister the video nodes, unlock and end with v4l2_device_put(v4l2_dev).
>
> It's a suggestion only, but experience has shown that it works well. And as I said,
> when you get multiple device nodes, then this is the only workable approach.

I'm convinced: it's both cleaner and more logical to use
v4l2_release instead of video_device release to the final cleanup.

>
> OK, the general rule is as follows (many drivers do not follow this correctly, BTW,
> but this is what should happen):
>
> - the filehandle that calls REQBUFS owns the buffers and is the only one that can
> start/stop streaming and queue/dequeue buffers.

and read, poll, etc right?

> This is until REQBUFS with count == 0
> is called, or until the filehandle is closed.

Okey. But currently videobuf2 doesn't notify the driver
when reqbufs with zero count has been called.

So, I have to "assume" it (aka trouble ahead) or "capture" the zero
count case before/after calling vb2_reqbufs (aka ugly).

I humbly think that, if we wan't to enforce this behavior
(as part of v4l2 driver semantics)
then we should have videobuf2 tell the driver when reqbufs has been
called with zero count.

You can take a look at pwc which only drops owner on filehandle close,
or uvc which captures this from vb2_reqbufs.

After looking at uvc, now I wonder is it really ugly? or perhaps
it's just ok.


> v4l2_device is a top-level struct, video_device represents a single device node.
> For cleanup purposes there isn't much difference between the two if you have
> only one device node. When you have more, then those differences are much more
> important.

Yes, it's cleaner now.

Thanks!
Ezequiel.
