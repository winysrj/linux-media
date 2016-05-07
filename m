Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:43637 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752156AbcEGNWl (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 7 May 2016 09:22:41 -0400
Date: Sat, 7 May 2016 10:22:35 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Soeren Moch <smoch@web.de>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] media: dvb_ringbuffer: Add memory barriers
Message-ID: <20160507102235.22e096d8@recife.lan>
In-Reply-To: <56B7997C.1070503@web.de>
References: <1451248920-4935-1-git-send-email-smoch@web.de>
	<56B7997C.1070503@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Soeren,

Em Sun, 7 Feb 2016 20:22:36 +0100
Soeren Moch <smoch@web.de> escreveu:

> On 27.12.2015 21:41, Soeren Moch wrote:
> > Implement memory barriers according to Documentation/circular-buffers.txt:
> > - use smp_store_release() to update ringbuffer read/write pointers
> > - use smp_load_acquire() to load write pointer on reader side
> > - use ACCESS_ONCE() to load read pointer on writer side
> >
> > This fixes data stream corruptions observed e.g. on an ARM Cortex-A9
> > quad core system with different types (PCI, USB) of DVB tuners.
> >
> > Signed-off-by: Soeren Moch <smoch@web.de>
> > Cc: stable@vger.kernel.org # 3.14+  
> 
> Mauro,
> 
> any news or comments on this?
> Since this is a real fix for broken behaviour, can you pick this up, please?

The problem here is that I'm very reluctant to touch at the DVB core
without doing some tests myself, as things like locking can be
very sensible.

I'll try to find some time to take a look on it for Kernel 4.8,
but I'd like to reproduce the bug locally.

Could you please provide me enough info to reproduce it (and
eventually some test MPEG-TS where you know this would happen)?

I have two DekTek RF generators here, so I should be able to
play such TS and see what happens with and without the patch
on x86, arm32 and arm64.

Regards,
Mauro

