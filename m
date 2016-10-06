Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:60269 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751137AbcJFNbk (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 6 Oct 2016 09:31:40 -0400
Date: Thu, 6 Oct 2016 10:31:32 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Jani Nikula <jani.nikula@intel.com>
Cc: Markus Heiser <markus.heiser@darmarit.de>,
        Jonathan Corbet <corbet@lwn.net>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH 0/4] reST-directive kernel-cmd / include contentent from
 scripts
Message-ID: <20161006103132.3a56802a@vento.lan>
In-Reply-To: <87oa2xrhqx.fsf@intel.com>
References: <1475738420-8747-1-git-send-email-markus.heiser@darmarit.de>
        <87oa2xrhqx.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 06 Oct 2016 11:42:14 +0300
Jani Nikula <jani.nikula@intel.com> escreveu:

> On Thu, 06 Oct 2016, Markus Heiser <markus.heiser@darmarit.de> wrote:
> > with this series a reST-directive kernel-cmd is introduced. The kernel-cmd
> > directive includes contend from the stdout of a command-line (@mchehab asked
> > for).  

Ok, I ran some tests here and it works as expected.

> I like the fact that this removes Documentation/media/Makefile, and
> cleans up the Sphinx build rule in Documentation/Makefile.sphinx.

Yeah, that sounds great.

> Does
> this also make the documentation buildable with sphinx-build directly,
> without the kernel build system? If so, great.

I guess it probably allows that, if you include the extension on
some other tree.

Just curious here: what use case do you see by building the Kernel
documentation without the Kernel tree?

> However, I would have much preferred the approach I proposed months ago,
> having the extension itself do specifically what parse-headers.pl does
> now. While it may seem generic on the surface, I don't think it's a
> clean or a secure approach to allow running of arbitrary scripts from
> PATH while building documentation. It's certainly not an approach that
> should be encouraged.

Sorry, but I disagree. The security threat of having a random command
doing something wrong is the same as we already have with the Kernel
Makefiles, as they can also run a random command. All it is needed
is to add this to a Makefile:

subdir-y                     += run_some_evil_cmd

If we accept the fact that we do need to run commands when running "make",
it doesn't really matter if such command is at a makefile, inside a 
perl/python script or called via some Sphinx directive. In all cases,
patches need to be reviewed by the community, to be sure that they won't
introduce any vulnerabilities.

Btw, with regards to security, a way bigger threat is if someone
introduces a vulnerable code inside the Kernel code, as this will
affect a lot more systems than a vulnerability at the documentation
build process.

Yet, if you think security is still a high risk, my suggestion
would be to restrict the kernel-cmd script to only run scripts
inside trusted places, like Documentation/sphinx.


-

The real issue here is that Sphinx itself doesn't provide what
it is needed to build the Kernel documentation. Some extra
scripts are required. Right now, we converted maybe 5% of the
documentation to ReST, and we're using running two perl scripts:
	- kernel-doc
	- parse-headers.pl

We also identified that, if we want to add the MAINTAINERS file to
some documentation (or a parsed version of it), we would need an extra
script to filter it[1].

I can think on other use cases to run such scripts[2].

What I'm saying is that, we can keep adding a Sphinx-specific
extension for every such needs, with will result in code duplication
and will make harder to maintain it, or we can use a generic
solution like this kernel-cmd extension.

IMO, a generic solution is a way better, as it sounds easier to
maintain.

Regards,
Mauro

[1] https://git.linuxtv.org/mchehab/experimental.git/commit/?h=lkml-books&id=c8b07684c0278d7f9d0e30f575eb4be3a2da4c3b

[2] There's another possible usecase, with I'm not convinced yet
whether should be addressed or not.

At the media subsystem, we use 8 out-of-tree scripts that update
the list of supported USB and PCI media boards, e. g. the files under:
	Documentation/media/v4l-drivers/*cardlist.rst

Such scripts used to be part of the mercurial tree, before we moved the 
media development to git, like this one:
	https://linuxtv.org/hg/v4l-dvb/file/3724e93f7af5/v4l/scripts/bttv.pl

Currently, I'm using a local fork of the old scripts, and, when I
notice a patch for a driver with a cardlist, if I remember, I run the
scripts to add to update the cardlists. While it could be kept
OOT forever, if moved it to the Kernel tree,  the documentation will 
always reflect the Kernel status, with is, IMHO, a good thing.
