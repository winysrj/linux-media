Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:42254 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727082AbeIMUDp (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 13 Sep 2018 16:03:45 -0400
Date: Thu, 13 Sep 2018 11:53:49 -0300
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: Maxime Ripard <maxime.ripard@bootlin.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        linux-media@vger.kernel.org
Subject: Re: [PATCH v2] staging: cedrus: Fix checkpatch issues
Message-ID: <20180913115349.608531f8@coco.lan>
In-Reply-To: <20180913144047.6390-1-maxime.ripard@bootlin.com>
References: <20180913144047.6390-1-maxime.ripard@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 13 Sep 2018 16:40:47 +0200
Maxime Ripard <maxime.ripard@bootlin.com> escreveu:


> --- a/drivers/staging/media/sunxi/cedrus/cedrus_video.c
> +++ b/drivers/staging/media/sunxi/cedrus/cedrus_video.c
> @@ -82,10 +82,7 @@ static struct cedrus_format *cedrus_find_format(u32 pixelformat, u32 directions,
>  static bool cedrus_check_format(u32 pixelformat, u32 directions,
>  				unsigned int capabilities)
>  {
> -	struct cedrus_format *fmt = cedrus_find_format(pixelformat, directions,
> -						       capabilities);
> -
> -	return fmt != NULL;
> +	return cedrus_find_format(pixelformat, directions, capabilities);
>  }

Hmm... just occurred to me... Why do you need this? I mean, you 
could simply do something like:

$ git filter-branch -f --tree-filter 'for i in $(git grep -l cedrus_check_format); do \
	sed -E s,\\bcedrus_check_format\\b,cedrus_find_format,g -i $i; done ' origin/master..

(or just do a sed -E s,\\bcedrus_check_format\\b,cedrus_find_format,g as
a separate patch)

and get rid of cedrus_check_format() for good.

Thanks,
Mauro
