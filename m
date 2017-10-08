Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp3.goneo.de ([85.220.129.37]:58670 "EHLO smtp3.goneo.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753329AbdJHKIK (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 8 Oct 2017 06:08:10 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Subject: Re: [PATCH v3 00/17] kernel-doc: add supported to document nested
 structs/
From: Markus Heiser <markus.heiser@darmarit.de>
In-Reply-To: <20171007103440.35393957@lwn.net>
Date: Sun, 8 Oct 2017 12:07:29 +0200
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <46422126-F8AB-41A0-8962-99D024EE17D3@darmarit.de>
References: <cover.1507116877.git.mchehab@s-opensource.com>
 <20171007103440.35393957@lwn.net>
To: Jonathan Corbet <corbet@lwn.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


> Am 07.10.2017 um 18:34 schrieb Jonathan Corbet <corbet@lwn.net>:
> 
> On Wed,  4 Oct 2017 08:48:38 -0300
> Mauro Carvalho Chehab <mchehab@s-opensource.com> wrote:
> 
>> Right now, it is not possible to document nested struct and nested unions.
>> kernel-doc simply ignore them.
>> 
>> Add support to document them.
> 
> So I've finally found some time to actually look at these; sorry for being
> so absent from the discussion.  I plead $EXCUSES...
> 
> Some overall impressions:
> 
> - Seems like something we want.
> - I love hacking all the cruft out of kernel-doc; I've been meaning to
>  do that for a bit.
> - It would sure be nice to restore proper man-page generation rather than
>  documenting a hack with a perl script.  Someday.
> 
> I have one real complaint, though: with these patches applied, a "make
> htmldocs" generates about 5500 (!) more warnings than it did before.  Over
> the last couple of months, I put a bit of focused time into reducing
> warnings, and managed to get rid of 20-30 of them.  Now I feel despondent.
> 
> I really don't want to add that much noise to the docs build; I think it
> will defeat any hope of cleaning up the warnings we already have.  I
> wonder if we could suppress warnings about nested structs by default, and
> add a flag or envar to turn them back on for those who want them?

This is what I vote for: +1

> In truth, now that I look, the real problem is that the warnings are
> repeated many times - as in, like 100 times:
> 
>> ./include/net/cfg80211.h:4115: warning: Function parameter or member 'wext.ibss' not described in 'wireless_dev'
>> ./include/net/cfg80211.h:4115: warning: Function parameter or member 'wext.ibss' not described in 'wireless_dev'
> <107 instances deleted...>
>> ./include/net/cfg80211.h:4115: warning: Function parameter or member 'wext.ibss' not described in 'wireless_dev'
> 
> That's not something that used to happen, and is certainly not helpful.
> Figuring that out would help a lot.  Can I get you to take a look at
> what's going on here?

Hi Jon, if you grep for 

 .. kernel-doc:: include/net/cfg80211.h

e.g. by:  grep cfg80211.h Documentation/driver-api/80211/cfg80211.rst | wc -l
you will see, that this directive is used 110 times in one reST file. If you
have 5 warnings about the kernel-doc markup in include/net/cfg80211.h you will
get 550 warnings about kernel-doc markup just for just one source code file.

This is because the kernel-doc parser is an external process which is called
(in this example) 110 times for one reST file and one source code file. If 
include/net/cfg80211.h is referred in other reST files, we got accordingly
more and more warnings .. thats really noise. 

So what I see is, that a major part of such noise is self made, it was one major
goal when I started with the python implementation: run kernel-doc parser in the 
Sphinx process, cache the results and use it in all reST files where it is required
from a kernel-doc directive.

Since there is also a man page solution in the py- version I vote to merge the
py-version into the kernel (ATM man is similar to what we had in DocBook and
it is expandable). If you want to have a preview of the result, try this patch:

 https://return42.github.io/linuxdoc/linux.html

The only drawback of the py version I see is, that Mauro prefers perl and I do
not want to lose him as an contributer to the kernel-doc parser. IMO he is an
experienced C programmer with an excellent regexpr knowledge. This is, what is
needed for this job. May be we can motivate him to give python one more try,
this is what I hope.

The py version includes all patches we had to the perl version, but I also
know, that you are not 100% compliant with the coding style, this could
all be fixed in a RFC round. Excuse me if I annoying with this solution;
IMO it contains what we need, if we really want to make a step forward.

Thanks,

-- Markus --

> 
> Thanks,
> 
> jon
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-doc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
