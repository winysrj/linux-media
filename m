Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:35753 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751368Ab2LQBTT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 16 Dec 2012 20:19:19 -0500
Received: by mail-lb0-f174.google.com with SMTP id gi11so4255840lbb.19
        for <linux-media@vger.kernel.org>; Sun, 16 Dec 2012 17:19:18 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1355707068-25751-1-git-send-email-mkrufky@linuxtv.org>
References: <1355707068-25751-1-git-send-email-mkrufky@linuxtv.org>
Date: Sun, 16 Dec 2012 20:19:17 -0500
Message-ID: <CAOcJUby1M8u1KfE9Mp=cC0SLBnbhXTyAEwoe8hfyKL9f0jMGkg@mail.gmail.com>
Subject: Re: [PATCH] tda18271: add missing entries for qam_7 to
 tda18271_update_std_map() and tda18271_dump_std_map()
From: Michael Krufky <mkrufky@linuxtv.org>
To: linux-media@vger.kernel.org
Cc: mchehab@redhat.com,
	=?ISO-8859-1?Q?Frank_Sch=E4fer?= <fschaefer.oss@googlemail.com>,
	Michael Krufky <mkrufky@linuxtv.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro,

Please merge:

git request-pull c6c22955f80f2db9614b01fe5a3d1cfcd8b3d848
git://linuxtv.org/mkrufky/tuners tda18271-qam7
The following changes since commit c6c22955f80f2db9614b01fe5a3d1cfcd8b3d848:

  [media] dma-mapping: fix dma_common_get_sgtable() conditional
compilation (2012-11-27 09:42:31 -0200)

are available in the git repository at:

  git://linuxtv.org/mkrufky/tuners tda18271-qam7

for you to fetch changes up to 6554906af8c145b4fa8d4ea1b9c98c20322dd132:

  tda18271: add missing entries for qam_7 to tda18271_update_std_map()
and tda18271_dump_std_map() (2012-12-04 14:14:26 -0500)

----------------------------------------------------------------
Frank Sch�fer (1):
      tda18271: add missing entries for qam_7 to
tda18271_update_std_map() and tda18271_dump_std_map()

 drivers/media/tuners/tda18271-fe.c |    2 ++
 1 file changed, 2 insertions(+)

Regards,

Mike

On Sun, Dec 16, 2012 at 8:17 PM, Michael Krufky <mkrufky@linuxtv.org> wrote:
> From: Frank Schäfer <fschaefer.oss@googlemail.com>
>
> Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
> Signed-off-by: Michael Krufky <mkrufky@linuxtv.org>
> ---
>  drivers/media/tuners/tda18271-fe.c |    2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/drivers/media/tuners/tda18271-fe.c b/drivers/media/tuners/tda18271-fe.c
> index 72c26fd..e778686 100644
> --- a/drivers/media/tuners/tda18271-fe.c
> +++ b/drivers/media/tuners/tda18271-fe.c
> @@ -1122,6 +1122,7 @@ static int tda18271_dump_std_map(struct dvb_frontend *fe)
>         tda18271_dump_std_item(dvbt_7, "dvbt 7");
>         tda18271_dump_std_item(dvbt_8, "dvbt 8");
>         tda18271_dump_std_item(qam_6,  "qam 6 ");
> +       tda18271_dump_std_item(qam_7,  "qam 7 ");
>         tda18271_dump_std_item(qam_8,  "qam 8 ");
>
>         return 0;
> @@ -1149,6 +1150,7 @@ static int tda18271_update_std_map(struct dvb_frontend *fe,
>         tda18271_update_std(dvbt_7, "dvbt 7");
>         tda18271_update_std(dvbt_8, "dvbt 8");
>         tda18271_update_std(qam_6,  "qam 6");
> +       tda18271_update_std(qam_7,  "qam 7");
>         tda18271_update_std(qam_8,  "qam 8");
>
>         return 0;
> --
> 1.7.10.4
>
