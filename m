Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f177.google.com ([74.125.82.177]:43218 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752755AbaFMSOP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Jun 2014 14:14:15 -0400
MIME-Version: 1.0
In-Reply-To: <20140612070145.GA18563@mwanda>
References: <CA+V-a8vhEyNdQRqNrzRV=t-D+uh6rCEY5-qLjTOWDfHwUai1Kg@mail.gmail.com>
 <20140612070145.GA18563@mwanda>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Fri, 13 Jun 2014 19:13:44 +0100
Message-ID: <CA+V-a8tGf8EAVV=OGEofJczN09X5FKPqLa8G+ZMg=j72rpDyCA@mail.gmail.com>
Subject: Re: [patch v2] [media] davinci: vpif: missing unlocks on error
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media <linux-media@vger.kernel.org>,
	dlos <davinci-linux-open-source@linux.davincidsp.com>,
	kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Jun 12, 2014 at 8:01 AM, Dan Carpenter <dan.carpenter@oracle.com> wrote:
> We recently changed some locking around so we need some new unlocks on
> the error paths.
>
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Applied!

Thanks,
--Prabhakar Lad

> ---
> v2: move the unlock so the list_for_each_entry_safe() loop is protected
>
> diff --git a/drivers/media/platform/davinci/vpif_capture.c b/drivers/media/platform/davinci/vpif_capture.c
> index a7ed164..1e4ec69 100644
> --- a/drivers/media/platform/davinci/vpif_capture.c
> +++ b/drivers/media/platform/davinci/vpif_capture.c
> @@ -269,6 +269,7 @@ err:
>                 list_del(&buf->list);
>                 vb2_buffer_done(&buf->vb, VB2_BUF_STATE_QUEUED);
>         }
> +       spin_unlock_irqrestore(&common->irqlock, flags);
>
>         return ret;
>  }
> diff --git a/drivers/media/platform/davinci/vpif_display.c b/drivers/media/platform/davinci/vpif_display.c
> index 5bb085b..b431b58 100644
> --- a/drivers/media/platform/davinci/vpif_display.c
> +++ b/drivers/media/platform/davinci/vpif_display.c
> @@ -233,6 +233,7 @@ err:
>                 list_del(&buf->list);
>                 vb2_buffer_done(&buf->vb, VB2_BUF_STATE_QUEUED);
>         }
> +       spin_unlock_irqrestore(&common->irqlock, flags);
>
>         return ret;
>  }
