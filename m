Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp2.goneo.de ([85.220.129.33]:34260 "EHLO smtp2.goneo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753929AbcGTOYL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Jul 2016 10:24:11 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: [PATCH] doc-rst: get rid of warnings at kernel-documentation.rst
From: Markus Heiser <markus.heiser@darmarit.de>
In-Reply-To: <610951ea382e015f178bb55391ea21bd80132d70.1469023848.git.mchehab@s-opensource.com>
Date: Wed, 20 Jul 2016 16:23:28 +0200
Cc: Jonathan Corbet <corbet@lwn.net>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-doc@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <83940B5E-B900-4D41-9FDA-CE2587ED4665@darmarit.de>
References: <610951ea382e015f178bb55391ea21bd80132d70.1469023848.git.mchehab@s-opensource.com>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Am 20.07.2016 um 16:11 schrieb Mauro Carvalho Chehab <mchehab@s-opensource.com>:

> Sphinx 1.4.5 complains about some literal blocks at
> kernel-documentation.rst:
> 
> 	Documentation/kernel-documentation.rst:373: WARNING: Could not lex literal_block as "C". Highlighting skipped.
> 	Documentation/kernel-documentation.rst:378: WARNING: Could not lex literal_block as "C". Highlighting skipped.
> 	Documentation/kernel-documentation.rst:576: WARNING: Could not lex literal_block as "C". Highlighting skipped.
> 
> Fix it by telling Sphinx to consider them as "none" type.

Hi Mauro,

IMHO we should better fix this by unsetting the lexers default language 
in the conf.py  [1] ... currently:

highlight_language = 'C'  # set this to 'none'
	
As far as I know the default highlight_language is also the default
for literal blocks starting with "::"

<SNIP>---
references. For example::

 See function :c:func:`foo` and struct/union/enum/typedef :c:type:`bar`.
<SNAP>---

[1] http://www.sphinx-doc.org/en/stable/config.html#confval-highlight_language

-- Markus --

> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> ---
> Documentation/kernel-documentation.rst | 6 ++++++
> 1 file changed, 6 insertions(+)
> 
> diff --git a/Documentation/kernel-documentation.rst b/Documentation/kernel-documentation.rst
> index 391decc66a18..1dd97478743e 100644
> --- a/Documentation/kernel-documentation.rst
> +++ b/Documentation/kernel-documentation.rst
> @@ -370,11 +370,15 @@ To cross-reference the functions and types defined in the kernel-doc comments
> from reStructuredText documents, please use the `Sphinx C Domain`_
> references. For example::
> 
> +.. code-block:: none
> +
>  See function :c:func:`foo` and struct/union/enum/typedef :c:type:`bar`.
> 
> While the type reference works with just the type name, without the
> struct/union/enum/typedef part in front, you may want to use::
> 
> +.. code-block:: none
> +
>  See :c:type:`struct foo <foo>`.
>  See :c:type:`union bar <bar>`.
>  See :c:type:`enum baz <baz>`.
> @@ -573,6 +577,8 @@ converted to Sphinx and reStructuredText. For most DocBook XML documents, a good
> enough solution is to use the simple ``Documentation/sphinx/tmplcvt`` script,
> which uses ``pandoc`` under the hood. For example::
> 
> +.. code-block:: none
> +
>  $ cd Documentation/sphinx
>  $ ./tmplcvt ../DocBook/in.tmpl ../out.rst
> 
> -- 
> 2.7.4
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

