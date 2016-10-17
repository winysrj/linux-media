Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:36675
        "EHLO s-opensource.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932489AbcJQRMp (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 17 Oct 2016 13:12:45 -0400
Date: Mon, 17 Oct 2016 15:12:37 -0200
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Johannes Stezenbach <js@linuxtv.org>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Jiri Kosina <jikos@kernel.org>,
        Patrick Boettcher <patrick.boettcher@posteo.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andy Lutomirski <luto@kernel.org>,
        Michael Krufky <mkrufky@linuxtv.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        =?UTF-8?B?SsO2cmc=?= Otte <jrg.otte@gmail.com>
Subject: Re: [PATCH v2 02/31] cinergyT2-core: don't do DMA on stack
Message-ID: <20161017151237.36baa8a1@vento.lan>
In-Reply-To: <20161015205449.pagb3a7nld7q6al4@linuxtv.org>
References: <cover.1476179975.git.mchehab@s-opensource.com>
        <1220fd764d747f153c240e14812e1d2045e59b4e.1476179975.git.mchehab@s-opensource.com>
        <20161015205449.pagb3a7nld7q6al4@linuxtv.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sat, 15 Oct 2016 22:54:49 +0200
Johannes Stezenbach <js@linuxtv.org> escreveu:

> On Tue, Oct 11, 2016 at 07:09:17AM -0300, Mauro Carvalho Chehab wrote:
> > --- a/drivers/media/usb/dvb-usb/cinergyT2-core.c
> > +++ b/drivers/media/usb/dvb-usb/cinergyT2-core.c
> > @@ -41,6 +41,8 @@ DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);
> >  
> >  struct cinergyt2_state {
> >  	u8 rc_counter;
> > +	unsigned char data[64];
> > +	struct mutex data_mutex;
> >  };  
> 
> Sometimes my thinking is slow but it just occured to me
> that this creates a potential issue with cache line sharing.
> On an architecture which manages cache coherence in software
> (ARM, MIPS etc.) a write to e.g. rc_counter in this example
> would dirty the cache line, and a later writeback from the
> cache could overwrite parts of data[] which was received via DMA.
> In contrast, if the DMA buffer is allocated seperately via
> kmalloc it is guaranteed to be safe wrt cache line sharing.
> (see bottom of Documentation/DMA-API-HOWTO.txt).
> 

Interesting point. I'm not sure well this would work with non-fully
coherent cache lines. I guess that will depend on how the USB
driver will be handling it.

> But of course DMA on stack also had the same issue
> and no one ever noticed so it's apparently not critical...

Yes, this shouldn't do it any worse than what we currently have.
In the past, I tested some drivers that uses a shared buffed for control
URB transfers in the past, on arm32 and arm64. I don't remember seeing
anything weird there that could be related to cache coherency, although
I remember several problems with USB on OMAP and RPi version 1, leading
troubles after several minutes of ISOC transfers on analog TV,
but they seemed to be unrelated to URB control traffic.

I'd say that we should keep our eyes on those drivers, after applying
this patch series and see if people will notice bad behavior on non-x86
archs.

Thanks,
Mauro
