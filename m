Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:2413 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752905Ab3ANKYY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Jan 2013 05:24:24 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Sachin Kamat <sachin.kamat@linaro.org>
Subject: Re: [PATCH 1/1] [media] s5p-mfc: Use NULL instead of 0 for pointer
Date: Mon, 14 Jan 2013 11:24:06 +0100
Cc: linux-media@vger.kernel.org, k.debski@samsung.com,
	s.nawrocki@samsung.com, patches@linaro.org
References: <1358158181-5356-1-git-send-email-sachin.kamat@linaro.org>
In-Reply-To: <1358158181-5356-1-git-send-email-sachin.kamat@linaro.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201301141124.06203.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon January 14 2013 11:09:41 Sachin Kamat wrote:
> Fixes the following warning:
> drivers/media/platform/s5p-mfc/s5p_mfc_opr.c:56:27: warning:
> Using plain integer as NULL pointer
> 
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

> ---
>  drivers/media/platform/s5p-mfc/s5p_mfc_opr.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_opr.c b/drivers/media/platform/s5p-mfc/s5p_mfc_opr.c
> index b4c1943..10f8ac3 100644
> --- a/drivers/media/platform/s5p-mfc/s5p_mfc_opr.c
> +++ b/drivers/media/platform/s5p-mfc/s5p_mfc_opr.c
> @@ -53,7 +53,7 @@ void s5p_mfc_release_priv_buf(struct device *dev,
>  {
>  	if (b->virt) {
>  		dma_free_coherent(dev, b->size, b->virt, b->dma);
> -		b->virt = 0;
> +		b->virt = NULL;
>  		b->dma = 0;
>  		b->size = 0;
>  	}
> 
