Return-path: <linux-media-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:37247 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752913Ab1I0TdM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 27 Sep 2011 15:33:12 -0400
Date: Tue, 27 Sep 2011 21:33:00 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: Greg KH <gregkh@suse.de>
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Mauro Carvalho Chehab <maurochehab@gmail.com>,
	Patrick Dickey <pdickeybeta@gmail.com>,
	LMML <linux-media@vger.kernel.org>, devel@driverdev.osuosl.org
Subject: Re: Staging submission: PCTV 80e and PCTV 74e drivers (was Re:
 Problems cloning the git repostories)
Message-ID: <20110927213300.6893677a@stein>
In-Reply-To: <20110927174307.GD24197@suse.de>
References: <4E7F1FB5.5030803@gmail.com>
	<CAGoCfixneQG=S5wy2qZZ50+PB-QNTFx=GLM7RYPuxfXtUy6Ecg@mail.gmail.com>
	<4E7FF0A0.7060004@gmail.com>
	<CAGoCfizyLgpEd_ei-SYEf6WWs5cygQJNjKPNPOYOQUqF773D4Q@mail.gmail.com>
	<20110927094409.7a5fcd5a@stein>
	<20110927174307.GD24197@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sep 27 Greg KH wrote:
> On Tue, Sep 27, 2011 at 09:44:09AM +0200, Stefan Richter wrote:
> > Adding Cc: staging maintainer and mailinglist.
> > 
> > On Sep 26 Devin Heitmueller wrote:
> > > On Sun, Sep 25, 2011 at 11:25 PM, Mauro Carvalho Chehab
> > > <maurochehab@gmail.com> wrote:
> > > > In summary, if you don't have a couple hours to make your driver to
> > > > match Kernel Coding Style, just send it as is to /drivers/staging, c/c
> > > > me and Greg KH, and that's it.
> > > 
> > > PULL http://kernellabs.com/hg/~dheitmueller/v4l-dvb-80e/
> > > PULL http://kernellabs.com/hg/~dheitmueller/v4l-dvb-as102-2/
> 
> I can't do that as I need some commit messages in a format we can accept
> (i.e. your directory structure doesn't match what we need in the kernel
> tree from what I can tell.)
[...]
> As the drivers don't seem to be touched in way over a year, odds are the
> code isn't going to be able to build as-is, so it will require some
> changes for basic issues.
> 
> And I'll glady accept patches for the staging tree.  Also note that
> we've just created a drivers/staging/media/ tree to house lots of
> different v4l drivers that are being worked on in the staging tree to
> help coordinate this type of work better.

The conversion into patches with proper changelog, fitting directory
structure, and basic build-ability in current staging is exactly
the first step for which a volunteer is sought (next would then be the
cleanup associated with staging->mainline transition); Devin noted that he
is not going to dedicate time for these types of tasks.  (I for one also
won't; still got plenty to do in some other drivers...)
-- 
Stefan Richter
-=====-==-== =--= ==-==
http://arcgraph.de/sr/
