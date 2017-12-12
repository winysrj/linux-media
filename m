Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:35519 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751729AbdLLMpk (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 12 Dec 2017 07:45:40 -0500
Date: Tue, 12 Dec 2017 10:45:30 -0200
From: Mauro Carvalho Chehab <mchehab@kernel.org>
To: Joe Perches <joe@perches.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Michael Ira Krufky <mkrufky@linuxtv.org>,
        linux-media <linux-media@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tuners: tda8290: reduce stack usage with kasan
Message-ID: <20171212104530.46ac4ffe@vento.lan>
In-Reply-To: <1513078952.3036.36.camel@perches.com>
References: <20171211120612.3775893-1-arnd@arndb.de>
        <1513020868.3036.0.camel@perches.com>
        <CAOcJUbyARps1CeRFvLau3w-rBvn2QLbsY2PHGymbpUyuFCJ2HA@mail.gmail.com>
        <CAK8P3a01sOsWSw4t-x6rv+9pzbfhZtEMc6iwV54Xq-48h6CN=Q@mail.gmail.com>
        <1513078952.3036.36.camel@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 12 Dec 2017 03:42:32 -0800
Joe Perches <joe@perches.com> escreveu:

> > I actually thought about marking them 'const' here before sending
> > (without noticing the changelog text) and then ran into what must
> > have led me to drop the 'const' originally: tuner_i2c_xfer_send()
> > takes a non-const pointer. This can be fixed but it requires
> > an ugly cast:  
> 
> Casting away const is always a horrible hack.
> 
> Until it could be changed, my preference would
> be to update the changelog and perhaps add to
> the changelog the reason why it can not be const
> as detailed below.
> 
> ie: xfer_send and xfer_xend_recv both take a
>     non-const unsigned char *

Perhaps, on a separate changeset, we could change I2C routines to
accept const unsigned char pointers. This is unrelated to tda8290
KASAN fixes. So, it should go via I2C tree, and, once accepted
there, we can change V4L2 drivers (and other drivers) accordingly.


Thanks,
Mauro
