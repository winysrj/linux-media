Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:58299 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755433AbdKAVHe (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 1 Nov 2017 17:07:34 -0400
Received: from [179.95.4.10] (helo=vento.lan)
        by bombadil.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1eA0EX-0007lJ-BQ
        for linux-media@vger.kernel.org; Wed, 01 Nov 2017 21:07:33 +0000
Date: Wed, 1 Nov 2017 19:07:30 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH v2 01/26] media: atmel-isc: avoid returning a random
 value at isc_parse_dt()
Message-ID: <20171101190730.55308c48@vento.lan>
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
> 
> I'll try to fix and re-send it.

Found the issue... on patch 2 of this series, it was marked with:

Cc: stable@vger.kernel.org # for 4.14

It seems that my environment didn't like this...

Just resent the hole stuff


Thanks,
Mauro
