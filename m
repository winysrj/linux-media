Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:46977 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1759454AbcIMXlL (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 13 Sep 2016 19:41:11 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [v4l-utils PATCH 2/2] media-ctl: Print information related to a single entity
Date: Wed, 14 Sep 2016 02:41:50 +0300
Message-ID: <2226876.Vxqef30rz5@avalon>
In-Reply-To: <1473755296-14109-3-git-send-email-sakari.ailus@linux.intel.com>
References: <1473755296-14109-1-git-send-email-sakari.ailus@linux.intel.com> <1473755296-14109-3-git-send-email-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Thank you for the patch. This is a feature I've often thought would be useful.

On Tuesday 13 Sep 2016 11:28:16 Sakari Ailus wrote:
> Add an optional argument to the -p option that allows printing all
> information related to a given entity. This may be handy sometimes if only
> a single entity is of interest and there are many entities.

Would it make sense to instead reuse the -e argument ? If both -p and -e are 
specified, print entity information for the entity referenced by -e. If only -
p or -e are specified, operate as we do today.

> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> ---
>  utils/media-ctl/media-ctl.c | 26 +++++++++++++++-----------
>  utils/media-ctl/options.c   |  9 ++++++---
>  utils/media-ctl/options.h   |  1 +
>  3 files changed, 22 insertions(+), 14 deletions(-)
> 
> diff --git a/utils/media-ctl/media-ctl.c b/utils/media-ctl/media-ctl.c
> index 0499008..fdd2449 100644
> --- a/utils/media-ctl/media-ctl.c
> +++ b/utils/media-ctl/media-ctl.c
> @@ -504,14 +504,6 @@ static void media_print_topology_text(struct
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
> @@ -611,9 +603,21 @@ int main(int argc, char **argv)
>  		}
>  	}
> 
> -	if (media_opts.print || media_opts.print_dot) {
> -		media_print_topology(media, media_opts.print_dot);
> -		printf("\n");
> +	if (media_opts.print_dot) {
> +		media_print_topology_dot(media);
> +	} else if (media_opts.print_entity) {
> +		struct media_entity *entity = NULL;
> +
> +		entity = media_get_entity_by_name(media,
> +						  media_opts.print_entity);
> +		if (entity == NULL) {
> +			printf("Entity '%s' not found\n",
> +			       media_opts.print_entity);
> +			goto out;
> +		}
> +		media_print_topology_text_entity(media, entity);
> +	} else if (media_opts.print) {
> +		media_print_topology_text(media);
>  	}
> 
>  	if (media_opts.reset) {
> diff --git a/utils/media-ctl/options.c b/utils/media-ctl/options.c
> index a288a1b..3352626 100644
> --- a/utils/media-ctl/options.c
> +++ b/utils/media-ctl/options.c
> @@ -51,7 +51,9 @@ static void usage(const char *argv0)
>  	printf("-i, --interactive	Modify links interactively\n");
>  	printf("-l, --links links	Comma-separated list of link
> descriptors to setup\n");
> 	printf("    --known-mbus-fmts	List known media bus formats and
> their numeric values\n");
> -	printf("-p, --print-topology	Print the device topology\n");
> +	printf("-p, --print-topology [name] Print the device topology\n");
> +	printf("			If entity name is specified,
> information to that entity\n");
> +	printf("			only is printed.\n");

I'd wrap this to make lines a bit shorter, and perhaps write it as

printf("-p, --print-topology [name]\n);
printf("			Print the device topology. If name\n");
printf("			is specified, print information for\n");
printf("			the named entity only.\n);

Or if you go by my proposal above,

printf("-p, --print-topology	Print the device topology. If an entity\n");
printf("			is specified through the -e option, print\n");
printf("			information for that entity only.\n);

>  	printf("    --print-dot		Print the device topology as a dot 
graph\n");
>  	printf("-r, --reset		Reset all links to inactive\n");
>  	printf("-v, --verbose		Be verbose\n");
> @@ -109,7 +111,7 @@ static struct option opts[] = {
>  	{"links", 1, 0, 'l'},
>  	{"known-mbus-fmts", 0, 0, OPT_LIST_KNOWN_MBUS_FMTS},
>  	{"print-dot", 0, 0, OPT_PRINT_DOT},
> -	{"print-topology", 0, 0, 'p'},
> +	{"print-topology", 2, 0, 'p'},
>  	{"reset", 0, 0, 'r'},
>  	{"verbose", 0, 0, 'v'},
>  	{ },
> @@ -146,7 +148,7 @@ int parse_cmdline(int argc, char **argv)
>  	}
> 
>  	/* parse options */
> -	while ((opt = getopt_long(argc, argv, "d:e:f:hil:prvV:",
> +	while ((opt = getopt_long(argc, argv, "d:e:f:hil:p::rvV:",
>  				  opts, NULL)) != -1) {
>  		switch (opt) {
>  		case 'd':
> @@ -182,6 +184,7 @@ int parse_cmdline(int argc, char **argv)
> 
>  		case 'p':
>  			media_opts.print = 1;
> +			media_opts.print_entity = optarg;
>  			break;
> 
>  		case 'r':
> diff --git a/utils/media-ctl/options.h b/utils/media-ctl/options.h
> index 9b5f314..ff9dfdf 100644
> --- a/utils/media-ctl/options.h
> +++ b/utils/media-ctl/options.h
> @@ -30,6 +30,7 @@ struct media_options
>  		     print_dot:1,
>  		     reset:1,
>  		     verbose:1;
> +	const char *print_entity;
>  	const char *entity;
>  	const char *formats;
>  	const char *links;

-- 
Regards,

Laurent Pinchart

