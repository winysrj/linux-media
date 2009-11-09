Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:16156 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751073AbZKISee (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 9 Nov 2009 13:34:34 -0500
Date: Mon, 9 Nov 2009 16:33:58 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [GIT PATCHES for 2.6.32] V4L/DVB fixes
Message-ID: <20091109163358.78183665@pedra.chehab.org>
In-Reply-To: <alpine.LFD.2.01.0911091001410.31845@localhost.localdomain>
References: <20091107143757.5a9453dc@pedra.chehab.org>
	<alpine.LFD.2.01.0911091001410.31845@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 9 Nov 2009 10:02:05 -0800 (PST)
Linus Torvalds <torvalds@linux-foundation.org> escreveu:

> 
> 
> On Sat, 7 Nov 2009, Mauro Carvalho Chehab wrote:
> > 
> > Please pull from:
> >         ssh://master.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git for_linus
> 
> 	"Already up-to-date."
> 
> Forgot to push it out?

Sorry.

Should be there already.

$ git push origin
Counting objects: 911, done.
Delta compression using up to 8 threads.
Compressing objects: 100% (138/138), done.
Writing objects: 100% (648/648), 102.81 KiB, done.
Total 648 (delta 512), reused 637 (delta 502)
To ssh://master.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git
   3f48258..22370ef  for_linus -> for_linus

-- 

Cheers,
Mauro
