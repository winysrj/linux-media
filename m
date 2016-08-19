Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1.goneo.de ([85.220.129.30]:42204 "EHLO smtp1.goneo.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752784AbcHSLiF (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 19 Aug 2016 07:38:05 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: [PATCH 1/7] doc-rst: generic way to build only sphinx sub-folders
From: Markus Heiser <markus.heiser@darmarit.de>
In-Reply-To: <20160818163514.43539c11@lwn.net>
Date: Fri, 19 Aug 2016 13:37:47 +0200
Cc: Jani Nikula <jani.nikula@intel.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        linux-doc@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <09880F76-6FE1-48E6-B76D-DFC4F47182D7@darmarit.de>
References: <1471097568-25990-1-git-send-email-markus.heiser@darmarit.de> <1471097568-25990-2-git-send-email-markus.heiser@darmarit.de> <20160818163514.43539c11@lwn.net>
To: Jonathan Corbet <corbet@lwn.net>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Am 19.08.2016 um 00:35 schrieb Jonathan Corbet <corbet@lwn.net>:

> On Sat, 13 Aug 2016 16:12:42 +0200
> Markus Heiser <markus.heiser@darmarit.de> wrote:
> 
>> Add a generic way to build only a reST sub-folder with or
>> without a individual *build-theme*.
>> 
>> * control *sub-folders* by environment SPHINXDIRS
>> * control *build-theme* by environment SPHINX_CONF
>> 
>> Folders with a conf.py file, matching $(srctree)/Documentation/*/conf.py
>> can be build and distributed *stand-alone*. E.g. to compile only the
>> html of 'media' and 'gpu' folder use::
>> 
>>  make SPHINXDIRS="media gpu" htmldocs
>> 
>> To use an additional sphinx-build configuration (*build-theme*) set the
>> name of the configuration file to SPHINX_CONF. E.g. to compile only the
>> html of 'media' with the *nit-picking* build use::
>> 
>>  make SPHINXDIRS=media SPHINX_CONF=conf_nitpick.py htmldocs
>> 
>> With this, the Documentation/conf.py is read first and updated with the
>> configuration values from the Documentation/media/conf_nitpick.py.
> 
> So this patch appears to have had the undocumented effect of moving HTML
> output from Documentation/output/html to Documentation/output.  I am
> assuming that was not the intended result?

Sorry for being unclear. My intention was to produce a structured output
which could copied 1:1 to a static HTML server.

Since the documentation says: 

  "The generated documentation is placed in ``Documentation/output``."

I thought I'am free to give it a structure. But I haven't clarified
this point / sorry.

The main structure is, that a HTML output is produced without any
folder prefix, so a simple htmldoc target goes to::

  Documentation/output/index.html

Other formats like epub are placed into a format-specific subfolder e.g. 
the epub from target "epubdocs" are placed in::

  Documentation/output/epub/*

If you only compile a subfolder e.g. "SPHINXDIRS=media" you get a
the analogous structure in the Documentation/output/media folder::

  Documentation/output/{subfolder}/{non-html-format}/

With you can place the Documentation/output/{subfolder} on 
your HTTP server including all formats.

Unfortunately at the this time, 

* the pdf goes to the "latex" folder .. since this is WIP
  and there are different solutions conceivable ... I left
  it open for the first.

* in the index.html we miss some links to pdf-/man- etc files
  
The last point needs some discussion. Hopefully, this discussion
starts right here.


> I'm not sure that we actually need the format-specific subfolders, but we
> should be consistent across all the formats and in the documentation and,
> as of this patch, we're not.

IMHO a structure where only non-HTML formats are placed in subfolders
(described above) is the better choice.

In the long run I like to get rid of all the intermediate formats
(latex, .doctrees) and build a clear output-folder (with all formats
in) which could be copied 1:1 to a static HTTP-server.

-- Markus --

> jon

