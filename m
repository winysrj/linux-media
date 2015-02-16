Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud6.xs4all.net ([194.109.24.28]:52591 "EHLO
	lb2-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755397AbbBPMwa (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Feb 2015 07:52:30 -0500
Message-ID: <54E1E7FB.40703@xs4all.nl>
Date: Mon, 16 Feb 2015 13:52:11 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
CC: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Shuah Khan <shuah.kh@samsung.com>,
	Ole Ernst <olebowle@gmx.com>,
	Akihiro Tsukada <tskd08@gmail.com>
Subject: Re: [PATCHv4 25/25] [media] dvb_frontend: start media pipeline while
 thread is running
References: <cover.1423867976.git.mchehab@osg.samsung.com> <08d239bd74bdc64596313f3c7edc21bff7a888c5.1423867976.git.mchehab@osg.samsung.com>
In-Reply-To: <08d239bd74bdc64596313f3c7edc21bff7a888c5.1423867976.git.mchehab@osg.samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/13/2015 11:58 PM, Mauro Carvalho Chehab wrote:
> While the DVB thread is running, the media pipeline should be
> streaming. This should prevent any attempt of using the analog
> TV while digital TV is working, and vice-versa.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> 
> diff --git a/drivers/media/dvb-core/dvb_frontend.c b/drivers/media/dvb-core/dvb_frontend.c
> index 50bc6056e914..aa5306908193 100644
> --- a/drivers/media/dvb-core/dvb_frontend.c
> +++ b/drivers/media/dvb-core/dvb_frontend.c
> @@ -131,6 +131,11 @@ struct dvb_frontend_private {
>  	int quality;
>  	unsigned int check_wrapped;
>  	enum dvbfe_search algo_status;
> +
> +#if defined(CONFIG_MEDIA_CONTROLLER_DVB)
> +	struct media_pipeline pipe;
> +	struct media_entity *pipe_start_entity;
> +#endif
>  };
>  
>  static void dvb_frontend_wakeup(struct dvb_frontend *fe);
> @@ -608,9 +613,9 @@ static void dvb_frontend_wakeup(struct dvb_frontend *fe)
>   * or 0 if everything is OK, if no tuner is linked to the frontend or if the
>   * mdev is NULL.
>   */
> +#ifdef CONFIG_MEDIA_CONTROLLER_DVB
>  static int dvb_enable_media_tuner(struct dvb_frontend *fe)
>  {
> -#ifdef CONFIG_MEDIA_CONTROLLER_DVB
>  	struct dvb_frontend_private *fepriv = fe->frontend_priv;
>  	struct dvb_adapter *adapter = fe->dvb;
>  	struct media_device *mdev = adapter->mdev;
> @@ -618,10 +623,14 @@ static int dvb_enable_media_tuner(struct dvb_frontend *fe)
>  	struct media_link *link, *found_link = NULL;
>  	int i, ret, n_links = 0, active_links = 0;
>  
> +	fepriv->pipe_start_entity = NULL;
> +
>  	if (!mdev)
>  		return 0;
>  
>  	entity = fepriv->dvbdev->entity;
> +	fepriv->pipe_start_entity = entity;
> +
>  	for (i = 0; i < entity->num_links; i++) {
>  		link = &entity->links[i];
>  		if (link->sink->entity == entity) {
> @@ -648,6 +657,7 @@ static int dvb_enable_media_tuner(struct dvb_frontend *fe)
>  	}
>  
>  	source = found_link->source->entity;
> +	fepriv->pipe_start_entity = source;
>  	for (i = 0; i < source->num_links; i++) {
>  		struct media_entity *sink;
>  		int flags = 0;
> @@ -672,9 +682,9 @@ static int dvb_enable_media_tuner(struct dvb_frontend *fe)
>  				source->name, sink->name,
>  				flags ? "ENABLED" : "disabled");
>  	}
> -#endif
>  	return 0;
>  }
> +#endif
>  
>  static int dvb_frontend_thread(void *data)
>  {
> @@ -696,12 +706,19 @@ static int dvb_frontend_thread(void *data)
>  	fepriv->wakeup = 0;
>  	fepriv->reinitialise = 0;
>  
> +#ifdef CONFIG_MEDIA_CONTROLLER_DVB

With this change I get this warning:

drivers/media/dvb-core/dvb_frontend.c: In function ‘dvb_frontend_thread’:
drivers/media/dvb-core/dvb_frontend.c:695:6: warning: unused variable ‘ret’ [-Wunused-variable]
  int ret;
      ^

So the 'ret' variable declaration should be under #ifdef CONFIG_MEDIA_CONTROLLER_DVB
as well.

Regards,

	Hans

>  	ret = dvb_enable_media_tuner(fe);
>  	if (ret) {
>  		/* FIXME: return an error if it fails */
>  		dev_info(fe->dvb->device,
>  			"proceeding with FE task\n");
> +	} else {
> +		ret = media_entity_pipeline_start(fepriv->pipe_start_entity,
> +						  &fepriv->pipe);
> +		if (ret)
> +			return ret;
>  	}
> +#endif
>  
>  	dvb_frontend_init(fe);
>  
> @@ -812,6 +829,11 @@ restart:
>  		}
>  	}
>  
> +#ifdef CONFIG_MEDIA_CONTROLLER_DVB
> +	media_entity_pipeline_stop(fepriv->pipe_start_entity);
> +	fepriv->pipe_start_entity = NULL;
> +#endif
> +
>  	if (dvb_powerdown_on_sleep) {
>  		if (fe->ops.set_voltage)
>  			fe->ops.set_voltage(fe, SEC_VOLTAGE_OFF);
> 

