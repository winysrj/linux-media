Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:14206 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933330AbcHaJCI (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 31 Aug 2016 05:02:08 -0400
From: Jani Nikula <jani.nikula@linux.intel.com>
To: Markus Heiser <markus.heiser@darmarit.de>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Subject: Re: [PATCH v3] docs-rst: ignore arguments on macro definitions
In-Reply-To: <B29EF07A-454E-456E-91B6-AE5B0D6C04D1@darmarit.de>
References: <e4955d6ed9b730f544fe40b0344c4451dd415cda.1472476362.git.mchehab@s-opensource.com> <BBC1BC77-BCF1-453C-B85D-9758C4C433A6@darmarit.de> <20160829121326.782e4261@vento.lan> <87y43fh9ix.fsf@intel.com> <B29EF07A-454E-456E-91B6-AE5B0D6C04D1@darmarit.de>
Date: Wed, 31 Aug 2016 12:02:05 +0300
Message-ID: <87vayhz4z6.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 31 Aug 2016, Markus Heiser <markus.heiser@darmarit.de> wrote:
> I haven't tested your suggestion, but since *void* is in the list
> of stop-words:
>
>     # These C types aren't described anywhere, so don't try to create
>     # a cross-reference to them
>     stopwords = set((
>         'const', 'void', 'char', 'wchar_t', 'int', 'short',
>         'long', 'float', 'double', 'unsigned', 'signed', 'FILE',
>         'clock_t', 'time_t', 'ptrdiff_t', 'size_t', 'ssize_t',
>         'struct', '_Bool',
>     ))
>
> I think it will work in the matter you think. 
>
> However I like to prefer to fix it in the C-domain, using
> Mauro's suggestion on argument parsing. IMHO it is not
> the best solution to add a void type to the reST signature
> of a macro. This will result in a unusual output and does
> not fix what is wrong in Sphinx's c-domain (there is also
> a drawback in the index, where a function-type macro is
> referred as function, not as macro).

>From an API user's perspective, functions and function-like macros
should work interchangeably. Personally, I don't think there needs to be
a difference in the index. This seems to be the approach taken in
Sphinx, but it just doesn't work well for automatic documentation
generation because we can't deduce the parameter types from the macro
definition.

BR,
Jani.


-- 
Jani Nikula, Intel Open Source Technology Center
