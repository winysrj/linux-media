Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr19.xs4all.nl ([194.109.24.39]:1235 "EHLO
	smtp-vbr19.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751404Ab3AUJ4t (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Jan 2013 04:56:49 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: Re: [PATCH] media: tvp514x: remove field description
Date: Mon, 21 Jan 2013 10:56:09 +0100
Cc: LMML <linux-media@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	"Lad, Prabhakar" <prabhakar.lad@ti.com>
References: <1358236540-2091-1-git-send-email-prabhakar.lad@ti.com>
In-Reply-To: <1358236540-2091-1-git-send-email-prabhakar.lad@ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201301211056.09244.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue January 15 2013 08:55:40 Lad, Prabhakar wrote:
> This patch removes the field description of fields that no
> longer exists, along side aligns the field description of
> fields.
> 
> Signed-off-by: Lad, Prabhakar <prabhakar.lad@ti.com>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Regards,

	Hans

> ---
>  include/media/tvp514x.h |    7 ++-----
>  1 files changed, 2 insertions(+), 5 deletions(-)
> 
> diff --git a/include/media/tvp514x.h b/include/media/tvp514x.h
> index 74387e8..86ed7e8 100644
> --- a/include/media/tvp514x.h
> +++ b/include/media/tvp514x.h
> @@ -96,12 +96,9 @@ enum tvp514x_output {
>  
>  /**
>   * struct tvp514x_platform_data - Platform data values and access functions.
> - * @power_set: Power state access function, zero is off, non-zero is on.
> - * @ifparm: Interface parameters access function.
> - * @priv_data_set: Device private data (pointer) access function.
>   * @clk_polarity: Clock polarity of the current interface.
> - * @ hs_polarity: HSYNC Polarity configuration for current interface.
> - * @ vs_polarity: VSYNC Polarity configuration for current interface.
> + * @hs_polarity: HSYNC Polarity configuration for current interface.
> + * @vs_polarity: VSYNC Polarity configuration for current interface.
>   */
>  struct tvp514x_platform_data {
>  	/* Interface control params */
> 
