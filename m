Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.sig21.net ([80.244.240.74]:53386 "EHLO mail.sig21.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755768AbcJOUzQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 15 Oct 2016 16:55:16 -0400
Date: Sat, 15 Oct 2016 22:54:49 +0200
From: Johannes Stezenbach <js@linuxtv.org>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Jiri Kosina <jikos@kernel.org>,
        Patrick Boettcher <patrick.boettcher@posteo.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andy Lutomirski <luto@kernel.org>,
        Michael Krufky <mkrufky@linuxtv.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        =?iso-8859-1?Q?J=F6rg?= Otte <jrg.otte@gmail.com>
Subject: Re: [PATCH v2 02/31] cinergyT2-core: don't do DMA on stack
Message-ID: <20161015205449.pagb3a7nld7q6al4@linuxtv.org>
References: <cover.1476179975.git.mchehab@s-opensource.com>
 <1220fd764d747f153c240e14812e1d2045e59b4e.1476179975.git.mchehab@s-opensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1220fd764d747f153c240e14812e1d2045e59b4e.1476179975.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Oct 11, 2016 at 07:09:17AM -0300, Mauro Carvalho Chehab wrote:
> --- a/drivers/media/usb/dvb-usb/cinergyT2-core.c
> +++ b/drivers/media/usb/dvb-usb/cinergyT2-core.c
> @@ -41,6 +41,8 @@ DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);
>  
>  struct cinergyt2_state {
>  	u8 rc_counter;
> +	unsigned char data[64];
> +	struct mutex data_mutex;
>  };

Sometimes my thinking is slow but it just occured to me
that this creates a potential issue with cache line sharing.
On an architecture which manages cache coherence in software
(ARM, MIPS etc.) a write to e.g. rc_counter in this example
would dirty the cache line, and a later writeback from the
cache could overwrite parts of data[] which was received via DMA.
In contrast, if the DMA buffer is allocated seperately via
kmalloc it is guaranteed to be safe wrt cache line sharing.
(see bottom of Documentation/DMA-API-HOWTO.txt).

But of course DMA on stack also had the same issue
and no one ever noticed so it's apparently not critical...


Johannes
