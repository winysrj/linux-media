Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:50172 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755406Ab3GQQUl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Jul 2013 12:20:41 -0400
Message-id: <51E6C455.5080907@samsung.com>
Date: Wed, 17 Jul 2013 18:20:37 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Prabhakar Lad <prabhakar.csengg@gmail.com>
Cc: LMML <linux-media@vger.kernel.org>,
	devicetree-discuss@lists.ozlabs.org,
	DLOS <davinci-linux-open-source@linux.davincidsp.com>,
	LKML <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org
Subject: Re: [PATCH RFC FINAL v5] media: OF: add "sync-on-green-active" property
References: <1374076022-10960-1-git-send-email-prabhakar.csengg@gmail.com>
In-reply-to: <1374076022-10960-1-git-send-email-prabhakar.csengg@gmail.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/17/2013 05:47 PM, Prabhakar Lad wrote:
> From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
> 
> This patch adds 'sync-on-green-active' property as part
> of endpoint property.
> 
> Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>

Thanks Prabhakar, it looks good to me.
Just a side note, the 'From' tag above isn't needed. It wasn't
added automatically, was it ?
Unless there are comments from others I think this patch should
be merged together with the users of this new property.

Acked-by: Sylwester Nawrocki <s.nawrocki@samsung.com>

Regards,
Sylwester
> ---
>   Changes for v5:
>   1: Changed description for sync-on-green-active property in
>      documentation file as suggested by Sylwester.
>   
>   Changes for v4:
>   1: Fixed review comments pointed by Sylwester.
> 
>   Changes for v3:
>   1: Fixed review comments pointed by Laurent and Sylwester.
> 
>   RFC v2 https://patchwork.kernel.org/patch/2578091/
> 
>   RFC V1 https://patchwork.kernel.org/patch/2572341/
> 
>  .../devicetree/bindings/media/video-interfaces.txt |    2 ++
>  drivers/media/v4l2-core/v4l2-of.c                  |    4 ++++
>  include/media/v4l2-mediabus.h                      |    2 ++
>  3 files changed, 8 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/media/video-interfaces.txt b/Documentation/devicetree/bindings/media/video-interfaces.txt
> index e022d2d..ce719f8 100644
> --- a/Documentation/devicetree/bindings/media/video-interfaces.txt
> +++ b/Documentation/devicetree/bindings/media/video-interfaces.txt
> @@ -88,6 +88,8 @@ Optional endpoint properties
>  - field-even-active: field signal level during the even field data transmission.
>  - pclk-sample: sample data on rising (1) or falling (0) edge of the pixel clock
>    signal.
> +- sync-on-green-active: active state of Sync-on-green (SoG) signal, 0/1 for
> +  LOW/HIGH respectively.
>  - data-lanes: an array of physical data lane indexes. Position of an entry
>    determines the logical lane number, while the value of an entry indicates
>    physical lane, e.g. for 2-lane MIPI CSI-2 bus we could have
> diff --git a/drivers/media/v4l2-core/v4l2-of.c b/drivers/media/v4l2-core/v4l2-of.c
> index aa59639..5c4c9f0 100644
> --- a/drivers/media/v4l2-core/v4l2-of.c
> +++ b/drivers/media/v4l2-core/v4l2-of.c
> @@ -100,6 +100,10 @@ static void v4l2_of_parse_parallel_bus(const struct device_node *node,
>  	if (!of_property_read_u32(node, "data-shift", &v))
>  		bus->data_shift = v;
>  
> +	if (!of_property_read_u32(node, "sync-on-green-active", &v))
> +		flags |= v ? V4L2_MBUS_VIDEO_SOG_ACTIVE_HIGH :
> +			V4L2_MBUS_VIDEO_SOG_ACTIVE_LOW;
> +
>  	bus->flags = flags;
>  
>  }
> diff --git a/include/media/v4l2-mediabus.h b/include/media/v4l2-mediabus.h
> index 83ae07e..d47eb81 100644
> --- a/include/media/v4l2-mediabus.h
> +++ b/include/media/v4l2-mediabus.h
> @@ -40,6 +40,8 @@
>  #define V4L2_MBUS_FIELD_EVEN_HIGH		(1 << 10)
>  /* FIELD = 1/0 - Field1 (odd)/Field2 (even) */
>  #define V4L2_MBUS_FIELD_EVEN_LOW		(1 << 11)
> +#define V4L2_MBUS_VIDEO_SOG_ACTIVE_HIGH	(1 << 12)
> +#define V4L2_MBUS_VIDEO_SOG_ACTIVE_LOW		(1 << 13)
>  
>  /* Serial flags */
>  /* How many lanes the client can use */
> 

-- 
Sylwester Nawrocki
Samsung R&D Institute Poland
