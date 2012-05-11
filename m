Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:55204 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946251Ab2EKWHi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 May 2012 18:07:38 -0400
Received: by obbtb18 with SMTP id tb18so3805624obb.19
        for <linux-media@vger.kernel.org>; Fri, 11 May 2012 15:07:38 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20120511170625.GB16306@VPir.telros.lan>
References: <1336714980-13460-1-git-send-email-volokh84@gmail.com>
	<4FAD1FAD.4020508@gmail.com>
	<20120511164907.GA16306@VPir.telros.lan>
	<CALF0-+Xc6cA9Myt05yWCFFnYMuynTQO8NNs5JEcD7Gc8bMw2WA@mail.gmail.com>
	<20120511170625.GB16306@VPir.telros.lan>
Date: Fri, 11 May 2012 19:07:38 -0300
Message-ID: <CALF0-+WG8aCSh0Kfxy65nQ=OOnE1xUSTKQv7APofOuOC97ez8A@mail.gmail.com>
Subject: Re: [PATCH] staging: media: go7007: Adlink MPG24 board issues
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: volokh@telros.ru
Cc: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, May 11, 2012 at 2:06 PM,  <volokh@telros.ru> wrote:
>>
>> One question... shouldn't this changeset be splitted into shorter patches?
>>
>
> Yes, should it.
> In next iteration i`ll learn how to do that.

As a git newbie I've found very useful to work like this:

1. Always work on a branch that's different from master
that way you can always do

git-rebase --interactive master

and quickly review your commits or even rewrite them.

2. If unsure on changeset, add files interactively
to stage area (aka the index) with

git-add --patch

3. Once you've commit a few stuff, you can simply
turn them into patches with

git-format-patch master.

This way it's very easy to split a change into patches.
And with git rebase it's very easy to review and clean
commits, to get a cleaner set of patches to keep
maintainers happy.

Just my two cents,
Hope it helps,
Ezequiel.
