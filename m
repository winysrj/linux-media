Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f194.google.com ([209.85.128.194]:47078 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932156AbeDWQoT (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 23 Apr 2018 12:44:19 -0400
Received: by mail-wr0-f194.google.com with SMTP id d1-v6so43084132wrj.13
        for <linux-media@vger.kernel.org>; Mon, 23 Apr 2018 09:44:19 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <87in8ibrql.wl%kuninori.morimoto.gx@renesas.com>
References: <87in8ibrql.wl%kuninori.morimoto.gx@renesas.com>
From: Tim Harvey <tharvey@gateworks.com>
Date: Mon, 23 Apr 2018 09:44:17 -0700
Message-ID: <CAJ+vNU0mykhkMNNrN=Zsrj0_pv=XAkGiiQkXehQ4EWBkMDAv7w@mail.gmail.com>
Subject: Re: [PATCH v3][RESEND] media: i2c: tda1997: replace codec to component
To: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Cc: Mark Brown <broonie@kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Linux-ALSA <alsa-devel@alsa-project.org>,
        linux-kernel@vger.kernel.org,
        linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Apr 22, 2018 at 7:10 PM, Kuninori Morimoto
<kuninori.morimoto.gx@renesas.com> wrote:
>
> From: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
>
> Now we can replace Codec to Component. Let's do it.
>
> Note:
>         xxx_codec_xxx()         ->      xxx_component_xxx()
>         .idle_bias_off = 0      ->      .idle_bias_on = 1
>         .ignore_pmdown_time = 0 ->      .use_pmdown_time = 1
>         -                       ->      .endianness = 1
>         -                       ->      .non_legacy_dai_naming = 1
>
> Signed-off-by: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
> ---
> Tim, Mauro
>
> 2 weeks passed. I re-send.
> This replace patch is needed for ALSA SoC, otherwise it can't probe anymore.
>
> v2 -> v3
>
>  - fixup driver name (= tda1997)
>

Kuninori,

Could you add some detail to the commit explaining why we need to
replace codec to component? I don't really know what that means.
Please refer to a commit if the ASoC API is changing in some way we
need to catch up with.

Regards,

Tim
