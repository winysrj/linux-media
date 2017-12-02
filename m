Return-path: <linux-media-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:32990 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751271AbdLBKo2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 2 Dec 2017 05:44:28 -0500
Date: Sat, 2 Dec 2017 13:20:09 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Jeremy Sowden <jeremy@azazel.net>
Cc: linux-media@vger.kernel.org, devel@driverdev.osuosl.org
Subject: Re: [PATCH v2 1/3] media: atomisp: convert default struct values to
 use compound-literals with designated initializers.
Message-ID: <20171202102009.pdly5urlxkt4rdcx@mwanda>
References: <20171201150725.cfcp6b4bs2ncqsip@mwanda>
 <20171201171939.3432-1-jeremy@azazel.net>
 <20171201171939.3432-2-jeremy@azazel.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171201171939.3432-2-jeremy@azazel.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Dec 01, 2017 at 05:19:37PM +0000, Jeremy Sowden wrote:
> -#define DEFAULT_PIPE_INFO \
> -{ \
> -	{IA_CSS_BINARY_DEFAULT_FRAME_INFO},	/* output_info */ \
> -	{IA_CSS_BINARY_DEFAULT_FRAME_INFO},	/* vf_output_info */ \
> -	IA_CSS_BINARY_DEFAULT_FRAME_INFO,	/* raw_output_info */ \
> -	{ 0, 0},				/* output system in res */ \
> -	DEFAULT_SHADING_INFO,			/* shading_info */ \
> -	DEFAULT_GRID_INFO,			/* grid_info */ \
> -	0					/* num_invalid_frames */ \
> -}
> +#define DEFAULT_PIPE_INFO ( \

Why does this have a ( now?  That can't compile can it??

> +	(struct ia_css_pipe_info) { \
> +		.output_info			= {IA_CSS_BINARY_DEFAULT_FRAME_INFO}, \
> +		.vf_output_info			= {IA_CSS_BINARY_DEFAULT_FRAME_INFO}, \
> +		.raw_output_info		= IA_CSS_BINARY_DEFAULT_FRAME_INFO, \
> +		.output_system_in_res_info	= { 0, 0 }, \
> +		.shading_info			= DEFAULT_SHADING_INFO, \
> +		.grid_info			= DEFAULT_GRID_INFO, \
> +		.num_invalid_frames		= 0 \
> +	} \
> +)

We need to get better compile test coverage on this...  :/  There are
some others as well.

regards,
dan carpenter
