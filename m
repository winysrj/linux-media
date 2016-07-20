Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:47052
	"EHLO s-opensource.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752072AbcGTAIO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Jul 2016 20:08:14 -0400
Date: Tue, 19 Jul 2016 21:08:08 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Jonathan Corbet <corbet@lwn.net>
Cc: Markus Heiser <markus.heiser@darmarit.de>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-doc@vger.kernel.org, Jani Nikula <jani.nikula@intel.com>
Subject: Re: Troubles with kernel-doc and RST files
Message-ID: <20160719210808.4fd591cb@recife.lan>
In-Reply-To: <20160719170133.416c94d8@lwn.net>
References: <20160717100154.64823d99@recife.lan>
	<20160719170133.416c94d8@lwn.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 19 Jul 2016 17:01:33 -0600
Jonathan Corbet <corbet@lwn.net> escreveu:

> On Sun, 17 Jul 2016 10:01:54 -0300
> Mauro Carvalho Chehab <mchehab@s-opensource.com> wrote:
> 
> > 2) For functions, kernel-doc is now an all or nothing. If not all
> > functions are declared, it outputs this warning:
> > 
> > 	./include/media/media-devnode.h:1: warning: no structured comments
> > 
> > And give up. No functions are exported, nor it points where it bailed.
> > So, we need to manually look into all exported symbols to identify
> > what's missing  
> 
> So could you describe this one in a bit more detail?  An example of a
> file with the problem and associated kernel-doc directive would be most
> helpful here.  This sounds like something we definitely want to fix.

I actually noticed it when I was checking for the documentation generated
by the RC header file. There, I had to add documentation for several
functions:
	https://git.linuxtv.org/media_tree.git/commit/?h=docs-next&id=5b6137dc84f627e8497e554890ae02378c54f9f0

Without that, I had an error like the above, and no functions were
documented.

I didn't further tried to investigate the root cause.

One thing I noticed is that Sphinx is very poor on detecting some types
of changes, and we need to wipe out the Sphinx docs after some changes, 
as otherwise the document won't be ok. Maybe that's the case.

Another possibility is that the all or nothing behavior happens when
the :export: attribute is used.


Thanks,
Mauro
