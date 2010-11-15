Return-path: <mchehab@pedra>
Received: from lo.gmane.org ([80.91.229.12]:60982 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757331Ab0KOEzJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 14 Nov 2010 23:55:09 -0500
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <gldv-linux-media@m.gmane.org>)
	id 1PHr5t-0004L6-5e
	for linux-media@vger.kernel.org; Mon, 15 Nov 2010 05:55:05 +0100
Received: from 203.106.17.237 ([203.106.17.237])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Mon, 15 Nov 2010 05:55:05 +0100
Received: from bahathir by 203.106.17.237 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Mon, 15 Nov 2010 05:55:05 +0100
To: linux-media@vger.kernel.org
From: Mohammad Bahathir Hashim <bahathir@gmail.com>
Subject: Re: For those that uses Pinnacle PCTV 340e
Date: Mon, 15 Nov 2010 04:24:13 +0000 (UTC)
Message-ID: <ibqclc$q5u$1@dough.gmane.org>
References: <AANLkTinWJu92nCR4vHUO3MWZp_ipNZL8LzpYrU4GDj7U@mail.gmail.com>
Reply-To: Mohammad Bahathir Hashim <bahathir@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On 2010-11-14, Magnus Alm <magnus.alm@gmail.com> wrote:
> --00504502b04953b108049503ec60
> Content-Type: text/plain; charset=ISO-8859-1
>
> Hi!
>
> I've merged the code for the 340e, that Devin Heitmueller made over at
> Kernellabs, with the latest HG tree and tested it on Ubuntu 10.10
> today (2.6.35-22-generic).
>
> I lack the knowledge on how to add the new files (xc4000.c and
> xc4000.h) to a patch, so the script added in the tar ball just copies
> it to the right place, the firmware has to be manually copied too.
>
> /Magnus

Just want to share an alternatives, patches to vanilla kernel 2.6.35;
by me, which I sent to Istvan Varga. 

http://istvanv.users.sourceforge.net/v4l/xc4000.html


I am using PCTV 340e with GNU/Linux since Devin Heitmueller's
"Christmas present" in kernellabs.com last year. I did few portings to
make the driver workable with vanilla 2.6.34 and later. 

Beside's Devin's xc4000.[ch], I also use the files (xc4000.[ch] and
firmware) from Istvan page. It works very well and the dongle feels
much cooler when idling. because the PCTV 340e's power management is
working. 

Since there are several devices using xc4000 driver; I really hope
that it can included in main v4l stream; at least in the staging
directory. 

Also really like to see analog support (S-video capture, analog TV and
FM radio) for PCTV 340e too :). I was told that the dib0700 driver
does not has the analog tuning yet.

Thank you

