Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:42139 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756031Ab2EHTbj (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 8 May 2012 15:31:39 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org
Subject: Re: [media-ctl PATCH v2 1/2] New, more flexible syntax for format
Date: Tue, 08 May 2012 21:31:35 +0200
Message-ID: <1529968.u1eeiRTNpn@avalon>
In-Reply-To: <1336398396-31526-1-git-send-email-sakari.ailus@iki.fi>
References: <1336398396-31526-1-git-send-email-sakari.ailus@iki.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Thanks for the patch.

On Monday 07 May 2012 16:46:35 Sakari Ailus wrote:
> More flexible and extensible syntax for format which allows better usage
> of the selection API.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
> ---
>  src/main.c       |   17 ++++++++++---
>  src/options.c    |   27 +++++++++++++-------
>  src/v4l2subdev.c |   70 ++++++++++++++++++++++++++++++++-------------------
>  3 files changed, 74 insertions(+), 40 deletions(-)

[snip]

> diff --git a/src/options.c b/src/options.c
> index 60cf6d5..46f6bef 100644
> --- a/src/options.c
> +++ b/src/options.c
> @@ -37,8 +37,8 @@ static void usage(const char *argv0, int verbose)
>  	printf("%s [options] device\n", argv0);
>  	printf("-d, --device dev	Media device name (default: %s)\n",
> MEDIA_DEVNAME_DEFAULT);
> 	printf("-e, --entity name	Print the device name associated with the
> given entity\n");
> -	printf("-f, --set-format	Comma-separated list of formats to
> setup\n");
> -	printf("   --get-format pad	Print the active format on a given pad\n");
> +	printf("-V, --set-v4l2 v4l2	Comma-separated list of formats to setup\n");
> +	printf("   --get-v4l2 pad	Print the active format on a given pad\n");

I still need to think about the name change.

>  	printf("-h, --help		Show verbose help and exit\n");
>  	printf("-i, --interactive	Modify links interactively\n");
>  	printf("-l, --links		Comma-separated list of links descriptors to
> setup\n");
> @@ -52,13 +52,17 @@ static void usage(const char *argv0, int verbose)
> 
>  	printf("\n");
>  	printf("Links and formats are defined as\n");
> -	printf("\tlink            = pad, '->', pad, '[', flags, ']' ;\n");
> -	printf("\tformat          = pad, '[', fcc, ' ', size, [ ' ', crop ], [ '
> ', '@', frame interval ], ']' ;\n"); -	printf("\tpad             = entity,
> ':', pad number ;\n");
> -	printf("\tentity          = entity number | ( '\"', entity name, '\"' )
> ;\n"); -	printf("\tsize            = width, 'x', height ;\n");
> -	printf("\tcrop            = '(', left, ',', top, ')', '/', size ;\n");
> -	printf("\tframe interval  = numerator, '/', denominator ;\n");
> +	printf("\tlink                = pad, '->', pad, '[', flags, ']' ;\n");
> +	printf("\tv4l2                = pad, '[', v4l2-cfgs ']' ;\n");
> +	printf("\tv4l2-cfgs           = v4l2-cfg [ ',' v4l2-cfg ] ;\n");
> +	printf("\tv4l2-cfg            = v4l2-mbusfmt | v4l2-crop\n");
> +	printf("\t                      | v4l2 frame interval ;\n");
> +	printf("\tv4l2-mbusfmt        = 'fmt:', fcc, '/', size ;\n");
> +	printf("\tpad                 = entity, ':', pad number ;\n");
> +	printf("\tentity              = entity number | ( '\"', entity name, '\"'
> ) ;\n"); +	printf("\tsize                = width, 'x', height ;\n");
> +	printf("\tv4l2-crop           = 'crop:(', left, ',', top, ')/', size
> ;\n"); +	printf("\tv4l2 frame interval = '@', numerator, '/', denominator
> ;\n"); printf("where the fields are\n");
>  	printf("\tentity number   Entity numeric identifier\n");
>  	printf("\tentity name     Entity name (string) \n");
> @@ -77,7 +81,9 @@ static void usage(const char *argv0, int verbose)
>  static struct option opts[] = {
>  	{"device", 1, 0, 'd'},
>  	{"entity", 1, 0, 'e'},
> +	{"set-v4l2", 1, 0, 'V'},
>  	{"set-format", 1, 0, 'f'},
> +	{"get-v4l2", 1, 0, OPT_GET_FORMAT},
>  	{"get-format", 1, 0, OPT_GET_FORMAT},
>  	{"help", 0, 0, 'h'},
>  	{"interactive", 0, 0, 'i'},
> @@ -98,7 +104,7 @@ int parse_cmdline(int argc, char **argv)
>  	}
> 
>  	/* parse options */
> -	while ((opt = getopt_long(argc, argv, "d:e:f:hil:prv", opts, NULL)) != 
-1)
> { +	while ((opt = getopt_long(argc, argv, "d:e:V:f:hil:prv", opts, NULL))
> != -1) { switch (opt) {
>  		case 'd':
>  			media_opts.devname = optarg;
> @@ -108,6 +114,7 @@ int parse_cmdline(int argc, char **argv)
>  			media_opts.entity = optarg;
>  			break;
> 
> +		case 'V':
>  		case 'f':
>  			media_opts.formats = optarg;
>  			break;
> diff --git a/src/v4l2subdev.c b/src/v4l2subdev.c
> index a2ab0c4..6881553 100644
> --- a/src/v4l2subdev.c
> +++ b/src/v4l2subdev.c
> @@ -233,13 +233,13 @@ static int v4l2_subdev_parse_format(struct
> v4l2_mbus_framefmt *format, char *end;
> 
>  	for (; isspace(*p); ++p);
> -	for (end = (char *)p; !isspace(*end) && *end != '\0'; ++end);
> +	for (end = (char *)p; *end != '/' && *end != '\0'; ++end);

I wouldn't change this to keep compatibility with the existing syntax.

> 
>  	code = v4l2_subdev_string_to_pixelcode(p, end - p);
>  	if (code == (enum v4l2_mbus_pixelcode)-1)
>  		return -EINVAL;
> 
> -	for (p = end; isspace(*p); ++p);
> +	p = end + 1;
>  	width = strtoul(p, &end, 10);
>  	if (*end != 'x')
>  		return -EINVAL;
> @@ -256,32 +256,32 @@ static int v4l2_subdev_parse_format(struct
> v4l2_mbus_framefmt *format, return 0;
>  }
> 
> -static int v4l2_subdev_parse_crop(
> -	struct v4l2_rect *crop, const char *p, char **endp)
> +static int v4l2_subdev_parse_rectangle(
> +	struct v4l2_rect *r, const char *p, char **endp)
>  {
>  	char *end;
> 
>  	if (*p++ != '(')
>  		return -EINVAL;
> 
> -	crop->left = strtoul(p, &end, 10);
> +	r->left = strtoul(p, &end, 10);
>  	if (*end != ',')
>  		return -EINVAL;
> 
>  	p = end + 1;
> -	crop->top = strtoul(p, &end, 10);
> +	r->top = strtoul(p, &end, 10);
>  	if (*end++ != ')')
>  		return -EINVAL;
>  	if (*end != '/')
>  		return -EINVAL;
> 
>  	p = end + 1;
> -	crop->width = strtoul(p, &end, 10);
> +	r->width = strtoul(p, &end, 10);
>  	if (*end != 'x')
>  		return -EINVAL;
> 
>  	p = end + 1;
> -	crop->height = strtoul(p, &end, 10);
> +	r->height = strtoul(p, &end, 10);
>  	*endp = end;
> 
>  	return 0;
> @@ -307,6 +307,17 @@ static int v4l2_subdev_parse_frame_interval(struct
> v4l2_fract *interval, return 0;
>  }
> 
> +static int strhazit(const char *str, const char **p)

I would make the function return a bool, or, if you want to keep the int 
return type, return 0 when there's no match and 1 when there's a match. I 
suppose you prefer keeping strhazit over strmatch ? :-)

> +{
> +	int len = strlen(str);

strlen() returns a size_t.

> +
> +	if (strncmp(str, *p, len))
> +		return -ENOENT;
> +
> +	*p += len;

What about also skipping white spaces here ?

> +	return 0;
> +}
> +
>  static struct media_pad *v4l2_subdev_parse_pad_format(
>  	struct media_device *media, struct v4l2_mbus_framefmt *format,
>  	struct v4l2_rect *crop, struct v4l2_fract *interval, const char *p,
> @@ -326,30 +337,37 @@ static struct media_pad *v4l2_subdev_parse_pad_format(
> if (*p++ != '[')
>  		return NULL;
> 
> -	for (; isspace(*p); ++p);
> +	for (;;) {
> +		for (; isspace(*p); p++);
> 
> -	if (isalnum(*p)) {
> -		ret = v4l2_subdev_parse_format(format, p, &end);
> -		if (ret < 0)
> -			return NULL;
> +		if (!strhazit("fmt:", &p)) {
> +			ret = v4l2_subdev_parse_format(format, p, &end);
> +			if (ret < 0)
> +				return NULL;
> 
> -		for (p = end; isspace(*p); p++);
> -	}
> +			p = end;
> +			continue;
> +		}

I'd like to keep compatibility with the existing syntax here. Checking whether 
this is the first argument and whether it starts with an uppercase letter 
should be enough, would you be OK with that ?

> 
> -	if (*p == '(') {
> -		ret = v4l2_subdev_parse_crop(crop, p, &end);
> -		if (ret < 0)
> -			return NULL;
> +		if (!strhazit("crop:", &p) || *p == '(') {
> +			ret = v4l2_subdev_parse_rectangle(crop, p, &end);
> +			if (ret < 0)
> +				return NULL;
> 
> -		for (p = end; isspace(*p); p++);
> -	}
> +			p = end;
> +			continue;
> +		}
> 
> -	if (*p == '@') {
> -		ret = v4l2_subdev_parse_frame_interval(interval, ++p, &end);
> -		if (ret < 0)
> -			return NULL;
> +		if (*p == '@') {
> +			ret = v4l2_subdev_parse_frame_interval(interval, ++p, &end);
> +			if (ret < 0)
> +				return NULL;
> +
> +			p = end;
> +			continue;
> +		}
> 
> -		for (p = end; isspace(*p); p++);
> +		break;
>  	}
> 
>  	if (*p != ']')

-- 
Regards,

Laurent Pinchart

