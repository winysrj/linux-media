Return-path: <linux-media-owner@vger.kernel.org>
Received: from www84.your-server.de ([213.133.104.84]:40686 "EHLO
        www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751443AbdK3Mz0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 30 Nov 2017 07:55:26 -0500
Message-ID: <1512045250.2568.1.camel@seibold.net>
Subject: Re: [PATCH v3 26/26] kfifo: DECLARE_KIFO_PTR(fifo, u64) does not
 work on arm 32 bit
From: Stefani Seibold <stefani@seibold.net>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Sean Young <sean@mess.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Randy Dunlap <randy.dunlap@oracle.com>
Date: Thu, 30 Nov 2017 13:34:10 +0100
In-Reply-To: <20171130102946.7168e93c@vento.lan>
References: <cover.1507618840.git.sean@mess.org>
         <1507622382.6064.2.camel@seibold.net> <20171130102946.7168e93c@vento.lan>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 2017-11-30 at 10:29 -0200, Mauro Carvalho Chehab wrote:
> Em Tue, 10 Oct 2017 09:59:42 +0200
> Sean Young <sean@mess.org> escreveu:
> 
> > If you try to store u64 in a kfifo (or a struct with u64 members),
> > then the buf member of __STRUCT_KFIFO_PTR will cause 4 bytes
> > padding due to alignment (note that struct __kfifo is 20 bytes
> > on 32 bit).
> > 
> > That in turn causes the __is_kfifo_ptr() to fail, which is caught
> > by kfifo_alloc(), which now returns EINVAL.
> > 
> > So, ensure that __is_kfifo_ptr() compares to the right structure.
> > 
> > Signed-off-by: Sean Young <sean@mess.org>
> > Acked-by: Stefani Seibold <stefani@seibold.net>
> 
> Hi Stefani/Andrew,
> 
> As this patch is required for the LIRC rework, would be ok if I would
> merge it via the media tree?
> 

It is okay by me. But the question remains why this patch wasn't
already merged?

Andrew: Any objections against this patch?


> > 
> > ---
> >  include/linux/kfifo.h | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> > 
> > diff --git a/include/linux/kfifo.h b/include/linux/kfifo.h
> > index 41eb6fdf87a8..86b5fb08e96c 100644
> > --- a/include/linux/kfifo.h
> > +++ b/include/linux/kfifo.h
> > @@ -113,7 +113,8 @@ struct kfifo_rec_ptr_2
> > __STRUCT_KFIFO_PTR(unsigned char, 2, void);
> >   * array is a part of the structure and the fifo type where the
> > array is
> >   * outside of the fifo structure.
> >   */
> > -#define	__is_kfifo_ptr(fifo)	(sizeof(*fifo) ==
> > sizeof(struct __kfifo))
> > +#define	__is_kfifo_ptr(fifo) \
> > +	(sizeof(*fifo) == sizeof(STRUCT_KFIFO_PTR(typeof(*(fifo)-
> > >type))))
> >  
> >  /**
> >   * DECLARE_KFIFO_PTR - macro to declare a fifo pointer object
> 
> 
> 
> Thanks,
> Mauro
