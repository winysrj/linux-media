Return-path: <linux-media-owner@vger.kernel.org>
Received: from bar.sig21.net ([80.81.252.164]:46995 "EHLO bar.sig21.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751348Ab1IZTYp (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Sep 2011 15:24:45 -0400
Date: Mon, 26 Sep 2011 21:24:39 +0200
From: Johannes Stezenbach <js@linuxtv.org>
To: Scott Jiang <scott.jiang.linux@gmail.com>
Cc: Mauro Carvalho Chehab <maurochehab@gmail.com>,
	Patrick Dickey <pdickeybeta@gmail.com>,
	LMML <linux-media@vger.kernel.org>
Subject: Re: Problems cloning the git repostories
Message-ID: <20110926192439.GA4848@linuxtv.org>
References: <4E7F1FB5.5030803@gmail.com>
 <20110925180340.GB23820@linuxtv.org>
 <4E7FE9E8.3010404@gmail.com>
 <CAHG8p1Dk=wtM7vpZNhYyw7GUvWpB3jK_6pghxpDHpjMWk6W56w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHG8p1Dk=wtM7vpZNhYyw7GUvWpB3jK_6pghxpDHpjMWk6W56w@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Sep 26, 2011 at 06:15:07PM +0800, Scott Jiang wrote:
> 2011/9/26 Mauro Carvalho Chehab <maurochehab@gmail.com>:
> > Em 25-09-2011 15:03, Johannes Stezenbach escreveu:
> >>
> >> But please don't clone from linuxtv.org, intead use
> >> git clone git://github.com/torvalds/linux.git
> >> and then add linuxtv to your repo like described on
> >> http://git.linuxtv.org/media_tree.git
> >
> > I've updated the instructions together with the git tree to point to the
> > github tree.
> >
> I followed your instructions using http instead, but I found it's not
> up to date.

What I meant is the follow the instructions on the
http://git.linuxtv.org/media_tree.git web page,
to use git:// protocol:

  git remote add linuxtv git://linuxtv.org/media_tree.git
  git remote update
  git checkout -b media-master remotes/linuxtv/staging/for_v3.2

Anyway, I did the git update-server-info thing so http should
work, too.  But git over http sucks, if you can then use git protocol.


Johannes		    
