Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:35246 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756042Ab3EHNca (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 8 May 2013 09:32:30 -0400
Date: Wed, 8 May 2013 15:32:29 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH 1/2] Print more detailed parse error messages
Message-ID: <20130508133229.GB32299@pengutronix.de>
References: <1368019674-25761-1-git-send-email-s.hauer@pengutronix.de>
 <1368019674-25761-2-git-send-email-s.hauer@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1368019674-25761-2-git-send-email-s.hauer@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, May 08, 2013 at 03:27:53PM +0200, Sascha Hauer wrote:
> The following errors usually resulted in the same 'Unable to parse link'
> message:
> 
> - one of the given entities does not exist
> - one of the pads of a given entity does not exist
> - No link exists between given pads
> - syntax error in link description
> 
> Add more detailed error messages to give the user a clue what is going wrong.
> 
> Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
> ---
>  src/mediactl.c | 35 ++++++++++++++++++++++++++---------
>  1 file changed, 26 insertions(+), 9 deletions(-)
> 
> diff --git a/src/mediactl.c b/src/mediactl.c
> index 4783a58..c65de50 100644
> --- a/src/mediactl.c
> +++ b/src/mediactl.c
> @@ -537,31 +537,42 @@ struct media_pad *media_parse_pad(struct media_device *media,
>  
>  	if (*p == '"') {
>  		for (end = (char *)p + 1; *end && *end != '"'; ++end);
> -		if (*end != '"')
> +		if (*end != '"') {
> +			media_dbg(media, "missing matching '\"'\n");
>  			return NULL;
> +		}
>  
>  		entity = media_get_entity_by_name(media, p + 1, end - p - 1);
> -		if (entity == NULL)
> +		if (entity == NULL) {
> +			media_dbg(media, "no such entity \"%.*s\"\n", end - p - 1, p + 1);
>  			return NULL;
> +		}
>  
>  		++end;
>  	} else {
>  		entity_id = strtoul(p, &end, 10);
>  		entity = media_get_entity_by_id(media, entity_id);
> -		if (entity == NULL)
> +		if (entity == NULL) {
> +			media_dbg(media, "no such entity %d\n", entity_id);
>  			return NULL;
> +		}
>  	}
>  	for (; isspace(*end); ++end);
>  
> -	if (*end != ':')
> +	if (*end != ':') {
> +		media_dbg(media, "Expected ':'\n", *end);
>  		return NULL;
> +	}
> +
>  	for (p = end + 1; isspace(*p); ++p);
>  
>  	pad = strtoul(p, &end, 10);
> -	for (p = end; isspace(*p); ++p);

Oops, this maybe should be a separate patch. This is not needed here...

>  
> -	if (pad >= entity->info.pads)
> +	if (pad >= entity->info.pads) {
> +		media_dbg(media, "No pad '%d' on entity \"%s\". Maximum pad number is %d\n",
> +				pad, entity->info.name, entity->info.pads - 1);
>  		return NULL;
> +	}
>  
>  	for (p = end; isspace(*p); ++p);

... since eating whitespaces once is enough.

Sascha


-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
