Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:59232 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752240AbcIVMI6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 22 Sep 2016 08:08:58 -0400
Date: Thu, 22 Sep 2016 09:08:50 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Markus Heiser <markus.heiser@darmarit.de>
Cc: Jonathan Corbet <corbet@lwn.net>,
        Jani Nikula <jani.nikula@intel.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        "linux-doc@vger.kernel.org Mailing List" <linux-doc@vger.kernel.org>
Subject: Re: [PATCH v2 0/3] doc-rst:c-domain: fix some issues in the
 c-domain
Message-ID: <20160922090850.56e3ebb1@vento.lan>
In-Reply-To: <35B447A7-6C12-4560-8D06-110B8B33CB56@darmarit.de>
References: <1473232378-11869-1-git-send-email-markus.heiser@darmarit.de>
        <20160909090832.35c2d982@vento.lan>
        <73B0403A-272C-4058-A0D9-493C685EE332@darmarit.de>
        <1089B8C0-6296-4CC4-84B9-A1F62FA565AD@darmarit.de>
        <20160919120030.4e390e9a@vento.lan>
        <35B447A7-6C12-4560-8D06-110B8B33CB56@darmarit.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 20 Sep 2016 20:56:35 +0200
Markus Heiser <markus.heiser@darmarit.de> escreveu:

> > If I understood it right, I could do something like:
> > 
> > diff --git a/Documentation/media/conf_nitpick.py b/Documentation/media/conf_nitpick.py
> > index 480d548af670..2de603871536 100644
> > --- a/Documentation/media/conf_nitpick.py
> > +++ b/Documentation/media/conf_nitpick.py
> > @@ -107,3 +107,9 @@ nitpick_ignore = [
> > 
> >     ("c:type", "v4l2_m2m_dev"),
> > ]
> > +
> > +
> > +extensions.append("linuxdoc.rstKernelDoc")
> > +extensions.append("linuxdoc.rstFlatTable")
> > +extensions.append("linuxdoc.kernel_include")
> > +extensions.append("linuxdoc.manKernelDoc")
> > 
> > Right?  
> 
> No ;)

> > It would be good to do some sort of logic on the
> > above for it to automatically include it, if linuxdoc is
> > present, otherwise print a warning and do "just" the normal
> > Sphinx tests.  
> 
> The intention is; with installing the linuxdoc project you get
> some nice command line tools, like lint for free and if you want
> to see how the linuxdoc project compiles your kernel documentation
> and how e.g. man pages are build or what warnings are spit, you
> have to **replace** the extensions from the kernel's source with
> the one from the linuxdoc project.
> 
> This is done by patching the build scripts as described in:
> 
>   https://return42.github.io/linuxdoc/linux.html
> 
> FYI: I updated the documentation of the linuxdoc project.

Hmm... It would be a way better to just do something like the
above patch, specially since a conf_lint.py could have the
modified conf_nitpick.py, and avoiding touching at the
tree. The need of making a patch to use it, touching at the
building system prevents it to be called for every applied
patch that would touch on a documented header file.

I used the above to detect some cut-and-paste issues with some
documentation.

Yet, from what I saw, the parsers of lint still need some work,
as it didn't parse some stuff at the media headers that seem ok.

> In this project I develop and maintain "future" concepts like
> man-page builder and the py-version of the kernel-doc parser. 

The new parser seems to have some bugs, like those:

$ kernel-lintdoc include/media/v4l2-ctrls.h
include/media/v4l2-ctrls.h:106 :WARN: typedef of function pointer not marked as typdef, use: 'typedef v4l2_ctrl_notify_fnc' in the comment.
...
include/media/v4l2-ctrls.h:605 :WARN: typedef of function pointer not marked as typdef, use: 'typedef v4l2_ctrl_filter' in the comment.
...
include/media/v4l2-ctrls.h:809 [kernel-doc WARN] : can't understand function proto: 'const char * const *v4l2_ctrl_get_menu(u32 id);'
...

in this case, both typedefs were defined. The prototype for
v4l2_ctrl_get_menu() is also valid.

Anyway, it helped to get some real troubles. Thanks!


> Vice versa, every improvement I see on kernel's source tree is
> merged into this project.
> 
> This project is also used by my POC at:
> 
> * http://return42.github.io/sphkerneldoc/
> 
> E.g. it builds the documentation of the complete kernel sources
> 
> * http://return42.github.io/sphkerneldoc/linux_src_doc/index.html
> 
> the last one is also my test-case to find regression when I change
> something / running against the whole source tree and compare the
> result to the versioned reST files at 
> 
> * https://github.com/return42/sphkerneldoc/tree/master/doc/linux_src_doc
> 
> -- Markus --
> 
> >> E.g. if you want to lint your whole include/media tree type:
> >> 
> >>  kernel-lintdoc [--sloppy] include/media  
> > 
> > Yeah, running it manually is another way, although I prefer to have
> > it done via a Makefile target, and doing only for the files that
> > are currently inside a Sphinx rst file (at least on a first moment).
> > 
> > Thanks,
> > Mauro  
> 



Thanks,
Mauro
