Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w2.samsung.com ([211.189.100.12]:51953 "EHLO
	usmailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933105AbcHJUfY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Aug 2016 16:35:24 -0400
Date: Wed, 10 Aug 2016 05:23:19 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Jani Nikula <jani.nikula@intel.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
	Markus Heiser <markus.heiser@darmarit.de>,
	Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: Re: parts of media docs sphinx re-building every time?
Message-id: <20160810052319.65b3862c.m.chehab@samsung.com>
In-reply-to: <87wpjpvzmk.fsf@intel.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
References: <8760rbp8zh.fsf@intel.com> <87wpjpvzmk.fsf@intel.com>
 <CGME20160810082326uscas1p1197a3281af8eb1a81b2b317b0b7c7066@uscas1p1.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 10 Aug 2016 10:42:27 +0300
Jani Nikula <jani.nikula@intel.com> escreveu:

> On Mon, 08 Aug 2016, Jani Nikula <jani.nikula@intel.com> wrote:
> > I wonder if it's related to Documentation/media/Makefile... which I have
> > to say I am not impressed by. I was really hoping we could build all the
> > documentation by standalone sphinx-build invocation too, relying only on
> > the conf.py so that e.g. Read the Docs can build the docs. Part of that
> > motivation was to keep the build clean in makefiles, and handing the
> > dependency tracking completely to Sphinx.
> >
> > I believe what's in Documentation/media/Makefile,
> > Documentation/sphinx/parse-headers.pl, and
> > Documentation/sphinx/kernel_include.py could be replaced by a Sphinx
> > extension looking at the sources directly. (I presume kernel_include.py
> > is mostly a workaround to keep out-of-tree builds working?)  
> 
> Additionally, 'make pdfdocs' fails with e.g. 
> 
> /path/to/linux/Documentation/media/uapi/cec/cec-header.rst:9: SEVERE: Problems with "kernel-include" directive path:
> InputError: [Errno 2] No such file or directory: '/path/to/linux/Documentation/output/cec.h.rst'.
> /path/to/linux/Documentation/media/uapi/dvb/audio_h.rst:9: SEVERE: Problems with "kernel-include" directive path:
> InputError: [Errno 2] No such file or directory: '/path/to/linux/Documentation/output/audio.h.rst'.
> /path/to/linux/Documentation/media/uapi/dvb/ca_h.rst:9: SEVERE: Problems with "kernel-include" directive path:
> InputError: [Errno 2] No such file or directory: '/path/to/linux/Documentation/output/ca.h.rst'.
> /path/to/linux/Documentation/media/uapi/dvb/dmx_h.rst:9: SEVERE: Problems with "kernel-include" directive path:
> InputError: [Errno 2] No such file or directory: '/path/to/linux/Documentation/output/dmx.h.rst'.
> 
> because the makefile hack is only done on htmldocs target.

Yeah, we need to call the media Makefile on other targets. I'll see if I can
write a quick fix for that. Please notice, however, that I'm on a trip this
week, with not much time available for writing patches.

Yet, you probably missed some e-mails while you were in vacations.
rst2pdf is not capable of handling complex documents. It crashes
with the media docs. See this patch:
	https://patchwork.kernel.org/patch/9231687/

There is a thread about that too... but, after checking my backlogs,
I noticed that this was not c/c to the ML, with is a shame :(

I'm enclosing the part of the thread where we've discussed about
rst2pdf, that resulted on the above patch.

In summary:

- rst2pdf is completely broken with Sphinx 1.3.x;
- rst2pdf doesn't handle complex documents, even with Sphinx 1.4.5;
- rst2pdf always report a successful build, even when it fails;
- Markus recommended removing the media book from the build, as he doesn't
  know any fixup or replacement for the tool.

That's why I came up with that patch, and recommended to even disable
pdf production at the patch comments while we don't have a sane alternative.

Regards,
Mauro


Am 13.07.2016 um 17:41 schrieb Mauro Carvalho Chehab <mchehab@osg.samsung.com>:

> Em Wed, 13 Jul 2016 17:22:05 +0200
> Markus Heiser <markus.heiser@darmarit.de> escreveu:
>   
>> Am 13.07.2016 um 14:40 schrieb Mauro Carvalho Chehab <mchehab@osg.samsung.com>:
>>   
>>> Em Thu, 7 Jul 2016 10:12:36 +0200
>>> Markus Heiser <markus.heiser@darmarit.de> escreveu:

>>> With Sphinx version 1.4.4/1.4.5, no errors were produced from media
>>> DocBook, with is great.
>>> 
>>> Yet, trying to use pdfdocs produce this error:
>>> 
>>> ERROR] pdfbuilder.py:130 too many values to unpack
>>> Traceback (most recent call last):
>>> File "/home/mchehab/.local/lib/python2.7/site-packages/rst2pdf/pdfbuilder.py", line 122, in write
>>>  appendices=opts.get('pdf_appendices', self.config.pdf_appendices) or [])
>>> File "/home/mchehab/.local/lib/python2.7/site-packages/rst2pdf/pdfbuilder.py", line 209, in assemble_doctree
>>>  index_nodes=genindex_nodes(genindex)
>>> File "/home/mchehab/.local/lib/python2.7/site-packages/rst2pdf/pdfbuilder.py", line 385, in genindex_nodes
>>>  for entryname, (links, subitems) in entries:
>>> ValueError: too many values to unpack
>>> FAILED
>>> build succeeded.
>>> 
>>> (for rst2pdf to work, I had to use pip2, as the version it downloaded
>>> doesn't run with python3)    
>> 
>> There was a time, I thought this rst2pdf tool could be a solution
>> which only needs some bug fixes, but in the meantime I have to
>> say, that rst2pdf is "broken by design".
>> 
>> This is very sad, but after dig into rst2pdf to fix some bugs I had 
>> to realized that it has tons of access on non existing properties. 
>> 
>> https://github.com/rst2pdf/rst2pdf/issues/556#issuecomment-228779542
>> 
>> Getting a build without an exception is just a game of luck. :-(
>> 
>> Sorry for the bad news ...  
> 
> Gah, that sucks. It sucks even more that sphinx is uncapable of
> detecting that something got wrong, keep saying that:
> 	"build succedded"
> 
> and keeping the zero byte pdf stored there.  

It is not only sphinx, it is the rst2pdf extension which does not throw 
a SystemMessagePropagation exception on fatal errors.

> Are there any other alternative to produce pdfs?  

Yes, the sphinx-doc build-in LaTeX builder

* http://www.sphinx-doc.org/en/stable/config.html#options-for-latex-output

But it has some drawbacks, e.g. it produce LaTeX for the pdfTeX engine.
LaTeX is by default ASCII and it needs some "inputenc" to supportma wider
range of characters. This is not very helpful if you have a toolchain
in an international community.

The alternative to LaTeX is to use the XeTeX engine, which supports UTF-8
encoded input by default and supports TrueType/OpenType fonts directly.
Thats why I started to write a XeLaTeX builder ...

* https://github.com/return42/sphkerneldoc/blob/master/scripts/site-python/xelatex_ext/__init__.py#L15 

... but I can't predict when this will be finished ...

However which tool is used, my experience is, that building
PDF (books) with a minimum of quality is not simple.
Layout width tables, split table content over pages, switch
from landscape to portrait and versus, the flow of objects etc.
.. all this will need some manually interventions.  

> I suspect that Jani and Jon may not be happy by the fact that the media
> book causes pdf generation to break. So, maybe we'll need some sort of
> "magic" to make sphinx to exclude the build for the media docbook,
> if pdf was requested.  

No magic, only structure ;-)

in the conf.py you will find the settings (similar to man page settings)

pdf_documents = [
   ('index', u'Kernel', u'Kernel', u'J. Random Bozo'),
]

With "index", the PDF is build for the root node, means all
books and text files in one big PDF ... IMHO (see above)
this will never work.

Since we have this structure:


.. toctree::
  :maxdepth: 2

  kernel-documentation
  media/media_uapi

I recommend to edit the pdf_documents value to:

pdf_documents = [
   ('kernel-documentation', u'Kernel', u'Kernel', u'J. Random Bozo'),
]

this should prevent building PDF from media book

-- Markus --

-- 

Cheers,
Mauro
