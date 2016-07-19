Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1.goneo.de ([85.220.129.30]:51956 "EHLO smtp1.goneo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752922AbcGSMcA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Jul 2016 08:32:00 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: [PATCH 00/18] Complete moving media documentation to ReST format
From: Markus Heiser <markus.heiser@darmarit.de>
In-Reply-To: <20160719081259.482a8c04@recife.lan>
Date: Tue, 19 Jul 2016 14:31:18 +0200
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
	Jani Nikula <jani.nikula@intel.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <6702C6D4-929F-420D-9CF9-911CA753B0A7@darmarit.de>
References: <cover.1468865380.git.mchehab@s-opensource.com> <578DF08F.8080701@xs4all.nl> <20160719081259.482a8c04@recife.lan>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Am 19.07.2016 um 13:12 schrieb Mauro Carvalho Chehab <mchehab@s-opensource.com>:

> Em Tue, 19 Jul 2016 11:19:11 +0200
> Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> 
>>> All those documents are built automatically, once by day, at linuxtv.org:
>>> 
>>> uAPI:
>>> 	https://linuxtv.org/downloads/v4l-dvb-apis-new/media/media_uapi.html  
>> 
>> Erm, there is nothing there, only the top-level menu.
> 
> Gah! The problem is due to the Sphinx version. I added a patch yesterday
> adding a caption to each book's toctree. This doesn't work with the
> Sphinx version at the server (1.2.3). Instead of ignoring the option,
> Sphinx decided to just drop the entire tag, with actually means to
> drop all media pages!
> 
> I really hate stupid toolchains that require everybody to upgrade to
> the very latest version of it every time.

Hi Mauro,

It might be annoying how sphinx handles errors, but normally a build
process should report errors to monitor.


> Maybe someone at linux-doc 
> may have an idea about how to add new markup attributes to the 
> documents without breaking for the ones using older versions of Sphinx.

see below

> The problem we're facing is due to a change meant to add a title before
> each media's table of contents (provided via :toctree:  markup).

I think this is only ONE drawback, others see the changelog  ..

* http://www.sphinx-doc.org/en/stable/changes.html

> All it needs is something that will be translated to HTML as:
> <h1>Table of contents</h1>, without the need of creating any cross
> reference, nor being added to the main TOC at Documentation/index.rst.
> 
> We can't simply use the normal way to generate <h1> tags:
> 
> --- a/Documentation/media/dvb-drivers/index.rst
> +++ b/Documentation/media/dvb-drivers/index.rst
> @@ -15,6 +15,10 @@ the license is included in the chapter entitled "GNU Free Documentation
> License".
> 
> 
> +#####################
> +FOO Table of contents
> +#####################
> +
> .. toctree::
> 	:maxdepth: 5
> 	:numbered:
> 
> The page itself would look OK, but this would produce a new entry at the
> output/html/index.html:
> 
> 	* Linux Digital TV driver-specific documentation
> 	* FOO Table of contents
> 
> 	    1. Introdution
> 
> With is not what we want.
> 
> With Sphinx 1.4.5, the way of doing that is to add a :caption: tag
> to the toctree, but this tag doesn't exist on 1.2.x. Also, as it
> also convert captions on references, and all books are linked
> together at Documentation/index.rst, it also needs a :name: tag,
> in order to avoid warnings about duplicated tags when building the
> main index.rst.
> 
> I have no idea about how to do that in a backward-compatible way.
> 
> Maybe Markus, Jani or someone else at linux-doc may have some
> glue.

IMHO: A backward-compatible way for all linux distros and versions
out there is not the way.

If we use options or features of a new version, we have to
install the new version (independent which xml we used in the past
or python tool we want to use).

IMHO the main problem is, that we have not yet documented on which
Sphinx version we agree and how to get a build environment which
fullfills these requirements.

For build environments I recommend to set up a python virtualenv

* https://virtualenv.pypa.io/en/stable/

Additional:

At this time, the make file only checks if sphinx is installed.
With a small addition to the make file, we could check if all
requirements are fulfilled. 

If you are interested in how, I could send a patch.

-- Markus --

> In the mean time, I attached a patch that the server applies before
> building the documentation.
> 
> 
> Thanks,
> Mauro
> 
> doc-rst: Don't use :caption: or :name:  tags for media documents
> 
> If Sphinx version is lower than 1.4.x (I tested with 1.4.5), this patch
> is needed for it to build, as otherwise Sphinx will ignore the toctable
> markups and won't build the media documentation, creating just an
> empty page.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> 
> diff --git a/Documentation/media/dvb-drivers/index.rst b/Documentation/media/dvb-drivers/index.rst
> index e1d4d87f2a47..0e065533beb6 100644
> --- a/Documentation/media/dvb-drivers/index.rst
> +++ b/Documentation/media/dvb-drivers/index.rst
> @@ -18,8 +18,6 @@ License".
> .. toctree::
> 	:maxdepth: 5
> 	:numbered:
> -	:caption: Table of Contents
> -	:name: dvb_mastertoc
> 
> 	intro
> 	avermedia
> diff --git a/Documentation/media/media_kapi.rst b/Documentation/media/media_kapi.rst
> index 0af80e90b7b5..556c0eb55c85 100644
> --- a/Documentation/media/media_kapi.rst
> +++ b/Documentation/media/media_kapi.rst
> @@ -17,8 +17,6 @@ License".
> .. toctree::
>     :maxdepth: 5
>     :numbered:
> -    :caption: Table of Contents
> -    :name: kapi_mastertoc
> 
>     kapi/v4l2-framework
>     kapi/v4l2-controls
> diff --git a/Documentation/media/media_uapi.rst b/Documentation/media/media_uapi.rst
> index debe4531040b..aae8124defcc 100644
> --- a/Documentation/media/media_uapi.rst
> +++ b/Documentation/media/media_uapi.rst
> @@ -17,8 +17,6 @@ License".
> 
> .. toctree::
>     :maxdepth: 5
> -    :caption: Table of Contents
> -    :name: uapi_mastertoc
> 
>     intro
>     uapi/v4l/v4l2
> diff --git a/Documentation/media/v4l-drivers/index.rst b/Documentation/media/v4l-drivers/index.rst
> index 8d1710234e5a..b9c9c0911db9 100644
> --- a/Documentation/media/v4l-drivers/index.rst
> +++ b/Documentation/media/v4l-drivers/index.rst
> @@ -18,8 +18,6 @@ License".
> .. toctree::
> 	:maxdepth: 5
> 	:numbered:
> -	:caption: Table of Contents
> -	:name: v4l_mastertoc
> 
> 	fourcc
> 	v4l-with-ir

