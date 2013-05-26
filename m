Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f48.google.com ([209.85.215.48]:64441 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753295Ab3EZOhF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 26 May 2013 10:37:05 -0400
Received: by mail-la0-f48.google.com with SMTP id fs12so5745501lab.21
        for <linux-media@vger.kernel.org>; Sun, 26 May 2013 07:37:03 -0700 (PDT)
Message-ID: <51A21E0D.2030509@cogentembedded.com>
Date: Sun, 26 May 2013 18:37:01 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
MIME-Version: 1.0
To: Prabhakar Lad <prabhakar.csengg@gmail.com>
CC: Hans Verkuil <hans.verkuil@cisco.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	LMML <linux-media@vger.kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	DLOS <davinci-linux-open-source@linux.davincidsp.com>,
	LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 2/9] media: davinci: vpif: Convert to devm_* api
References: <1369569612-30915-1-git-send-email-prabhakar.csengg@gmail.com> <1369569612-30915-3-git-send-email-prabhakar.csengg@gmail.com>
In-Reply-To: <1369569612-30915-3-git-send-email-prabhakar.csengg@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello.

On 26-05-2013 16:00, Prabhakar Lad wrote:

> From: Lad, Prabhakar <prabhakar.csengg@gmail.com>

> Use devm_ioremap_resource instead of reques_mem_region()/ioremap().
> This ensures more consistent error values and simplifies error paths.

> Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
> Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> ---
>   drivers/media/platform/davinci/vpif.c |   27 ++++-----------------------
>   1 files changed, 4 insertions(+), 23 deletions(-)

> diff --git a/drivers/media/platform/davinci/vpif.c b/drivers/media/platform/davinci/vpif.c
> index 761c825..f857d8f 100644
> --- a/drivers/media/platform/davinci/vpif.c
> +++ b/drivers/media/platform/davinci/vpif.c
[...]
> @@ -421,23 +419,12 @@ EXPORT_SYMBOL(vpif_channel_getfid);
>
>   static int vpif_probe(struct platform_device *pdev)
>   {
> -	int status = 0;
> +	static struct resource	*res;
>
>   	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
[...]
> +	vpif_base = devm_request_and_ioremap(&pdev->dev, res);

    No, don't use this deprecated funtion please. Undo to 
devm_ioremap_resource().

> +	if (IS_ERR(vpif_base))

     NAK, devm_request_and_ioremap() doesn't rethrn error cpdes, only 
NULL. BTW, it's implemented via a call to devm_ioremap_resource() now.
Is it so hard to look at the code that you've calling?

> +		return PTR_ERR(vpif_base);

WBR, Sergei

