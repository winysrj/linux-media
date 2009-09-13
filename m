Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-09.arcor-online.net ([151.189.21.49]:42120 "EHLO
	mail-in-09.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750746AbZIMEPp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 13 Sep 2009 00:15:45 -0400
Subject: Re: Problems with Pinnacle 310i (saa7134) and recent kernels
From: hermann pitton <hermann-pitton@arcor.de>
To: Avl Jawrowski <avljawrowski@gmail.com>
Cc: linux-media@vger.kernel.org
In-Reply-To: <loom.20090912T211959-273@post.gmane.org>
References: <loom.20090718T135733-267@post.gmane.org>
	 <1248033581.3667.40.camel@pc07.localdom.local>
	 <loom.20090720T224156-477@post.gmane.org>
	 <1248146456.3239.6.camel@pc07.localdom.local>
	 <loom.20090722T123703-889@post.gmane.org>
	 <1248338430.3206.34.camel@pc07.localdom.local>
	 <loom.20090910T234610-403@post.gmane.org>
	 <1252630820.3321.14.camel@pc07.localdom.local>
	 <loom.20090912T211959-273@post.gmane.org>
Content-Type: text/plain
Date: Sun, 13 Sep 2009 06:12:58 +0200
Message-Id: <1252815178.3259.39.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Am Samstag, den 12.09.2009, 21:39 +0000 schrieb Avl Jawrowski:
> hermann pitton <hermann-pitton <at> arcor.de> writes:
> 
> > > However it works still only with Kaffeine and w_scan.
> > > dvbscan (last mercurial) give:
> > 
> > Off hand I can't tell, but try with "scan".
> > I did not use "dvbscan" since years and can't tell the status.
> 
> Even scan works perfectly (I didn't know it).
> I think it's an mplayer problem, I'll write about it in the mplayer mailing list.
> 
> > Cheers,
> > Hermann
> 
> You've been very helpful!
> Thank you very much,
> Avl
> 

I'm sorry that we have some mess on some of such devices, but currently
really nobody can help much further.

Mike and Hauppauge don't have any schematics for LNA and external
antenna voltage switching for now, he assured it to me personally and we
must live with the back hacks for now and try to further work through
it.

However, mplayer should work as well, but my last checkout is a little
out dated.

It will go to Nico anyway, he is usually at the list here.

If you can tell me on what you are, I might be able to confirm or not.

The only other issue I'm aware of is that radio is broken since guessed
8 weeks on my tuners, only realized when testing on enabling external
active antenna voltage for DVB-T on a/some 310i.

Might be anything, hm, hopefully I should not have caused it ;)

Cheers,
Hermann
        



