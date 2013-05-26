Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:59191 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758500Ab3EZAva (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 25 May 2013 20:51:30 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Prabhakar Lad <prabhakar.csengg@gmail.com>
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	LMML <linux-media@vger.kernel.org>,
	DLOS <davinci-linux-open-source@linux.davincidsp.com>,
	LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 3/5] media: davinci: vpif: remove unnecessary braces around defines
Date: Sun, 26 May 2013 02:51:27 +0200
Message-ID: <9072131.neW5PtBrWa@avalon>
In-Reply-To: <1369499796-18762-4-git-send-email-prabhakar.csengg@gmail.com>
References: <1369499796-18762-1-git-send-email-prabhakar.csengg@gmail.com> <1369499796-18762-4-git-send-email-prabhakar.csengg@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Prabhakar,

Thank you for the patch.

On Saturday 25 May 2013 22:06:34 Prabhakar Lad wrote:
> From: Lad, Prabhakar <prabhakar.csengg@gmail.com>
> 
> Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
> ---
>  drivers/media/platform/davinci/vpif.c |    8 ++++----
>  1 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/media/platform/davinci/vpif.c
> b/drivers/media/platform/davinci/vpif.c index 164c1b7..d9269c9 100644
> --- a/drivers/media/platform/davinci/vpif.c
> +++ b/drivers/media/platform/davinci/vpif.c
> @@ -32,10 +32,10 @@
>  MODULE_DESCRIPTION("TI DaVinci Video Port Interface driver");
>  MODULE_LICENSE("GPL");
> 
> -#define VPIF_CH0_MAX_MODES	(22)
> -#define VPIF_CH1_MAX_MODES	(02)
> -#define VPIF_CH2_MAX_MODES	(15)
> -#define VPIF_CH3_MAX_MODES	(02)
> +#define VPIF_CH0_MAX_MODES	22
> +#define VPIF_CH1_MAX_MODES	02
> +#define VPIF_CH2_MAX_MODES	15
> +#define VPIF_CH3_MAX_MODES	02

Could you also replace 02 with 2 while you're at it ? 02 is an octal constant. 
While it still evaluates to 2 in this case, it would be a good practice to use 
decimal when decimal is intended.

With that change,

Laurent Pinchart <laurent.pinchart@ideasonboard.com>

>  spinlock_t vpif_lock;
-- 
Regards,

Laurent Pinchart

