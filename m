Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:1632 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756066AbaCONsP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 15 Mar 2014 09:48:15 -0400
Message-ID: <532459E8.9060903@xs4all.nl>
Date: Sat, 15 Mar 2014 14:47:20 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Fengguang Wu <fengguang.wu@intel.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [RFC PATCH 1/3] dvbdev: add a dvb_dettach() macro
References: <1394890994-29185-1-git-send-email-m.chehab@samsung.com> <1394890994-29185-2-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1394890994-29185-2-git-send-email-m.chehab@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On 03/15/2014 02:43 PM, Mauro Carvalho Chehab wrote:
> The dvb_attach() was unbalanced, as there was no dvb_dettach. Ok,
> on current cases, the dettach is done by dvbdev, but that are some
> future corner cases where we may need to do this before registering
> the frontend.
> 
> So, add a dvb_dettach() and use it at dvb_frontend.c.

Typo: it's spelled 'detach', one 't'.

Regards,

	Hans

> 
> Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
> ---
>  drivers/media/dvb-core/dvb_frontend.c | 8 ++++----
>  drivers/media/dvb-core/dvbdev.h       | 4 ++++
>  2 files changed, 8 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/media/dvb-core/dvb_frontend.c b/drivers/media/dvb-core/dvb_frontend.c
> index 6ce435ac866f..24cf4fbf92a8 100644
> --- a/drivers/media/dvb-core/dvb_frontend.c
> +++ b/drivers/media/dvb-core/dvb_frontend.c
> @@ -2666,20 +2666,20 @@ void dvb_frontend_detach(struct dvb_frontend* fe)
>  
>  	if (fe->ops.release_sec) {
>  		fe->ops.release_sec(fe);
> -		symbol_put_addr(fe->ops.release_sec);
> +		dvb_dettach(fe->ops.release_sec);
>  	}
>  	if (fe->ops.tuner_ops.release) {
>  		fe->ops.tuner_ops.release(fe);
> -		symbol_put_addr(fe->ops.tuner_ops.release);
> +		dvb_dettach(fe->ops.tuner_ops.release);
>  	}
>  	if (fe->ops.analog_ops.release) {
>  		fe->ops.analog_ops.release(fe);
> -		symbol_put_addr(fe->ops.analog_ops.release);
> +		dvb_dettach(fe->ops.analog_ops.release);
>  	}
>  	ptr = (void*)fe->ops.release;
>  	if (ptr) {
>  		fe->ops.release(fe);
> -		symbol_put_addr(ptr);
> +		dvb_dettach(ptr);
>  	}
>  }
>  #else
> diff --git a/drivers/media/dvb-core/dvbdev.h b/drivers/media/dvb-core/dvbdev.h
> index 93a9470d3f0c..49904efc476c 100644
> --- a/drivers/media/dvb-core/dvbdev.h
> +++ b/drivers/media/dvb-core/dvbdev.h
> @@ -136,11 +136,15 @@ extern int dvb_usercopy(struct file *file, unsigned int cmd, unsigned long arg,
>  	__r; \
>  })
>  
> +#define dvb_dettach(FUNC)	symbol_put_addr(FUNC)
> +
>  #else
>  #define dvb_attach(FUNCTION, ARGS...) ({ \
>  	FUNCTION(ARGS); \
>  })
>  
> +#define dvb_dettach(FUNC)	{}
> +
>  #endif
>  
>  #endif /* #ifndef _DVBDEV_H_ */
> 

