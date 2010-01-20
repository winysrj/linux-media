Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f219.google.com ([209.85.219.219]:53070 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751951Ab0ATKTr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Jan 2010 05:19:47 -0500
Received: by ewy19 with SMTP id 19so865720ewy.1
        for <linux-media@vger.kernel.org>; Wed, 20 Jan 2010 02:19:46 -0800 (PST)
Date: Wed, 20 Jan 2010 11:19:43 +0100 (CET)
From: BOUWSMA Barry <freebeer.bouwsma@gmail.com>
To: Andy Walls <awalls@radix.net>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [ANNOUNCE] git tree repositories
In-Reply-To: <1263944295.5229.16.camel@palomino.walls.org>
Message-ID: <alpine.DEB.2.01.1001201117240.10376@ybpnyubfg.ybpnyqbznva>
References: <4B55445A.10300@infradead.org>  <201001190853.11050.hverkuil@xs4all.nl>  <201001190910.39479.pboettcher@kernellabs.com> <1263944295.5229.16.camel@palomino.walls.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Moin Andy,

On Tue, 19 Jan 2010, Andy Walls wrote:

> On Tue, 2010-01-19 at 09:10 +0100, Patrick Boettcher wrote:
> 
> > BTW: I just made a clone of the git-tree - 365MB *ouff*.
> 
> Assuming 53.333 kbps download speed, 0% overhead, no compression:
> 
> 365 MiB * 2^20 bytes/MiB * 8 bits/byte / 53333 bits/sec / 3600 sec/hr =
> 15.95 hours
> 
> :(

Wow, that's about twice as fast as my first clone of the 
various SCM trees, mostly with CVSup, many years ago, after
leaving the world of high-speedLand.  Actually, when I made
my first git kernel clone, I think it was less than 100MB
yet still elicited the same astoundment I see now.

And basically I did dial in and let all the checkouts run
overnight from whichever provider was affordable, back when
the per-minute costs were ten to 100 times what I see today.

Although many other BSD full trees were updates of changes
that had then occurred in five years, and CVSup/rsync and
the like can do the work in bits and pieces.



> Can git resume aborted clones?  It could be many weeks before I have a
> 20 hour window where I don't have to use my land line phone for voice...

Unfortunately, my experience has been no, both in initial
checkouts, and in large updates -- if I go for a month without
pulling Linus' latest changes, with the poor connectivity I
have, sometimes it will take three or four attempts until I
can get all those handful of megabytes of chunks intact at
once.

Worse is if your ISP has you on a configuration that doesn't
preserve your IP for the duration of your download, changing
it every few minutes, or hours, as is a common practice to
keep customers from running servers or doing anything useful.
The net was made for surfing, not downloading, dammit.


I am writing from the point of view of a beginner who knows
nothing about the advantages of `git' or `hg' or `svn' and
friends and who only wants to clone the entire development
tree locally for off-line work with access to any point of
development, and as such I don't know of any possible expert
flags like ``--partial'' or something to instruct `git' not
to discard any complete or partial chunks.  In fact, I don't 
remember if I downloaded the original kernel in any special way, 
such as a .tbz file to be used as a base and then updated from 
there.  So don't take my word as gospel.


barry bouwsma
in the middle of an aborted-after-four-hours update of FreeBSD 
during the bandwidth-hungry ``fixup'' process that thanks to 
their accursed move to `svn' seems to take much longer than just
pulling the deltas alone, but luckily which I can resume once I
get ``better'' connectivity and not lose much of anything.
grumble mumble old fart grumble
