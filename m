Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:46095 "EHLO
	lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751665AbcBWMf4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Feb 2016 07:35:56 -0500
Subject: Re: [v4l-utils PATCH 4/4] media-ctl: List supported media bus formats
To: Sakari Ailus <sakari.ailus@linux.intel.com>,
	linux-media@vger.kernel.org
References: <1456090187-1191-1-git-send-email-sakari.ailus@linux.intel.com>
 <1456090187-1191-5-git-send-email-sakari.ailus@linux.intel.com>
Cc: laurent.pinchart@ideasonboard.com
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <56CC522D.1030907@xs4all.nl>
Date: Tue, 23 Feb 2016 13:35:57 +0100
MIME-Version: 1.0
In-Reply-To: <1456090187-1191-5-git-send-email-sakari.ailus@linux.intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/21/16 22:29, Sakari Ailus wrote:
> Add a new topic option for -h to allow listing supported media bus codes
> in conversion functions. This is useful in figuring out which media bus
> codes are actually supported by the library. The numeric values of the
> codes are listed as well.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> ---
>  utils/media-ctl/options.c | 42 ++++++++++++++++++++++++++++++++++++++----
>  1 file changed, 38 insertions(+), 4 deletions(-)
> 
> diff --git a/utils/media-ctl/options.c b/utils/media-ctl/options.c
> index 0afc9c2..55cdd29 100644
> --- a/utils/media-ctl/options.c
> +++ b/utils/media-ctl/options.c
> @@ -22,7 +22,9 @@
>  #include <getopt.h>
>  #include <stdio.h>
>  #include <stdlib.h>
> +#include <string.h>
>  #include <unistd.h>
> +#include <v4l2subdev.h>
>  
>  #include <linux/videodev2.h>
>  
> @@ -45,7 +47,8 @@ static void usage(const char *argv0)
>  	printf("-V, --set-v4l2 v4l2	Comma-separated list of formats to setup\n");
>  	printf("    --get-v4l2 pad	Print the active format on a given pad\n");
>  	printf("    --set-dv pad	Configure DV timings on a given pad\n");
> -	printf("-h, --help		Show verbose help and exit\n");
> +	printf("-h, --help[=topic]	Show verbose help and exit\n");
> +	printf("			topics:	mbus-fmt: List supported media bus pixel codes\n");
>  	printf("-i, --interactive	Modify links interactively\n");
>  	printf("-l, --links links	Comma-separated list of link descriptors to setup\n");
>  	printf("-p, --print-topology	Print the device topology\n");
> @@ -100,7 +103,7 @@ static struct option opts[] = {
>  	{"get-format", 1, 0, OPT_GET_FORMAT},
>  	{"get-v4l2", 1, 0, OPT_GET_FORMAT},
>  	{"set-dv", 1, 0, OPT_SET_DV},
> -	{"help", 0, 0, 'h'},
> +	{"help", 2, 0, 'h'},
>  	{"interactive", 0, 0, 'i'},
>  	{"links", 1, 0, 'l'},
>  	{"print-dot", 0, 0, OPT_PRINT_DOT},
> @@ -110,6 +113,27 @@ static struct option opts[] = {
>  	{ },
>  };
>  
> +void list_mbus_formats(void)
> +{
> +	unsigned int ncodes;
> +	const unsigned int *code = v4l2_subdev_pixelcode_list(&ncodes);
> +
> +	printf("Supported media bus pixel codes\n");
> +
> +	for (ncodes++; ncodes; ncodes--, code++) {

Huh? Just do:

	while (ncodes--) {
		....
		code++;
	}

That for loop is weird.

	Hans

> +		const char *str = v4l2_subdev_pixelcode_to_string(*code);
> +		int spaces = 30 - (int)strlen(str);
> +
> +		if (*code == 0)
> +			break;
> +
> +		if (spaces < 0)
> +			spaces = 0;
> +
> +		printf("\t%s %*c (0x%8.8x)\n", str, spaces, ' ', *code);
> +	}
> +}
> +
>  int parse_cmdline(int argc, char **argv)
>  {
>  	int opt;
> @@ -120,7 +144,8 @@ int parse_cmdline(int argc, char **argv)
>  	}
>  
>  	/* parse options */
> -	while ((opt = getopt_long(argc, argv, "d:e:f:hil:prvV:", opts, NULL)) != -1) {
> +	while ((opt = getopt_long(argc, argv, "d:e:f:h::il:prvV:",
> +				  opts, NULL)) != -1) {
>  		switch (opt) {
>  		case 'd':
>  			media_opts.devname = optarg;
> @@ -142,7 +167,16 @@ int parse_cmdline(int argc, char **argv)
>  			break;
>  
>  		case 'h':
> -			usage(argv[0]);
> +			if (optarg) {
> +				if (!strcmp(optarg, "mbus-fmt"))
> +					list_mbus_formats();
> +				else
> +					fprintf(stderr,
> +						"Unknown topic \"%s\"\n",
> +						optarg);
> +			} else {
> +				usage(argv[0]);
> +			}
>  			exit(0);
>  
>  		case 'i':
> 
