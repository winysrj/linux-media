Return-path: <linux-media-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:44825 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755291Ab2KMQjU (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 13 Nov 2012 11:39:20 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gldv-linux-media@m.gmane.org>)
	id 1TYJWJ-0008Jz-9e
	for linux-media@vger.kernel.org; Tue, 13 Nov 2012 17:39:27 +0100
Received: from 84-72-11-174.dclient.hispeed.ch ([84.72.11.174])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Tue, 13 Nov 2012 17:39:27 +0100
Received: from auslands-kv by 84-72-11-174.dclient.hispeed.ch with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Tue, 13 Nov 2012 17:39:27 +0100
To: linux-media@vger.kernel.org
From: Neuer User <auslands-kv@gmx.de>
Subject: Re: Color problem with MPX-885 card (cx23885)
Date: Tue, 13 Nov 2012 17:39:05 +0100
Message-ID: <k7tt38$aol$1@ger.gmane.org>
References: <k7tkcu$m6j$1@ger.gmane.org> <CAGoCfiwBJv04ffd+gDn1t+_3GPn+KeDdcaRQ+PbrqAjAsiMEHg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
In-Reply-To: <CAGoCfiwBJv04ffd+gDn1t+_3GPn+KeDdcaRQ+PbrqAjAsiMEHg@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello David

Thanks for taking the time to help.

I had looked through the linux-media GIT tree for any commits that have
"cx23885" in the description. The last ones I found were from mid 2011.

That was probably why I did not try any newer kernels. Stupid me. Should
have tried anyway.

I can confirm that the biggest problem, the color problem, is fixed at
least with kernel 3.5.7 (maybe earlier).

The minor ones (card not autodetected, and black border on the left
side) can probably be dealt with, e.g. in postprocessing. Or is there a
chance to fix these in the driver?

Michael

Am 13.11.2012 16:02, schrieb Devin Heitmueller:
> You should start by installing the current media_build tree.  There
> were a bunch of cx23885 fixes done back in June, which won't be in
> 12.04.  I believe this issue may already be fixed.
> 
> Cheers,
> 
> Devin
> 


