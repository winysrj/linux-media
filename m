Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54588 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933157Ab2JYNes (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 25 Oct 2012 09:34:48 -0400
Date: Thu, 25 Oct 2012 11:34:35 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: "Hiremath, Vaibhav" <hvaibhav@ti.com>
Cc: Andrey Mandychev <andreymandychev@gmail.com>,
	"Taneja, Archit" <archit@ti.com>,
	"Valkeinen, Tomi" <tomi.valkeinen@ti.com>,
	"Semwal, Sumit" <sumit.semwal@ti.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Andrei Mandychev <andrei.mandychev@parrot.com>
Subject: Re: [PATCH] Fixed list_del corruption in videobuf-core.c :
 videobuf_queue_cancel()
Message-ID: <20121025113435.69e4e96f@redhat.com>
In-Reply-To: <79CD15C6BA57404B839C016229A409A83EB3A67D@DBDE01.ent.ti.com>
References: <1349451865-26678-1-git-send-email-andrei.mandychev@parrot.com>
	<79CD15C6BA57404B839C016229A409A83EB38F54@DBDE01.ent.ti.com>
	<CAH9bG+Cp8gURyZ=cc3doCd_TR2CzLMrcKSGMKpe55jmCNYr+KQ@mail.gmail.com>
	<79CD15C6BA57404B839C016229A409A83EB3A67D@DBDE01.ent.ti.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Vaibhav/Andrei,

Em Tue, 9 Oct 2012 17:32:25 +0000
"Hiremath, Vaibhav" <hvaibhav@ti.com> escreveu:

> On Tue, Oct 09, 2012 at 14:08:18, Andrey Mandychev wrote:
> > Hi,
> > 
> > Please find below some additional comments.
> > 
> > Actually it's not a real issue. It's more warning than issue. When you
> > are trying to delete element from the queue the implementation of
> > list_del (in list_debug.c) checks that previous element and next element
> > of the element you are going to delete reference to this element
> > properly. In other words the method checks the integrity of the queue
> > before deleting the element and it generates warning if something is
> > wrong. In my case the head looses a pointer to the next element because
> > of INIT_LIST_HEAD() 
> > and when we try to delete this element from the
> > queue the list_del() generates warning because the previous element
> > (i.e. head) doesn't reference to this element (element we want to
> > delete).
> > 
> > void __list_del_entry(struct list_head *entry)
> > {
> >     struct list_head *prev, *next;
> > 
> >     prev = entry->prev;
> >     next = entry->next;
> > 
> >     if (WARN(next == LIST_POISON1,
> >         "list_del corruption, %p->next is LIST_POISON1 (%p)\n",
> >         entry, LIST_POISON1) ||
> >         WARN(prev == LIST_POISON2,
> >         "list_del corruption, %p->prev is LIST_POISON2 (%p)\n",
> >         entry, LIST_POISON2) ||
> >         WARN(prev->next != entry,
> >         "list_del corruption. prev->next should be %p, "
> >         "but was %p\n", entry, prev->next) ||
> >         WARN(next->prev != entry,
> >         "list_del corruption. next->prev should be %p, "
> >         "but was %p\n", entry, next->prev))
> >         return;
> > 
> >     __list_del(prev, next);
> > }
> > 
> > So my patch is a small improvement that avoids generating this kind of
> > warning.
> > 
> 
> Any mechanism or suggestion to reproduce this issue, which I can 
> use to reproduce this issue. Just switching between LCD<=>TV, will be enough 
> to hit this issue?
> 
> Thanks,
> Vaibhav
> > --
> > BR,
> > Andrei
> > 
> > 
> > On Mon, Oct 8, 2012 at 4:50 PM, Hiremath, Vaibhav <hvaibhav@ti.com>
> > wrote:
> > 
> > 
> > 	On Fri, Oct 05, 2012 at 21:14:25, Andrei Mandychev wrote:
> > 	> If there is a buffer with VIDEOBUF_QUEUED state it won't be
> > deleted properly
> > 	> because the head of queue loses its elements by calling
> > INIT_LIST_HEAD()
> > 	> before videobuf_streamoff().
> > 	
> > 	
> > 	"dma_queue" is driver internal queue and videobuf_streamoff()
> > function
> > 	will end up into buf_release() callback, which in our case
> > doesn't do
> > 	anything with dmaqueue.
> > 	
> > 	
> > 	Did you face any runtime issues with this? I still did not
> > understand
> > 	about this corruption thing.
> > 	
> > 	Thanks,
> > 	Vaibhav
> > 	
> > 	> ---
> > 	>  drivers/media/video/omap/omap_vout.c |    2 +-
> > 	>  1 file changed, 1 insertion(+), 1 deletion(-)
> > 	>
> > 	> diff --git a/drivers/media/video/omap/omap_vout.c
> > b/drivers/media/video/omap/omap_vout.c
> > 	> index 409da0f..f02eb8e 100644
> > 	> --- a/drivers/media/video/omap/omap_vout.c
> > 	> +++ b/drivers/media/video/omap/omap_vout.c
> > 	> @@ -1738,8 +1738,8 @@ static int vidioc_streamoff(struct file
> > *file, void *fh, enum v4l2_buf_type i)
> > 	>               v4l2_err(&vout->vid_dev->v4l2_dev, "failed to
> > change mode in"
> > 	>                               " streamoff\n");
> > 	>
> > 	> -     INIT_LIST_HEAD(&vout->dma_queue);
> > 	>       ret = videobuf_streamoff(&vout->vbq);
> > 	> +     INIT_LIST_HEAD(&vout->dma_queue);

Why do we ever need to call INIT_LIST_HEAD() here in the first place?

List initialization should happen only once, when vout is created.
After that, list add/del macros should be used.

Having a code like this here seems to indicate that there are something
wrong somewhere.

Regards,
Mauro
