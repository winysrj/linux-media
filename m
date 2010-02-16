Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:43684 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932374Ab0BPAhI (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Feb 2010 19:37:08 -0500
Subject: Re: cx23885
From: Andy Walls <awalls@radix.net>
To: Ralph Siemsen <ralphs@netwinder.org>
Cc: Michael <auslands-kv@gmx.de>, linux-media@vger.kernel.org
In-Reply-To: <20100215232253.GA17950@harvey.netwinder.org>
References: <1266238446.3075.13.camel@palomino.walls.org>
	 <hlbhck$uh9$1@ger.gmane.org> <4B795D1A.9040502@kernellabs.com>
	 <hlbopr$v7s$1@ger.gmane.org> <4B79803B.4070302@kernellabs.com>
	 <hlcbhu$4s3$1@ger.gmane.org> <4B79B437.5000004@kernellabs.com>
	 <hlch5h$ogp$1@ger.gmane.org> <hlciur$tb0$1@ger.gmane.org>
	 <hlcjfi$unq$1@ger.gmane.org>  <20100215232253.GA17950@harvey.netwinder.org>
Content-Type: text/plain
Date: Mon, 15 Feb 2010 19:36:50 -0500
Message-Id: <1266280610.3236.26.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 2010-02-15 at 18:22 -0500, Ralph Siemsen wrote:
> On Mon, Feb 15, 2010 at 11:56:52PM +0100, Michael wrote:
> > 
> > If anybody can give me a hint, what to include in a patch and what was old 
> > stuff that has jsut changed in 2.6.31, I'd be grateful.
> 
> Their source tree contains a .hg_archival.txt file which looks like
> it can be used to identify the original v4l-dvb tree they used.
> 
> Attached is a diff from that v4l version to the MPX-885 tree.
>  cx23885/cx23885-cards.c    |   90 ++++++++++++++++
>  cx23885/cx23885-dvb.c      |   30 +++++
>  cx23885/cx23885-video.c    |    2 
>  cx23885/cx23885.h          |    1 
>  cx25840/cx25840-core.c     |  248 +++++++++++++++++++++++++++++++++++++++------
>  cx25840/cx25840-firmware.c |    4 
>  6 files changed, 338 insertions(+), 37 deletions(-)
> 
> Hope it helps...
> -R


That is very helpful.

However, changes to the CX25840 module, since their MPX885 changes were
developed, are extenesive when it comes to initialization of the
CX23885/7/8 A/V decoder.  Their changes will be difficult to port.

I also see changes which will at least break existing drivers and apps.
For example, this one will violate a key assumption made by the ivtv
driver:

-       state->vid_input = CX25840_COMPOSITE7;
+       state->vid_input = CX25840_COMPOSITE1;


This sort of thing is typical of many vendor driver developments: get it
working for this part as fast as possible so the product can ship -
don't worry about anything else.

It is still decent of them to provide a linux driver and the source
changes without a hassle.  RAR format is inconvenient on linux though.

Regards,
Andy

