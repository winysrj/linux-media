Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.126.186]:55492 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753442Ab0KPQP4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Nov 2010 11:15:56 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Jimmy RUBIN <jimmy.rubin@stericsson.com>
Subject: Re: [PATCH 01/10] MCDE: Add hardware abstraction layer
Date: Tue, 16 Nov 2010 17:16:44 +0100
Cc: "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Dan JOHANSSON <dan.johansson@stericsson.com>,
	Linus WALLEIJ <linus.walleij@stericsson.com>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>
References: <1289390653-6111-1-git-send-email-jimmy.rubin@stericsson.com> <F45880696056844FA6A73F415B568C6953604E7D94@EXDCVYMBSTM006.EQ1STM.local> <201011161712.31703.arnd@arndb.de>
In-Reply-To: <201011161712.31703.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201011161716.44542.arnd@arndb.de>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

sent out too early...

On Tuesday 16 November 2010, Arnd Bergmann wrote:
> > > This looks a bit like you actually have multiple interrupt lines
> > > multiplexed
> > > through a private interrupt controller. Have you considered making this
> > > controller
> > > a separate device to multiplex the interrupt numbers?
> > 
> > MCDE contains several pipelines, each of them can generate interrupts.
> > Since each interrupt comes from the same device there is no need for
> > separate devices for interrupt controller.
> 
> Right, so this one and the one above is really a question of how to describe
> a pipeline:
 
It may be good to have a source file that only deals with the pipelines
and all that they have in common. If you use the same basic pipeline
logic for doing multiple different things, this can be used to structure
the code more logically. Not sure if this is worth trying, since it might
not actually gain all that much in the end

	Arnd
