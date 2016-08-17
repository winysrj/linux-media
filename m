Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp3-1.goneo.de ([85.220.129.38]:35849 "EHLO smtp3-1.goneo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750758AbcHQFoe (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Aug 2016 01:44:34 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: [PATCH 0/7] doc-rst: sphinx sub-folders & parseheaders directive
From: Markus Heiser <markus.heiser@darmarit.de>
In-Reply-To: <20160816152243.17927afe@vento.lan>
Date: Wed, 17 Aug 2016 07:44:16 +0200
Cc: Jonathan Corbet <corbet@lwn.net>,
	Jani Nikula <jani.nikula@intel.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	linux-doc@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <D841D797-4EF0-4D32-BD74-6F675822C940@darmarit.de>
References: <1471097568-25990-1-git-send-email-markus.heiser@darmarit.de> <20160814120920.62098dae@lwn.net> <DCB8AFBC-2E5E-4CD0-97A0-9325686CE17F@darmarit.de> <20160816152243.17927afe@vento.lan>
To: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Daniel Vetter <daniel.vetter@ffwll.ch>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


@Daniel: I added you to this discussion. May you are interested in, 
it is about the parse-headers functionality from Mauro.

Am 16.08.2016 um 20:22 schrieb Mauro Carvalho Chehab <mchehab@infradead.org>:

> Em Mon, 15 Aug 2016 10:21:07 +0200
> Markus Heiser <markus.heiser@darmarit.de> escreveu:
> 
>> Am 14.08.2016 um 20:09 schrieb Jonathan Corbet <corbet@lwn.net>:

...

>>> but stopped at parse-header.
>>> At this point, I have a few requests.  These are in approximate order of
>>> decreasing importance, but they're all important, I think.
> 
> After writing the PDF support, I'm starting to think that maybe we
> should migrate the entire functionality to the Sphinx extension.
> The rationale is that we won't need to be concerned about output
> specific escape codes there.

What do you mean with "output specific escape codes"? This: 

<SNIP>----
#
# Add escape codes for special characters
#
$data =~ s,([\_\`\*\<\>\&\\\\:\/\|]),\\$1,g;

$data =~ s,DEPRECATED,**DEPRECATED**,g;
<SNIP>----

will be resist, even if you implement it in python.


>>> - The new directive could really use some ... documentation.  Preferably in
>>> kernel-documentation.rst with the rest.  What is parse-header, how does
>>> it differ from kernel-doc, why might a kernel developer doing
>>> documentation want (or not want) to use it?  That's all pretty obscure
>>> now.  If we want others to jump onto this little bandwagon of ours, we
>>> need to make sure it's all really clear.  
>> 
>> This could be answered by Mauro.
> 
> We use it to allow including an entire header file as-is at the
> documentation, and cross-reference it with the documents.
> 
> IMO, this is very useful to document the ioctl UAPI. There, the most
> important things to be documented are the ioctl themselves. We don't
> have any way to document via kernel-doc (as they're #define macros).
> 
> Also, when documenting an ioctl, we want to document the structures
> that are used (most media ioctls use a struct instead of a single value).
> 
> So, what we do is that we write a proper description for the ioctl and
> everything related to it outside the source code. As we want to be
> sure that everything in the header is documented, we use the
> "parse-header.pl" (ok, this name really sucks) to create cross-references
> between the header and the documentation itself.
> 
> So, it is actually a script that replaces all occurrences of typedefs,
> defines, structs, functions, enums into references to the uAPI
> documentation.
> 
> This is is somewhat equivalent to:
> 	.. code-block:: c
> 
> Or, even better, it resembles the Doxygen's \example directive:
> 	https://www.stack.nl/~dimitri/doxygen/manual/commands.html#cmdexample
> 
> With produces a parsed file, like this one:
> 	https://linuxtv.org/docs/libdvbv5/dvb-fe-tool_8c-example.html
> 
> Except that:
> 
> 1) It doesn't randomly painting the file;
> 
> 2) All places where the a typedef, define, struct, struct member,
> function or enum exists are replaced by a cross-reference to the
> documentation (except if explicitly defined to not do that, via a
> configuration file).
> 
> That, plus the nitpick mode at Sphinx, allows us to check what
> parts of the uAPI file aren't documented.
> 
>>> - Along those lines, is parse-header the right name for this thing?
>>> "Parsing" isn't necessarily the goal of somebody who uses this directive,
>>> right?  They want to extract documentation information.  Can we come up
>>> with a better name?  
>> 
>> Mauro, what is your suggestion and how would we go on in this topic?
> 
> Maybe we could call it as: "include-c-code-block" or something similar.

Hmm, that's not any better, IMHO ... there is a 'parsed-literal' so, what's
wrong with a 'parsed-header' directive or for my sake ' parse-c-header'.
IMHO it is very unspecific what this directive does and it might be changed in
the near future if someone (e.g. Daniel [1]) see more use cases then the one yet.

[1] https://www.mail-archive.com/linux-media%40vger.kernel.org/msg101129.html

-- Markus --

> Regards,
> Mauro

