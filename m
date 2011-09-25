Return-path: <linux-media-owner@vger.kernel.org>
Received: from bar.sig21.net ([80.81.252.164]:55774 "EHLO bar.sig21.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751329Ab1IYSDo (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 25 Sep 2011 14:03:44 -0400
Date: Sun, 25 Sep 2011 20:03:40 +0200
From: Johannes Stezenbach <js@linuxtv.org>
To: Patrick Dickey <pdickeybeta@gmail.com>
Cc: LMML <linux-media@vger.kernel.org>
Subject: Re: Problems cloning the git repostories
Message-ID: <20110925180340.GB23820@linuxtv.org>
References: <4E7F1FB5.5030803@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E7F1FB5.5030803@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Sep 25, 2011 at 07:33:57AM -0500, Patrick Dickey wrote:
> 
> I tried to follow the steps for cloning both the "media_tree.git" and
> "media_build.git" repositories, and received errors for both.  The
> media_tree repository failed on the first line
> 
> > git clone git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git v4l-dvb 
> 
> which I'm assuming is because kernel.org is down.
> 
> The media_build.git repository fails on the first line also
> 
> > git clone git://linuxtv.org/media_build.git 
> 
> with a fatal: read error: Connection reset by peer.

The git error should be fixed now.

But please don't clone from linuxtv.org, intead use
git clone git://github.com/torvalds/linux.git
and then add linuxtv to your repo like described on
http://git.linuxtv.org/media_tree.git


Johannes
