Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:42654 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754529AbcEQJHW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 May 2016 05:07:22 -0400
Date: Tue, 17 May 2016 12:06:46 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH 4/4] Support setting control from values stored in a file
Message-ID: <20160517090646.GZ26360@valkosipuli.retiisi.org.uk>
References: <1463392932-28307-1-git-send-email-laurent.pinchart@ideasonboard.com>
 <1463392932-28307-5-git-send-email-laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1463392932-28307-5-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Thanks for the set!

On Mon, May 16, 2016 at 01:02:12PM +0300, Laurent Pinchart wrote:
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> ---
>  yavta.c | 24 ++++++++++++++++++++++++
>  1 file changed, 24 insertions(+)
> 
> diff --git a/yavta.c b/yavta.c
> index 4b531a0360fe..d0bcf7f19c7b 100644
> --- a/yavta.c
> +++ b/yavta.c
> @@ -1225,6 +1225,30 @@ static int video_parse_control_array(const struct v4l2_query_ext_ctrl *query,
>  
>  	for ( ; isspace(*val); ++val) { };
>  
> +	if (*val == '<') {
> +		/* Read the control value from the given file. */
> +		ssize_t size;
> +		int fd;
> +
> +		val++;
> +		fd = open(val, O_RDONLY);
> +		if (fd < 0) {
> +			printf("unable to open control file `%s'\n", val);
> +			return -EINVAL;
> +		}
> +
> +		size = read(fd, ctrl->ptr, ctrl->size);
> +		if (size != (ssize_t)ctrl->size) {
> +			printf("error reading control file `%s' (%s)\n", val,
> +			       strerror(errno));
> +			close(fd);
> +			return -EINVAL;
> +		}
> +
> +		close(fd);
> +		return 0;
> +	}
> +
>  	if (*val++ != '{')
>  		return -EINVAL;
>  

How about adding a new command line option to read the value from a file? I
think that'd be cleaner. I'd also add support for writing binary values to a
file, that would be quite convenient. Write support could be done later as
well.

For patches 1--3:

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
