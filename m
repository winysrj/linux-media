Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:39562 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751173AbdILStf (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 12 Sep 2017 14:49:35 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Max Kellermann <max.kellermann@gmail.com>,
        Shuah Khan <shuah@kernel.org>,
        Colin Ian King <colin.king@canonical.com>,
        Ingo Molnar <mingo@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Masahiro Yamada <yamada.masahiro@socionext.com>
Subject: Re: [PATCH] media: dvb_frontend: only use kref after initialized
Date: Tue, 12 Sep 2017 21:49:35 +0300
Message-ID: <3219429.OiDNIzDXCm@avalon>
In-Reply-To: <f763ad52d4cb7cf2190871ccb461ab28e3c45eef.1505211481.git.mchehab@s-opensource.com>
References: <f763ad52d4cb7cf2190871ccb461ab28e3c45eef.1505211481.git.mchehab@s-opensource.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Thank you for the patch.

On Tuesday, 12 September 2017 13:19:10 EEST Mauro Carvalho Chehab wrote:
> As reported by Laurent, when a DVB frontend need to register
> two drivers (e. g. a tuner and a demod), if the second driver
> fails to register (for example because it was not compiled),
> the error handling logic frees the frontend by calling
> dvb_frontend_detach(). That used to work fine, but changeset
> 1f862a68df24 ("[media] dvb_frontend: move kref to struct dvb_frontend")
> added a kref at struct dvb_frontend. So, now, instead of just
> freeing the data, the error handling do a kref_put().
> 
> That works fine only after dvb_register_frontend() succeeds.
> 
> While it would be possible to add a helper function that
> would be initializing earlier the kref, that would require
> changing every single DVB frontend on non-trivial ways, and
> would make frontends different than other drivers.
> 
> So, instead of doing that, let's focus on the real issue:
> only call kref_put() after kref_init(). That's easy to
> check, as, when the dvb frontend is successfuly registered,
> it will allocate its own private struct. So, if such
> struct is allocated, it means that it is safe to use
> kref_put(). If not, then nobody is using yet the frontend,
> and it is safe to just deallocate it.
> 
> Fixes: 1f862a68df24 ("[media] dvb_frontend: move kref to struct
> dvb_frontend") Reported-by: Laurent Pinchart
> <laurent.pinchart+renesas@ideasonboard.com> Signed-off-by: Mauro Carvalho
> Chehab <mchehab@s-opensource.com>
> ---
> 
> Laurent,
> 
> Could you please check if this patch fixes the issue you noticed?

I can't as I don't have the device with me this week.

Reviewing the code, I think this is a hack. Now, if dvb_attach() goes away, I 
understand you might not want to change all old-style drivers to fix the issue 
I've reported, only to convert them to the new API later. However, API 
conversion seems to go very slow. In the end it's up to you whether you want 
to fix issues properly or hack around them, but pilin up hacks creates a 
technical debt that will bite you back sooner or latter (and definitely at the 
worst possible time).

>  drivers/media/dvb-core/dvb_frontend.c | 25 +++++++++++++++++++++----
>  1 file changed, 21 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/media/dvb-core/dvb_frontend.c
> b/drivers/media/dvb-core/dvb_frontend.c index 2fcba1616168..9139d01ba7ed
> 100644
> --- a/drivers/media/dvb-core/dvb_frontend.c
> +++ b/drivers/media/dvb-core/dvb_frontend.c
> @@ -141,22 +141,39 @@ struct dvb_frontend_private {
>  static void dvb_frontend_invoke_release(struct dvb_frontend *fe,
>  					void (*release)(struct dvb_frontend *fe));
> 
> -static void dvb_frontend_free(struct kref *ref)
> +static void __dvb_frontend_free(struct dvb_frontend *fe)
>  {
> -	struct dvb_frontend *fe =
> -		container_of(ref, struct dvb_frontend, refcount);
>  	struct dvb_frontend_private *fepriv = fe->frontend_priv;
> 
> +	if (!fepriv)
> +		return;
> +
>  	dvb_free_device(fepriv->dvbdev);
> 
>  	dvb_frontend_invoke_release(fe, fe->ops.release);
> 
>  	kfree(fepriv);
> +	fe->frontend_priv = NULL;
> +}
> +
> +static void dvb_frontend_free(struct kref *ref)
> +{
> +	struct dvb_frontend *fe =
> +		container_of(ref, struct dvb_frontend, refcount);
> +
> +	__dvb_frontend_free(fe);
>  }
> 
>  static void dvb_frontend_put(struct dvb_frontend *fe)
>  {
> -	kref_put(&fe->refcount, dvb_frontend_free);
> +	/*
> +	 * Check if the frontend was registered, as otherwise
> +	 * kref was not initialized yet.
> +	 */
> +	if (fe->frontend_priv)
> +		kref_put(&fe->refcount, dvb_frontend_free);
> +	else
> +		__dvb_frontend_free(fe);
>  }
> 
>  static void dvb_frontend_get(struct dvb_frontend *fe)


-- 
Regards,

Laurent Pinchart
