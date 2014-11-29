Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:57326 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751408AbaK2SLO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 29 Nov 2014 13:11:14 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Prabhakar Lad <prabhakar.csengg@gmail.com>
Cc: LMML <linux-media@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [PATCH v3] media: usb: uvc: use vb2_ops_wait_prepare/finish helper
Date: Sat, 29 Nov 2014 20:11:41 +0200
Message-ID: <1532665.63kW7uD9fo@avalon>
In-Reply-To: <CA+V-a8sAUDo+ut1t2_twy6hNjX5WQpridCEm6NrNmrwQvR1Nrw@mail.gmail.com>
References: <1417044344-20611-1-git-send-email-prabhakar.csengg@gmail.com> <4838705.gmGJIAUqrM@avalon> <CA+V-a8sAUDo+ut1t2_twy6hNjX5WQpridCEm6NrNmrwQvR1Nrw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Prabhakar,

On Friday 28 November 2014 17:06:52 Prabhakar Lad wrote:
> On Thu, Nov 27, 2014 at 9:32 PM, Laurent Pinchart wrote:
> > Hi Prabhakar,
> 
> [Snip]
> 
> >> +     queue->queue.lock = &queue->mutex;
> > 
> > I'm a bit concerned that this would introduce future breakages. Setting
> > the queue.lock pointer enables locking in all vb2_fop_* and vb2_ops_wait_*
> > functions. The uvcvideo driver isn't ready for that, but doesn't use the
> > vb2_fop_* functions yet, so that's not an issue. However, in the future,
> > videobuf2 might use the lock in more places, including functions used by
> > the uvcvideo driver. This could then cause breakages.
> 
> Even if in future if videobuf2 uses this lock it would be in helpers mostly,
> so any way it doesn’t harm :)

My concern is about vb2 starting using the lock in existing helpers used by 
the uvcvideo driver. I suppose we can deal with it later.

> > It would be better to completely convert the uvcvideo driver to the
> > vb2_fop_* functions if we want to use vb2_ops_*. I'm not sure how complex
> > that would be though, and whether it would be possible while still
> > keeping the fine-grained locking implemented by the uvcvideo driver. Do
> > you think it should be attempted ?
> 
> mmap & poll should be fairly simple, looks like open & release cannot be
> dropped as it does some usb_autopm_get/put_interface() calls which I am not
> aware of.

I've looked at that, and there's a race condition in vb2_fop_poll() (for which 
I've already sent a patch) and possible in vb2_mmap() (raised the issue on 
#v4l today) as well that need to be fixed first.

Anyway, for this patch

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

Have you tested it by the way ?

Should I take it in my tree or will you send a pull request for the whole 
series ?

> >>       ret = vb2_queue_init(&queue->queue);
> >>       if (ret)
> >>               return ret;

-- 
Regards,

Laurent Pinchart

