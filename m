Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail3.sea5.speakeasy.net ([69.17.117.5]:51364 "EHLO
	mail3.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752231AbZLATtR (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 1 Dec 2009 14:49:17 -0500
Date: Tue, 1 Dec 2009 11:49:22 -0800 (PST)
From: Trent Piepho <xyzzy@speakeasy.org>
To: Patrick Boettcher <pboettcher@kernellabs.com>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Replace Mercurial with GIT as SCM
In-Reply-To: <alpine.LRH.2.00.0912011003480.30797@pub3.ifh.de>
Message-ID: <Pine.LNX.4.58.0912011141340.4729@shell2.speakeasy.net>
References: <alpine.LRH.2.00.0912011003480.30797@pub3.ifh.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 1 Dec 2009, Patrick Boettcher wrote:
> To start right away: I'm in favour of using GIT because of difficulties I
> have with my "daily" work with v4l-dvb. It is in my nature do to mistakes,
> so I need a tool which assists me in fixing those, I have not found a
> simple way to do my stuff with HG.

Try the mq extension.  It's included by default with mercurial, you just
need to add:
[extensions]
hgext.mq=
to your .hgrc file.  It lets you maintain a stack of patches that you can
freely push and pop.  You can make changes and then commit them to one of
the existing patches.  Like git commit -amend, except you can amend any
patch not just the last one.  IMHO, it's better than stock git when you're
trying to make a good patch series.  There is something called stgit which
is very much like mq and a little better I think.
