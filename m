Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f195.google.com ([209.85.128.195]:35229 "EHLO
        mail-wr0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751106AbdFUROv (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 21 Jun 2017 13:14:51 -0400
Received: by mail-wr0-f195.google.com with SMTP id z45so28160430wrb.2
        for <linux-media@vger.kernel.org>; Wed, 21 Jun 2017 10:14:50 -0700 (PDT)
Date: Wed, 21 Jun 2017 19:14:40 +0200
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: linux-media@vger.kernel.org, mchehab@kernel.org,
        liplianin@netup.ru, rjkm@metzlerbros.de
Subject: Re: [PATCH] [media] ddbridge: use dev_* macros in favor of printk
Message-ID: <20170621191440.2f38616a@audiostation.wuest.de>
In-Reply-To: <20170621140808.7d5ad295@vento.lan>
References: <20170621165347.19409-1-d.scheller.oss@gmail.com>
        <20170621140808.7d5ad295@vento.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am Wed, 21 Jun 2017 14:08:08 -0300
schrieb Mauro Carvalho Chehab <mchehab@s-opensource.com>:

> Em Wed, 21 Jun 2017 18:53:47 +0200
> Daniel Scheller <d.scheller.oss@gmail.com> escreveu:
> 
> > From: Daniel Scheller <d.scheller@gmx.net>
> > 
> > Side effect: KERN_DEBUG messages aren't written to the kernel log anymore.
> > This also improves the tda18212_ping reporting a bit so users know that if
> > pinging wasn't successful, bad things will happen.
> > 
> > Since in module_init_ddbridge() there's no dev yet, pr_info is used
> > instead.
> > 
> > Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
> > ---
> >  drivers/media/pci/ddbridge/ddbridge-core.c | 78 ++++++++++++++++++------------
> >  1 file changed, 46 insertions(+), 32 deletions(-)
> > 
> > diff --git a/drivers/media/pci/ddbridge/ddbridge-core.c b/drivers/media/pci/ddbridge/ddbridge-core.c
> > index 9420479bee9a..540a121eadd6 100644
> > --- a/drivers/media/pci/ddbridge/ddbridge-core.c
> > +++ b/drivers/media/pci/ddbridge/ddbridge-core.c
> > @@ -17,6 +17,8 @@
> >   * http://www.gnu.org/copyleft/gpl.html
> >   */
> >  
> > +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> > +  
> 
> I guess this is a left over from the old patch. When you use dev_foo,
> it will get the driver's name from dev->name. So, no need to do the
> above.

I intentionally left this in for the pr_info used in module_init_ddbridge(). If you prefer, we can ofc probably also leave this as printk like

printk(KERN_INFO KBUILD_MODNAME ": Digital..."); 

IMHO, we should also have the modname info there aswell, especially when thinking of a possible ddbridge-legacy, so users see what's loaded.

Best regards,
Daniel Scheller
-- 
https://github.com/herrnst
