Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:35083 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932828AbeALK0X (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 12 Jan 2018 05:26:23 -0500
Message-ID: <1515667384.12538.51.camel@pengutronix.de>
Subject: Re: [Linaro-mm-sig] [PATCH] dma-buf: add some lockdep asserts to
 the reservation object implementation
From: Lucas Stach <l.stach@pengutronix.de>
To: Sumit Semwal <sumit.semwal@linaro.org>
Cc: linaro-mm-sig@lists.linaro.org, patchwork-lst@pengutronix.de,
        kernel@pengutronix.de, dri-devel@lists.freedesktop.org,
        linux-media@vger.kernel.org
Date: Thu, 11 Jan 2018 11:43:04 +0100
In-Reply-To: <20171201111216.7050-1-l.stach@pengutronix.de>
References: <20171201111216.7050-1-l.stach@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Did this fall through the cracks over the holidays? It really has made
my work much easier while reworking some of the reservation object
handling in etnaviv and I think it might benefit others.

Regards,
Lucas

Am Freitag, den 01.12.2017, 12:12 +0100 schrieb Lucas Stach:
> This adds lockdep asserts to the reservation functions which state in their
> documentation that obj->lock must be held. Allows builds with PROVE_LOCKING
> enabled to check that the locking requirements are met.
> 
> > Signed-off-by: Lucas Stach <l.stach@pengutronix.de>
> ---
>  drivers/dma-buf/reservation.c | 8 ++++++++
>  include/linux/reservation.h   | 2 ++
>  2 files changed, 10 insertions(+)
> 
> diff --git a/drivers/dma-buf/reservation.c b/drivers/dma-buf/reservation.c
> index b44d9d7db347..accd398e2ea6 100644
> --- a/drivers/dma-buf/reservation.c
> +++ b/drivers/dma-buf/reservation.c
> @@ -71,6 +71,8 @@ int reservation_object_reserve_shared(struct reservation_object *obj)
> >  	struct reservation_object_list *fobj, *old;
> >  	u32 max;
>  
> > +	reservation_object_assert_held(obj);
> +
> >  	old = reservation_object_get_list(obj);
>  
> >  	if (old && old->shared_max) {
> @@ -211,6 +213,8 @@ void reservation_object_add_shared_fence(struct reservation_object *obj,
>  {
> >  	struct reservation_object_list *old, *fobj = obj->staged;
>  
> > +	reservation_object_assert_held(obj);
> +
> >  	old = reservation_object_get_list(obj);
> >  	obj->staged = NULL;
>  
> @@ -236,6 +240,8 @@ void reservation_object_add_excl_fence(struct reservation_object *obj,
> >  	struct reservation_object_list *old;
> >  	u32 i = 0;
>  
> > +	reservation_object_assert_held(obj);
> +
> >  	old = reservation_object_get_list(obj);
> >  	if (old)
> >  		i = old->shared_count;
> @@ -276,6 +282,8 @@ int reservation_object_copy_fences(struct reservation_object *dst,
> >  	size_t size;
> >  	unsigned i;
>  
> > +	reservation_object_assert_held(dst);
> +
> >  	rcu_read_lock();
> >  	src_list = rcu_dereference(src->fence);
>  
> diff --git a/include/linux/reservation.h b/include/linux/reservation.h
> index 21fc84d82d41..55e7318800fd 100644
> --- a/include/linux/reservation.h
> +++ b/include/linux/reservation.h
> @@ -212,6 +212,8 @@ reservation_object_unlock(struct reservation_object *obj)
>  static inline struct dma_fence *
>  reservation_object_get_excl(struct reservation_object *obj)
>  {
> > +	reservation_object_assert_held(obj);
> +
> >  	return rcu_dereference_protected(obj->fence_excl,
> >  					 reservation_object_held(obj));
>  }
