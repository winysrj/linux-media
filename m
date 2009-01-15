Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:53662 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754794AbZAOPxW (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 15 Jan 2009 10:53:22 -0500
Cc: linux-media@vger.kernel.org, linux-dvb@linuxtv.org,
	krisu@nomadiclab.com, pauli@borodulin.fi
Content-Type: text/plain; charset="utf-8"
Date: Thu, 15 Jan 2009 16:53:19 +0100
From: "Hans Werner" <HWerner4@gmx.de>
In-Reply-To: <496F4E8E.1060702@gmail.com>
Message-ID: <20090115155319.112070@gmx.net>
MIME-Version: 1.0
References: <49634AFE.2080405@borodulin.fi>
	<200901071558.08220.liplianin@tut.by>	<20090115135107.298140@gmx.net>
 <496F4E8E.1060702@gmail.com>
Subject: Re: [linux-dvb] The status and future of Mantis driver
To: Manu Abraham <abraham.manu@gmail.com>
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> Hans Werner wrote:
> > -------- Original-Nachricht --------
> >> Datum: Wed, 7 Jan 2009 15:58:08 +0200
> >> Von: "Igor M. Liplianin" <liplianin@tut.by>
> >> An: linux-dvb@linuxtv.org
> >> Betreff: Re: [linux-dvb] The status and future of Mantis driver
> > 
> >> В сообщении от 6 January 2009 14:13:50 Pauli Borodulin
> >> написал(а):
> >>> Heya!
> >>>
> >>> I found out that there is some new activity on Manu Abraham's Mantis
> >>> driver, so I thought I could throw in some thoughts about it.
> >>>
> >>> I have been using Manu's Mantis driver (http://www.jusst.de/hg/mantis)
> >>> for over two years now. I have a VP-2033 card (DVB-C) and at least for
> >>> the last year the driver has worked without any hickups in my daily
> >>> (VDR) use. For a long time I have thought that the driver should
> already
> >>> be merged to the v4l-dvb tree.
> >>>
> >>> Igor M. Liplianin has created a new tree
> >>> (http://mercurial.intuxication.org/hg/s2-liplianin) with the
> description
> >>> "DVB-S(S2) drivers for Linux". Mantis driver was merged into the tree
> in
> >>> October and since then some fixes has also been applied to the driver.
> >>> Some of these fixes already exist in Manu's tree, some don't. Both
> trees
> >>> are missing the remote control support for VP-2033 and VP-2040.
> >>>
> >>> Until merging of the driver into s2-liplianin, there was a single tree
> >>> for the Mantis driver development. Now that there are two trees, I
> fear
> >>> that the development could scatter if there's no clear idea how the
> >>> driver is going to get into v4l-dvb. Also, the driver is not only
> >>> DVB-S(S2), but it also contains support for VP-2033 (DVB-C), VP-2040
> >>> (DVB-C) and VP-3030 (DVB-T). DVB-S(S2) stuff will probably greatly(?)
> >>> delay getting the support for DVB-C/T Mantis cards into v4l-dvb.
> >>>
> >>> For my personal use I have created a patch against the latest v4l-dvb
> >>> based on Manu's Mantis tree including the remote control support for
> >>> VP-2033 and VP-2040. But what I would really like to see is Mantis
> >>> driver merged into v4l-dvb and later into mainstream.
> >>>
> >>> Igor, what are your thoughts about the Mantis driver? How about the
> >>> other Mantis users, like Marko Ristola, Roland Scheidegger, and
> Kristian
> >>> Slavov?
> >> Anyone and everyone is permitted to take anything and everything from
> >> s2-liplianin.
> >> The tree was made for testing purposes. If it works, than it works:)
> >> Me and Manu Abraham is not a friends, so ask him to make a pull request
> >> for mantis.
> >> And after that we(we like community) with combined efforts bring it to
> >> v4l-dvb.
> >>
> > 
> > Manu,
> > 
> > will you issue the pull request for the mantis driver?
> > 
> > The version at s2-liplianin is synchronised with the current kernel and
> is functional
> > for a number of cards. 
> > 
> 
> No, the Mantis driver from the s2 liplianin tree will not be pulled in 
> as it is.
>  
> It is way under work. Look out for changes in the
> http://jusst.de/hg/mantis 
> By just splitting up the user base, you have made this process a bit
> longer,
> that's what it is.

Longer? On the contrary -- the s2-liplianin repository is well in advance of the 
one at jusst.de. I didn't split any userbase myself. I remind everyone that the
repository at jusst.de does not compile with kernel 2.6.28 and does not use the
current API, namely S2API. Fortunately the work to bring mantis up to date for
the current kernel has already been done, just not by you, and it is in 
s2-liplianin. You could and should benefit rapidly from this like everyone else.

To keep your userbase you need to get up to date and merge mantis into the
kernel.

Hans

> 
> 
> _______________________________________________
> linux-dvb users mailing list
> For V4L/DVB development, please use instead linux-media@vger.kernel.org
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb

-- 
Release early, release often.

Sensationsangebot verlängert: GMX FreeDSL - Telefonanschluss + DSL 
für nur 16,37 Euro/mtl.!* http://dsl.gmx.de/?ac=OM.AD.PD003K1308T4569a
