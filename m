Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp2.goneo.de ([85.220.129.33]:52744 "EHLO smtp2.goneo.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753144AbcHaIQI (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 31 Aug 2016 04:16:08 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: [PATCH v3] docs-rst: ignore arguments on macro definitions
From: Markus Heiser <markus.heiser@darmarit.de>
In-Reply-To: <87y43fh9ix.fsf@intel.com>
Date: Wed, 31 Aug 2016 10:15:49 +0200
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <B29EF07A-454E-456E-91B6-AE5B0D6C04D1@darmarit.de>
References: <e4955d6ed9b730f544fe40b0344c4451dd415cda.1472476362.git.mchehab@s-opensource.com> <BBC1BC77-BCF1-453C-B85D-9758C4C433A6@darmarit.de> <20160829121326.782e4261@vento.lan> <87y43fh9ix.fsf@intel.com>
To: Jani Nikula <jani.nikula@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Am 29.08.2016 um 17:36 schrieb Jani Nikula <jani.nikula@linux.intel.com>:

> On Mon, 29 Aug 2016, Mauro Carvalho Chehab <mchehab@s-opensource.com> wrote:
>> Em Mon, 29 Aug 2016 16:12:39 +0200
>> Markus Heiser <markus.heiser@darmarit.de> escreveu:
>> 
>>> Am 29.08.2016 um 15:13 schrieb Mauro Carvalho Chehab <mchehab@s-opensource.com>:
>>> 
>>>> A macro definition is mapped via .. c:function:: at the
>>>> ReST markup when using the following kernel-doc tag:
>>>> 
>>>> 	/**
>>>> 	 * DMX_FE_ENTRY - Casts elements in the list of registered
>>>> 	 *               front-ends from the generic type struct list_head
>>>> 	 *               to the type * struct dmx_frontend
>>>> 	 *
>>>> 	 * @list: list of struct dmx_frontend
>>>> 	 */
>>>> 	 #define DMX_FE_ENTRY(list) \
>>>> 	        list_entry(list, struct dmx_frontend, connectivity_list)
>>>> 
>>>> However, unlike a function description, the arguments of a macro
>>>> doesn't contain the data type.
>>>> 
>>>> This causes warnings when enabling Sphinx on nitkpick mode,
>>>> like this one:
>>>> 	./drivers/media/dvb-core/demux.h:358: WARNING: c:type reference target not found: list  
>>> 
>>> I think this is a drawback of sphinx's C-domain, using function
>>> definition for macros also. From the function documentation
>>> 
>>> """This is also used to describe function-like preprocessor
>>>    macros. The names of the arguments should be given so
>>>    they may be used in the description."""
>>> 
>>> I think about to fix the nitpick message for macros (aka function
>>> directive) in the C-domain extension (we already have).
>> 
>> Yeah, that could produce a better output, if it is doable.
>> 
>>> 
>>> But for this, I need a rule to distinguish between macros
>>> and functions ... is the uppercase of the macro name a good
>>> rule to suppress the nitpick message? 
>> 
>> No. There are lots of macros in lowercase. never did any stats about
>> that, but I guess that we actually have a way more such macros in
>> lowercase.
>> 
>>> Any other suggestions?
>> 
>> I guess the best thing is to check if the type is empty, just like
>> on this patch. Macros are always:
>> 	foo(arg1, arg2, arg3, ...)

Yes, it is so clear, ... I'am a gawk ;-)

>> while functions always have some type (with could be as complex as
>> a function pointer). So, if all arguments match this rejex:
>> 	\s*\S+\s*
>> Then, it is a macro. Otherwise, it is a function.
>> 
>> There's no way for the C domain to distinguish between a macro or
>> a function when the number of arguments is zero, but, on such case,
>> it doesn't really matter.
> 
> What does Sphinx say if you add "void" as the type? Or a fake
> "macroparam" type?

Hi Jani, sorry for my late reply,

I haven't tested your suggestion, but since *void* is in the list
of stop-words:

    # These C types aren't described anywhere, so don't try to create
    # a cross-reference to them
    stopwords = set((
        'const', 'void', 'char', 'wchar_t', 'int', 'short',
        'long', 'float', 'double', 'unsigned', 'signed', 'FILE',
        'clock_t', 'time_t', 'ptrdiff_t', 'size_t', 'ssize_t',
        'struct', '_Bool',
    ))

I think it will work in the matter you think. 

However I like to prefer to fix it in the C-domain, using
Mauro's suggestion on argument parsing. IMHO it is not
the best solution to add a void type to the reST signature
of a macro. This will result in a unusual output and does
not fix what is wrong in Sphinx's c-domain (there is also
a drawback in the index, where a function-type macro is
referred as function, not as macro).

I will give it a try, to eliminate these drawbacks in 
the C-domain and send a patch series, we can discuss further.

-- Markus --


> 
> If those hacks don't help, Mauro's suggestion seems sane.
> 
> BR,
> Jani.
> 
> 
> 
>> 
>> Thanks,
>> Mauro
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-doc" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> -- 
> Jani Nikula, Intel Open Source Technology Center

