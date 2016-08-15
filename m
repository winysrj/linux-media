Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp3-1.goneo.de ([85.220.129.38]:60212 "EHLO smtp3-1.goneo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752377AbcHOIVc (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Aug 2016 04:21:32 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: [PATCH 0/7] doc-rst: sphinx sub-folders & parseheaders directive
From: Markus Heiser <markus.heiser@darmarit.de>
In-Reply-To: <20160814120920.62098dae@lwn.net>
Date: Mon, 15 Aug 2016 10:21:07 +0200
Cc: Jani Nikula <jani.nikula@intel.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	linux-doc@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <DCB8AFBC-2E5E-4CD0-97A0-9325686CE17F@darmarit.de>
References: <1471097568-25990-1-git-send-email-markus.heiser@darmarit.de> <20160814120920.62098dae@lwn.net>
To: Jonathan Corbet <corbet@lwn.net>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Am 14.08.2016 um 20:09 schrieb Jonathan Corbet <corbet@lwn.net>:

> On Sat, 13 Aug 2016 16:12:41 +0200
> Markus Heiser <markus.heiser@darmarit.de> wrote:
> 
>> this series is a consolidation on Jon's docs-next branch. It merges the "sphinx
>> sub-folders" patch [1] and the "parseheaders directive" patch [2] on top of
>> Jon's docs-next.
>> 
>> In sense of consolidation, it also includes:
>> 
>> *  doc-rst: add media/conf_nitpick.py
>> 
>>   Adds media/conf_nitpick.py from mchehab/docs-next [3].
>> 
>> *  doc-rst: migrated media build to parseheaders directive
> 
> OK, I have applied the first five of these,

Thanks!

> but stopped at parse-header.
> At this point, I have a few requests.  These are in approximate order of
> decreasing importance, but they're all important, I think.
> 
> - The new directive could really use some ... documentation.  Preferably in
>  kernel-documentation.rst with the rest.  What is parse-header, how does
>  it differ from kernel-doc, why might a kernel developer doing
>  documentation want (or not want) to use it?  That's all pretty obscure
>  now.  If we want others to jump onto this little bandwagon of ours, we
>  need to make sure it's all really clear.

This could be answered by Mauro.

> - Along those lines, is parse-header the right name for this thing?
>  "Parsing" isn't necessarily the goal of somebody who uses this directive,
>  right?  They want to extract documentation information.  Can we come up
>  with a better name?

Mauro, what is your suggestion and how would we go on in this topic?

> - Can we please try to get the coding style a bit more in line with both
>  kernel and Python community norms?  

Jonathan, we had this already, I gave you the links to "python community
norms" and tools, please read/use them.

* https://www.python.org/dev/peps/pep-0008/
* https://www.pylint.org/

Some of these norms might be unusual for C developers.

> I suspect some people will get grumpy
>  if they see this code.  In particular:
> 
>    - Please try to stick to the 80-column limit when possible.  Python
>      makes that a bit harder than C does, and please don't put in
>      ridiculous line breaks that make the code worse.  But sticking a bit
>      closer to the rule would be good.
> 
>    - The "#========================" lines around function/class
>      definition lines or other comments are not helpful, please avoid
>      them.  Instead, placing a real comment with actual informative text
>      above the function/class would be a good thing.  (I could live with
>      Python docstrings if you prefer, though I will confess I prefer
>      ordinary comments).
> 
>    - No commas at the beginning of continuation lines, please; that would
>      get you yelled at in C code.  If you need to break a function call
>      (or whatever), please put the commas at the end of the line as is
>      done elsewhere.
> 
>  Sorry to poke at nits here, but we want others in the kernel community to
>  be able to look at this code, and that will be easier if we stick closer
>  to the usual rules.

OK, if that's all you find, I will paint a eye candy picture for you.

-- Markus --

