Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f209.google.com ([209.85.219.209]:41046 "EHLO
	mail-ew0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751930Ab0ATLn0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Jan 2010 06:43:26 -0500
Received: by ewy1 with SMTP id 1so2788350ewy.28
        for <linux-media@vger.kernel.org>; Wed, 20 Jan 2010 03:43:24 -0800 (PST)
Date: Wed, 20 Jan 2010 12:43:21 +0100 (CET)
From: BOUWSMA Barry <freebeer.bouwsma@gmail.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
cc: Andy Walls <awalls@radix.net>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [ANNOUNCE] git tree repositories
In-Reply-To: <4B56788B.907@infradead.org>
Message-ID: <alpine.DEB.2.01.1001201202400.10376@ybpnyubfg.ybpnyqbznva>
References: <4B55445A.10300@infradead.org>  <201001190853.11050.hverkuil@xs4all.nl>  <201001190910.39479.pboettcher@kernellabs.com> <1263944295.5229.16.camel@palomino.walls.org> <4B56788B.907@infradead.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 20 Jan 2010, Mauro Carvalho Chehab wrote:

> Andy Walls wrote:
> > On Tue, 2010-01-19 at 09:10 +0100, Patrick Boettcher wrote:
> > 
> >> BTW: I just made a clone of the git-tree - 365MB *ouff*.
> > 
> > Assuming 53.333 kbps download speed, 0% overhead, no compression:
> > 
> > 365 MiB * 2^20 bytes/MiB * 8 bits/byte / 53333 bits/sec / 3600 sec/hr =
> > 15.95 hours
> 
> It is an one time download, since, once you got it, the updates are cheap.

Getting a bit off-topic here, but hey....

Yes, but it is that first step of getting the download that is
the problem.

Until the tree ends up with a conflicted merge (has happened to
me a few times), and then a beginner such as myself has no idea
what to do and pushes the tree out of the way and starts anew
(or decides to give up on the tree that's no longer so much of
interest), but that's when I've had better connectivity than
Sir Walls here.


A big problem I see and which will affect the majority of people
on less-than-ideal connections is that the initial clone is that
the `git clone' for such a large tree is not something you can
pick up if interrupted in the middle.  I'd hate to be in Andy's
house as he's drenched with sweat clenching the arms of his
chair watching the progress bar go from 98% to 99% to
^%{3f{NO CARRIER as someone on his party line down the road
picks up the phone to chat with their sister in the next room.
Actually, that's not true, I'd love to hear it as I'm sure there
are a good variety of swear words I haven't learned from the time
I had me mouth washed out with Irish Spring, carried on to this
day by gargling every evening with Fairy Liquid.



> Btw, it is a way small than a single CD needed for you to install Linux.

But `wget' has an option to resume the download, even if it takes
a week to get the entire CD as it did me.  Or better, as I used,
`jigdo' which splits the download even further, automagically
uses `wget' in shortened `retry' mode, and allows me to get the
missing parts elsewhere -- before, like `git' or other SCM
frontends, getting incremental updates.

That is what seems to be missing from `git', in spite of its
other advantages over `rsync' or `CVSup', for an initial download.


> If you want to get it and you're not willing to pay to a decent Internet
> connection, just ask someone to get it for you and save on a CD.

This is not a good attitude to have -- I have been in places with
no practical internet connection and places where it was not worth
it to pay for a ``decent'' connection.  Still, I tried to get on-
line when possible.

You are also working with volunteers who are putting out their own
money to get connectivity.  I'm sure that I am not the only one on
the list who is unable to get a satisfactory decent-paying job at
present, but who is willing to donate time and some resources to
advance Linux and other free software.  To do so I rely on more
fortunate friends who can afford a decent connection, when most of
my usage wouldn't even be noticed on a dial-up connection.


Sorry, I'm just ranting.  Ignore me.  Or I'll blow you all 
sky-high after a week.

barry bouwsma
no-fly zone, until spring
