Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:40668 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754017Ab2HWGTn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 23 Aug 2012 02:19:43 -0400
Received: by wgbdr13 with SMTP id dr13so331805wgb.1
        for <linux-media@vger.kernel.org>; Wed, 22 Aug 2012 23:19:42 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1345669220-21052-1-git-send-email-sylvester.nawrocki@gmail.com>
References: <1345669220-21052-1-git-send-email-sylvester.nawrocki@gmail.com>
Date: Thu, 23 Aug 2012 08:19:41 +0200
Message-ID: <CACKLOr3BVJS_iB-y-5PNxCZD+xeNPUw5XzwN8rTgMaa8wWjVww@mail.gmail.com>
Subject: Re: [PATCH] coda: Add V4L2_CAP_VIDEO_M2M capability flag
From: javier Martin <javier.martin@vista-silicon.com>
To: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 22 August 2012 23:00, Sylwester Nawrocki
<sylvester.nawrocki@gmail.com> wrote:
> New mem-to-mem video drivers should use V4L2_CAP_VIDEO_M2M capability, rather
> than ORed V4L2_CAP_VIDEO_CAPTURE and V4L2_CAP_VIDEO_OUTPUT flags, as outlined
> in commit a1367f1b260d29e9b9fb20d8e2f39f1e74fa6c3b.
>
> Cc: Javier Martin <javier.martin@vista-silicon.com>
> Signed-off-by: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
> ---
>  drivers/media/platform/coda.c |    9 +++++++--
>  1 files changed, 7 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/media/platform/coda.c b/drivers/media/platform/coda.c
> index 0d6e0a0..e74705c 100644
> --- a/drivers/media/platform/coda.c
> +++ b/drivers/media/platform/coda.c
> @@ -287,8 +287,13 @@ static int vidioc_querycap(struct file *file, void *priv,
>         strlcpy(cap->driver, CODA_NAME, sizeof(cap->driver));
>         strlcpy(cap->card, CODA_NAME, sizeof(cap->card));
>         strlcpy(cap->bus_info, CODA_NAME, sizeof(cap->bus_info));
> -       cap->device_caps = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_VIDEO_OUTPUT
> -                               | V4L2_CAP_STREAMING;
> +       /*
> +        * This is only a mem-to-mem video device. The capture and output
> +        * device capability flags are left only for backward compatibility
> +        * and are scheduled for removal.
> +        */
> +       cap->device_caps = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_VIDEO_OUTPUT |
> +                          V4L2_CAP_VIDEO_M2M | V4L2_CAP_STREAMING;
>         cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
>
>         return 0;
> --
> 1.7.4.1
>

Acked-by: Javier Martin <javier.martin@vista-silicon.com>

-- 
Javier Martin
Vista Silicon S.L.
CDTUC - FASE C - Oficina S-345
Avda de los Castros s/n
39005- Santander. Cantabria. Spain
+34 942 25 32 60
www.vista-silicon.com
