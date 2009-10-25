Return-path: <linux-media-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:34670 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753166AbZJYKZA (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 25 Oct 2009 06:25:00 -0400
Received: from list by lo.gmane.org with local (Exim 4.50)
	id 1N20HX-0004Yg-VS
	for linux-media@vger.kernel.org; Sun, 25 Oct 2009 11:25:03 +0100
Received: from 151.82.16.244 ([151.82.16.244])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Sun, 25 Oct 2009 11:25:03 +0100
Received: from francescolavra by 151.82.16.244 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Sun, 25 Oct 2009 11:25:03 +0100
To: linux-media@vger.kernel.org
From: Francesco Lavra <francescolavra@interfree.it>
Subject: Re: em28xx DVB modeswitching change: call for testers
Date: Sun, 25 Oct 2009 09:55:46 +0000 (UTC)
Message-ID: <loom.20091025T104917-100@post.gmane.org>
References: <829197380910132052w155116ecrcea808abe87a57a6@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Devin Heitmueller <dheitmueller <at> kernellabs.com> writes:

> 
> Hello all,
> 
> I have setup a tree that removes the mode switching code when
> starting/stopping streaming.  If you have one of the em28xx dvb
> devices mentioned in the previous thread and volunteered to test,
> please try out the following tree:
> 
> http://kernellabs.com/hg/~dheitmueller/em28xx-modeswitch
> 
> In particular, this should work for those of you who reported problems
> with zl10353 based devices like the Pinnacle 320e (or Dazzle) and were
> using that one line change I sent this week.  It should also work with
> Antti's Reddo board without needing his patch to move the demod reset
> into the tuner_gpio.
> 
> This also brings us one more step forward to setting up the locking
> properly so that applications cannot simultaneously open the analog
> and dvb side of the device.
> 
> Thanks for your help,
> 
> Devin
> 

Tested your tree with a EM2882_BOARD_TERRATEC_HYBRID_XS (0x0ccd, 0x005e) in
digital mode. It works fine, now I can successfully switch between DVB channels,
while with the official tree channel switching doesn't work. I'm using MPlayer.

Regards,
Francesco


