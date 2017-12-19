Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:48852 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751799AbdLSMKv (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Dec 2017 07:10:51 -0500
Date: Tue, 19 Dec 2017 10:10:46 -0200
From: Mauro Carvalho Chehab <mchehab@kernel.org>
To: Ralph Metzler <rjkm@metzlerbros.de>
Cc: linux-media@vger.kernel.org,
        Athanasios Oikonomou <athoik@gmail.com>,
        Manu Abraham <abraham.manu@gmail.com>
Subject: Re: [PATCH 0/2] Support Physical Layer Scrambling
Message-ID: <20171219101046.243ce297@vento.lan>
In-Reply-To: <23094.30253.636599.33684@morden.metzler>
References: <cover.1513426880.git.athoik@gmail.com>
        <23094.30253.636599.33684@morden.metzler>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sun, 17 Dec 2017 14:50:37 +0100
Ralph Metzler <rjkm@metzlerbros.de> escreveu:

> Athanasios Oikonomou writes:
>  > A new property DTV_SCRAMBLING_SEQUENCE_INDEX introduced to control
>  > the gold sequence that several demods support.
>  > 
>  > Also the DVB API was increased in order userspace to be aware of the
>  > changes.
>  > 
>  > The stv090x driver was changed to make use of the new property.
>  > 
>  > Those commits based on discussion previously made on the mailling list.
>  > https://www.mail-archive.com/linux-media@vger.kernel.org/msg122600.html
>  > 
>  > I would like to thanks Ralph Metzler (rjkm@metzlerbros.de) for the
>  > great help and ideas he provide me in order create those patches.
>  > 
>  > Athanasios Oikonomou (2):
>  >   media: dvb_frontend: add physical layer scrambling support
>  >   media: stv090x: add physical layer scrambling support
>  > 
>  >  .../media/uapi/dvb/fe_property_parameters.rst          | 18 ++++++++++++++++++
>  >  .../uapi/dvb/frontend-property-satellite-systems.rst   |  2 ++
>  >  drivers/media/dvb-core/dvb_frontend.c                  | 12 ++++++++++++
>  >  drivers/media/dvb-core/dvb_frontend.h                  |  5 +++++
>  >  drivers/media/dvb-frontends/stv090x.c                  | 16 ++++++++++++++++
>  >  include/uapi/linux/dvb/frontend.h                      |  5 ++++-
>  >  include/uapi/linux/dvb/version.h                       |  2 +-
>  >  7 files changed, 58 insertions(+), 2 deletions(-)
>  > 
>  > -- 
>  > 2.1.4  
> 
> Acked-by: Ralph Metzler <rjkm@metzlerbros.de>

I'm applying both patches.

> We had some thoughts about having a:
> 
> #define NO_SCRAMBLING_CODE     (~0U)
> 
> But DVB-S2 is always scrambling (with default index 0) and other delivery systems can ignore this
> property. Or do you think it is needed?
> 
> 
> One could add a define for AUTO or AUTO_S2X for the standard 7 indices to be tested
> in DVB-S2X. But either dvb_frontend.c or the demod driver would have to support this in software.
> I don't think there is a demod which supports this in hardware yet?

I think that, once we have a hardware capable of auto-detecting the gold
sequence, then a NO_SCRAMBLING_CODE (or AUTO_GOLD_SEQUENCE) could make
sense.

For now, I don't think any demod currently supports it.

Thanks,
Mauro
