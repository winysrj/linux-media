Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud6.xs4all.net ([194.109.24.28]:49447 "EHLO
	lb2-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751146AbbFSGHb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Jun 2015 02:07:31 -0400
Message-ID: <5583B18C.7020303@xs4all.nl>
Date: Fri, 19 Jun 2015 08:07:08 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Prashant Laddha <prladdha@cisco.com>, linux-media@vger.kernel.org
CC: Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFC PATCH 2/2] v4l2-utils: extend set-dv-timing options for
 RB version
References: <1434447031-21434-1-git-send-email-prladdha@cisco.com> <1434447031-21434-3-git-send-email-prladdha@cisco.com>
In-Reply-To: <1434447031-21434-3-git-send-email-prladdha@cisco.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/16/2015 11:30 AM, Prashant Laddha wrote:
> To support the timings calculations for reduced blanking version 2
> (RB v2), extended the command line options to include flag indicating
> whether to use RB V2 or not. Updated the command usage for the same.
> 
> Cc: Hans Verkuil <hans.verkuil@cisco.com>
> Signed-off-by: Prashant Laddha <prladdha@cisco.com>
> ---
>  utils/v4l2-ctl/v4l2-ctl-stds.cpp | 13 +++++++++++--
>  1 file changed, 11 insertions(+), 2 deletions(-)
> 
> diff --git a/utils/v4l2-ctl/v4l2-ctl-stds.cpp b/utils/v4l2-ctl/v4l2-ctl-stds.cpp
> index c0e919b..9734c80 100644
> --- a/utils/v4l2-ctl/v4l2-ctl-stds.cpp
> +++ b/utils/v4l2-ctl/v4l2-ctl-stds.cpp
> @@ -41,7 +41,10 @@ void stds_usage(void)
>  	       "                     index=<index>: use the index as provided by --list-dv-timings\n"
>  	       "                     or specify timings using cvt/gtf options as follows:\n"
>  	       "                     cvt/gtf,width=<width>,height=<height>,fps=<frames per sec>\n"
> -	       "                     interlaced=<0/1>,reduced-blanking=<0/1>\n"
> +	       "                     interlaced=<0/1>,reduced-blanking=<0/1>,use-rb-v2=<0/1>\n"
> +	       "                     use-rb-v2 indicates whether to use reduced blanking version 2\n"
> +	       "                     or not. This flag is relevant only for cvt timings and has\n"
> +	       "                     effect only if reduced-blanking=1\n"

Why not just allow a value of 2 for the reduced-blanking argument instead
of introducing a new argument? For gtf 1 and 2 mean the same thing, for cvt 1
will use the standard RB and 2 RBv2.

Seems simpler to me. It also means that calc_cvt_modeline doesn't need a new
argument, just that bool reduced_blanking becomes int reduced_blanking.

Other than this it looks good to me.

Regards,

	Hans

>  	       "                     or give a fully specified timings:\n"
>  	       "                     width=<width>,height=<height>,interlaced=<0/1>,\n"
>  	       "                     polarities=<polarities mask>,pixelclock=<pixelclock Hz>,\n"
> @@ -148,6 +151,7 @@ enum timing_opts {
>  	GTF,
>  	FPS,
>  	REDUCED_BLANK,
> +	USE_RB_V2,
>  };
>  
>  static int parse_timing_subopt(char **subopt_str, int *value)
> @@ -175,6 +179,7 @@ static int parse_timing_subopt(char **subopt_str, int *value)
>  		"gtf",
>  		"fps",
>  		"reduced-blanking",
> +		"use-rb-v2",
>  		NULL
>  	};
>  
> @@ -205,6 +210,7 @@ static void get_cvt_gtf_timings(char *subopt, int standard,
>  	int fps = 0;
>  	int r_blank = 0;
>  	int interlaced = 0;
> +	int use_rb_v2 = 0;
>  
>  	bool timings_valid = false;
>  
> @@ -231,6 +237,8 @@ static void get_cvt_gtf_timings(char *subopt, int standard,
>  		case INTERLACED:
>  			interlaced = opt_val;
>  			break;
> +		case USE_RB_V2:
> +			use_rb_v2 = opt_val;
>  		default:
>  			break;
>  		}
> @@ -240,7 +248,8 @@ static void get_cvt_gtf_timings(char *subopt, int standard,
>  		timings_valid = calc_cvt_modeline(width, height, fps,
>  			              r_blank == 1 ? true : false,
>  			              interlaced == 1 ? true : false,
> -			              false, bt);
> +			              use_rb_v2 == 1 ? true : false,
> +			              bt);
>  	} else {
>  		timings_valid = calc_gtf_modeline(width, height, fps,
>  			              r_blank == 1 ? true : false,
> 

