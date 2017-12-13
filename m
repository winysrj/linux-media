Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f169.google.com ([209.85.128.169]:43438 "EHLO
        mail-wr0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752908AbdLMU0l (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 13 Dec 2017 15:26:41 -0500
Received: by mail-wr0-f169.google.com with SMTP id z34so3239720wrz.10
        for <linux-media@vger.kernel.org>; Wed, 13 Dec 2017 12:26:40 -0800 (PST)
Date: Wed, 13 Dec 2017 21:26:37 +0100
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: linux-media@vger.kernel.org, mchehab@s-opensource.com
Subject: Re: [PATCH 2/2] [media] ddbridge: don't break on single/last port
 attach failure
Message-ID: <20171213212637.14eb84a6@macbox>
In-Reply-To: <20171213174437.6eab2491@vento.lan>
References: <20171206175915.20669-1-d.scheller.oss@gmail.com>
        <20171206175915.20669-3-d.scheller.oss@gmail.com>
        <20171213132602.79a35512@vento.lan>
        <20171213184052.29866eb2@macbox>
        <20171213174437.6eab2491@vento.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 13 Dec 2017 17:44:37 -0200
Mauro Carvalho Chehab <mchehab@kernel.org> wrote:

> Em Wed, 13 Dec 2017 18:40:52 +0100
> Daniel Scheller <d.scheller.oss@gmail.com> escreveu:
> 
> > On Wed, 13 Dec 2017 13:26:02 -0200
> > Mauro Carvalho Chehab <mchehab@kernel.org> wrote:
> >   
> > > Em Wed,  6 Dec 2017 18:59:15 +0100
> > > Daniel Scheller <d.scheller.oss@gmail.com> escreveu:
> > >     
> > > > From: Daniel Scheller <d.scheller@gmx.net>
> > > > 
> > > > As all error handling improved quite a bit, don't stop attaching
> > > > frontends if one of them failed, since - if other tuner modules
> > > > are connected to the PCIe bridge - other hardware may just
> > > > work, so lets not break on a single port failure, but rather
> > > > initialise as much as possible. Ie. if there are issues with a
> > > > C2T2-equipped PCIe bridge card which has additional DuoFlex
> > > > modules connected and the bridge generally works, the DuoFlex
> > > > tuners can still work fine. Also, this only had an effect
> > > > anyway if the failed device/port was the last one being
> > > > enumerated.
> > > > 
> > > > Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
> > > > ---
> > > >  drivers/media/pci/ddbridge/ddbridge-core.c | 2 +-
> > > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > > 
> > > > diff --git a/drivers/media/pci/ddbridge/ddbridge-core.c
> > > > b/drivers/media/pci/ddbridge/ddbridge-core.c index
> > > > 11c5cae92408..b43c40e0bf73 100644 ---
> > > > a/drivers/media/pci/ddbridge/ddbridge-core.c +++
> > > > b/drivers/media/pci/ddbridge/ddbridge-core.c @@ -1962,7 +1962,7
> > > > @@ int ddb_ports_attach(struct ddb *dev) }
> > > >  	for (i = 0; i < dev->port_num; i++) {
> > > >  		port = &dev->port[i];
> > > > -		ret = ddb_port_attach(port);
> > > > +		ddb_port_attach(port);      
> > > 
> > > Nah, ignoring an error doesn't seem right. It should at least
> > > print that attach failed.    
> > 
> > This is already the case in ddb_port_attach() (if (ret < 0)
> > dev_err(...)).
> >   
> > > Also, if all attaches fail, probably the best
> > > would be to just detach everything and go to the error handling
> > > code, as there's something serious happening.    
> > 
> > Well, will recheck the whole error handling there then when already
> > at it, as single port failures can still leave some
> > half-initialised stuff behind until ddbridge gets unloaded.  
> 
> If this is the case, then you need to fix also the unbind logic,
> to be sure that nothing gets left. The best is to compile your test
> Kernel with KASAN enabled, in order to see if the remove logic is
> OK.

There's nothing wrong regarding memory corruption when this happens,
the state machine in the driver keeps track of this, knows how far a
port got, tears down exactly these resources, and doesn't blindly free
things (use-after-free etc). On unload, everything is correctly removed
from memory, the unbind/teardown logic works fine regarding this. The
only real issue which also other drivers suffered from was improper
un-refcounting but all this was completely fixed with the latest
changes in core:dvb_frontend.c (frontend_free and related friends).

But that KASAN thing is a good hint for some other issue I'm having
with another driver for which I've no idea yet how to track that down,
thanks for that (yet some things to learn and discover).

Best regards,
Daniel Scheller
-- 
https://github.com/herrnst
