Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1.goneo.de ([85.220.129.30]:38888 "EHLO smtp1.goneo.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752854AbcJKQHL (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 11 Oct 2016 12:07:11 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: [PATCH 0/4] reST-directive kernel-cmd / include contentent from scripts
From: Markus Heiser <markus.heiser@darmarit.de>
In-Reply-To: <87vawyyk5v.fsf@intel.com>
Date: Tue, 11 Oct 2016 18:06:46 +0200
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        "linux-doc@vger.kernel.org Mailing List" <linux-doc@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <E8B76D61-2072-431B-AAB0-E85475D7BFB6@darmarit.de>
References: <1475738420-8747-1-git-send-email-markus.heiser@darmarit.de> <87oa2xrhqx.fsf@intel.com> <20161006103132.3a56802a@vento.lan> <87lgy15zin.fsf@intel.com> <20161006135028.2880f5a5@vento.lan> <8737k8ya6f.fsf@intel.com> <8E74FF11-208D-4C76-8A8C-2B2102E5CB20@darmarit.de> <20161011112853.01e15632@vento.lan> <87vawyyk5v.fsf@intel.com>
To: Jani Nikula <jani.nikula@intel.com>,
        Jonathan Corbet <corbet@lwn.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Am 11.10.2016 um 17:34 schrieb Jani Nikula <jani.nikula@intel.com>:

> On Tue, 11 Oct 2016, Mauro Carvalho Chehab <mchehab@infradead.org> wrote:
>> Em Tue, 11 Oct 2016 09:26:48 +0200
>> Markus Heiser <markus.heiser@darmarit.de> escreveu:
>> 
>>> Am 07.10.2016 um 07:56 schrieb Jani Nikula <jani.nikula@intel.com>:
>>> 
>>>> On Thu, 06 Oct 2016, Mauro Carvalho Chehab <mchehab@infradead.org> wrote:  
>>>>> Em Thu, 06 Oct 2016 17:21:36 +0300
>>>>> Jani Nikula <jani.nikula@intel.com> escreveu:  
>>>>>> We've seen what happens when we make it easy to add random scripts to
>>>>>> build documentation. We've worked hard to get rid of that. In my books,
>>>>>> one of the bigger points in favor of Sphinx over AsciiDoc(tor) was
>>>>>> getting rid of all the hacks required in the build. Things that broke in
>>>>>> subtle ways.  
>>>>> 
>>>>> I really can't see what scripts it get rids.  
>>>> 
>>>> Really? You don't see why the DocBook build was so fragile and difficult
>>>> to maintain? That scares me a bit, because then you will not have
>>>> learned why we should at all costs avoid adding random scripts to
>>>> produce documentation.  
>>> 
>>> For me, disassembling the DocBok build was hard and bothersome, I don't
>>> want this back.
>>> 
>>> IMO: old hats are productive with perl and they won't adapt another
>>> interpreter language (like python) for scripting. 
>>> 
>>> This series -- the kernel-cmd -- directive avoid that they build
>>> fragile and difficult to maintain Makefile constructs, calling their
>>> perl scripts.
>>> 
>>> Am 06.10.2016 um 16:21 schrieb Jani Nikula <jani.nikula@intel.com>:
>>> 
>>>> This is connected to the above: keeping documentation buildable with
>>>> sphinx-build directly will force you to avoid the Makefile hacks.  
>>> 
>>> 
>>> Thats why I think, that the kernel-cmd directive is a more *straight-
>>> forward* solution, helps to **avoid** complexity while not everyone
>>> has to script in python ... 
>>> 
>>>> Case in point, parse-headers.pl was added for a specific need of media
>>>> documentation, and for the life of me I can't figure out by reading the
>>>> script what good, if any, it would be for gpu documentation. I call
>>>> *that* unmaintainable.  
>>> 
>>> 
>>> If one adds a script like parse-headers.pl to the Documentation/sphinx 
>>> folder, he/she also has to add a documentation to the kernel-documentation.rst
>>> 
>>> If the kernel-cmd directive gets acked, I will add a description to
>>> kernel-documentation.rst and I request Mauro to document the parse-headers.pl
>>> also.
>> 
>> I can write documentation for parse-headers.pl, either as a --help/--man
>> option or at some ReST file (or both). I'll add this to my mental TODO
>> list.
> 
> Thanks, documentation will help everyone else evaluate whether
> parse-headers.pl is only useful for some corner case in media docs, or
> perhaps more generally useful. Currently, it's hard to tell.
> 
> Anyway, documentation does not change my view on adding such scripts. As
> I've said, I think they will make the documentation build more difficult
> to maintain. They are likely to become special purpose hacks for corner
> cases across documentation.

Hmm, why not generating reST content by (Perl) scripts? From my POV,
the scripts/kernel-doc is such a script and parse-headers.pl
is just another. The only difference of both is, that kernel-doc
has its own integration (directive) while kernel-cmd is a simple
solution to call scripts (e.g. parse-headers.pl) within sphinx-build.

Joking: the kernel-doc directive could replaced by
        the kernel-cmd directive ;-)

> The rest of what you say is unrelated to the patches at hand.

I think Mauro want's to address your (justifiable) fear about
complexity and hacks. IMO he says (by examples); "there are a lot of
other hard to maintain hacks required, especially when it comes
to build PDF".

IMO, complexity is not reduced by prohibit scripts, it is
ongoing job of the maintainers to observe. 

Anyway, these are only my 2cent. I'am interested in what Jon says
in general about using (Perl) scripts to generate reST content.

--Markus--

