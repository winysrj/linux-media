Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:60909 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752002Ab2HQLvd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Aug 2012 07:51:33 -0400
Received: by ialo24 with SMTP id o24so748919ial.19
        for <linux-media@vger.kernel.org>; Fri, 17 Aug 2012 04:51:32 -0700 (PDT)
Message-ID: <1345204225.1800.73.camel@dcky-ubuntu64>
Subject: Preferred setup for development?
From: Patrick Dickey <pdickeybeta@gmail.com>
Reply-To: pdickeybeta@gmail.com
To: linux-media@vger.kernel.org
Date: Fri, 17 Aug 2012 06:50:25 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I'm looking for information about what distributions people are using,
and how they go about testing their code.  The reason is, I'm running
Ubuntu for my main distribution, and it seems like I'll have to go
through a lot of hoops in order to compile and test changes to the
kernel.  I realize that I could probably just use the media_build tree,
and add the changes there.  But, I'd prefer to go the same route that
the majority of the developers here do.

So, my questions are these:

1.  Do you use a specific distribution for development, or a roll your
own (like Linux from Scratch)?
2.  If you use a distribution, which one?
3.  Do you do your development on physical computers or on virtual
machines (or both)?
4.  Do you have a machine that's dedicated to development, or is it one
that you use for other things?
5.  Do you use a newer computer, or older computer for development? (or
both)

For anyone using the media_build tree (instead of the media_git tree):

Are you able to seamlessly implement changes that are in the media_git
tree files to the media_build tree, or do you have to make changes in
order to get them to compile? 

Are your files able to be implemented into the media_git tree
seamlessly, or do you have to make changes to get them to compile?

If you're able to use the media_build tree, and the changes you make can
be implemented in the media_git tree without hassle, I may go that route
instead.

I downloaded a Slackware DVD, as it appears to be one that you can "roll
your own kernel" without too much of a hassle. But, I want to get
people's opinions before I start.

Thanks to everyone who responds, and have a great day:)
Patrick.

