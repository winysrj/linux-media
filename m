Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f194.google.com ([209.85.128.194]:46414 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932163AbeDWU7e (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 23 Apr 2018 16:59:34 -0400
Received: by mail-wr0-f194.google.com with SMTP id d1-v6so44895572wrj.13
        for <linux-media@vger.kernel.org>; Mon, 23 Apr 2018 13:59:33 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180423165213.GL19834@sirena.org.uk>
References: <87in8ibrql.wl%kuninori.morimoto.gx@renesas.com>
 <CAJ+vNU0mykhkMNNrN=Zsrj0_pv=XAkGiiQkXehQ4EWBkMDAv7w@mail.gmail.com> <20180423165213.GL19834@sirena.org.uk>
From: Tim Harvey <tharvey@gateworks.com>
Date: Mon, 23 Apr 2018 13:59:32 -0700
Message-ID: <CAJ+vNU35TfSLRYnkEYMkMQVC9r+XHt_pa-=+s4Dro3b-VNGULA@mail.gmail.com>
Subject: Re: [PATCH v3][RESEND] media: i2c: tda1997: replace codec to component
To: Mark Brown <broonie@kernel.org>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Linux-ALSA <alsa-devel@alsa-project.org>,
        linux-kernel@vger.kernel.org,
        linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Apr 23, 2018 at 9:52 AM, Mark Brown <broonie@kernel.org> wrote:
> On Mon, Apr 23, 2018 at 09:44:17AM -0700, Tim Harvey wrote:
>
>> Could you add some detail to the commit explaining why we need to
>> replace codec to component? I don't really know what that means.
>> Please refer to a commit if the ASoC API is changing in some way we
>> need to catch up with.
>
> This is a big transition in the ASoC API which is nearing completion -
> this driver is one of the last users of the CODEC struct, we've (well,
> mainly Morimoto-san) been migrating things away from it to the more
> general purpose component.  There's no one commit to point at really as
> the two have coexisted for a while and we won't be able to finally
> remove the CODEC struct until all the drivers have transitioned away.

Mark,

Ok - thanks for the explanation!

Kuninori,

Sorry this took so long to get to. Tested on a GW5404

Tested-by: Tim Harvey <tharvey@gateworks.com>
Acked-by: Tim Harvey <tharvey@gateworks.com>

Regards,

Tim
