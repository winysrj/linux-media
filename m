Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.telros.ru ([83.136.244.21]:64299 "EHLO mail.telros.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751742Ab2ELGBF (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 12 May 2012 02:01:05 -0400
Date: Sat, 12 May 2012 10:01:02 +0400
From: volokh@telros.ru
To: Ezequiel Garcia <elezegarcia@gmail.com>
Cc: linux-media <linux-media@vger.kernel.org>
Subject: Re: [PATCH] staging: media: go7007: Adlink MPG24 board issues
Message-ID: <20120512060101.GA16714@VPir.telros.lan>
References: <1336714980-13460-1-git-send-email-volokh84@gmail.com>
 <4FAD1FAD.4020508@gmail.com>
 <20120511164907.GA16306@VPir.telros.lan>
 <CALF0-+Xc6cA9Myt05yWCFFnYMuynTQO8NNs5JEcD7Gc8bMw2WA@mail.gmail.com>
 <20120511170625.GB16306@VPir.telros.lan>
 <CALF0-+WG8aCSh0Kfxy65nQ=OOnE1xUSTKQv7APofOuOC97ez8A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALF0-+WG8aCSh0Kfxy65nQ=OOnE1xUSTKQv7APofOuOC97ez8A@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, May 11, 2012 at 07:07:38PM -0300, Ezequiel Garcia wrote:
> On Fri, May 11, 2012 at 2:06 PM,  <volokh@telros.ru> wrote:
> >>
> >> One question... shouldn't this changeset be splitted into shorter patches?
> >>
> >
> > Yes, should it.
> > In next iteration i`ll learn how to do that.
> 
> As a git newbie I've found very useful to work like this:
> 
> 1. Always work on a branch that's different from master
> that way you can always do
> 
> git-rebase --interactive master
> 
> and quickly review your commits or even rewrite them.
> 
> 2. If unsure on changeset, add files interactively
> to stage area (aka the index) with
> 
> git-add --patch
> 
> 3. Once you've commit a few stuff, you can simply
> turn them into patches with
> 
> git-format-patch master.
> 
> This way it's very easy to split a change into patches.
> And with git rebase it's very easy to review and clean
> commits, to get a cleaner set of patches to keep
> maintainers happy.
> 
> Just my two cents,
> Hope it helps,
> Ezequiel.
OOh! Very thanks for good idea!
