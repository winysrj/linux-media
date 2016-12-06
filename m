Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:44010 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752696AbcLFLPn (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 6 Dec 2016 06:15:43 -0500
Subject: Re: [PATCH v2] v4l: async: make v4l2 coexist with devicetree nodes in
 a dt overlay
To: Javi Merino <javi.merino@kernel.org>, linux-media@vger.kernel.org
References: <1480932596-4108-1-git-send-email-javi.merino@kernel.org>
Cc: Javier Martinez Canillas <javier@osg.samsung.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Message-id: <2ac49275-7762-5ceb-21bd-684862379610@samsung.com>
Date: Tue, 06 Dec 2016 12:15:17 +0100
MIME-version: 1.0
In-reply-to: <1480932596-4108-1-git-send-email-javi.merino@kernel.org>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

(resending, hopefully now it reaches the mailing lists)

On 12/05/2016 11:09 AM, Javi Merino wrote:

> Each time the overlay is applied, its of_node pointer will be
> different.  We are not interested in matching the pointer, what we
> want to match is that the path is the one we are expecting.  Change to
> use of_node_cmp() so that we continue matching after the overlay has
> been removed and reapplied.
> 
> Signed-off-by: Javi Merino <javi.merino@kernel.org>

Thanks, there is clearly a bug in current code as it assumed static
representation of DT in the kernel.

Reviewed-by: Sylwester Nawrocki <s.nawrocki@samsung.com>

> ---
>  drivers/media/v4l2-core/v4l2-async.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-async.c b/drivers/media/v4l2-core/v4l2-async.c
> index 5bada20..d33a17c 100644
> --- a/drivers/media/v4l2-core/v4l2-async.c
> +++ b/drivers/media/v4l2-core/v4l2-async.c
> @@ -42,7 +42,8 @@ static bool match_devname(struct v4l2_subdev *sd,
>  
>  static bool match_of(struct v4l2_subdev *sd, struct v4l2_async_subdev *asd)
>  {
> -	return sd->of_node == asd->match.of.node;
> +	return !of_node_cmp(of_node_full_name(sd->of_node),
> +			    of_node_full_name(asd->match.of.node));
>  }
