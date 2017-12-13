Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f175.google.com ([209.85.128.175]:45391 "EHLO
        mail-wr0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753209AbdLMRlC (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 13 Dec 2017 12:41:02 -0500
Received: by mail-wr0-f175.google.com with SMTP id h1so2791412wre.12
        for <linux-media@vger.kernel.org>; Wed, 13 Dec 2017 09:41:01 -0800 (PST)
Date: Wed, 13 Dec 2017 18:40:52 +0100
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: linux-media@vger.kernel.org, mchehab@s-opensource.com
Subject: Re: [PATCH 2/2] [media] ddbridge: don't break on single/last port
 attach failure
Message-ID: <20171213184052.29866eb2@macbox>
In-Reply-To: <20171213132602.79a35512@vento.lan>
References: <20171206175915.20669-1-d.scheller.oss@gmail.com>
        <20171206175915.20669-3-d.scheller.oss@gmail.com>
        <20171213132602.79a35512@vento.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 13 Dec 2017 13:26:02 -0200
Mauro Carvalho Chehab <mchehab@kernel.org> wrote:

> Em Wed,  6 Dec 2017 18:59:15 +0100
> Daniel Scheller <d.scheller.oss@gmail.com> escreveu:
> 
> > From: Daniel Scheller <d.scheller@gmx.net>
> > 
> > As all error handling improved quite a bit, don't stop attaching
> > frontends if one of them failed, since - if other tuner modules are
> > connected to the PCIe bridge - other hardware may just work, so
> > lets not break on a single port failure, but rather initialise as
> > much as possible. Ie. if there are issues with a C2T2-equipped PCIe
> > bridge card which has additional DuoFlex modules connected and the
> > bridge generally works, the DuoFlex tuners can still work fine.
> > Also, this only had an effect anyway if the failed device/port was
> > the last one being enumerated.
> > 
> > Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
> > ---
> >  drivers/media/pci/ddbridge/ddbridge-core.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/media/pci/ddbridge/ddbridge-core.c
> > b/drivers/media/pci/ddbridge/ddbridge-core.c index
> > 11c5cae92408..b43c40e0bf73 100644 ---
> > a/drivers/media/pci/ddbridge/ddbridge-core.c +++
> > b/drivers/media/pci/ddbridge/ddbridge-core.c @@ -1962,7 +1962,7 @@
> > int ddb_ports_attach(struct ddb *dev) }
> >  	for (i = 0; i < dev->port_num; i++) {
> >  		port = &dev->port[i];
> > -		ret = ddb_port_attach(port);
> > +		ddb_port_attach(port);  
> 
> Nah, ignoring an error doesn't seem right. It should at least print
> that attach failed.

This is already the case in ddb_port_attach() (if (ret < 0)
dev_err(...)).

> Also, if all attaches fail, probably the best
> would be to just detach everything and go to the error handling code,
> as there's something serious happening.

Well, will recheck the whole error handling there then when already at
it, as single port failures can still leave some half-initialised stuff
behind until ddbridge gets unloaded.

Thanks for your review, comments and your proposal!

Best regards,
Daniel Scheller
-- 
https://github.com/herrnst