> 
> Regards,
> Soeren
> 
> > ---
> > Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> > Cc: linux-media@vger.kernel.org
> > Cc: linux-kernel@vger.kernel.org
> >
> > Since smp_store_release() and smp_load_acquire() were introduced in linux-3.14,
> > a 3.14+ stable tag was added. Is it desired to apply a similar patch to older
> > stable kernels?
> > ---
> >  drivers/media/dvb-core/dvb_ringbuffer.c | 27 ++++++++++++++-------------
> >  1 file changed, 14 insertions(+), 13 deletions(-)
> >
> > diff --git a/drivers/media/dvb-core/dvb_ringbuffer.c b/drivers/media/dvb-core/dvb_ringbuffer.c
> > index 1100e98..58b5968 100644
> > --- a/drivers/media/dvb-core/dvb_ringbuffer.c
> > +++ b/drivers/media/dvb-core/dvb_ringbuffer.c
> > @@ -55,7 +55,7 @@ void dvb_ringbuffer_init(struct dvb_ringbuffer *rbuf, void *data, size_t len)
> >  
> >  int dvb_ringbuffer_empty(struct dvb_ringbuffer *rbuf)
> >  {
> > -	return (rbuf->pread==rbuf->pwrite);
> > +	return (rbuf->pread == smp_load_acquire(&rbuf->pwrite));
> >  }
> >  
> >  
> > @@ -64,7 +64,7 @@ ssize_t dvb_ringbuffer_free(struct dvb_ringbuffer *rbuf)
> >  {
> >  	ssize_t free;
> >  
> > -	free = rbuf->pread - rbuf->pwrite;
> > +	free = ACCESS_ONCE(rbuf->pread) - rbuf->pwrite;
> >  	if (free <= 0)
> >  		free += rbuf->size;
> >  	return free-1;
> > @@ -76,7 +76,7 @@ ssize_t dvb_ringbuffer_avail(struct dvb_ringbuffer *rbuf)
> >  {
> >  	ssize_t avail;
> >  
> > -	avail = rbuf->pwrite - rbuf->pread;
> > +	avail = smp_load_acquire(&rbuf->pwrite) - rbuf->pread;
> >  	if (avail < 0)
> >  		avail += rbuf->size;
> >  	return avail;
> > @@ -86,14 +86,15 @@ ssize_t dvb_ringbuffer_avail(struct dvb_ringbuffer *rbuf)
> >  
> >  void dvb_ringbuffer_flush(struct dvb_ringbuffer *rbuf)
> >  {
> > -	rbuf->pread = rbuf->pwrite;
> > +	smp_store_release(&rbuf->pread, smp_load_acquire(&rbuf->pwrite));
> >  	rbuf->error = 0;
> >  }
> >  EXPORT_SYMBOL(dvb_ringbuffer_flush);
> >  
> >  void dvb_ringbuffer_reset(struct dvb_ringbuffer *rbuf)
> >  {
> > -	rbuf->pread = rbuf->pwrite = 0;
> > +	smp_store_release(&rbuf->pread, 0);
> > +	smp_store_release(&rbuf->pwrite, 0);
> >  	rbuf->error = 0;
> >  }
> >  
> > @@ -119,12 +120,12 @@ ssize_t dvb_ringbuffer_read_user(struct dvb_ringbuffer *rbuf, u8 __user *buf, si
> >  			return -EFAULT;
> >  		buf += split;
> >  		todo -= split;
> > -		rbuf->pread = 0;
> > +		smp_store_release(&rbuf->pread, 0);
> >  	}
> >  	if (copy_to_user(buf, rbuf->data+rbuf->pread, todo))
> >  		return -EFAULT;
> >  
> > -	rbuf->pread = (rbuf->pread + todo) % rbuf->size;
> > +	smp_store_release(&rbuf->pread, (rbuf->pread + todo) % rbuf->size);
> >  
> >  	return len;
> >  }
> > @@ -139,11 +140,11 @@ void dvb_ringbuffer_read(struct dvb_ringbuffer *rbuf, u8 *buf, size_t len)
> >  		memcpy(buf, rbuf->data+rbuf->pread, split);
> >  		buf += split;
> >  		todo -= split;
> > -		rbuf->pread = 0;
> > +		smp_store_release(&rbuf->pread, 0);
> >  	}
> >  	memcpy(buf, rbuf->data+rbuf->pread, todo);
> >  
> > -	rbuf->pread = (rbuf->pread + todo) % rbuf->size;
> > +	smp_store_release(&rbuf->pread, (rbuf->pread + todo) % rbuf->size);
> >  }
> >  
> >  
> > @@ -158,10 +159,10 @@ ssize_t dvb_ringbuffer_write(struct dvb_ringbuffer *rbuf, const u8 *buf, size_t
> >  		memcpy(rbuf->data+rbuf->pwrite, buf, split);
> >  		buf += split;
> >  		todo -= split;
> > -		rbuf->pwrite = 0;
> > +		smp_store_release(&rbuf->pwrite, 0);
> >  	}
> >  	memcpy(rbuf->data+rbuf->pwrite, buf, todo);
> > -	rbuf->pwrite = (rbuf->pwrite + todo) % rbuf->size;
> > +	smp_store_release(&rbuf->pwrite, (rbuf->pwrite + todo) % rbuf->size);
> >  
> >  	return len;
> >  }
> > @@ -181,12 +182,12 @@ ssize_t dvb_ringbuffer_write_user(struct dvb_ringbuffer *rbuf,
> >  			return len - todo;
> >  		buf += split;
> >  		todo -= split;
> > -		rbuf->pwrite = 0;
> > +		smp_store_release(&rbuf->pwrite, 0);
> >  	}
> >  	status = copy_from_user(rbuf->data+rbuf->pwrite, buf, todo);
> >  	if (status)
> >  		return len - todo;
> > -	rbuf->pwrite = (rbuf->pwrite + todo) % rbuf->size;
> > +	smp_store_release(&rbuf->pwrite, (rbuf->pwrite + todo) % rbuf->size);
> >  
> >  	return len;
> >  }  
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 
Thanks,
Mauro
