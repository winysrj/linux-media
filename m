Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:52639 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750903AbdK3Jcy (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 30 Nov 2017 04:32:54 -0500
Subject: Re: [PATCH 16/22] media: vsp1: add a missing kernel-doc parameter
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-renesas-soc@vger.kernel.org
References: <73497577f67fbb917e40ab4328104ff310a7c356.1511982439.git.mchehab@s-opensource.com>
 <cf39264f87c1ca4436c11e07df455feb3ea6d1e1.1511982439.git.mchehab@s-opensource.com>
From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Reply-To: kieran.bingham@ideasonboard.com
Message-ID: <bf0f9eee-66fc-2c01-5f85-bcb47c130c11@ideasonboard.com>
Date: Thu, 30 Nov 2017 09:32:49 +0000
MIME-Version: 1.0
In-Reply-To: <cf39264f87c1ca4436c11e07df455feb3ea6d1e1.1511982439.git.mchehab@s-opensource.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Thanks for the patch.

On 29/11/17 19:08, Mauro Carvalho Chehab wrote:
> Fix this warning:
> 	drivers/media/platform/vsp1/vsp1_dl.c:87: warning: No description found for parameter 'has_chain'
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>

Ah yes, I missed that... Thanks for fixing.

Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>

> ---
>  drivers/media/platform/vsp1/vsp1_dl.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/media/platform/vsp1/vsp1_dl.c b/drivers/media/platform/vsp1/vsp1_dl.c
> index 8b5cbb6b7a70..4257451f1bd8 100644
> --- a/drivers/media/platform/vsp1/vsp1_dl.c
> +++ b/drivers/media/platform/vsp1/vsp1_dl.c
> @@ -70,6 +70,7 @@ struct vsp1_dl_body {
>   * @dma: DMA address for the header
>   * @body0: first display list body
>   * @fragments: list of extra display list bodies
> + * @has_chain: if true, indicates that there's a partition chain
>   * @chain: entry in the display list partition chain
>   */
>  struct vsp1_dl_list {
> 
