Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:45920 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751757Ab2LDXWO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 4 Dec 2012 18:22:14 -0500
Date: Wed, 5 Dec 2012 01:22:08 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Andrzej Hajda <a.hajda@samsung.com>
Cc: linux-media@vger.kernel.org,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Seung-Woo Kim <sw0312.kim@samsung.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [PATCH RFC 3/3] s5p-fimc: improved pipeline try format routine
Message-ID: <20121204232208.GP31879@valkosipuli.retiisi.org.uk>
References: <1353684150-24581-1-git-send-email-a.hajda@samsung.com>
 <1353684150-24581-4-git-send-email-a.hajda@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1353684150-24581-4-git-send-email-a.hajda@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Andrzej,

On Fri, Nov 23, 2012 at 04:22:30PM +0100, Andrzej Hajda wrote:
> Function support variable number of subdevs in pipe-line.
> 
> Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  drivers/media/platform/s5p-fimc/fimc-capture.c |  100 +++++++++++++++---------
>  1 file changed, 64 insertions(+), 36 deletions(-)
> 
> diff --git a/drivers/media/platform/s5p-fimc/fimc-capture.c b/drivers/media/platform/s5p-fimc/fimc-capture.c
> index 3acbea3..39c4555 100644
> --- a/drivers/media/platform/s5p-fimc/fimc-capture.c
> +++ b/drivers/media/platform/s5p-fimc/fimc-capture.c
> @@ -794,6 +794,21 @@ static int fimc_cap_enum_fmt_mplane(struct file *file, void *priv,
>  	return 0;
>  }
>  
> +static struct media_entity *fimc_pipeline_get_head(struct media_entity *me)
> +{
> +	struct media_pad *pad = &me->pads[0];
> +
> +	while (!(pad->flags & MEDIA_PAD_FL_SOURCE)) {
> +		pad = media_entity_remote_source(pad);
> +		if (!pad)
> +			break;

Isn't it an error if a sink pad of the entity isn't connected?
media_entity_remote_source(pad) returns NULL if the link is disabled. I'm
just wondering if this is possible.

> +		me = pad->entity;
> +		pad = &me->pads[0];
> +	}
> +
> +	return me;
> +}
> +

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
