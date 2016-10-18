Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:47497 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750749AbcJRJNz (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 18 Oct 2016 05:13:55 -0400
Date: Tue, 18 Oct 2016 07:13:48 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Jani Nikula <jani.nikula@intel.com>
Cc: Markus Heiser <markus.heiser@darmarit.de>,
        Jonathan Corbet <corbet@lwn.net>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        linux-doc@vger.kernel.org, Joe Perches <joe@perches.com>
Subject: Re: [PATCH 1/4] doc-rst: reST-directive kernel-cmd / include
 contentent from scripts
Message-ID: <20161018071348.64550345@vento.lan>
In-Reply-To: <87lgxmxkag.fsf@intel.com>
References: <1475738420-8747-1-git-send-email-markus.heiser@darmarit.de>
        <1475738420-8747-2-git-send-email-markus.heiser@darmarit.de>
        <20161017144638.139491ad@vento.lan>
        <87lgxmxkag.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 18 Oct 2016 09:07:03 +0300
Jani Nikula <jani.nikula@intel.com> escreveu:

> On Mon, 17 Oct 2016, Mauro Carvalho Chehab <mchehab@infradead.org> wrote:
> > [PATCH] docs-rst: user: add MAINTAINERS
> >
> > including MAINTAINERS using ReST is tricky, because all
> > maintainer's entries are like:
> >
> > FOO SUBSYSTEM:
> > M: My Name <my@name>
> > L: mailing@list
> > S: Maintained
> > F: foo/bar
> >
> > On ReST, this would be displayed on a single line. Using
> > alias, like |M|, |L|, ... won't solve, as an alias in
> > Sphinx doesn't accept breaking lines.
> >
> > So, instead of changing every line at MAINTAINERS, let's
> > use kernel-cmd extension in order to parse it via a script.  
> 
> Soon I'm going to stop fighting the windmills...
> 
> If you're going to insist on getting kernel-cmd upstream (and I haven't
> changed my opinion on that) 

I also didn't change my mind that maintaining just one python script is
easier than maintaining a plead of python scripts with almost identical
contents.

In any case, if we're willing to have one Python script per each
different non-Python parser, it helps if the source code of such extensions
would be identical, except for the command line that will run the script,
as, if we find a bug on one such script, the same bug fix could be applied
to the other almost identical ones.

> please at least have the sense to have just
> *one* perl script to parse MAINTAINERS, not many. The one script should
> be scripts/get_maintainer.pl.

Agreed. get_maintainer.pl is indeed the best place to put it. I wrote
it this separate script just for a proof of concept, whose goal is to test
if the kernel-cmd extension would be properly parsing the ReST output,
and to identify what sort of output would fit best for the MAINTAINERS
database.

Thanks,
Mauro
