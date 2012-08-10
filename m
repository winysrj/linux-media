Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:63001 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760066Ab2HJXzj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Aug 2012 19:55:39 -0400
Received: by weyx8 with SMTP id x8so1323910wey.19
        for <linux-media@vger.kernel.org>; Fri, 10 Aug 2012 16:55:38 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <E1SzvhW-0005hd-1S@www.linuxtv.org>
References: <E1SzvhW-0005hd-1S@www.linuxtv.org>
Date: Sat, 11 Aug 2012 05:25:37 +0530
Message-ID: <CAHFNz9Ju7dB-iz0mcGuNMLDwibFXZqGe73jpBk7RPqG_w+MmXg@mail.gmail.com>
Subject: Re: [git:v4l-dvb/for_v3.7] [media] mantis: Terratec Cinergy C PCI HD (CI)
From: Manu Abraham <abraham.manu@gmail.com>
To: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linuxtv-commits@linuxtv.org, "Igor M. Liplianin" <liplianin@me.by>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro,

Please revert this patch. Patch is incorrect. There is the VP-20300,
VP-20330, VP-2040, with differences in tuner types TDA10021, TDA10023,
MK-I, MK-II and MK-III. I have detailed this issue in an earlier mail.
Terratec Cinregy C is VP-2033 and not VP-2040.

Thanks!


On Sat, Aug 11, 2012 at 1:34 AM, Mauro Carvalho Chehab
<mchehab@redhat.com> wrote:
> This is an automatic generated email to let you know that the following patch were queued at the
> http://git.linuxtv.org/media_tree.git tree:
>
> Subject: [media] mantis: Terratec Cinergy C PCI HD (CI)
> Author:  Igor M. Liplianin <liplianin@me.by>
> Date:    Wed May 9 07:23:14 2012 -0300
>
> This patch seems for rectifying a typo. But actually the difference between
> mantis_vp2040.c and mantis_vp2033.c code is a card name only.
>
> Signed-off-by: Igor M. Liplianin <liplianin@me.by>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
>
>  drivers/media/dvb/mantis/mantis_cards.c |    2 +-
>  drivers/media/dvb/mantis/mantis_core.c  |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
>
> ---
>
> http://git.linuxtv.org/media_tree.git?a=commitdiff;h=9fa4d6a102ebb06663a03554b57fb93ad618b72e
>
> diff --git a/drivers/media/dvb/mantis/mantis_cards.c b/drivers/media/dvb/mantis/mantis_cards.c
> index 095cf3a..0207d1f 100644
> --- a/drivers/media/dvb/mantis/mantis_cards.c
> +++ b/drivers/media/dvb/mantis/mantis_cards.c
> @@ -275,7 +275,7 @@ static struct pci_device_id mantis_pci_table[] = {
>         MAKE_ENTRY(TWINHAN_TECHNOLOGIES, MANTIS_VP_2033_DVB_C, &vp2033_config),
>         MAKE_ENTRY(TWINHAN_TECHNOLOGIES, MANTIS_VP_2040_DVB_C, &vp2040_config),
>         MAKE_ENTRY(TECHNISAT, CABLESTAR_HD2, &vp2040_config),
> -       MAKE_ENTRY(TERRATEC, CINERGY_C, &vp2033_config),
> +       MAKE_ENTRY(TERRATEC, CINERGY_C, &vp2040_config),
>         MAKE_ENTRY(TWINHAN_TECHNOLOGIES, MANTIS_VP_3030_DVB_T, &vp3030_config),
>         { }
>  };
> diff --git a/drivers/media/dvb/mantis/mantis_core.c b/drivers/media/dvb/mantis/mantis_core.c
> index 22524a8..684d906 100644
> --- a/drivers/media/dvb/mantis/mantis_core.c
> +++ b/drivers/media/dvb/mantis/mantis_core.c
> @@ -121,7 +121,7 @@ static void mantis_load_config(struct mantis_pci *mantis)
>                 mantis->hwconfig = &vp2033_mantis_config;
>                 break;
>         case MANTIS_VP_2040_DVB_C:      /* VP-2040 */
> -       case TERRATEC_CINERGY_C_PCI:    /* VP-2040 clone */
> +       case CINERGY_C: /* VP-2040 clone */
>         case TECHNISAT_CABLESTAR_HD2:
>                 mantis->hwconfig = &vp2040_mantis_config;
>                 break;
>
> _______________________________________________
> linuxtv-commits mailing list
> linuxtv-commits@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linuxtv-commits
