Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.126.171]:56242 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752332Ab0KQJ4H (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Nov 2010 04:56:07 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Joe Perches <joe@perches.com>
Subject: Re: [PATCH 01/10] MCDE: Add hardware abstraction layer
Date: Wed, 17 Nov 2010 10:55:58 +0100
Cc: Jimmy RUBIN <jimmy.rubin@stericsson.com>,
	Dan JOHANSSON <dan.johansson@stericsson.com>,
	"linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
	Linus WALLEIJ <linus.walleij@stericsson.com>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
References: <1289390653-6111-1-git-send-email-jimmy.rubin@stericsson.com> <F45880696056844FA6A73F415B568C6953604E7D94@EXDCVYMBSTM006.EQ1STM.local> <1289936772.28741.188.camel@Joe-Laptop>
In-Reply-To: <1289936772.28741.188.camel@Joe-Laptop>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201011171055.58201.arnd@arndb.de>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Tuesday 16 November 2010, Joe Perches wrote:
> static inline u32 MCDE_channel_path(u32 chnl, u32 fifo, u32 type, u32 ifc, u32 link)
> {
>         return ((chnl << 16) |
>                 (fifo << 12) |
>                 (type << 8) |
>                 (ifc << 4) |
>                 (link << 0));
> }
> 
> #define SET_ENUM_MCDE_CHNLPATH(chnl, fifo, var, type, ifc, link)        \
>         MCDE_CHNLPATH_CHNL##chnl##_FIFO##fifo##_##var =                 \
>                 MCDE_channel_path(MCDE_CHNL_##chnl,                     \
>                                   MCDE_FIFO_##fifo,                     \
>                                   MCDE_PORTTYPE_##type,                 \
>                                   ifc,                                  \
>                                   link)
> 
> enum mcde_chnl_path {
>         /* Channel A */
>         SET_ENUM_MCDE_CHNLPATH(A, A, DPI_0,             DPI, 0, 0),
>         SET_ENUM_MCDE_CHNLPATH(A, A, DSI_IFC0_0,        DSI, 0, 0),
>         SET_ENUM_MCDE_CHNLPATH(A, A, DSI_IFC0_1,        DSI, 0, 1),

While more readable, this has two significant problems:

* You cannot use the result of an inline function in an enum definition
* It hides the name of the identifier, making it impossible to use grep
  or ctags to find the definition when you only know the name

The easiest way is probably to get rid of the macros entirely here
and just define the values as hex, with a comment exmplaining what the
digits mean.

	Arnd
