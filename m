Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:44876 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755218AbdLUVgB (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 21 Dec 2017 16:36:01 -0500
Date: Thu, 21 Dec 2017 19:35:42 -0200
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Jonathan Corbet <corbet@lwn.net>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>
Subject: Re: [PATCH v4 00/18] kernel-doc: add supported to document nested
 structs
Message-ID: <20171221193542.5bfd4bfc@vento.lan>
In-Reply-To: <20171221140843.5e4bcffd@lwn.net>
References: <cover.1513599193.git.mchehab@s-opensource.com>
        <20171221140843.5e4bcffd@lwn.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 21 Dec 2017 14:08:43 -0700
Jonathan Corbet <corbet@lwn.net> escreveu:

> On Mon, 18 Dec 2017 10:30:01 -0200
> Mauro Carvalho Chehab <mchehab@s-opensource.com> wrote:
> 
> > This is a rebased version of my patch series that add support for
> > nested structs on kernel-doc. With this version, it won't produce anymore
> > hundreds of identical warnings, as patch 17 removes the warning
> > duplication.
> > 
> > Excluding warnings about duplicated Note: section at hash.h, before
> > this series, it reports 166 kernel-doc warnings. After this patch series,
> > it reports 123 kernel-doc warnings, being 51 from DVB. I have already a patch
> > series that will cleanup those new DVB warnings due to nested structs.
> > 
> > So, the net result is that the number of warnings is reduced with
> > this version.  
> 
> This seems like a great set of improvements overall, and I love getting
> rid of all that old kernel-doc code. 

> I will note that it makes a full
> htmldocs build take 20-30 seconds longer, which is not entirely
> welcome, but so be it. Someday, I guess, $SOMEBODY should see if there's
> some low-hanging optimization fruit there.

Yeah. Well, I used a recursive algorithm, with can be painfull if there
are mang things to parse.

Anyway, I didn't notice it, because there was a major performance regression
that happened recently that it is affecting all my sphinx builds: trying to
compile stuff in parallel with SPHINXOPTS=-j5 is crashing with:

# Loaded extensions:
#   kfigure (1.0.0) from /devel/v4l/patchwork/Documentation/sphinx/kfigure.py
#   kernel_include (1.0) from /devel/v4l/patchwork/Documentation/sphinx/kernel_include.py
#   rstFlatTable (1.0) from /devel/v4l/patchwork/Documentation/sphinx/rstFlatTable.py
#   cdomain (1.0) from /devel/v4l/patchwork/Documentation/sphinx/cdomain.py
#   kerneldoc (1.0) from /devel/v4l/patchwork/Documentation/sphinx/kerneldoc.py
#   alabaster (0.7.10) from /devel/v4l/docs/sphinx_1.4/lib/python2.7/site-packages/alabaster/__init__.pyc
#   sphinx.ext.imgmath (1.4.9) from /devel/v4l/docs/sphinx_1.4/lib/python2.7/site-packages/sphinx/ext/imgmath.pyc
Traceback (most recent call last):
  File "/devel/v4l/docs/sphinx_1.4/lib/python2.7/site-packages/sphinx/cmdline.py", line 244, in main
    app.build(opts.force_all, filenames)
  File "/devel/v4l/docs/sphinx_1.4/lib/python2.7/site-packages/sphinx/application.py", line 297, in build
    self.builder.build_update()
  File "/devel/v4l/docs/sphinx_1.4/lib/python2.7/site-packages/sphinx/builders/__init__.py", line 251, in build_update
    'out of date' % len(to_build))
  File "/devel/v4l/docs/sphinx_1.4/lib/python2.7/site-packages/sphinx/builders/__init__.py", line 265, in build
    self.doctreedir, self.app))
  File "/devel/v4l/docs/sphinx_1.4/lib/python2.7/site-packages/sphinx/environment.py", line 567, in update
    self._read_parallel(docnames, app, nproc=app.parallel)
  File "/devel/v4l/docs/sphinx_1.4/lib/python2.7/site-packages/sphinx/environment.py", line 625, in _read_parallel
    tasks.join()
  File "/devel/v4l/docs/sphinx_1.4/lib/python2.7/site-packages/sphinx/util/parallel.py", line 92, in join
    self._join_one()
  File "/devel/v4l/docs/sphinx_1.4/lib/python2.7/site-packages/sphinx/util/parallel.py", line 97, in _join_one
    exc, result = pipe.recv()
EOFError

I had to change my build scripts to remove parallel build, with increased
*a lot* the building time. So, right now, I just go out to take a coffee
or two when building documentation, as, without -j (even without this
patch series), is really slow.

If someone wants to look into it, the breakage happened by the time
I upgraded to Fedora 27 and Kernel 4.14 was released. Yet, I'm using
pip for Sphinx.

So, I dunno what's the culprit. I didn't have time yet to investigate.

> Applied, thanks.

Thank you!

Regards,
Mauro
