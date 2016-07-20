Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp3-1.goneo.de ([85.220.129.38]:44461 "EHLO smtp3-1.goneo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754715AbcGTPdp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Jul 2016 11:33:45 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: [PATCH] doc-rst: get rid of warnings at kernel-documentation.rst
From: Markus Heiser <markus.heiser@darmarit.de>
In-Reply-To: <20160720120658.4880f37d@recife.lan>
Date: Wed, 20 Jul 2016 17:33:31 +0200
Cc: Jonathan Corbet <corbet@lwn.net>,
	Daniel Vetter <daniel.vetter@intel.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-doc@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <90A9E97F-874A-4783-8743-354B89722934@darmarit.de>
References: <610951ea382e015f178bb55391ea21bd80132d70.1469023848.git.mchehab@s-opensource.com> <83940B5E-B900-4D41-9FDA-CE2587ED4665@darmarit.de> <20160720083149.1ea84b43@lwn.net> <731EED92-7B58-4B36-AEF7-250653E90A35@darmarit.de> <20160720120658.4880f37d@recife.lan>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Am 20.07.2016 um 17:06 schrieb Mauro Carvalho Chehab <mchehab@s-opensource.com>:

> Em Wed, 20 Jul 2016 16:49:59 +0200
> Markus Heiser <markus.heiser@darmarit.de> escreveu:
> 
>> Am 20.07.2016 um 16:31 schrieb Jonathan Corbet <corbet@lwn.net>:
>> 
>>> On Wed, 20 Jul 2016 16:23:28 +0200
>>> Markus Heiser <markus.heiser@darmarit.de> wrote:
>>> 
>>>> Am 20.07.2016 um 16:11 schrieb Mauro Carvalho Chehab <mchehab@s-opensource.com>:
>>>> 
>>>>> Sphinx 1.4.5 complains about some literal blocks at
>>>>> kernel-documentation.rst:
>>>>> 
>>>>> 	Documentation/kernel-documentation.rst:373: WARNING: Could not lex literal_block as "C". Highlighting skipped.
>>>>> 	Documentation/kernel-documentation.rst:378: WARNING: Could not lex literal_block as "C". Highlighting skipped.
>>>>> 	Documentation/kernel-documentation.rst:576: WARNING: Could not lex literal_block as "C". Highlighting skipped.
>>>>> 
>>>>> Fix it by telling Sphinx to consider them as "none" type.    
>>>> 
>>>> Hi Mauro,
>>>> 
>>>> IMHO we should better fix this by unsetting the lexers default language 
>>>> in the conf.py  [1] ... currently:
>>>> 
>>>> highlight_language = 'C'  # set this to 'none'
>>>> 	
>>>> As far as I know the default highlight_language is also the default
>>>> for literal blocks starting with "::"  
>>> 
>>> The thing with that is that a lot of literal blocks *do* have C code, even
>>> in kernel-documentation.rst.  Setting that in conf.py would turn off all C
>>> highlighting.  I think that might actually be a desirable outcome, but it
>>> would be good to make that decision explicitly.
>>> 
>>> As it happens, I'd already fixed these particular warnings in docs-next:
>>> 
>>> 	http://permalink.gmane.org/gmane.linux.documentation/39806
>>> 
>>> I took a different approach; using code-block might actually be better.  
>> 
>> In some kernel-doc comments we have constructs like this:
>> 
>> * host point of view, the graphic address space is partitioned by multiple
>> * vGPUs in different VMs.::
>> *
>> *                        vGPU1 view         Host view
>> *             0 ------> +-----------+     +-----------+
>> *               ^       |///////////|     |   vGPU3   |
>> *               |       |///////////|     +-----------+
>> *               |       |///////////|     |   vGPU2   |
>> *               |       +-----------+     +-----------+
>> *        mappable GM    | available | ==> |   vGPU1   |
>> *               |       +-----------+     +-----------+
>> 
>> I mean, in kernel-doc comments it would be nice to have no lexer
>> active when starting a literal block with a double colon "::".
>> Introducing a none highlighted literal block with a directive
>> like ".. highlight::" or ".. code-block" is a bit verbose
>> for a C comment.  And on the opposite, if one place a C construct
>> in a literal block with a double colon "::", only the highlighting
>> is missed, but we get now warning.
>> 
>> At least a code-block should be a code block, not a diagram 
>> or anything other ...
>> 
>> I don't know whats the best ... but these are my 2cent :)
> 
> I actually think that the best would be if we could have a way to
> "draw" graphs inside the documentation.

please .. not yet ;-)  ... we have so many problem sites to 
close first ... graphiz & Co. bring additional dependencies
to fulfill in context with sphinx 1.2 ...

> We have a few cases of
> diagrams like the above at the media documentation too.
> 
> As Sphinx seems to like ASCIIart, IMHO, the more Sphinx-style
> way would be to have a:
> 
> .. code-block:: asciiart

> 
> markup to handle it.

why a special markup for a literal block?

-- M --

> Another possibility would be to have a graphviz extension.
> 
>> 
>> --Markus--
>> 
>> 
>>> 
>>> jon
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html  
>> 
> 
> 
> 
> Thanks,
> Mauro
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

