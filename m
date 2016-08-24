Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:45897 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755423AbcHXOKI (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 24 Aug 2016 10:10:08 -0400
Date: Wed, 24 Aug 2016 11:10:02 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Markus Heiser <markus.heiser@darmarit.de>
Cc: Jonathan Corbet <corbet@lwn.net>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH] doc-rst:sphinx-extensions: add metadata parallel-safe
Message-ID: <20160824111002.0e0aeffe@vento.lan>
In-Reply-To: <1472045724-14559-1-git-send-email-markus.heiser@darmarit.de>
References: <1472045724-14559-1-git-send-email-markus.heiser@darmarit.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 24 Aug 2016 15:35:24 +0200
Markus Heiser <markus.heiser@darmarit.de> escreveu:

> From: Markus Heiser <markus.heiser@darmarIT.de>
> 
> The setup() function of a Sphinx-extension can return a dictionary. This
> is treated by Sphinx as metadata of the extension [1].
> 
> With metadata "parallel_read_safe = True" a extension is marked as
> save for "parallel reading of source". This is needed if you want
> build in parallel with N processes. E.g.:
> 
>   make SPHINXOPTS=-j4 htmldocs
> 
> will no longer log warnings like:
> 
>   WARNING: the foobar extension does not declare if it is safe for
>   parallel reading, assuming it isn't - please ask the extension author
>   to check and make it explicit.
> 
> Add metadata to extensions:
> 
> * kernel-doc
> * flat-table
> * kernel-include
> 
> [1] http://www.sphinx-doc.org/en/stable/extdev/#extension-metadata
> 
> Signed-off-by: Markus Heiser <markus.heiser@darmarIT.de>

Tested here on my desktop:

$ make cleandocs; time make SPHINXOPTS="-q" DOCBOOKS="" SPHINXDIRS=media SPHINX_CONF="conf.py" htmldocs
  SPHINX  htmldocs --> file:///devel/v4l/patchwork/Documentation/output/media;
make[2]: warning: jobserver unavailable: using -j1.  Add '+' to parent make rule.
  PARSE   include/uapi/linux/dvb/audio.h
  PARSE   include/uapi/linux/dvb/ca.h
  PARSE   include/uapi/linux/dvb/dmx.h
  PARSE   include/uapi/linux/dvb/frontend.h
  PARSE   include/uapi/linux/dvb/net.h
  PARSE   include/uapi/linux/dvb/video.h
  PARSE   include/uapi/linux/videodev2.h
  PARSE   include/uapi/linux/media.h
  PARSE   include/linux/cec.h
  PARSE   include/uapi/linux/lirc.h
load additional sphinx-config: /devel/v4l/patchwork/Documentation/media/conf.py
/devel/v4l/patchwork/Documentation/media/uapi/v4l/extended-controls.rst:2116: WARNING: Inline literal start-string without end-string.
/devel/v4l/patchwork/Documentation/media/uapi/v4l/extended-controls.rst:2116: WARNING: Inline literal start-string without end-string.
  SKIP    DocBook htmldocs target (DOCBOOKS="" specified).

real	0m55.837s
user	0m54.620s
sys	0m1.333s

$ make cleandocs; time make SPHINXOPTS="-q -j8" DOCBOOKS="" SPHINXDIRS=media SPHINX_CONF="conf.py" htmldocs
  SPHINX  htmldocs --> file:///devel/v4l/patchwork/Documentation/output/media;
make[2]: warning: jobserver unavailable: using -j1.  Add '+' to parent make rule.
  PARSE   include/uapi/linux/dvb/audio.h
  PARSE   include/uapi/linux/dvb/ca.h
  PARSE   include/uapi/linux/dvb/dmx.h
  PARSE   include/uapi/linux/dvb/frontend.h
  PARSE   include/uapi/linux/dvb/net.h
  PARSE   include/uapi/linux/dvb/video.h
  PARSE   include/uapi/linux/videodev2.h
  PARSE   include/uapi/linux/media.h
  PARSE   include/linux/cec.h
  PARSE   include/uapi/linux/lirc.h
