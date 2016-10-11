Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:57598 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753111AbcJKQpg (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 11 Oct 2016 12:45:36 -0400
Date: Tue, 11 Oct 2016 13:45:10 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Markus Heiser <markus.heiser@darmarit.de>
Cc: Jani Nikula <jani.nikula@intel.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        "linux-doc@vger.kernel.org Mailing List" <linux-doc@vger.kernel.org>
Subject: Re: [PATCH 0/4] reST-directive kernel-cmd / include contentent from
 scripts
Message-ID: <20161011134510.0afab942@vento.lan>
In-Reply-To: <E8B76D61-2072-431B-AAB0-E85475D7BFB6@darmarit.de>
References: <1475738420-8747-1-git-send-email-markus.heiser@darmarit.de>
        <87oa2xrhqx.fsf@intel.com>
        <20161006103132.3a56802a@vento.lan>
        <87lgy15zin.fsf@intel.com>
        <20161006135028.2880f5a5@vento.lan>
        <8737k8ya6f.fsf@intel.com>
        <8E74FF11-208D-4C76-8A8C-2B2102E5CB20@darmarit.de>
        <20161011112853.01e15632@vento.lan>
        <87vawyyk5v.fsf@intel.com>
        <E8B76D61-2072-431B-AAB0-E85475D7BFB6@darmarit.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 11 Oct 2016 18:06:46 +0200
Markus Heiser <markus.heiser@darmarit.de> escreveu:

> Am 11.10.2016 um 17:34 schrieb Jani Nikula <jani.nikula@intel.com>:
> 
> > On Tue, 11 Oct 2016, Mauro Carvalho Chehab <mchehab@infradead.org> wrote:  
> >> Em Tue, 11 Oct 2016 09:26:48 +0200
> >> Markus Heiser <markus.heiser@darmarit.de> escreveu:
> >>   
> >>> Am 07.10.2016 um 07:56 schrieb Jani Nikula <jani.nikula@intel.com>:
> >>>   
> >>>> On Thu, 06 Oct 2016, Mauro Carvalho Chehab <mchehab@infradead.org> wrote:    
> >>>>> Em Thu, 06 Oct 2016 17:21:36 +0300
> >>>>> Jani Nikula <jani.nikula@intel.com> escreveu:    
> >>>>>> We've seen what happens when we make it easy to add random scripts to
> >>>>>> build documentation. We've worked hard to get rid of that. In my books,
> >>>>>> one of the bigger points in favor of Sphinx over AsciiDoc(tor) was
> >>>>>> getting rid of all the hacks required in the build. Things that broke in
> >>>>>> subtle ways.    
> >>>>> 
> >>>>> I really can't see what scripts it get rids.    
> >>>> 
> >>>> Really? You don't see why the DocBook build was so fragile and difficult
> >>>> to maintain? That scares me a bit, because then you will not have
> >>>> learned why we should at all costs avoid adding random scripts to
> >>>> produce documentation.    
> >>> 
> >>> For me, disassembling the DocBok build was hard and bothersome, I don't
> >>> want this back.
> >>> 
> >>> IMO: old hats are productive with perl and they won't adapt another
> >>> interpreter language (like python) for scripting. 
> >>> 
> >>> This series -- the kernel-cmd -- directive avoid that they build
> >>> fragile and difficult to maintain Makefile constructs, calling their
> >>> perl scripts.
> >>> 
> >>> Am 06.10.2016 um 16:21 schrieb Jani Nikula <jani.nikula@intel.com>:
> >>>   
> >>>> This is connected to the above: keeping documentation buildable with
> >>>> sphinx-build directly will force you to avoid the Makefile hacks.    
> >>> 
> >>> 
> >>> Thats why I think, that the kernel-cmd directive is a more *straight-
> >>> forward* solution, helps to **avoid** complexity while not everyone
> >>> has to script in python ... 
> >>>   
> >>>> Case in point, parse-headers.pl was added for a specific need of media
> >>>> documentation, and for the life of me I can't figure out by reading the
> >>>> script what good, if any, it would be for gpu documentation. I call
> >>>> *that* unmaintainable.    
> >>> 
> >>> 
> >>> If one adds a script like parse-headers.pl to the Documentation/sphinx 
> >>> folder, he/she also has to add a documentation to the kernel-documentation.rst
> >>> 
> >>> If the kernel-cmd directive gets acked, I will add a description to
> >>> kernel-documentation.rst and I request Mauro to document the parse-headers.pl
> >>> also.  
> >> 
> >> I can write documentation for parse-headers.pl, either as a --help/--man
> >> option or at some ReST file (or both). I'll add this to my mental TODO
> >> list.  
> > 
> > Thanks, documentation will help everyone else evaluate whether
> > parse-headers.pl is only useful for some corner case in media docs, or
> > perhaps more generally useful. Currently, it's hard to tell.
> > 
> > Anyway, documentation does not change my view on adding such scripts. As
> > I've said, I think they will make the documentation build more difficult
> > to maintain. They are likely to become special purpose hacks for corner
> > cases across documentation.  
> 
> Hmm, why not generating reST content by (Perl) scripts? From my POV,
> the scripts/kernel-doc is such a script and parse-headers.pl
> is just another. 

And Sphinx is a third one - or, actually, a set of scripts, as each
extension is also a script ;)

> The only difference of both is, that kernel-doc
> has its own integration (directive) while kernel-cmd is a simple
> solution to call scripts (e.g. parse-headers.pl) within sphinx-build.
> 
> Joking: the kernel-doc directive could replaced by
>         the kernel-cmd directive ;-)

I'm actually OK with either strategy - although it sounds easier
to maintain if we have a single extension to run an external
script - including kernel-doc - specially if the Sphinx extension
API and/or Python changes in the future in a non-backward compatible way.

> > The rest of what you say is unrelated to the patches at hand.  
> 
> I think Mauro want's to address your (justifiable) fear about
> complexity and hacks. IMO he says (by examples); "there are a lot of
> other hard to maintain hacks required, especially when it comes
> to build PDF".
> 
> IMO, complexity is not reduced by prohibit scripts, it is
> ongoing job of the maintainers to observe. 

Yes, that's exactly my point. IMO, not allowing scripts actually
increase complexity, as we'll need Makefile rules to generate
rst files, if we won't allow doing that via perl/python scripts.

If we allow such scripts (and we do since day zero, due to
kernel-doc), then there are 3 options:

1) use a single python script to run the scripts needed in the
   build process (e. g. merging kernel-cmd extension upstream);

2) use a dedicated python script for every non-phyton script;

3) use only python scripts to extend Sphinx functionality.

The (2) scenario seems to be the worse case, as it will end by
having a perl(/shell?) script/python script pair for every 
non-python script we need to run, we're actually making it twice
worse.

For (3) to happen, we'll need to convert both kernel-doc and
parse-headers.pl to Python. This could be a long term goal,
but I prefer to not rewrite those scripts for a while, as
it is a lot easier to maintain them in perl, at least to me, and it
is less disruptive, as rewriting kernel-doc to Python can introduce
regressions.

So, the way I see, (1) is the best approach.

> Anyway, these are only my 2cent. I'am interested in what Jon says
> in general about using (Perl) scripts to generate reST content.
> 
> --Markus--
> 

Regards,
Mauro
