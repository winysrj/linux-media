Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-it0-f65.google.com ([209.85.214.65]:35363 "EHLO
        mail-it0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751732AbeETXBO (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 20 May 2018 19:01:14 -0400
Received: by mail-it0-f65.google.com with SMTP id q72-v6so19185793itc.0
        for <linux-media@vger.kernel.org>; Sun, 20 May 2018 16:01:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180520072437.9686-1-laurent.pinchart+renesas@ideasonboard.com>
References: <20180520072437.9686-1-laurent.pinchart+renesas@ideasonboard.com>
From: Nobuhiro Iwamatsu <iwamatsu@nigauri.org>
Date: Mon, 21 May 2018 08:00:43 +0900
Message-ID: <CABMQnVLYUkCwgAi__vaou3EfwRsed5EWgT0BdcWBMWCESenogQ@mail.gmail.com>
Subject: Re: [PATCH v2] v4l: vsp1: Fix vsp1_regs.h license header
To: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Cc: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

2018-05-20 16:24 GMT+09:00 Laurent Pinchart
<laurent.pinchart+renesas@ideasonboard.com>:
> All source files of the vsp1 driver are licensed under the GPLv2+ except
> for vsp1_regs.h which is licensed under GPLv2. This is caused by a bad
> copy&paste that dates back from the initial version of the driver. Fix
> it.
>
> Cc: Nobuhiro Iwamatsu <nobuhiro.iwamatsu.yj@renesas.com>
> Acked-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
> Acked-by: Sergei Shtylyov<sergei.shtylyov@cogentembedded.com>
> Acked-by: Niklas S=C3=B6derlund <niklas.soderlund+renesas@ragnatech.se>
> Acked-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
> Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.co=
m>
> ---
> Iwamatsu-san,
>
> While working on the VSP1 driver I noticed that all source files are
> licensed under the GPLv2+ except for vsp1_regs.h which is licensed under
> GPLv2. I'd like to fix this inconsistency. As you have contributed to
> that file, could you please provide your explicit ack if you agree to
> this change ?

Yes,  I agree with this change.

Acked-by: Nobuhiro Iwamatsu <iwamatsu@nigauri.org>

> ---
>  drivers/media/platform/vsp1/vsp1_regs.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/media/platform/vsp1/vsp1_regs.h b/drivers/media/plat=
form/vsp1/vsp1_regs.h
> index 0d249ff9f564..e82661216c1d 100644
> --- a/drivers/media/platform/vsp1/vsp1_regs.h
> +++ b/drivers/media/platform/vsp1/vsp1_regs.h
> @@ -1,4 +1,4 @@
> -/* SPDX-License-Identifier: GPL-2.0 */
> +/* SPDX-License-Identifier: GPL-2.0+ */
>  /*
>   * vsp1_regs.h  --  R-Car VSP1 Registers Definitions
>   *
> --
> Regards,
>
> Laurent Pinchart
>

Best regards,
  Nobuhiro

--=20
Nobuhiro Iwamatsu
   iwamatsu at {nigauri.org / debian.org}
   GPG ID: 40AD1FA6
