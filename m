Return-path: <linux-media-owner@vger.kernel.org>
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:55410 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752049AbbL1Pdf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 28 Dec 2015 10:33:35 -0500
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
	by mailout.nyi.internal (Postfix) with ESMTP id 82AB820817
	for <linux-media@vger.kernel.org>; Mon, 28 Dec 2015 10:33:34 -0500 (EST)
Date: Mon, 28 Dec 2015 07:33:32 -0800
From: Greg KH <greg@kroah.com>
To: Andrey Utkin <andrey.utkin@corp.bluecherry.net>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	kernel-janitors <kernel-janitors@vger.kernel.org>,
	"kernel-mentors@selenic.com" <kernel-mentors@selenic.com>,
	Linux Media <linux-media@vger.kernel.org>,
	devel@driverdev.osuosl.org, andrey.od.utkin@gmail.com
Subject: Re: On Lindent shortcomings and massive style fixing
Message-ID: <20151228153332.GA6159@kroah.com>
References: <CAM_ZknVmAnoa=+BA9Q+BSJ_dKwtBWWXHqZyJ_BH=FppqGLpFUg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAM_ZknVmAnoa=+BA9Q+BSJ_dKwtBWWXHqZyJ_BH=FppqGLpFUg@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Dec 28, 2015 at 04:33:27PM +0200, Andrey Utkin wrote:
> After some iterations of checkpatch.pl, on a new developed driver
> (tw5864), now I have the following:
> 
>  $ grep 'WARNING\|ERROR' /src/checkpatch.tw5864 | sort | uniq -c
>      31 ERROR: do not use C99 // comments
>     147 WARNING: Block comments use a trailing */ on a separate line
>     144 WARNING: Block comments use * on subsequent lines
>     435 WARNING: line over 80 characters
> 
> At this point, Lindent was already used, and checkpatch.pl warnings
> introduced by Lindent itself were fixed. Usage of "indent
> --linux-style" (which behaves differently BTW) doesn't help anymore,
> too.
> 
> Could anybody please advise how to sort out these issues
> automatically, because they look like perfectly solvable in automated
> fashion. Of course manual work would result in more niceness, but I am
> not eager to go through hundreds of place of code just to fix "over 80
> characters" issues now.

Shouldn't take very long to do so, all of the above can be fixed in less
than a day's worth of work manually.  Or you can use indent to fix up
the line length issues, but watch out for the results, sometimes it's
better to refactor the code than to just blindly accept the output of
that tool.

good luck!

greg k-h
