Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f219.google.com ([209.85.219.219]:52411 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754755AbZLBANz (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 1 Dec 2009 19:13:55 -0500
Received: by ewy19 with SMTP id 19so5575476ewy.21
        for <linux-media@vger.kernel.org>; Tue, 01 Dec 2009 16:14:01 -0800 (PST)
Date: Wed, 2 Dec 2009 01:13:54 +0100
From: Domenico Andreoli <cavokz@gmail.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Replace Mercurial with GIT as SCM
Message-ID: <20091202001354.GA32247@raptus.dandreoli.com>
References: <alpine.LRH.2.00.0912011003480.30797@pub3.ifh.de>
 <1259709900.3102.3.camel@palomino.walls.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1259709900.3102.3.camel@palomino.walls.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Dec 01, 2009 at 06:25:00PM -0500, Andy Walls wrote:
> On Tue, 2009-12-01 at 15:59 +0100, Patrick Boettcher wrote:
> > Hi all,
> > 
> > I would like to start a discussion which ideally results in either 
> > changing the SCM of v4l-dvb to git _or_ leaving everything as it is today 
> > with mercurial.
> > 
> 
> > I'm waiting for comments.
> 
> I only have one requirement: reduce bandwidth usage between the server
> and my home.
> 
> The less I have to clone out 65 M of history to start a new series of
> patches the better.  I suppose that would include a rebase...

no, it would not. in case you feel better to clone something before a
rebase, you can clone it locally.

rebasing is an easily abused practice which destroys the history of
a branch and puts in trouble the followers of that branch. published
branch which is often rebased is usually frown upon.

git is a branch-merge-branch-throw-away-branch-branch-merge-... tool.
commit massaging is another tempting practice, it's so easy to produce a
cleaned up history of your branch. writing code in 2D is already pretty
difficult, God save us from writing code in 3D.

cheers,
Domenico

-----[ Domenico Andreoli, aka cavok
 --[ http://www.dandreoli.com/gpgkey.asc
   ---[ 3A0F 2F80 F79C 678A 8936  4FEE 0677 9033 A20E BC50
