Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:63202 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752516Ab1J3VJ7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 30 Oct 2011 17:09:59 -0400
Received: by bkbzt4 with SMTP id zt4so1642214bkb.19
        for <linux-media@vger.kernel.org>; Sun, 30 Oct 2011 14:09:57 -0700 (PDT)
From: Marek Vasut <marek.vasut@gmail.com>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Subject: Re: Problems cloning the git repostories
Date: Sun, 30 Oct 2011 22:09:55 +0100
Cc: Patrick Dickey <pdickeybeta@gmail.com>,
	LMML <linux-media@vger.kernel.org>
References: <4E7F1FB5.5030803@gmail.com> <CAGoCfixneQG=S5wy2qZZ50+PB-QNTFx=GLM7RYPuxfXtUy6Ecg@mail.gmail.com>
In-Reply-To: <CAGoCfixneQG=S5wy2qZZ50+PB-QNTFx=GLM7RYPuxfXtUy6Ecg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201110302209.55418.marek.vasut@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> On Sun, Sep 25, 2011 at 8:33 AM, Patrick Dickey <pdickeybeta@gmail.com> wrote:
> > Hello there,
> > 
> > I tried to follow the steps for cloning both the "media_tree.git" and
> > "media_build.git" repositories, and received errors for both.  The
> > media_tree repository failed on the first line
> > 
> >> git clone
> >> git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
> >> v4l-dvb
> > 
> > which I'm assuming is because kernel.org is down.
> > 
> > The media_build.git repository fails on the first line also
> > 
> >> git clone git://linuxtv.org/media_build.git
> > 
> > with a fatal: read error: Connection reset by peer.
> > 
> > Is it possible to clone either (or both) repositories at this time, or
> > are they down?  And in the absence of cloning the kernel for the
> > media_tree.git repository, is it possible to simply clone the
> > git://linuxtv.org/media_tree.git repository and work from that?
> > 
> > My interest in this is to install some patches created by Devin
> > Heitmueller for the Pinnacle PCTV 80e USB tuner (at least the ATSC
> > portion of the tuner). Once I'm able to determine exactly what changes
> > are made, I would like to either submit the patches to the repository,
> > or send them to someone who has more experience in patching the files
> > for submission.
> > 
> > One other question (totally unrelated to this post though): When I send
> > emails, normally they are GPG signed. Should I disable that for this
> > list, or is it acceptable?
> > 
> > Thank you for any information, and have a great day:)
> > Patrick.
> 
> Hi Patrick,
> 
> As I said on the blog, the issue isn't getting the driver to work
> against current kernels.  Merging the driver against the current tree
> is a trivial exercise (the patch series should apply trivially against
> the current code, with only a few minor conflicts related to board
> numbers, etc).
> 
> The bigger issue though is once you do that and have the driver
> running, you now have a body of code > 10,000 lines which doesn't meet
> the "coding standards".  Doing such a refactoring is a relatively
> straightforward exercise but very time consuming (you already have a
> working driver, so you just have to make sure you don't break
> anything).
> 
> The more I think about this, the more it annoys me.  I did all the hard
> parts:
> 
> * I worked with the product vendor to get the details for the design
> * I got Hauppauge/PCTV to compel the chipset vendor to release the
> reference code under a GPL compatible license
> * I worked out redistribution terms on the firmware
> * I ported the driver to Linux
> * I integrated the driver and debugged it to achieve signal lock
> 
> And why is it not in the mainline?  Because none of the above matters
> if I didn't waste a bunch of my time removing a bunch of "#ifdef
> WINDOWS" lines and converting whitespace from tabs to spaces.
> 
> It's crap like this that's the reason why some of the best LinuxTV
> driver authors still have a bunch of stuff that isn't merged upstream.
>  We just don't have time for this sort of bullshit that any monkey
> could do if he/she was willing to invest the effort.  We're just too
> busy doing *actual* driver work.
> 
> Five years ago the hard part was finding competent developers, getting
> access to datasheets, getting access to reference driver code, and
> getting access to the details for a hardware design.  Now most of
> those problems are not the issue - we have access to all the data but
> we want to waste the time of the few competent developers out there
> making them do "coding style cleanup" before perfectly good code gets
> merged upstream.  There has been more than one case where I've
> considered doing a driver for a new board and decided against it
> because the barrier to getting it upstream is not worth my time.
> 
> Want to see more device support upstream?  Optimize the process to
> make it easy for the people who know the hardware and how to write the
> drivers to get code upstream, and leave it to the "janitors" to work
> out the codingstyle issues.

Mate, I feel sorry for you :-(
