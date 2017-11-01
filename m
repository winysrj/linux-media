Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:40446 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933267AbdKAVDy (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 1 Nov 2017 17:03:54 -0400
Date: Wed, 1 Nov 2017 19:03:49 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Songjun Wu <songjun.wu@microchip.com>
Subject: Re: [PATCH v2 01/26] media: atmel-isc: avoid returning a random
 value at isc_parse_dt()
Message-ID: <20171101190349.30c173e6@vento.lan>
In-Reply-To: <20171101185948.4a5d91c6@vento.lan>
References: <c4389ab1c02bb08c1a55012fdb859c8b10bdc47e.1509569763.git.mchehab@s-opensource.com>
        <20171101185948.4a5d91c6@vento.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 1 Nov 2017 18:59:48 -0200
Mauro Carvalho Chehab <mchehab@s-opensource.com> escreveu:

> Em Wed,  1 Nov 2017 16:56:33 -0400
> Mauro Carvalho Chehab <mchehab@s-opensource.com> escreveu:
> 
> > As warned by smatch:
> > drivers/media/platform/atmel/atmel-isc.c:2097 isc_parse_dt() error: uninitialized symbol 'ret'.
> > 
> > The problem here is that of_graph_get_next_endpoint() can
> > potentially return NULL on its first pass, with would make
> > it return a random value, as ret is not initialized.
> > 
> > While here, use while(1) instead of for(; ;), as while is
> > the preferred syntax for such kind of loops.
> 
> Sorry, please discard this e-mail... there's something wrong on my
> environment.
> 
> git send-email is dying after the first e-mail:
> 
> 	Died at /usr/libexec/git-core/git-send-email line 1350.

Btw, this never happened before today... probably it is because I'm trying
to send a pull request between Halloween and the Day of the Dead :-p

Thanks,
Mauro
