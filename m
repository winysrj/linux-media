Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:39792 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755390Ab2EEMV7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 5 May 2012 08:21:59 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org
Subject: Re: [media-ctl PATCH 2/3] New, more flexible syntax for media-ctl
Date: Sat, 05 May 2012 14:22:26 +0200
Message-ID: <14849350.mp0nWfDsvJ@avalon>
In-Reply-To: <1336119883-14978-2-git-send-email-sakari.ailus@iki.fi>
References: <1336119883-14978-1-git-send-email-sakari.ailus@iki.fi> <1336119883-14978-2-git-send-email-sakari.ailus@iki.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Thanks for the patch.

On Friday 04 May 2012 11:24:42 Sakari Ailus wrote:
> More flexible and extensible syntax for media-ctl which allows better usage
> of the selection API.

[snip]

> diff --git a/src/options.c b/src/options.c
> index 60cf6d5..4d9d48f 100644
> --- a/src/options.c
> +++ b/src/options.c
> @@ -53,12 +53,15 @@ static void usage(const char *argv0, int verbose)
>  	printf("\n");
>  	printf("Links and formats are defined as\n");
>  	printf("\tlink            = pad, '->', pad, '[', flags, ']' ;\n");
> -	printf("\tformat          = pad, '[', fcc, ' ', size, [ ' ', crop ], [ '
> ', '@', frame interval ], ']' ;\n");
> +	printf("\tformat          = pad, '[', formats ']' ;\n");
> +	printf("\tformats         = formats ',' formats ;\n");
> +	printf("\tformats         = fmt | crop | frame interval ;\n");

That's not a valid EBNF. I'm not an expert on the subject, but I think the 
following is better.

formats = format { ' ', formats }
format = fmt | crop | frame interval

> +	printf("\fmt              = 'fmt:', fcc, '/', size ;\n");

format, formats and fmt are becoming confusing. A different name for 'formats' 
would be good.

I find the '/' a bit confusing compared to the ' ' (but I think you find the 
space confusing compared to '/' :-)). I also wonder whether we shouldn't just 
drop 'fmt:', as there can be a single format only.

>  	printf("\tpad             = entity, ':', pad number ;\n");
>  	printf("\tentity          = entity number | ( '\"', entity name, '\"' )
> ;\n");
>  	printf("\tsize            = width, 'x', height ;\n");
> -	printf("\tcrop            = '(', left, ',', top, ')', '/', size ;\n");
> -	printf("\tframe interval  = numerator, '/', denominator ;\n");
> +	printf("\tcrop            = 'crop.actual:', left, ',', top, '/', size
> ;\n");

Would it make sense to make .actual implicit ? Both 'crop' and 'crop.actual' 
would be supported by the parser. The code would be more generic if the target 
was parsed in a generic way, not associated with the rectangle name.

I would keep the parenthesis around the (top,left) coordinates. You could then 
define

rectangle = '(', left, ',', top, ')', '/', size
crop = 'crop' [ '.', target ] ':', rectangle
target = 'actual'

or something similar.

What about also keeping compatibility with the existing syntax (both for 
formats and crop rectangles) ? That shouldn't be too difficult in the parser, 
crop rectangles start with a '(', and formats come first. We would then have

rectangle = '(', left, ',', top, ')', '/', size
crop = [ 'crop' [ '.', target ] ':' ], rectangle
target = 'actual'

> +	printf("\tframe interval  = '@', numerator, '/', denominator ;\n");
>  	printf("where the fields are\n");
>  	printf("\tentity number   Entity numeric identifier\n");
>  	printf("\tentity name     Entity name (string) \n");

-- 
Regards,

Laurent Pinchart

