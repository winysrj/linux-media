Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:47369
	"EHLO s-opensource.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751241AbcGWCZo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Jul 2016 22:25:44 -0400
Date: Fri, 22 Jul 2016 23:25:38 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Jonathan Corbet <corbet@lwn.net>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-doc@vger.kernel.org
Subject: Re: [PATCH] doc-rst: kernel-doc: fix handling of address_space tags
Message-ID: <20160722232538.6f6581ff@recife.lan>
In-Reply-To: <20160722153716.7ac9a4b6@lwn.net>
References: <263bbae9c1bf6ea7c14dad8c29f9b3148b2b5de7.1469198779.git.mchehab@s-opensource.com>
	<20160722153716.7ac9a4b6@lwn.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 22 Jul 2016 15:37:16 -0600
Jonathan Corbet <corbet@lwn.net> escreveu:

> On Fri, 22 Jul 2016 11:46:36 -0300
> Mauro Carvalho Chehab <mchehab@s-opensource.com> wrote:
> 
> > The RST cpp:function handler is very pedantic: it doesn't allow any
> > macros like __user on it:
> > [...]
> > So, we have to remove it from the function prototype.  
> 
> Sigh, this is the kind of thing where somehow there's always more moles
> to whack. 

Agreed.

> I feel like there must be a better fix, 

Well, we might create a "kernel-c" domain, I guess. I suspect we'll 
need something like that anyway, in order to handle things like
per-subsystem declarations of the syscalls (specially ioctl), but
I've no idea how difficult would be to do so.

For now, I guess that's the easiest fix.

> but I don't know what
> it is, so I've applied this, thanks.

Thank you!

> I'm trying to get my act together so that the pull request can go in
> right away once the merge window opens.  If there's anything else you
> think really needs to be there, please do let me know.

I suspect that that's it. There are a few trivial conflicts between
my tree and Daniel's one, as we both are adding new books at
Documentation/index.rst, but this is something that Stephen already
handled, and should be easy for Linus to handle as well.

Yet, if you prefer, you could pull from my docs-next branch, but
there are also lots of subsystem's patch on that, merged from
my master (stable) branch. So, if you pull from it and send to
Linus before me, you'll also be sending patches from the media
subsystem. Not really an issue, as, if Linus pull from my tree
later, he'll get only the few remains that aren't merged at my
docs-next branch.

Thanks,
Mauro
