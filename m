Return-path: <linux-media-owner@vger.kernel.org>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:52950 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751061Ab0EWUMn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 23 May 2010 16:12:43 -0400
Subject: Re: Q: Setting up a GIT repository on linuxtv.org
From: Andy Walls <awalls@md.metrocast.net>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-media@vger.kernel.org
In-Reply-To: <4BF9756E.2020507@redhat.com>
References: <1274635044.2275.11.camel@localhost>
	 <4BF9756E.2020507@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 23 May 2010 16:12:38 -0400
Message-ID: <1274645558.2275.20.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 2010-05-23 at 15:35 -0300, Mauro Carvalho Chehab wrote:
> Andy Walls wrote:
> > Hi,
> > 
> > I'm a GIT idiot, so I need a little help on getting a properly setup
> > repo at linuxtv.org.  Can someone tell me if this is the right
> > procedure:
> > 
> > $ ssh -t awalls@linuxtv.org git-menu
> >         (clone linux-2.6.git naming it v4l-dvb  <-- Is this right?)
> 
> Whatever name you choose. v4l-dvb is just a suggestion. 

OK.  So cloning /linuxtv.org/git/linux-2.6.git, and not
the /linuxtv.org/git/v4l-dvb.git, with git-menu is the proper way to set
up a tree on linuxtv.org, correct?.

(git push didn't work right if I cloned /linuxtv.org/git/v4l-dvb.git
with git-menu.  I got an error message about'fast-forward' commits and
not losing data.)


> The last changes are currently at devel/for_v2.6.34 (with some patches that will
> go soon to upstream). So, in order to work against them, you would need to use,
> instead:
> 
> 	$ git checkout -b cxfoo linuxtv/devel/for_v2.6.34

OK. Thanks!

Regards,
Andy


