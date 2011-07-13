Return-path: <linux-media-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:33485 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752168Ab1GMTFI (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 13 Jul 2011 15:05:08 -0400
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <gldv-linux-media@m.gmane.org>)
	id 1Qh4k7-0004hw-DS
	for linux-media@vger.kernel.org; Wed, 13 Jul 2011 21:05:07 +0200
Received: from h82-143-164-59-static.e-wro.net.pl ([82.143.164.59])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Wed, 13 Jul 2011 21:05:07 +0200
Received: from kamil by h82-143-164-59-static.e-wro.net.pl with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Wed, 13 Jul 2011 21:05:07 +0200
To: linux-media@vger.kernel.org
From: Kamil Kaminski <kamil@mrblur.net>
Subject: Re: Gigabyte 8300
Date: Wed, 13 Jul 2011 19:00:43 +0000 (UTC)
Message-ID: <loom.20110713T195633-611@post.gmane.org>
References: <AANLkTi=SY9xWCjp_0q6US7XN6XYoTWnGHA2=6EfjuWK-@mail.gmail.com> <AANLkTikg79zui71Xz8r-Lg3zut0jkSk-BGEpBpXfWz5Y@mail.gmail.com> <AANLkTimc2TTQQogO8Q6ih6Bv3j_oOcVMux3cg-CJPGsw@mail.gmail.com> <AANLkTim_mU7ayxjeE2HQz57UsPqHU46dPC3Ys600RJAD@mail.gmail.com> <1283529713.12583.84.camel@morgan.silverblock.net> <AANLkTimvC6811Pb-sxTVSod-p2U+Cmy5QUenKRn9ceYX@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Devin Heitmueller <dheitmueller <at> kernellabs.com> writes:

> 
> On Fri, Sep 3, 2010 at 12:01 PM, Andy Walls <awalls <at> md.metrocast.net> 
wrote:
> > On Fri, 2010-09-03 at 10:55 +0000, Dagur Ammendrup wrote:
> >> I tried it on a windows machine where it's identified as "Conextant
> >> Polaris Video Capture"  or
> >> 
"oem17.inf:Conexant.NTx86:POLARIS.DVBTX.x86:6.113.1125.1210:usb\vid_1b80&pid_d41
6&mi_01"
> >> if that tells you anything.
> >
> >
> > Polaris refers to the series of CX2310[012] chips IIRC.
> >
> > Support would need changes to the cx231xx driver, and possibly changes
> > to the cx25480 module, depending on how far the board differs from
> > Conexant reference designs.
> 
> I've been working with Conexant on this, and have their current tree here:
> 
> https://www.kernellabs.com/hg/~dheitmueller/polaris4/
> 
> So if you feel the urge to do any new device support, I would suggest
> using this as a starting point.
> 
> Devin
> 


Hello everyone,

I'd like to refresh a little this thread as I have also bought this device and 
I'm willing to donate my time to make it working with Linux.

The bad news is that I am not familiar with Linux API (and device programming at 
all), so I can only offer myself for testing and gathering informations.

I have taken two high resolution pictures of this board.
As you (propably) know, it has 3 chips:
- Conexant 23102-11Z
- Conexant 24232-11Z
- NXP TDA18271 HDC2

The board is labeled UD412 if it makes any sense.

Pictures are on Picasa account: 
https://picasaweb.google.com/kamilkaminski000/GigabyteU8300?
authuser=0&authkey=Gv1sRgCID_5oOcsdXRpwE&feat=directlink
Both are 10MPix, you can zoom-in.

Device is still not recognized on Gentoo with 2.6.39-r3 (2.6.39.3) kernel.
It has same vendor id and device id (1b80:d416).

I have seen that there are drivers ready for tuner and for conexant chip. Is it 
really a problem to put them together?

I do not know where to start, and this thread is the only one Google shows.

I do not understand also the last message on thread, I have checked kernellabs 
code, but haven't seen my device in USB devices table for cx231xx. No cx2432 
also.

Best regards,
Kamil Kaminski

