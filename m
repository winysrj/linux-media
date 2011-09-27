Return-path: <linux-media-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:59769 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751052Ab1I0Ho7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 27 Sep 2011 03:44:59 -0400
Date: Tue, 27 Sep 2011 09:44:09 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: Mauro Carvalho Chehab <maurochehab@gmail.com>,
	Patrick Dickey <pdickeybeta@gmail.com>,
	LMML <linux-media@vger.kernel.org>,
	Greg Kroah-Hartman <gregkh@suse.de>, devel@driverdev.osuosl.org
Subject: Staging submission: PCTV 80e and PCTV 74e drivers (was Re: Problems
 cloning the git repostories)
Message-ID: <20110927094409.7a5fcd5a@stein>
In-Reply-To: <CAGoCfizyLgpEd_ei-SYEf6WWs5cygQJNjKPNPOYOQUqF773D4Q@mail.gmail.com>
References: <4E7F1FB5.5030803@gmail.com>
	<CAGoCfixneQG=S5wy2qZZ50+PB-QNTFx=GLM7RYPuxfXtUy6Ecg@mail.gmail.com>
	<4E7FF0A0.7060004@gmail.com>
	<CAGoCfizyLgpEd_ei-SYEf6WWs5cygQJNjKPNPOYOQUqF773D4Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Adding Cc: staging maintainer and mailinglist.

On Sep 26 Devin Heitmueller wrote:
> On Sun, Sep 25, 2011 at 11:25 PM, Mauro Carvalho Chehab
> <maurochehab@gmail.com> wrote:
> >> Want to see more device support upstream?  Optimize the process to
> >> make it easy for the people who know the hardware and how to write the
> >> drivers to get code upstream, and leave it to the "janitors" to work
> >> out the codingstyle issues.
> >
> > The process you've just described exists already since Sept, 2008.
> > It is called:
> >        /drivers/staging
> >
> > In summary, if you don't have a couple hours to make your driver to
> > match Kernel Coding Style, just send it as is to /drivers/staging, c/c
> > me and Greg KH, and that's it.
> 
> PULL http://kernellabs.com/hg/~dheitmueller/v4l-dvb-80e/
> PULL http://kernellabs.com/hg/~dheitmueller/v4l-dvb-as102-2/
> 
> Have fun.
> 
> The harder you make it to get code upstream, the more developers who
> will just say "to hell with this".  And *that* is why there are
> thousands of lines of working drivers which various developers have in
> out-of-tree drivers.

Hi,

perhaps a kind developer over at devel@driverdev could extract patches for
staging out of the above mercurial repositories, and then folks can work
on mainline inclusion.  (Somebody who actually has such a device might be
most motivated to do it.)

No need to get angry that it hasn't happened yet. :-)  It's just a matter
of the right people joining the effort at the right time.

Thanks Devin for the offer,
-- 
Stefan Richter
-=====-==-== =--= ==-==
http://arcgraph.de/sr/
