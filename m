Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vk0-f66.google.com ([209.85.213.66]:36475 "EHLO
        mail-vk0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751262AbeEDOhZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 4 May 2018 10:37:25 -0400
MIME-Version: 1.0
In-Reply-To: <a1bedd480c31bcc2f48cd6d965a9bb853e8786ee.1525436031.git.mchehab+samsung@kernel.org>
References: <a1bedd480c31bcc2f48cd6d965a9bb853e8786ee.1525436031.git.mchehab+samsung@kernel.org>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Fri, 4 May 2018 16:37:23 +0200
Message-ID: <CAMuHMdX-kD0a_bRnxB+G8eE6sVhETAGuyoYOr5N0HM9VZa8LCw@mail.gmail.com>
Subject: Re: [PATCH] media: vsp1: cleanup a false positive warning
To: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On Fri, May 4, 2018 at 2:13 PM, Mauro Carvalho Chehab
<mchehab+samsung@kernel.org> wrote:
> With the new vsp1 code changes introduced by changeset
> f81f9adc4ee1 ("media: v4l: vsp1: Assign BRU and BRS to pipelines dynamically"),
> smatch complains with:
>         drivers/media/platform/vsp1/vsp1_drm.c:262 vsp1_du_pipeline_setup_bru() error: we previously assumed 'pipe->bru' could be null (see line 180)
>
> This is a false positive, as, if pipe->bru is NULL, the brx
> var will be different, with ends by calling a code that will
> set pipe->bru to another value.
>
> Yet, cleaning this false positive is as easy as adding an explicit
> check if pipe->bru is NULL.
>
> Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>

Thanks for your patch!

s/bru/brx/

> --- a/drivers/media/platform/vsp1/vsp1_drm.c
> +++ b/drivers/media/platform/vsp1/vsp1_drm.c
> @@ -185,7 +185,7 @@ static int vsp1_du_pipeline_setup_brx(struct vsp1_device *vsp1,
>                 brx = &vsp1->brs->entity;
>
>         /* Switch BRx if needed. */
> -       if (brx != pipe->brx) {
> +       if (brx != pipe->brx || !pipe->brx) {
>                 struct vsp1_entity *released_brx = NULL;
>
>                 /* Release our BRx if we have one. */

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
