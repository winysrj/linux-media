Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:47468 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751687AbeEDS6f (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 4 May 2018 14:58:35 -0400
Date: Fri, 4 May 2018 15:58:27 -0300
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: Tim Harvey <tharvey@gateworks.com>, Takashi Iwai <tiwai@suse.de>
Cc: Mark Brown <broonie@kernel.org>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Linux-ALSA <alsa-devel@alsa-project.org>,
        linux-kernel@vger.kernel.org,
        linux-media <linux-media@vger.kernel.org>
Subject: Re: [PATCH v3][RESEND] media: i2c: tda1997: replace codec to
 component
Message-ID: <20180504155827.3a192297@vento.lan>
In-Reply-To: <CAJ+vNU35TfSLRYnkEYMkMQVC9r+XHt_pa-=+s4Dro3b-VNGULA@mail.gmail.com>
References: <87in8ibrql.wl%kuninori.morimoto.gx@renesas.com>
        <CAJ+vNU0mykhkMNNrN=Zsrj0_pv=XAkGiiQkXehQ4EWBkMDAv7w@mail.gmail.com>
        <20180423165213.GL19834@sirena.org.uk>
        <CAJ+vNU35TfSLRYnkEYMkMQVC9r+XHt_pa-=+s4Dro3b-VNGULA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 23 Apr 2018 13:59:32 -0700
Tim Harvey <tharvey@gateworks.com> escreveu:

> On Mon, Apr 23, 2018 at 9:52 AM, Mark Brown <broonie@kernel.org> wrote:
> > On Mon, Apr 23, 2018 at 09:44:17AM -0700, Tim Harvey wrote:
> >  
> >> Could you add some detail to the commit explaining why we need to
> >> replace codec to component? I don't really know what that means.
> >> Please refer to a commit if the ASoC API is changing in some way we
> >> need to catch up with.  
> >
> > This is a big transition in the ASoC API which is nearing completion -
> > this driver is one of the last users of the CODEC struct, we've (well,
> > mainly Morimoto-san) been migrating things away from it to the more
> > general purpose component.  There's no one commit to point at really as
> > the two have coexisted for a while and we won't be able to finally
> > remove the CODEC struct until all the drivers have transitioned away.  
> 
> Mark,
> 
> Ok - thanks for the explanation!
> 
> Kuninori,
> 
> Sorry this took so long to get to. Tested on a GW5404
> 
> Tested-by: Tim Harvey <tharvey@gateworks.com>
> Acked-by: Tim Harvey <tharvey@gateworks.com>

In order to keep it together with the patches doing the removal of
the old API, it is probably better to apply this via ALSA tree:

Acked-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>

> 
> Regards,
> 
> Tim



Thanks,
Mauro
