Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:35544 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751374Ab1JQLlc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Oct 2011 07:41:32 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Subject: Re: [media-ctl PATCH 1/1] Several printout fixes.
Date: Mon, 17 Oct 2011 13:41:53 +0200
Cc: linux-media@vger.kernel.org
References: <1318608333-9136-1-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <1318608333-9136-1-git-send-email-sakari.ailus@iki.fi>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201110171341.53719.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Thanks for the patch.

On Friday 14 October 2011 18:05:33 Sakari Ailus wrote:
> - There are sink and source pads, not input and output.
> - Print also DYNAMIC flag.
> - Don't print "pad" before pad number in some cases. The strings are more
>   usable for link parsing now.
> - Don't print extra commas afterlink flags.
>
> Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
> ---
>  src/main.c |   29 +++++++++++++++++++++--------
>  1 files changed, 21 insertions(+), 8 deletions(-)
> 
> diff --git a/src/main.c b/src/main.c
> index c04e12f..3c5fcb8 100644
> --- a/src/main.c
> +++ b/src/main.c
> @@ -129,8 +129,8 @@ static const char *media_pad_type_to_string(unsigned
> flag) __u32 flag;
>  		const char *name;
>  	} flags[] = {
> -		{ MEDIA_PAD_FL_SINK, "Input" },
> -		{ MEDIA_PAD_FL_SOURCE, "Output" },
> +		{ MEDIA_PAD_FL_SINK, "Sink" },
> +		{ MEDIA_PAD_FL_SOURCE, "Source" },
>  	};
> 
>  	unsigned int i;
> @@ -251,20 +251,33 @@ static void media_print_topology_text(struct
> media_device *media) struct media_link *link = &entity->links[k];
>  				struct media_pad *source = link->source;
>  				struct media_pad *sink = link->sink;
> +				int i, flags = link->flags;
> +				struct {
> +					int flag;
> +					char *str;
> +				} tbl[] = {
> +					{ MEDIA_LNK_FL_ENABLED, "ENABLED" },
> +					{ MEDIA_LNK_FL_IMMUTABLE, "IMMUTABLE" },
> +					{ MEDIA_LNK_FL_DYNAMIC, "DYNAMIC" },
> +				};

The table should be static const.

> 
>  				if (source->entity == entity && source->index == j)
> -					printf("\t\t-> '%s':pad%u [",
> +					printf("\t\t-> \"%s\":%u [",
>  						sink->entity->info.name, sink->index);
>  				else if (sink->entity == entity && sink->index == j)
> -					printf("\t\t<- '%s':pad%u [",
> +					printf("\t\t<- \"%s\":%u [",
>  						source->entity->info.name, source->index);
>  				else
>  					continue;
> 
> -				if (link->flags & MEDIA_LNK_FL_IMMUTABLE)
> -					printf("IMMUTABLE,");
> -				if (link->flags & MEDIA_LNK_FL_ENABLED)
> -					printf("ACTIVE");
> +				for (i = 0; i < ARRAY_SIZE(tbl); i++) {
> +					if (!(flags & tbl[i].flag))
> +						continue;
> +					if (link->flags != flags)
> +						printf(",");
> +					printf("%s", tbl[i].str);
> +					flags &= ~tbl[i].flag;

What about using a 'first' variable instead of removing flags one by one ? I 
had to think for a second as to why the test was "link->flags != flags" for 
printing the comma.

If you're fine with that I'll make the modifications, no need to resubmit.

> +				}
> 
>  				printf("]\n");
>  			}

-- 
Regards,

Laurent Pinchart
