Return-path: <linux-media-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:50828 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753866Ab1KLOPI (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 12 Nov 2011 09:15:08 -0500
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <gldv-linux-media@m.gmane.org>)
	id 1RPEMM-00049k-SM
	for linux-media@vger.kernel.org; Sat, 12 Nov 2011 15:15:06 +0100
Received: from AMarseille-551-1-91-234.w92-137.abo.wanadoo.fr ([92.137.194.234])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Sat, 12 Nov 2011 15:15:06 +0100
Received: from tnorret by AMarseille-551-1-91-234.w92-137.abo.wanadoo.fr with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Sat, 12 Nov 2011 15:15:06 +0100
To: linux-media@vger.kernel.org
From: Norret Thierry <tnorret@yahoo.com>
Subject: Re: HVR-4000 may be broken in kernel mods (again) ?
Date: Sat, 12 Nov 2011 14:10:15 +0000 (UTC)
Message-ID: <loom.20111112T150258-917@post.gmane.org>
References: <CAA7M+FBvP0A7L6o-Fw4CQ2xR2CYqu233L+83BGGOcLooK0bk7w@mail.gmail.com> <CAGoCfiw+yy3Hz=7yvGTYrYQn5VfNh3CrabS_Kxx7G88jcwt9aQ@mail.gmail.com> <20111112141403.53708f28@hana.gusto> <CAGoCfiwnOTv=yhFeAsjQ+=5vrsUfy5b8HqtXGiFuimXe2M-+Bw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Devin Heitmueller <dheitmueller <at> kernellabs.com> writes:

> 
> On Sat, Nov 12, 2011 at 8:14 AM, Lars Schotte <gusto <at> guttok.net> wrote:
> > i am alos curious what he means by "try to use it". i mean did he try
> > to use it with tzap, or szap, or w_scan, or what? because i dont even
> > know about mythtv, i only use dvbutils, mplayer, xine and vdr.
> 
> I agree with Lars on this.  It would be useful if the user could
> describe in more detail his testing methodology.  Also, is there some
> previous kernel in which he knew it was working properly?  Has he
> *ever* seen it work in his environment?  Do we know definitively that
> this really a regression or has the user never seen the board work?
> 
> Devin
> 

I think your problem and mine are the same
I've too an hauppauge dvb-t

http://www.spinics.net/lists/linux-media/msg39917.html

Since upgrade from kernel 2.6.38 to 2.6.39/3.0 channels can't be lock.

