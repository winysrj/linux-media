Return-path: <linux-media-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:36709 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750965Ab1I0RpN (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 27 Sep 2011 13:45:13 -0400
Date: Tue, 27 Sep 2011 10:43:07 -0700
From: Greg KH <gregkh@suse.de>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>,
	Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: Mauro Carvalho Chehab <maurochehab@gmail.com>,
	Patrick Dickey <pdickeybeta@gmail.com>,
	LMML <linux-media@vger.kernel.org>, devel@driverdev.osuosl.org
Subject: Re: Staging submission: PCTV 80e and PCTV 74e drivers (was Re:
 Problems cloning the git repostories)
Message-ID: <20110927174307.GD24197@suse.de>
References: <4E7F1FB5.5030803@gmail.com>
 <CAGoCfixneQG=S5wy2qZZ50+PB-QNTFx=GLM7RYPuxfXtUy6Ecg@mail.gmail.com>
 <4E7FF0A0.7060004@gmail.com>
 <CAGoCfizyLgpEd_ei-SYEf6WWs5cygQJNjKPNPOYOQUqF773D4Q@mail.gmail.com>
 <20110927094409.7a5fcd5a@stein>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20110927094409.7a5fcd5a@stein>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Sep 27, 2011 at 09:44:09AM +0200, Stefan Richter wrote:
> Adding Cc: staging maintainer and mailinglist.
> 
> On Sep 26 Devin Heitmueller wrote:
> > On Sun, Sep 25, 2011 at 11:25 PM, Mauro Carvalho Chehab
> > <maurochehab@gmail.com> wrote:
> > >> Want to see more device support upstream?  Optimize the process to
> > >> make it easy for the people who know the hardware and how to write the
> > >> drivers to get code upstream, and leave it to the "janitors" to work
> > >> out the codingstyle issues.
> > >
> > > The process you've just described exists already since Sept, 2008.
> > > It is called:
> > >        /drivers/staging
> > >
> > > In summary, if you don't have a couple hours to make your driver to
> > > match Kernel Coding Style, just send it as is to /drivers/staging, c/c
> > > me and Greg KH, and that's it.
> > 
> > PULL http://kernellabs.com/hg/~dheitmueller/v4l-dvb-80e/
> > PULL http://kernellabs.com/hg/~dheitmueller/v4l-dvb-as102-2/

I can't do that as I need some commit messages in a format we can accept
(i.e. your directory structure doesn't match what we need in the kernel
tree from what I can tell.)

> > Have fun.
> > 
> > The harder you make it to get code upstream, the more developers who
> > will just say "to hell with this".  And *that* is why there are
> > thousands of lines of working drivers which various developers have in
> > out-of-tree drivers.

The Linux patch process is one of the easiest, and most well-documented
for any open source project that I have ever seen.

If you don't agree (and that's fine if you don't), any ideas on what we
can do to make it better would be glady appreciated.

> perhaps a kind developer over at devel@driverdev could extract patches for
> staging out of the above mercurial repositories, and then folks can work
> on mainline inclusion.  (Somebody who actually has such a device might be
> most motivated to do it.)

As the drivers don't seem to be touched in way over a year, odds are the
code isn't going to be able to build as-is, so it will require some
changes for basic issues.

And I'll glady accept patches for the staging tree.  Also note that
we've just created a drivers/staging/media/ tree to house lots of
different v4l drivers that are being worked on in the staging tree to
help coordinate this type of work better.

thanks,

greg k-h
