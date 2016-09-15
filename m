Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:50582 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934058AbcIOIKB (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 15 Sep 2016 04:10:01 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [v4l-utils PATCH v1.3 2/2] media-ctl: Print information related to a single entity
Date: Thu, 15 Sep 2016 11:10:41 +0300
Message-ID: <3546778.Vlt7Ku4CEB@avalon>
In-Reply-To: <1473921639-6544-1-git-send-email-sakari.ailus@linux.intel.com>
References: <163775066.40INlWgSp9@avalon> <1473921639-6544-1-git-send-email-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Thank you for the patch.

On Thursday 15 Sep 2016 09:40:39 Sakari Ailus wrote:
> Add a possibility to printing all information related to a given entity by
> using both -p and -e options. This may be handy sometimes if only a single
> entity is of interest and there are many entities.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
>  utils/media-ctl/media-ctl.c | 32 ++++++++++++++------------------
>  utils/media-ctl/options.c   |  4 +++-
>  2 files changed, 17 insertions(+), 19 deletions(-)
> 
> diff --git a/utils/media-ctl/media-ctl.c b/utils/media-ctl/media-ctl.c
> index 0499008..b60d297 100644
> --- a/utils/media-ctl/media-ctl.c
> +++ b/utils/media-ctl/media-ctl.c
> @@ -504,19 +504,11 @@ static void media_print_topology_text(struct
> media_device *media) media, media_get_entity(media, i));
>  }
> 
> -void media_print_topology(struct media_device *media, int dot)
> -{
> -	if (dot)
> -		media_print_topology_dot(media);
> -	else
> -		media_print_topology_text(media);
> -}
> -
>  int main(int argc, char **argv)
>  {
>  	struct media_device *media;
> +	struct media_entity *entity = NULL;
>  	int ret = -1;
> -	const char *devname;
> 
>  	if (parse_cmdline(argc, argv))
>  		return EXIT_FAILURE;
> @@ -562,17 +554,11 @@ int main(int argc, char **argv)
>  	}
> 
>  	if (media_opts.entity) {
> -		struct media_entity *entity;
> -
>  		entity = media_get_entity_by_name(media, media_opts.entity);
>  		if (entity == NULL) {
>  			printf("Entity '%s' not found\n", media_opts.entity);
>  			goto out;
>  		}
> -
> -		devname = media_entity_get_devname(entity);
> -		if (devname)
> -			printf("%s\n", devname);
>  	}
> 
>  	if (media_opts.fmt_pad) {
> @@ -611,9 +597,19 @@ int main(int argc, char **argv)
>  		}
>  	}
> 
> -	if (media_opts.print || media_opts.print_dot) {
> -		media_print_topology(media, media_opts.print_dot);
> -		printf("\n");
> +	if (media_opts.print_dot) {
> +		media_print_topology_dot(media);
> +	} else if (media_opts.print) {
> +		if (entity)
> +			media_print_topology_text_entity(media, entity);
> +		else
> +			media_print_topology_text(media);
> +	} else if (entity) {
> +		const char *devname;
> +
> +		devname = media_entity_get_devname(entity);
> +		if (devname)
> +			printf("%s\n", devname);
>  	}
> 
>  	if (media_opts.reset) {
> diff --git a/utils/media-ctl/options.c b/utils/media-ctl/options.c
> index a288a1b..77d1a51 100644
> --- a/utils/media-ctl/options.c
> +++ b/utils/media-ctl/options.c
> @@ -51,7 +51,9 @@ static void usage(const char *argv0)
>  	printf("-i, --interactive	Modify links interactively\n");
>  	printf("-l, --links links	Comma-separated list of link 
descriptors to
> setup\n"); printf("    --known-mbus-fmts	List known media bus formats 
and
> their numeric values\n"); -	printf("-p, --print-topology	Print the 
device
> topology\n");
> +	printf("-p, --print-topology	Print the device topology. If an 
entity\n");
> +	printf("			is specified through the -e option, 
print\n");
> +	printf("			information for that entity only.\n);
>  	printf("    --print-dot		Print the device topology as a dot 
graph\n");
>  	printf("-r, --reset		Reset all links to inactive\n");
>  	printf("-v, --verbose		Be verbose\n");

-- 
Regards,

Laurent Pinchart

