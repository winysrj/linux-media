Return-path: <linux-media-owner@vger.kernel.org>
Received: from tex.lwn.net ([70.33.254.29]:38008 "EHLO vena.lwn.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933808AbcJUWFp (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 21 Oct 2016 18:05:45 -0400
Date: Fri, 21 Oct 2016 16:05:43 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Markus Heiser <markus.heiser@darmarit.de>
Cc: Jani Nikula <jani.nikula@intel.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        "linux-doc@vger.kernel.org Mailing List" <linux-doc@vger.kernel.org>
Subject: Re: [PATCH 0/4] reST-directive kernel-cmd / include contentent from
 scripts
Message-ID: <20161021160543.264b8cf2@lwn.net>
In-Reply-To: <8E74FF11-208D-4C76-8A8C-2B2102E5CB20@darmarit.de>
References: <1475738420-8747-1-git-send-email-markus.heiser@darmarit.de>
        <87oa2xrhqx.fsf@intel.com>
        <20161006103132.3a56802a@vento.lan>
        <87lgy15zin.fsf@intel.com>
        <20161006135028.2880f5a5@vento.lan>
        <8737k8ya6f.fsf@intel.com>
        <8E74FF11-208D-4C76-8A8C-2B2102E5CB20@darmarit.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 11 Oct 2016 09:26:48 +0200
Markus Heiser <markus.heiser@darmarit.de> wrote:

> If the kernel-cmd directive gets acked, I will add a description to
> kernel-documentation.rst and I request Mauro to document the parse-headers.pl
> also.
> 
> But, let's hear what Jon says.

Sigh.

I've been shunting this discussion aside while I dug out from other
things.  Now I've pushed through the whole thing; I'm still not sure what
I think is the best thing to do.

kernel-cmd scares me.  It looks like the ioctl() of documentation
building; people will be able to add all kinds of wild things and it will
take a lot of attention to catch them.  I think we could make things
pretty messy in a real hurry.  And yes, I do think we should consider the
security aspects of it; we're talking about adding another shell
code-execution context in the kernel build, and that can only make things
harder to audit.

OTOH, forcing things into dedicated Sphinx extensions doesn't necessarily
fix the problem.  We're adding system calls rather than ioctl() commands,
let's say, but we're still adding long-term maintenance complications.

How many special-case commands are we going to need to run?  Does it
really need to go beyond what parse-headers is doing now?  Let's really
think about what the other use cases might be and whether we can do
without them. I'm still thoroughly unconvinced about the utility of
incorporating, say, the MAINTAINERS file into the formatted docs, for
example, so I'm not yet convinced that making that easier to do is
something we need.

Not much clarity here, sorry.

jon
