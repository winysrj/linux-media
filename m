Return-path: <mchehab@pedra>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:51199 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750920Ab1COFSy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Mar 2011 01:18:54 -0400
Received: by wya21 with SMTP id 21so203592wya.19
        for <linux-media@vger.kernel.org>; Mon, 14 Mar 2011 22:18:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <28773e810fb3efb9dc0a9cc683a2268f@localhost>
References: <28773e810fb3efb9dc0a9cc683a2268f@localhost>
Date: Tue, 15 Mar 2011 14:18:52 +0900
Message-ID: <AANLkTinN9GpY2f4=t2bCTMPcnXrmdhvC3u6+FdUubzxi@mail.gmail.com>
Subject: Re: [PATCH] fix of mutex locking bug in fops_read
From: Kyungmin Park <kmpark@infradead.org>
To: Tobias Lorenz <tobias.lorenz@gmx.net>
Cc: mchehab@infradead.org,
	Nils Faerber <nils.faerber@kernelconcepts.de>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Acked-by: Kyungmin Park <kyungmin.park@samsung.com>

On Tue, Mar 15, 2011 at 6:03 AM, Tobias Lorenz <tobias.lorenz@gmx.net> wrote:
> This patch fixes a mutex locking bug causing userspace processes
> to hang indefinitely upon reading the radio device for RDS data.
>
> Signed-off-by: Nils Faerber <nils.faerber@kernelconcepts.de>
> Acked-by: Tobias Lorenz <tobias.lorenz@gmx.net>
> ---
>  drivers/media/radio/si470x/radio-si470x-common.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/media/radio/si470x/radio-si470x-common.c
> b/drivers/media/radio/si470x/radio-si470x-common.c
> index 4c69698..41ee757 100644
> --- a/drivers/media/radio/si470x/radio-si470x-common.c
> +++ b/drivers/media/radio/si470x/radio-si470x-common.c
> @@ -483,7 +483,6 @@ static ssize_t si470x_fops_read(struct file *file,
> char __user *buf,
>        count /= 3;
>
>        /* copy RDS block out of internal buffer and to user buffer */
> -       mutex_lock(&radio->lock);
>        while (block_count < count) {
>                if (radio->rd_index == radio->wr_index)
>                        break;
> --
> 1.7.2.3
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
