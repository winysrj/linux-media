Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:57268 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752826AbbKQNLl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Nov 2015 08:11:41 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org, hverkuil@xs4all.nl
Subject: Re: [v4l-utils 1/1] media-ctl: Fix bad long option crash
Date: Tue, 17 Nov 2015 15:11:50 +0200
Message-ID: <10125299.Wyb64Yx7LA@avalon>
In-Reply-To: <1447760458-8327-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1447760458-8327-1-git-send-email-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Thank you for the patch.

On Tuesday 17 November 2015 13:40:58 Sakari Ailus wrote:
> The long options array has to be followed by an all-zero entry. There was
> none.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
>  utils/media-ctl/options.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/utils/media-ctl/options.c b/utils/media-ctl/options.c
> index ffaffcd..2751e6e 100644
> --- a/utils/media-ctl/options.c
> +++ b/utils/media-ctl/options.c
> @@ -97,6 +97,7 @@ static struct option opts[] = {
>  	{"print-topology", 0, 0, 'p'},
>  	{"reset", 0, 0, 'r'},
>  	{"verbose", 0, 0, 'v'},
> +	{ },
>  };
> 
>  int parse_cmdline(int argc, char **argv)

-- 
Regards,

Laurent Pinchart
-- 
Regards,

Laurent Pinchart

