Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vc0-f175.google.com ([209.85.220.175]:65509 "EHLO
	mail-vc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757501Ab3DAUkK (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 1 Apr 2013 16:40:10 -0400
Received: by mail-vc0-f175.google.com with SMTP id hf12so2767174vcb.20
        for <linux-media@vger.kernel.org>; Mon, 01 Apr 2013 13:40:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201303261217.42913.hverkuil@xs4all.nl>
References: <201303261217.42913.hverkuil@xs4all.nl>
Date: Mon, 1 Apr 2013 16:40:09 -0400
Message-ID: <CAOcJUbz1WDetKXUm0nUwHt7ifqDhcy=uQ8NrKno6VnRk1k95cw@mail.gmail.com>
Subject: Re: [PATCH] Fix undefined reference to `au8522_attach'
From: Michael Krufky <mkrufky@linuxtv.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, mchehab@redhat.com,
	Fengguang Wu <fengguang.wu@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Good catch!  I don't know if this fix got merged yet or not, but it's correct.

Reviewed-by: Michael Krufky <mkrufky@linuxtv.org>

On Tue, Mar 26, 2013 at 7:17 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> au8522_attach is dependent on CONFIG_DVB_AU8522_DTV, not CONFIG_DVB_AU8522.
>
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
>
> diff --git a/drivers/media/dvb-frontends/au8522.h b/drivers/media/dvb-frontends/au8522.h
> index f2111e0..83fe9a6 100644
> --- a/drivers/media/dvb-frontends/au8522.h
> +++ b/drivers/media/dvb-frontends/au8522.h
> @@ -61,7 +61,7 @@ struct au8522_config {
>         enum au8522_if_freq qam_if;
>  };
>
> -#if IS_ENABLED(CONFIG_DVB_AU8522)
> +#if IS_ENABLED(CONFIG_DVB_AU8522_DTV)
>  extern struct dvb_frontend *au8522_attach(const struct au8522_config *config,
>                                           struct i2c_adapter *i2c);
>  #else
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
