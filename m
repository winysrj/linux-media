Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:3312 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752970AbaFTHCN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Jun 2014 03:02:13 -0400
Message-ID: <53A3DC57.8080405@xs4all.nl>
Date: Fri, 20 Jun 2014 09:01:43 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Ramakrishnan Muthukrishnan <ram@fastmail.in>,
	linux-media@vger.kernel.org
CC: Ramakrishnan Muthukrishnan <ramakrmu@cisco.com>
Subject: Re: [REVIEW PATCH 3/4] media: v4l2-dev.h: remove V4L2_FL_USE_FH_PRIO
 flag.
References: <1403198580-3126-1-git-send-email-ram@fastmail.in> <1403198580-3126-4-git-send-email-ram@fastmail.in>
In-Reply-To: <1403198580-3126-4-git-send-email-ram@fastmail.in>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/19/2014 07:22 PM, Ramakrishnan Muthukrishnan wrote:
> From: Ramakrishnan Muthukrishnan <ramakrmu@cisco.com>
> 
> Since none of the drivers are using it, this flag can be removed.
> 
> Signed-off-by: Ramakrishnan Muthukrishnan <ramakrmu@cisco.com>

Reviewed-by: Hans Verkuil <hans.verkuil@cisco.com>

> ---
>  include/media/v4l2-dev.h | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/include/media/v4l2-dev.h b/include/media/v4l2-dev.h
> index eec6e46..eb76cfd 100644
> --- a/include/media/v4l2-dev.h
> +++ b/include/media/v4l2-dev.h
> @@ -44,8 +44,6 @@ struct v4l2_ctrl_handler;
>  #define V4L2_FL_REGISTERED	(0)
>  /* file->private_data points to struct v4l2_fh */
>  #define V4L2_FL_USES_V4L2_FH	(1)
> -/* Use the prio field of v4l2_fh for core priority checking */
> -#define V4L2_FL_USE_FH_PRIO	(2)
>  
>  /* Priority helper functions */
>  
> 

