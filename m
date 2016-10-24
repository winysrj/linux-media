Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:33372
        "EHLO s-opensource.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S936515AbcJXJnD (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 24 Oct 2016 05:43:03 -0400
Date: Mon, 24 Oct 2016 07:42:56 -0200
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Jani Nikula <jani.nikula@intel.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
        Markus Heiser <markus.heiser@darmarit.de>
Subject: Re: Documentation/media/uapi/cec/ sporadically unnecessarily
 rebuilding
Message-ID: <20161024074256.3a2eb697@vento.lan>
In-Reply-To: <871sz6p17k.fsf@intel.com>
References: <871sz6p17k.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 24 Oct 2016 12:04:31 +0300
Jani Nikula <jani.nikula@intel.com> escreveu:

> I think I saw some of this in the past [1], but then couldn't reproduce
> it after all. Now I'm seeing it again. Sporadically
> Documentation/media/uapi/cec/ gets rebuilt on successive runs of make
> htmldocs, even when nothing has changed.
> 
> Output of 'make SPHINXOPTS="-v -v" htmldocs' attached for both cases.
> 
> Using Sphinx (sphinx-build) 1.4.6

I notice some erratic behavior like that too, when I was writing the
admin-guide and process books... Sometimes, Sphinx decide to rebuild
everything (media, gpu, etc) without a good reason. Also, sometimes,
I was forced to run make cleandocs, as just touching at an rst file 
or at a file parsed by kernel-doc is not enough.

The only safe way to be sure that the documentation will be OK and
won't take too long to build is to use:

	make cleandocs; make DOCBOOKS="" SPHINXDIRS="admin-guide process" SPHINXOPTS="-j11" htmldocs

It will generate warnings, though, due to the cross-references between
admin-guide and process books. Due to that, after testing for individual
changes, I run:

	make cleandocs; make DOCBOOKS="" SPHINXOPTS="-j11" htmldocs

To check those references.

I didn't see any improvement for that on Sphinx 1.4.7 or 1.4.8.

Thanks,
Mauro
