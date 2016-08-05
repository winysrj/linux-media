Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:54381
	"EHLO s-opensource.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934986AbcHEMo2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 5 Aug 2016 08:44:28 -0400
Date: Fri, 5 Aug 2016 09:43:38 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Markus Heiser <markus.heiser@darmarit.de>
Cc: Jani Nikula <jani.nikula@intel.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	linux-doc@vger.kernel.org
Subject: Re: Functions and data structure cross references with Sphinx
Message-ID: <20160805094338.0ac79c14@recife.lan>
In-Reply-To: <94956A8D-0933-4096-B732-196D5409D9BA@darmarit.de>
References: <20160801082527.0eb7eace@recife.lan>
	<91BDDA51-4A60-495F-9475-341950051EE9@darmarit.de>
	<20160805074724.74190683@recife.lan>
	<94956A8D-0933-4096-B732-196D5409D9BA@darmarit.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 5 Aug 2016 14:22:19 +0200
Markus Heiser <markus.heiser@darmarit.de> escreveu:

> Am 05.08.2016 um 12:47 schrieb Mauro Carvalho Chehab <mchehab@s-opensource.com>:
> 
> > Em Fri, 5 Aug 2016 09:29:23 +0200
> > Markus Heiser <markus.heiser@darmarit.de> escreveu:
> >   

> > Is there a way for us to specify the nitpick_ignore list (or a different
> > conf.py) via command line?  
> 
> Since conf.py is python, we could implement something, which loads a
> "conditional configuration", e.g. loading a config with a nitpick_ignore
> list in. Depending on an environment 
> 
>  "SPHINX_BUILD_CONF=[strong|lazy]-nit-picking.py"
> 
> we could load individual build-configs overwriting the default settings
> from the origin conf.py.

That would be interesting!

> On which repo/branch you are working? .. I send you a RFC patch 
> for "conditional configurations".

You can send it against either the media_tree.git[1] or the upstream 
one[2]. All Sphinx patches I have were merged there already (except for 
the experimental nickpick patch I attached on the previous e-mail).

[1] https://git.linuxtv.org/media_tree.git/log/
[2] https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/

> > 3) The references generated from the header files I'm parsing don't
> > use the c (or cpp) domain. They're declared at the media book as a
> > normal reference:
> > 	Documentation/media/uapi/v4l/field-order.rst:.. _v4l2-field:
> > 

> Back to (3) ... as far as I know, there is no way to add a 
> *Internal Hyperlink Target* (e.g. "_v4l2-field:") to the C or 
> CPP domain.

Argh!

> 
> There is a ":any:" directive does something vice versa.
> 
> http://www.sphinx-doc.org/en/stable/markup/inline.html#role-any
> 
> But I think, this will not help referencing a type from a function
> prototype to a *Internal Hyperlink Target*, like the struct described
> under the "_v4l2-field:" target.

Hmm... it might help, but this is Sphinx 1.3 or upper only.
As we decide to set the minimal version bar to 1.2, we should
avoid using it.

> 
> If ":any:" does not help, we might find a solution with an additional
> crossref-type or something similar:
> 
> http://www.sphinx-doc.org/en/stable/extdev/appapi.html#sphinx.application.Sphinx.add_crossref_type
> 
> But this needs some more thoughts.

That sounds more promising, but we'll need a replacement for the
:c:func: tag to use it.


Thanks,
Mauro
