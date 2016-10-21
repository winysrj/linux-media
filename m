Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:33823 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754802AbcJUKeS (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 21 Oct 2016 06:34:18 -0400
Date: Fri, 21 Oct 2016 08:34:03 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: SF Markus Elfring <elfring@users.sourceforge.net>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Max Kellermann <max@duempel.org>,
        Shuah Khan <shuah@kernel.org>,
        Malcolm Priestley <tvboxspy@gmail.com>,
        Michael Ira Krufky <mkrufky@linuxtv.org>,
        Abhilash Jindal <klock.android@gmail.com>,
        Xiubo Li <lixiubo@cmss.chinamobile.com>
Subject: Re: [PATCH 11/25] [media] dvb-core: use pr_foo() instead of
 printk()
Message-ID: <20161021083403.3fd0e83f@vento.lan>
In-Reply-To: <ad6e8052-d9e2-e5bd-1c19-f402c04007ea@users.sourceforge.net>
References: <cover.1476466574.git.mchehab@s-opensource.com>
        <1d5040384c93e1cb37dd41e780e44a88b1e63ce4.1476466574.git.mchehab@s-opensource.com>
        <ad6e8052-d9e2-e5bd-1c19-f402c04007ea@users.sourceforge.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 14 Oct 2016 20:22:40 +0200
SF Markus Elfring <elfring@users.sourceforge.net> escreveu:

> > diff --git a/drivers/media/dvb-core/dmxdev.c b/drivers/media/dvb-core/dmxdev.c
> > index 7b67e1dd97fd..1e96a6f1b6f0 100644
> > --- a/drivers/media/dvb-core/dmxdev.c
> > +++ b/drivers/media/dvb-core/dmxdev.c
> > @@ -20,6 +20,8 @@
> >   *
> >   */
> >  
> > +#define pr_fmt(fmt) "dmxdev: " fmt
> > +
> >  #include <linux/sched.h>
> >  #include <linux/spinlock.h>
> >  #include <linux/slab.h>  
> 
> How do you think to use an approach like the following there?
> 
> 
> +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> 
> 
>    or eventually
> 
> 
> +#define MY_LOG_PREFIX KBUILD_MODNAME ": "
> +#define pr_fmt(fmt) MY_LOG_PREFIX fmt

we use a lot KBUILD_MODNAME on driver's pr_fmt() macros.

However, in this specific case, it is not a good idea, as this patch
is touching at the DVB core, with is composed by several different
and almost independent parts. So, we want to know what part
of the DVB core is producing such messages.

Regards,
Mauro
