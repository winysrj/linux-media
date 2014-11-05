Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:43534 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751732AbaKEJO7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 5 Nov 2014 04:14:59 -0500
Date: Wed, 5 Nov 2014 07:14:54 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCH 4/8] sp2: fix sparse warnings
Message-ID: <20141105071454.6fe2b595@recife.lan>
In-Reply-To: <1415175472-24203-5-git-send-email-hverkuil@xs4all.nl>
References: <1415175472-24203-1-git-send-email-hverkuil@xs4all.nl>
	<1415175472-24203-5-git-send-email-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed,  5 Nov 2014 09:17:48 +0100
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> sp2.c:272:5: warning: symbol 'sp2_init' was not declared. Should it be static?
> sp2.c:354:5: warning: symbol 'sp2_exit' was not declared. Should it be static?

This one was fixed already (at fixes branch).

> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  drivers/media/dvb-frontends/sp2.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/dvb-frontends/sp2.c b/drivers/media/dvb-frontends/sp2.c
> index 320cbe9..cc1ef96 100644
> --- a/drivers/media/dvb-frontends/sp2.c
> +++ b/drivers/media/dvb-frontends/sp2.c
> @@ -269,7 +269,7 @@ int sp2_ci_poll_slot_status(struct dvb_ca_en50221 *en50221,
>  	return s->status;
>  }
>  
> -int sp2_init(struct sp2 *s)
> +static int sp2_init(struct sp2 *s)
>  {
>  	int ret = 0;
>  	u8 buf;
> @@ -351,7 +351,7 @@ err:
>  	return ret;
>  }
>  
> -int sp2_exit(struct i2c_client *client)
> +static int sp2_exit(struct i2c_client *client)
>  {
>  	struct sp2 *s;
>  
