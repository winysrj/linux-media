Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:41162
        "EHLO s-opensource.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756135AbcH2PNd (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 29 Aug 2016 11:13:33 -0400
Date: Mon, 29 Aug 2016 12:13:26 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Markus Heiser <markus.heiser@darmarit.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Subject: Re: [PATCH v3] docs-rst: ignore arguments on macro definitions
Message-ID: <20160829121326.782e4261@vento.lan>
In-Reply-To: <BBC1BC77-BCF1-453C-B85D-9758C4C433A6@darmarit.de>
References: <e4955d6ed9b730f544fe40b0344c4451dd415cda.1472476362.git.mchehab@s-opensource.com>
        <BBC1BC77-BCF1-453C-B85D-9758C4C433A6@darmarit.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 29 Aug 2016 16:12:39 +0200
Markus Heiser <markus.heiser@darmarit.de> escreveu:

> Am 29.08.2016 um 15:13 schrieb Mauro Carvalho Chehab <mchehab@s-opensource.com>:
> 
> > A macro definition is mapped via .. c:function:: at the
> > ReST markup when using the following kernel-doc tag:
> > 
> > 	/**
> > 	 * DMX_FE_ENTRY - Casts elements in the list of registered
> > 	 *               front-ends from the generic type struct list_head
> > 	 *               to the type * struct dmx_frontend
> > 	 *
> > 	 * @list: list of struct dmx_frontend
> > 	 */
> > 	 #define DMX_FE_ENTRY(list) \
> > 	        list_entry(list, struct dmx_frontend, connectivity_list)
> > 
> > However, unlike a function description, the arguments of a macro
> > doesn't contain the data type.
> > 
> > This causes warnings when enabling Sphinx on nitkpick mode,
> > like this one:
> > 	./drivers/media/dvb-core/demux.h:358: WARNING: c:type reference target not found: list  
> 
> I think this is a drawback of sphinx's C-domain, using function
> definition for macros also. From the function documentation
> 
>  """This is also used to describe function-like preprocessor
>     macros. The names of the arguments should be given so
>     they may be used in the description."""
> 
> I think about to fix the nitpick message for macros (aka function
> directive) in the C-domain extension (we already have).

Yeah, that could produce a better output, if it is doable.

> 
> But for this, I need a rule to distinguish between macros
> and functions ... is the uppercase of the macro name a good
> rule to suppress the nitpick message? 

No. There are lots of macros in lowercase. never did any stats about
that, but I guess that we actually have a way more such macros in
lowercase.

> Any other suggestions?

I guess the best thing is to check if the type is empty, just like
on this patch. Macros are always:
	foo(arg1, arg2, arg3, ...)

while functions always have some type (with could be as complex as
a function pointer). So, if all arguments match this rejex:
	\s*\S+\s*
Then, it is a macro. Otherwise, it is a function.

There's no way for the C domain to distinguish between a macro or
a function when the number of arguments is zero, but, on such case,
it doesn't really matter.

Thanks,
Mauro
