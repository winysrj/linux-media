Return-path: <mchehab@pedra>
Received: from mail.perches.com ([173.55.12.10]:1501 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934804Ab0KQQBU (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Nov 2010 11:01:20 -0500
Subject: Re: [PATCH 01/10] MCDE: Add hardware abstraction layer
From: Joe Perches <joe@perches.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Jimmy RUBIN <jimmy.rubin@stericsson.com>,
	Dan JOHANSSON <dan.johansson@stericsson.com>,
	"linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
	Linus WALLEIJ <linus.walleij@stericsson.com>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
In-Reply-To: <201011171055.58201.arnd@arndb.de>
References: <1289390653-6111-1-git-send-email-jimmy.rubin@stericsson.com>
	 <F45880696056844FA6A73F415B568C6953604E7D94@EXDCVYMBSTM006.EQ1STM.local>
	 <1289936772.28741.188.camel@Joe-Laptop>  <201011171055.58201.arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 17 Nov 2010 08:01:17 -0800
Message-ID: <1290009677.28741.302.camel@Joe-Laptop>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Wed, 2010-11-17 at 10:55 +0100, Arnd Bergmann wrote:
> On Tuesday 16 November 2010, Joe Perches wrote:
> > static inline u32 MCDE_channel_path(u32 chnl, u32 fifo, u32 type, u32 ifc, u32 link)
> > {
> >         return ((chnl << 16) |
> >                 (fifo << 12) |
> >                 (type << 8) |
> >                 (ifc << 4) |
> >                 (link << 0));
> > }
> > 
> > #define SET_ENUM_MCDE_CHNLPATH(chnl, fifo, var, type, ifc, link)        \
> >         MCDE_CHNLPATH_CHNL##chnl##_FIFO##fifo##_##var =                 \
> >                 MCDE_channel_path(MCDE_CHNL_##chnl,                     \
> >                                   MCDE_FIFO_##fifo,                     \
> >                                   MCDE_PORTTYPE_##type,                 \
> >                                   ifc,                                  \
> >                                   link)
> > 
> > enum mcde_chnl_path {
> >         /* Channel A */
> >         SET_ENUM_MCDE_CHNLPATH(A, A, DPI_0,             DPI, 0, 0),
> >         SET_ENUM_MCDE_CHNLPATH(A, A, DSI_IFC0_0,        DSI, 0, 0),
> >         SET_ENUM_MCDE_CHNLPATH(A, A, DSI_IFC0_1,        DSI, 0, 1),
> 
> While more readable, this has two significant problems:
> 
> * You cannot use the result of an inline function in an enum definition
> * It hides the name of the identifier, making it impossible to use grep
>   or ctags to find the definition when you only know the name

True, though I would avoid that problem by using a get function/macro
and not use an enum at all.

There are just 4 items of interest here.  chan, fifo, #1, #2.
Encoding those in the variable name is a bit of a visual chase and
a bit mind numbing to read I think.
 
> The easiest way is probably to get rid of the macros entirely here
> and just define the values as hex, with a comment exmplaining what the
> digits mean.

That'd be fine too.


