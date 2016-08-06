Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:15136 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751647AbcHFUJQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 6 Aug 2016 16:09:16 -0400
From: Jani Nikula <jani.nikula@intel.com>
To: Markus Heiser <markus.heiser@darmarit.de>,
	Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	linux-media@vger.kernel.org
Cc: Markus Heiser <markus.heiser@darmarIT.de>,
	Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Subject: Re: [PATCH] doc-rst: support *sphinx build themes*
In-Reply-To: <1470410047-9911-1-git-send-email-markus.heiser@darmarit.de>
References: <1470410047-9911-1-git-send-email-markus.heiser@darmarit.de>
Date: Sat, 06 Aug 2016 19:41:49 +0300
Message-ID: <87eg6126k2.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 05 Aug 2016, Markus Heiser <markus.heiser@darmarit.de> wrote:
> From: Markus Heiser <markus.heiser@darmarIT.de>
>
> Load an additional configuration file into conf.py namespace.
>
> The name of the configuration file is taken from the environment
> SPHINX_CONF. The external configuration file extends (or overwrites) the
> configuration values from the origin conf.py.  With this you are
> able to maintain *build themes*.
>
> E.g. to create your own nit-picking *build theme*, create a file
> Documentation/conf_nitpick.py::
>
>   nitpicky=True
>   nitpick_ignore = [
>       ("c:func", "clock_gettime"),
>       ...
>       ]
>
> and run make with SPHINX_CONF environment::
>
>   make SPHINX_CONF=conf_nitpick.py htmldocs

I think I would try to accomplish this by using the -c option in
SPHINXOPTS, and loading the main config file from the "special case"
config file. I think it would be a more generic approach instead of a
specific framework of our own. *shrug*.

BR,
Jani.


>
> Signed-off-by: Markus Heiser <markus.heiser@darmarIT.de>
> ---
>  Documentation/conf.py               |  9 +++++++++
>  Documentation/sphinx/load_config.py | 25 +++++++++++++++++++++++++
>  2 files changed, 34 insertions(+)
>  create mode 100644 Documentation/sphinx/load_config.py
>
> diff --git a/Documentation/conf.py b/Documentation/conf.py
> index 96b7aa6..d502775 100644
> --- a/Documentation/conf.py
> +++ b/Documentation/conf.py
> @@ -20,6 +20,8 @@ import os
>  # documentation root, use os.path.abspath to make it absolute, like shown here.
>  sys.path.insert(0, os.path.abspath('sphinx'))
>  
> +from load_config import loadConfig
> +
>  # -- General configuration ------------------------------------------------
>  
>  # If your documentation needs a minimal Sphinx version, state it here.
> @@ -419,3 +421,10 @@ pdf_documents = [
>  # line arguments.
>  kerneldoc_bin = '../scripts/kernel-doc'
>  kerneldoc_srctree = '..'
> +
> +
> +# ------------------------------------------------------------------------------
> +# Since loadConfig overwrites settings from the global namespace, it has to be
> +# the last statement in the conf.py file
> +# ------------------------------------------------------------------------------
> +loadConfig(globals())
> diff --git a/Documentation/sphinx/load_config.py b/Documentation/sphinx/load_config.py
> new file mode 100644
> index 0000000..44bdd22
> --- /dev/null
> +++ b/Documentation/sphinx/load_config.py
> @@ -0,0 +1,25 @@
> +# -*- coding: utf-8; mode: python -*-
> +# pylint: disable=R0903, C0330, R0914, R0912, E0401
> +
> +import os
> +from sphinx.util.pycompat import execfile_
> +
> +# ------------------------------------------------------------------------------
> +def loadConfig(namespace):
> +# ------------------------------------------------------------------------------
> +
> +    u"""Load an additional configuration file into *namespace*.
> +
> +    The name of the configuration file is taken from the environment
> +    ``SPHINX_CONF``. The external configuration file extends (or overwrites) the
> +    configuration values from the origin ``conf.py``.  With this you are able to
> +    maintain *build themes*.  """
> +
> +    config_file = os.environ.get("SPHINX_CONF", None)
> +    if config_file is not None and os.path.exists(config_file):
> +        config_file = os.path.abspath(config_file)
> +        config = namespace.copy()
> +        config['__file__'] = config_file
> +        execfile_(config_file, config)
> +        del config['__file__']
> +        namespace.update(config)

-- 
Jani Nikula, Intel Open Source Technology Center
