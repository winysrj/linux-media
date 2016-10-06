Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:27712 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751055AbcJFOVj (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 6 Oct 2016 10:21:39 -0400
From: Jani Nikula <jani.nikula@intel.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Markus Heiser <markus.heiser@darmarit.de>,
        Jonathan Corbet <corbet@lwn.net>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH 0/4] reST-directive kernel-cmd / include contentent from scripts
In-Reply-To: <20161006103132.3a56802a@vento.lan>
References: <1475738420-8747-1-git-send-email-markus.heiser@darmarit.de> <87oa2xrhqx.fsf@intel.com> <20161006103132.3a56802a@vento.lan>
Date: Thu, 06 Oct 2016 17:21:36 +0300
Message-ID: <87lgy15zin.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 06 Oct 2016, Mauro Carvalho Chehab <mchehab@infradead.org> wrote:
> Em Thu, 06 Oct 2016 11:42:14 +0300
> Jani Nikula <jani.nikula@intel.com> escreveu:
> Just curious here: what use case do you see by building the Kernel
> documentation without the Kernel tree?

Not without the kernel tree, but without the kernel build system. If
sphinx-build works directly, https://readthedocs.org/ just works when
you point it at a kernel git repo and the conf.py inside it.

It would be important to get Sphinx working over at
https://www.kernel.org/doc/htmldocs/ (which still looks kind of sad) but
in the mean time we could have had that at https://readthedocs.org/. If
it weren't for parse-headers.pl and the build hacks around it.

At least there's one at https://01.org/linuxgraphics/gfx-docs/drm/ now.

>> However, I would have much preferred the approach I proposed months ago,
>> having the extension itself do specifically what parse-headers.pl does
>> now. While it may seem generic on the surface, I don't think it's a
>> clean or a secure approach to allow running of arbitrary scripts from
>> PATH while building documentation. It's certainly not an approach that
>> should be encouraged.
>
> Sorry, but I disagree. The security threat of having a random command
> doing something wrong is the same as we already have with the Kernel
> Makefiles, as they can also run a random command. All it is needed
> is to add this to a Makefile:

My intention was to emphasize the importance of the clarity of the
documentation build, and not get hung up on the security aspect.

This is connected to the above: keeping documentation buildable with
sphinx-build directly will force you to avoid the Makefile hacks.

> IMO, a generic solution is a way better, as it sounds easier to
> maintain.

We've seen what happens when we make it easy to add random scripts to
build documentation. We've worked hard to get rid of that. In my books,
one of the bigger points in favor of Sphinx over AsciiDoc(tor) was
getting rid of all the hacks required in the build. Things that broke in
subtle ways.

I think having people write Sphinx extensions for the special needs have
a better chance of solving the problems in more generic ways than
writing scripts for each specific need. Ideally, we can push those
extensions to upstream Sphinx, but at least make them easily usable
across the kernel documentation.

Case in point, parse-headers.pl was added for a specific need of media
documentation, and for the life of me I can't figure out by reading the
script what good, if any, it would be for gpu documentation. I call
*that* unmaintainable.


BR,
Jani.

-- 
Jani Nikula, Intel Open Source Technology Center
