Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:48584
        "EHLO s-opensource.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752100AbcHaK0i (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 31 Aug 2016 06:26:38 -0400
Date: Wed, 31 Aug 2016 07:26:29 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Markus Heiser <markus.heiser@darmarit.de>
Cc: Jani Nikula <jani.nikula@linux.intel.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Subject: Re: [PATCH v3] docs-rst: ignore arguments on macro definitions
Message-ID: <20160831072629.6b42ff3c@vento.lan>
In-Reply-To: <449181AD-39BC-4A88-A633-13BA1EC21449@darmarit.de>
References: <e4955d6ed9b730f544fe40b0344c4451dd415cda.1472476362.git.mchehab@s-opensource.com>
        <BBC1BC77-BCF1-453C-B85D-9758C4C433A6@darmarit.de>
        <20160829121326.782e4261@vento.lan>
        <87y43fh9ix.fsf@intel.com>
        <B29EF07A-454E-456E-91B6-AE5B0D6C04D1@darmarit.de>
        <87vayhz4z6.fsf@intel.com>
        <449181AD-39BC-4A88-A633-13BA1EC21449@darmarit.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 31 Aug 2016 12:09:39 +0200
Markus Heiser <markus.heiser@darmarit.de> escreveu:

> Am 31.08.2016 um 11:02 schrieb Jani Nikula <jani.nikula@linux.intel.com>:
> 
> > On Wed, 31 Aug 2016, Markus Heiser <markus.heiser@darmarit.de> wrote:  
> >> I haven't tested your suggestion, but since *void* is in the list
> >> of stop-words:
> >> 
> >>    # These C types aren't described anywhere, so don't try to create
> >>    # a cross-reference to them
> >>    stopwords = set((
> >>        'const', 'void', 'char', 'wchar_t', 'int', 'short',
> >>        'long', 'float', 'double', 'unsigned', 'signed', 'FILE',
> >>        'clock_t', 'time_t', 'ptrdiff_t', 'size_t', 'ssize_t',
> >>        'struct', '_Bool',
> >>    ))
> >> 
> >> I think it will work in the matter you think. 
> >> 
> >> However I like to prefer to fix it in the C-domain, using
> >> Mauro's suggestion on argument parsing. IMHO it is not
> >> the best solution to add a void type to the reST signature
> >> of a macro. This will result in a unusual output and does
> >> not fix what is wrong in Sphinx's c-domain (there is also
> >> a drawback in the index, where a function-type macro is
> >> referred as function, not as macro).  
> > 
> > From an API user's perspective, functions and function-like macros
> > should work interchangeably.  
> 
> Ah, OK.
> 
> > Personally, I don't think there needs to be
> > a difference in the index. This seems to be the approach taken in
> > Sphinx, but it just doesn't work well for automatic documentation
> > generation because we can't deduce the parameter types from the macro
> > definition.  
> 
> In the index, sphinx refers only object-like macros with an entry 
> "FOO (C macro))". Function-like macros are referred as "BAR (C function)".
> 
> I thought it is more straight forward to refer all macros with a 
> "BAR (C macro)" entry in the index. I will split this change in
> a separate patch, so we can decide if we like to patch the index
> that way.
>
> But now, as we discuss this, I have another doubt to fix the index.
> It might be confusing when writing references to those macros.
> 
> Since function-like macros internally are functions in the c-domain, 
> they are referred with ":c:func:`BAR`". On the other side, object-like
> macros are referred by role ":c:macro:`FOO`".
> 
> Taking this into account, it might be one reason more to follow
> your conclusion that functions and function-like macros are 
> interchangeable from the user's perspective.

It is not uncommon to "promote" some such macros to inline
functions, in order to have a stronger type check, or to do the
reverse, when we need a more generic declaration that would work
for multiple types.

So, keeping both macro function-like functions and functions using
the :c:function: seems to be the best, IMHO. It also makes life
easier for kernel-doc script.

> 
> -- Markus --
> 
> > 
> > BR,
> > Jani.
> > 
> > 
> > -- 
> > Jani Nikula, Intel Open Source Technology Center
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-doc" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html  
> 



Thanks,
Mauro
