Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56584 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751530AbZDGBNj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 6 Apr 2009 21:13:39 -0400
Date: Mon, 6 Apr 2009 18:11:34 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [GIT PATCHES for 2.6.30] V4L/DVB updates
In-Reply-To: <20090406215632.3eb96373@pedra.chehab.org>
Message-ID: <alpine.LFD.2.00.0904061808580.4010@localhost.localdomain>
References: <20090406215632.3eb96373@pedra.chehab.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On Mon, 6 Apr 2009, Mauro Carvalho Chehab wrote:
> 
> Please pull from:
>         ssh://master.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git for_linus

Have you rebased your tree and pushed out multiple versions of it?

I'm getting very confusing things from the mirrors, which are subtly 
different from the copy on master.

This all looks like it was rebased just hours ago, and to top it off, it 
looks like you actually change stuff you had exported earlier.

Don't do that. Really. It's very annoying. More than annoying, in fact. 
This had better simply not happen again!

		Linus
