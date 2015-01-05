Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f54.google.com ([209.85.220.54]:53353 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753228AbbAEOgF (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 5 Jan 2015 09:36:05 -0500
Received: by mail-pa0-f54.google.com with SMTP id fb1so28904862pad.27
        for <linux-media@vger.kernel.org>; Mon, 05 Jan 2015 06:36:05 -0800 (PST)
Message-ID: <54AAA150.7000109@gmail.com>
Date: Mon, 05 Jan 2015 23:36:00 +0900
From: Akihiro TSUKADA <tskd08@gmail.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH 4/5] dvb core: add media controller support for the demod
References: <cover.1420127255.git.mchehab@osg.samsung.com> <16368e1f9dfb1db65ec6f0d91a38d5233a12542c.1420127255.git.mchehab@osg.samsung.com>
In-Reply-To: <16368e1f9dfb1db65ec6f0d91a38d5233a12542c.1420127255.git.mchehab@osg.samsung.com>
Content-Type: text/plain; charset=iso-2022-jp
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 2015年01月02日 00:51, Mauro Carvalho Chehab wrote:
>  /*
> @@ -416,6 +418,11 @@ struct dvb_frontend {
>  	struct dvb_frontend_ops ops;
>  	struct dvb_adapter *dvb;
>  	struct i2c_client *fe_cl;
> +#if defined(CONFIG_MEDIA_CONTROLLER)
> +	struct media_device *mdev;
> +	struct media_entity demod_entity;
> +#endif
> +

I understood that this patch was invalidated by the updated patch series:
"dvb core: add basic suuport for the media controller",
and now the demod_entity is registered in dvbdev.c::dvb_register_device()
via dvb_frontend_register(). Is that right?
And if so,
Shouldn't only the (tuner) subdevices be registered separately
in dvb_i2c_attach_tuner(), instead of dvb_i2c_attach_fe()?
(and it would be simpler if "mdev" can be accessed
like dvb_fe_get_mdev() {return fepriv->dvbdev->mdev;},
instead of having a cached value in dvb_frontend.)

sorry if I'm totally wrong,
I don't have an experience with media controller API.

regards,
akihiro
