Return-path: <linux-media-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:33835 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751075Ab2JIXue (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 9 Oct 2012 19:50:34 -0400
Date: Tue, 9 Oct 2012 20:50:27 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Julia Lawall <julia.lawall@lip6.fr>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 13/13] drivers/media/tuners/e4000.c: use macros for
 i2c_msg initialization
Message-ID: <20121009205027.32835fd1@infradead.org>
In-Reply-To: <alpine.DEB.2.02.1210081028340.1989@hadrien>
References: <1349624323-15584-1-git-send-email-Julia.Lawall@lip6.fr>
	<1349624323-15584-3-git-send-email-Julia.Lawall@lip6.fr>
	<5071AEF3.6080108@bfs.de>
	<alpine.DEB.2.02.1210071839040.2745@localhost6.localdomain6>
	<5071B834.1010200@bfs.de>
	<alpine.DEB.2.02.1210071917040.2745@localhost6.localdomain6>
	<1349633780.15802.8.camel@joe-AO722>
	<alpine.DEB.2.02.1210072053550.2745@localhost6.localdomain6>
	<1349645970.15802.12.camel@joe-AO722>
	<alpine.DEB.2.02.1210072342460.2745@localhost6.localdomain6>
	<1349646718.15802.16.camel@joe-AO722>
	<20121007225639.364a41b4@infradead.org>
	<50723661.6040107@gmail.com>
	<alpine.DEB.2.02.1210081028340.1989@hadrien>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Julia,

Em Mon, 8 Oct 2012 10:31:33 +0200 (CEST)
Julia Lawall <julia.lawall@lip6.fr> escreveu:

> I found only 15 uses of I2C_MSG_OP, out of 653 uses of one of the three
> macros.  Since I2C_MSG_OP has the complete set of flags, I think it should
> be OK?
> 
> One of the uses, in drivers/media/i2c/adv7604.c, is as follows:
> 
>        struct i2c_msg msg[2] = { { client->addr, 0, 1, msgbuf0 },
>                                  { client->addr, 0 | I2C_M_RD, len, msgbuf1 }
> 
> I'm not sure what was intended, but I guess the second structure is
> supposed to only do a read?

As we're discussing the macro names, etc, I'll just mark this patch series
as RFC, at patchwork, removing it from my pending queue. Feel free to 
re-submit it later, after some agreement got reached.

Thanks,
Mauro
