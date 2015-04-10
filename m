Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:57782 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754760AbbDJJr0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Apr 2015 05:47:26 -0400
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout4.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0NML00LJI4PJBA40@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 10 Apr 2015 10:51:19 +0100 (BST)
Message-id: <55279C28.5080900@samsung.com>
Date: Fri, 10 Apr 2015 11:47:20 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org, g.liakhovetski@gmx.de,
	laurent.pinchart@ideasonboard.com
Subject: Re: [PATCH v4 1/4] v4l: of: Remove the head field in struct
 v4l2_of_endpoint
References: <1428614706-8367-1-git-send-email-sakari.ailus@iki.fi>
 <1428614706-8367-2-git-send-email-sakari.ailus@iki.fi>
In-reply-to: <1428614706-8367-2-git-send-email-sakari.ailus@iki.fi>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On 09/04/15 23:25, Sakari Ailus wrote:
> The field is unused. Remove it.
> 
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

I don't remember what this list_head was originally intended for,
probably for some code in soc_camera on which didn't the works were
postponed or abandoned. Presumably now such code would likely live
in drivers/of/base.c anyway.

Acked-by: Sylwester Nawrocki <s.nawrocki@samsung.com>

-- 
Regards,
Sylwester