load additional sphinx-config: /devel/v4l/patchwork/Documentation/media/conf.py
/devel/v4l/patchwork/Documentation/media/uapi/v4l/extended-controls.rst:2116: WARNING: Inline literal start-string without end-string.
/devel/v4l/patchwork/Documentation/media/uapi/v4l/extended-controls.rst:2116: WARNING: Inline literal start-string without end-string.
  SKIP    DocBook htmldocs target (DOCBOOKS="" specified).

real	0m22.340s
user	1m21.041s
sys	0m3.624s

Time reduced from 55 to 22 seconds. Sounds good enough!

Tested-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>

Thanks!
Mauro

PS: on my server with 16 dual-thread Xeon CPU, the gain with a
bigger value for -j was not impressive. Got about the same time as
with -j8 or -j32 there.

> ---
>  Documentation/sphinx/kernel-doc.py     | 8 ++++++++
>  Documentation/sphinx/kernel_include.py | 7 +++++++
>  Documentation/sphinx/rstFlatTable.py   | 6 ++++++
>  3 files changed, 21 insertions(+)
>  mode change 100644 => 100755 Documentation/sphinx/rstFlatTable.py
> 
> diff --git a/Documentation/sphinx/kernel-doc.py b/Documentation/sphinx/kernel-doc.py
> index f6920c0..d15e07f 100644
> --- a/Documentation/sphinx/kernel-doc.py
> +++ b/Documentation/sphinx/kernel-doc.py
> @@ -39,6 +39,8 @@ from docutils.parsers.rst import directives
>  from sphinx.util.compat import Directive
>  from sphinx.ext.autodoc import AutodocReporter
>  
> +__version__  = '1.0'
> +
>  class KernelDocDirective(Directive):
>      """Extract kernel-doc comments from the specified file"""
>      required_argument = 1
> @@ -139,3 +141,9 @@ def setup(app):
>      app.add_config_value('kerneldoc_verbosity', 1, 'env')
>  
>      app.add_directive('kernel-doc', KernelDocDirective)
> +
> +    return dict(
> +        version = __version__,
> +        parallel_read_safe = True,
> +        parallel_write_safe = True
> +    )
> diff --git a/Documentation/sphinx/kernel_include.py b/Documentation/sphinx/kernel_include.py
> index db57382..f523aa6 100755
> --- a/Documentation/sphinx/kernel_include.py
> +++ b/Documentation/sphinx/kernel_include.py
> @@ -39,11 +39,18 @@ from docutils.parsers.rst import directives
>  from docutils.parsers.rst.directives.body import CodeBlock, NumberLines
>  from docutils.parsers.rst.directives.misc import Include
>  
> +__version__  = '1.0'
> +
>  # ==============================================================================
>  def setup(app):
>  # ==============================================================================
>  
>      app.add_directive("kernel-include", KernelInclude)
> +    return dict(
> +        version = __version__,
> +        parallel_read_safe = True,
> +        parallel_write_safe = True
> +    )
>  
>  # ==============================================================================
>  class KernelInclude(Include):
> diff --git a/Documentation/sphinx/rstFlatTable.py b/Documentation/sphinx/rstFlatTable.py
> old mode 100644
> new mode 100755
> index 26db852..55f2757
> --- a/Documentation/sphinx/rstFlatTable.py
> +++ b/Documentation/sphinx/rstFlatTable.py
> @@ -73,6 +73,12 @@ def setup(app):
>      roles.register_local_role('cspan', c_span)
>      roles.register_local_role('rspan', r_span)
>  
> +    return dict(
> +        version = __version__,
> +        parallel_read_safe = True,
> +        parallel_write_safe = True
> +    )
> +
>  # ==============================================================================
>  def c_span(name, rawtext, text, lineno, inliner, options=None, content=None):
>  # ==============================================================================



Thanks,
Mauro
