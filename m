Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:50342 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754792Ab2E2VW5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 29 May 2012 17:22:57 -0400
Received: by bkcji2 with SMTP id ji2so3505447bkc.19
        for <linux-media@vger.kernel.org>; Tue, 29 May 2012 14:22:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1338325692-19684-1-git-send-email-martin.blumenstingl@googlemail.com>
References: <1338154013-5124-3-git-send-email-martin.blumenstingl@googlemail.com>
	<1338325692-19684-1-git-send-email-martin.blumenstingl@googlemail.com>
Date: Tue, 29 May 2012 18:22:56 -0300
Message-ID: <CAOMZO5Bmc3cesaJ_y_NgSaAPYQpcwOUtn_6TX=khg7k=4da-Bg@mail.gmail.com>
Subject: Re: [PATCH] [media] em28xx: Show a warning if the board does not
 support remote controls
From: Fabio Estevam <festevam@gmail.com>
To: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, May 29, 2012 at 6:08 PM, Martin Blumenstingl
<martin.blumenstingl@googlemail.com> wrote:
> This simply shows a little warning if the board does not have remote
> control support. This should make it easier for users to see if they
> have misconfigured their system or if the driver simply does not have
> rc-support for their card (yet).
>
> Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
> ---
>  drivers/media/video/em28xx/em28xx-input.c |    3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/drivers/media/video/em28xx/em28xx-input.c b/drivers/media/video/em28xx/em28xx-input.c
> index fce5f76..d94b434 100644
> --- a/drivers/media/video/em28xx/em28xx-input.c
> +++ b/drivers/media/video/em28xx/em28xx-input.c
> @@ -527,6 +527,9 @@ static int em28xx_ir_init(struct em28xx *dev)
>
>        if (dev->board.ir_codes == NULL) {
>                /* No remote control support */
> +               printk("No remote control support for em28xx "
> +                       "card %s (model %d) available.\n",
> +                       dev->name, dev->model);

What about using dev_err instead?
