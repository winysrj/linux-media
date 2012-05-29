Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:48617 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755875Ab2E2VXx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 29 May 2012 17:23:53 -0400
Received: by yhmm54 with SMTP id m54so2733546yhm.19
        for <linux-media@vger.kernel.org>; Tue, 29 May 2012 14:23:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1338326368-20108-1-git-send-email-martin.blumenstingl@googlemail.com>
References: <1338154013-5124-2-git-send-email-martin.blumenstingl@googlemail.com>
 <1338326368-20108-1-git-send-email-martin.blumenstingl@googlemail.com>
From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Date: Tue, 29 May 2012 23:23:32 +0200
Message-ID: <CAFBinCC32XkEerQnMSpJMG=o8nRZ36Qx+xKUJ+11-1ugF7qtYw@mail.gmail.com>
Subject: Re: [PATCH 1/2] [media] em28xx: Add remote control support for
 Terratec's Cinergy HTC Stick HD
To: linux-media@vger.kernel.org
Cc: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello everyone,

sorry for the first reply - I messed up the git send-email command.
This is the correct version of the patch (including my signed-off-by
and a whitespace fix).

Regards,
Martin

On Tue, May 29, 2012 at 11:19 PM, Martin Blumenstingl
<martin.blumenstingl@googlemail.com> wrote:
> The Cinergy HTC Stick HD uses the same remote control as the TerraTec
> Cinergy XS products. Thus the same keymap could be re-used.
>
> Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
> ---
>  drivers/media/video/em28xx/em28xx-cards.c |    1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/drivers/media/video/em28xx/em28xx-cards.c b/drivers/media/video/em28xx/em28xx-cards.c
> index 20a7e24..92da7c2 100644
> --- a/drivers/media/video/em28xx/em28xx-cards.c
> +++ b/drivers/media/video/em28xx/em28xx-cards.c
> @@ -974,6 +974,7 @@ struct em28xx_board em28xx_boards[] = {
>        [EM2884_BOARD_CINERGY_HTC_STICK] = {
>                .name         = "Terratec Cinergy HTC Stick",
>                .has_dvb      = 1,
> +               .ir_codes     = RC_MAP_NEC_TERRATEC_CINERGY_XS,
>  #if 0
>                .tuner_type   = TUNER_PHILIPS_TDA8290,
>                .tuner_addr   = 0x41,
> --
> 1.7.10.2
>
