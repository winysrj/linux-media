Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:41169 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933091AbaICX4W (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 3 Sep 2014 19:56:22 -0400
Message-ID: <5407AAA3.1090607@iki.fi>
Date: Thu, 04 Sep 2014 02:56:19 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH 32/46] [media] e4000: simplify boolean tests
References: <cover.1409775488.git.m.chehab@samsung.com> <86da9d3c8d8ced8d61c8c57b774da2e7f7a2a4ef.1409775488.git.m.chehab@samsung.com>
In-Reply-To: <86da9d3c8d8ced8d61c8c57b774da2e7f7a2a4ef.1409775488.git.m.chehab@samsung.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Which is static analyzer you are referring to fix these?

Using true/false for boolean datatype sounds OK, but personally I 
dislike use of negation operator. For my eyes (foo = 0) / (foo == false) 
is better and I have changed all the time negate operators to equal 
operators from my drivers.

regards
Antti

On 09/03/2014 11:33 PM, Mauro Carvalho Chehab wrote:
> Instead of using if (foo == false), just use
> if (!foo).
>
> That allows a faster mental parsing when analyzing the
> code.
>
> Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
>
> diff --git a/drivers/media/tuners/e4000.c b/drivers/media/tuners/e4000.c
> index 90d93348f20c..cd9cf643f602 100644
> --- a/drivers/media/tuners/e4000.c
> +++ b/drivers/media/tuners/e4000.c
> @@ -400,7 +400,7 @@ static int e4000_g_volatile_ctrl(struct v4l2_ctrl *ctrl)
>   	struct e4000 *s = container_of(ctrl->handler, struct e4000, hdl);
>   	int ret;
>
> -	if (s->active == false)
> +	if (!s->active)
>   		return 0;
>
>   	switch (ctrl->id) {
> @@ -423,7 +423,7 @@ static int e4000_s_ctrl(struct v4l2_ctrl *ctrl)
>   	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
>   	int ret;
>
> -	if (s->active == false)
> +	if (!s->active)
>   		return 0;
>
>   	switch (ctrl->id) {
>

-- 
http://palosaari.fi/
