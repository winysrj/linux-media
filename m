Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ie0-f174.google.com ([209.85.223.174]:33701 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754561Ab2IWWZJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 23 Sep 2012 18:25:09 -0400
Received: by ieak13 with SMTP id k13so9472566iea.19
        for <linux-media@vger.kernel.org>; Sun, 23 Sep 2012 15:25:08 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1345425826-13429-1-git-send-email-elezegarcia@gmail.com>
References: <1345425826-13429-1-git-send-email-elezegarcia@gmail.com>
Date: Sun, 23 Sep 2012 19:25:08 -0300
Message-ID: <CALF0-+VMYuop_WF+KoR3dJOyDAG1uGTYrBy7ebPuLJiM4xQLmA@mail.gmail.com>
Subject: Re: [PATCH 1/4] stk1160: Make kill/free urb debug message more verbose
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Ezequiel Garcia <elezegarcia@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro,

On Sun, Aug 19, 2012 at 10:23 PM, Ezequiel Garcia <elezegarcia@gmail.com> wrote:
> This is just a cleaning patch to produce more useful
> debug messages.
>
> Signed-off-by: Ezequiel Garcia <elezegarcia@gmail.com>
> ---
>  drivers/media/usb/stk1160/stk1160-video.c |   14 +++++++-------
>  1 files changed, 7 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/media/usb/stk1160/stk1160-video.c b/drivers/media/usb/stk1160/stk1160-video.c
> index 3785269..022092a 100644
> --- a/drivers/media/usb/stk1160/stk1160-video.c
> +++ b/drivers/media/usb/stk1160/stk1160-video.c
> @@ -342,18 +342,18 @@ static void stk1160_isoc_irq(struct urb *urb)
>   */
>  void stk1160_cancel_isoc(struct stk1160 *dev)
>  {
> -       int i;
> +       int i, num_bufs = dev->isoc_ctl.num_bufs;
>
>         /*
>          * This check is not necessary, but we add it
>          * to avoid a spurious debug message
>          */
> -       if (!dev->isoc_ctl.num_bufs)
> +       if (!num_bufs)
>                 return;
>
> -       stk1160_dbg("killing urbs...\n");
> +       stk1160_dbg("killing %d urbs...\n", num_bufs);
>
> -       for (i = 0; i < dev->isoc_ctl.num_bufs; i++) {
> +       for (i = 0; i < num_bufs; i++) {
>
>                 /*
>                  * To kill urbs we can't be in atomic context.
> @@ -373,11 +373,11 @@ void stk1160_cancel_isoc(struct stk1160 *dev)
>  void stk1160_free_isoc(struct stk1160 *dev)
>  {
>         struct urb *urb;
> -       int i;
> +       int i, num_bufs = dev->isoc_ctl.num_bufs;
>
> -       stk1160_dbg("freeing urb buffers...\n");
> +       stk1160_dbg("freeing %d urb buffers...\n", num_bufs);
>
> -       for (i = 0; i < dev->isoc_ctl.num_bufs; i++) {
> +       for (i = 0; i < num_bufs; i++) {
>
>                 urb = dev->isoc_ctl.urb[i];
>                 if (urb) {
> --
> 1.7.8.6
>

Please don't forget these patches for your v3.7 pull request.
Unless you don't want to add them yet.

Thanks,
Ezequiel.
