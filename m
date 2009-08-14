Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:34074 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752486AbZHNCxK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 13 Aug 2009 22:53:10 -0400
Date: Thu, 13 Aug 2009 23:53:03 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Brandon Philips <brandon@ifup.org>
Cc: linux-media@vger.kernel.org, jayakumar.lkml@gmail.com, mag@mag.cx
Subject: Re: [PATCH] quickcam_messenger.c: add support for all quickcam
 Messengers of the same family
Message-ID: <20090813235303.2ff66400@caramujo.chehab.org>
In-Reply-To: <20090808012135.GA11251@jenkins.home.ifup.org>
References: <20081202223854.GA5770@jenkins.ifup.org>
	<20090808012135.GA11251@jenkins.home.ifup.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Brandon,

Em Fri, 7 Aug 2009 18:21:35 -0700
Brandon Philips <brandon@ifup.org> escreveu:

> Hey Mauro-
> 
> I sent this patch long ago and it seemed to have gotten lost along the
> way.
> 
> Jaya acked the patch so it is in my mercurial tree now:
> 
>  http://ifup.org/hg/v4l-dvb/
>  http://ifup.org/hg/v4l-dvb/rev/335a6ccbacb3
> 
> Please pull the patch when you get a chance.

Please add a [PULL] tag on pull requests, for it to be properly catched by my
scripts.

If you add [PATCH] instead, it will be moved to a special inbox that I
generally read only when analyzing Patchwork queue. In this specific case, as
your email doesn't have any patch, it will be silently ignored by Patchwork.
So, sending it like this is close to send it to /dev/null :)

Anyway, I've re-queued your pull request to my pile of pull's. I'll be handling
it shortly.


Cheers,
Mauro
