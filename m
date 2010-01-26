Return-path: <linux-media-owner@vger.kernel.org>
Received: from dudelab.org ([212.12.33.202]:16539 "EHLO mail.dudelab.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752338Ab0AZBDb (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Jan 2010 20:03:31 -0500
Received: from abrasax.taupan.ath.cx (p5DE89DD7.dip.t-dialin.net [93.232.157.215])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client CN "Friedrich Delgado Friedrichs", Issuer "User CA" (not verified))
	by mail.dudelab.org (Postfix) with ESMTP id 8C368228148
	for <linux-media@vger.kernel.org>; Tue, 26 Jan 2010 02:04:46 +0100 (CET)
Date: Tue, 26 Jan 2010 02:03:28 +0100
From: Friedrich Delgado Friedrichs <friedel@nomaden.org>
To: linux-media@vger.kernel.org
Subject: Re: Hauppauge Win TV HVR-1300: streaming and grabbing fail after a
 while, changing resolution renders card inoperable
Message-ID: <20100126010327.GA20636@taupan.ath.cx>
Reply-To: friedel@nomaden.org
References: <20100117133300.GA3668@taupan.ath.cx>
 <20100119103911.GA27938@taupan.ath.cx>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100119103911.GA27938@taupan.ath.cx>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Reproduced this problem with latest checkout from http://linuxtv.org/hg/v4l-dvb

Friedel wrote:
> I'm sorry, two of the problems described in my mail have nothing to do
> with the driver. There's a daemon running that accesses the tuner and
> vbi (nxtvepg), which causes problems 1 and 2.
> 
> I've failed to notice this because nxtvepg can (normally) detect
> tvtime and xawtv and doesn't interfere with them, so I assumed it
> might have a general mechanism for detecting if the tv driver is in
> use by a different app.
> 
> The third problem remains:
> 
> Friedel wrote:
> > 3) changing resolutions causes mpeg encoder stream to become
> > completely inoperable
> 
> > When I switch resolutions in mythtv recording profile, but also via
> > e.g.
> > 
> > v4l2-ctl -d /dev/video1 --set-fmt-video=width=720,height=568
> > 
> > I seem to totally break the encoder. There's no stream any more,
> > 
> > ~> cat /dev/video1
> > cat: /dev/video1: Input/output error
> > 
> > And switching the resolution back doesn't help. Unloading the modules
> > doesn't help either, I have to reboot the box.
> > 
> > dmesg output pastebinned at http://pastebin.com/f4e27757a
> > 
> > Tests were done with a 2.6.32 kernel from ubuntu.
> 
> Which I assume is a vanilla kernel. I might be wrong about this, too.
> 
> I could test with newer drivers or a newer kernel of course, if you
> suspect that the problem might not be fixed yet.
> 
> > Please ask if there's any information you can't easily infer from this
> > mail or the attached logs.
> 
> 
---Zitatende---

-- 
        Friedrich Delgado Friedrichs <friedel@nomaden.org>
                             TauPan on Ircnet and Freenode ;)
