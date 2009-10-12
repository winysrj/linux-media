Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f227.google.com ([209.85.220.227]:46479 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756443AbZJLMea convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 12 Oct 2009 08:34:30 -0400
Received: by fxm27 with SMTP id 27so9136676fxm.17
        for <linux-media@vger.kernel.org>; Mon, 12 Oct 2009 05:33:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <164184.43566.qm@web23105.mail.ird.yahoo.com>
References: <164184.43566.qm@web23105.mail.ird.yahoo.com>
Date: Mon, 12 Oct 2009 08:33:53 -0400
Message-ID: <30353c3d0910120533j53804660t6706c04b13e48221@mail.gmail.com>
Subject: Re: How to store the latest image without modifying videobuf-core.c
From: David Ellingsworth <david@identd.dyndns.org>
To: Mattias Persson <d98mp@yahoo.se>
Cc: video4linux-list@redhat.com,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Oct 12, 2009 at 3:33 AM, Mattias Persson <d98mp@yahoo.se> wrote:
> Hi,
>

Please send messages to the new mailing list:
linux-media@vger.kernel.org from now on.

> I am developing a driver for a camera. As an example I am using the vivi driver (2.6.28) and the first major difference between my ISR and thread_tick() is that my driver will always attempt to store the latest image, even if nobody is waiting for a new image.

I believe the standard here is that your driver should simply drop the
frame if no one is waiting for it.
>
> In my driver, when all queued buffers are used any new images will be stored in the oldest frame which has already been captured (state == VIDEOBUF_DONE) and here is where my problems start. (If this is wrong, what shall I do to always keep the latest captured image?)
>

If no one wants the image you should just drop it but note that it
existed. I believe the v4l2 api has frame counters so that the
application knows that it missed some.

> In the function videobuf_dqbuf in videobuf-core.c, if a new image is returned by stream_next_buffer and the ISR kicks in before videobuf_dqbuf can set buf->state to VIDEOBUF_IDLE, my driver will modify the image presented to userspace and that is not acceptable.

Correct, it's not acceptable to modify userspace memory when not asked to do so.

>
> The only solution I can find is to use the spinlock in videobuf_queue when the userspace application is requesting a new image (DQBUF/poll) to check for a new image and set some flag indicating that the buffer can't be overwritten by the ISR. However, this approach would require changes to videobuf-core.c and that doesn't seem right. Can someone please give me some guidance on this?
>
> Regards,
> Mattias

You might want to take a look at possibly using gspca as a base for
your driver. It currently supports hundreds of cameras and there are
quite a few drivers that you can use as a reference. gspca doesn't use
videobuf.. but should make it less painful to write a driver.

Regards,

David Ellingsworth
