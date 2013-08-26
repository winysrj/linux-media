Return-path: <linux-media-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:54797 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751945Ab3HZI5w (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Aug 2013 04:57:52 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gldv-linux-media@m.gmane.org>)
	id 1VDscP-0001Ef-FJ
	for linux-media@vger.kernel.org; Mon, 26 Aug 2013 10:57:51 +0200
Received: from exchange.muehlbauer.de ([194.25.158.132])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Mon, 26 Aug 2013 10:57:49 +0200
Received: from Bassai_Dai by exchange.muehlbauer.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Mon, 26 Aug 2013 10:57:49 +0200
To: linux-media@vger.kernel.org
From: Tom <Bassai_Dai@gmx.net>
Subject: Re: media-ctl: line 1: syntax error: "(" unexpected
Date: Mon, 26 Aug 2013 08:57:30 +0000 (UTC)
Message-ID: <loom.20130826T105417-821@post.gmane.org>
References: <loom.20130821T143312-331@post.gmane.org> <loom.20130823T150508-871@post.gmane.org> <CA+2YH7tXLgwFjN9S2mrVQ2rhu==GQ5=HPSyf8hpZP2_UA=7j2g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Enrico <ebutera <at> users.berlios.de> writes:

> 
> On Fri, Aug 23, 2013 at 3:08 PM, Tom <Bassai_Dai <at> gmx.net> wrote:
> > Tom <Bassai_Dai <at> gmx.net> writes:
> >
> >>
> >> Hello,
> >>
> >> I got the media-ctl tool from http://git.ideasonboard.org/git/media-ctl.git
> >> and compiled and build it successfully. But when try to run it I get this
> > error:
> >>
> >> sudo ./media-ctl -r -l "ov3640 3-003c":0->"OMAP3 ISP CCDC":0[1], "OMAP3 ISP
> >> CCDC":1->"OMAP3 ISP CCDC output":0[1]
> >>
> >> ./media-ctl: line 1: syntax error: "(" unexpected
> >>
> >> Does anyone know how I can solve that problem?
> 
> Looks like you are trying to execute a wrapper script instead of the
> real binary, it's in src/.libs
> 
> Enrico
> 

Hello Enrico,

thanks for your reply. All I did was to build the media-ctl tool, made "make
install" and copied the resulting folder "media-ctl-exe" to my arm board.
Then I executed the /media-ctl-exe/bin/media-ctl file with "./media-ctl
--help" and got this error.

Best Regards, Tom


