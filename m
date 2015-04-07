Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:39237 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750993AbbDGKLW (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 7 Apr 2015 06:11:22 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org, g.liakhovetski@gmx.de,
	s.nawrocki@samsung.com
Subject: Re: [PATCH v3 1/4] v4l: of: Remove the head field in struct v4l2_of_endpoint
Date: Tue, 07 Apr 2015 13:11:34 +0300
Message-ID: <2590752.PorL0aNYep@avalon>
In-Reply-To: <1428361053-20411-2-git-send-email-sakari.ailus@iki.fi>
References: <1428361053-20411-1-git-send-email-sakari.ailus@iki.fi> <1428361053-20411-2-git-send-email-sakari.ailus@iki.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Thank you for the patch.

On Tuesday 07 April 2015 01:57:29 Sakari Ailus wrote:
> The field is unused. Remove it.

Do you know what the field was added for in the first place ?

> Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
> ---
>  include/media/v4l2-of.h |    2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/include/media/v4l2-of.h b/include/media/v4l2-of.h
> index f831c9c..f66b92c 100644
> --- a/include/media/v4l2-of.h
> +++ b/include/media/v4l2-of.h
> @@ -57,7 +57,6 @@ struct v4l2_of_bus_parallel {
>   * @base: struct of_endpoint containing port, id, and local of_node
>   * @bus_type: bus type
>   * @bus: bus configuration data structure
> - * @head: list head for this structure
>   */
>  struct v4l2_of_endpoint {
>  	struct of_endpoint base;
> @@ -66,7 +65,6 @@ struct v4l2_of_endpoint {
>  		struct v4l2_of_bus_parallel parallel;
>  		struct v4l2_of_bus_mipi_csi2 mipi_csi2;
>  	} bus;
> -	struct list_head head;
>  };
> 
>  /**

-- 
Regards,

Laurent Pinchart

