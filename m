Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:51307 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752672AbcJKO33 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 11 Oct 2016 10:29:29 -0400
Date: Tue, 11 Oct 2016 11:28:53 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Markus Heiser <markus.heiser@darmarit.de>
Cc: Jani Nikula <jani.nikula@intel.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        "linux-doc@vger.kernel.org Mailing List" <linux-doc@vger.kernel.org>
Subject: Re: [PATCH 0/4] reST-directive kernel-cmd / include contentent from
 scripts
Message-ID: <20161011112853.01e15632@vento.lan>
In-Reply-To: <8E74FF11-208D-4C76-8A8C-2B2102E5CB20@darmarit.de>
References: <1475738420-8747-1-git-send-email-markus.heiser@darmarit.de>
        <87oa2xrhqx.fsf@intel.com>
        <20161006103132.3a56802a@vento.lan>
        <87lgy15zin.fsf@intel.com>
        <20161006135028.2880f5a5@vento.lan>
        <8737k8ya6f.fsf@intel.com>
        <8E74FF11-208D-4C76-8A8C-2B2102E5CB20@darmarit.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 11 Oct 2016 09:26:48 +0200
Markus Heiser <markus.heiser@darmarit.de> escreveu:

> Am 07.10.2016 um 07:56 schrieb Jani Nikula <jani.nikula@intel.com>:
> 
> > On Thu, 06 Oct 2016, Mauro Carvalho Chehab <mchehab@infradead.org> wrote:  
> >> Em Thu, 06 Oct 2016 17:21:36 +0300
> >> Jani Nikula <jani.nikula@intel.com> escreveu:  
> >>> We've seen what happens when we make it easy to add random scripts to
> >>> build documentation. We've worked hard to get rid of that. In my books,
> >>> one of the bigger points in favor of Sphinx over AsciiDoc(tor) was
> >>> getting rid of all the hacks required in the build. Things that broke in
> >>> subtle ways.  
> >> 
> >> I really can't see what scripts it get rids.  
> > 
> > Really? You don't see why the DocBook build was so fragile and difficult
> > to maintain? That scares me a bit, because then you will not have
> > learned why we should at all costs avoid adding random scripts to
> > produce documentation.  
> 
> For me, disassembling the DocBok build was hard and bothersome, I don't
> want this back.
> 
> IMO: old hats are productive with perl and they won't adapt another
> interpreter language (like python) for scripting. 
> 
> This series -- the kernel-cmd -- directive avoid that they build
> fragile and difficult to maintain Makefile constructs, calling their
> perl scripts.
> 
> Am 06.10.2016 um 16:21 schrieb Jani Nikula <jani.nikula@intel.com>:
> 
> > This is connected to the above: keeping documentation buildable with
> > sphinx-build directly will force you to avoid the Makefile hacks.  
> 
> 
> Thats why I think, that the kernel-cmd directive is a more *straight-
> forward* solution, helps to **avoid** complexity while not everyone
> has to script in python ... 
> 
> > Case in point, parse-headers.pl was added for a specific need of media
> > documentation, and for the life of me I can't figure out by reading the
> > script what good, if any, it would be for gpu documentation. I call
> > *that* unmaintainable.  
> 
> 
> If one adds a script like parse-headers.pl to the Documentation/sphinx 
> folder, he/she also has to add a documentation to the kernel-documentation.rst
> 
> If the kernel-cmd directive gets acked, I will add a description to
> kernel-documentation.rst and I request Mauro to document the parse-headers.pl
> also.

I can write documentation for parse-headers.pl, either as a --help/--man
option or at some ReST file (or both). I'll add this to my mental TODO
list.

-

With regards to Sphinx x DocBook, in terms of functionality, Sphinx
is an improvement, as we can now use the same markup for everything,
and cross-reference all documents. Unfortunately, it has less
functionality than DocBook, and requires more magic to work.

However, there are costs to pay on using a Python script like Sphinx.
I won't mention again the issues with Python itself and its unstable
API, but, instead, focus on Sphinx script itself.

First of all, installing packages for Sphinx script to work is a lot
more complex, specially for the PDF output, as the LaTeX requirements are
very distribution specific, as some distributions package each LaTeX
extension as optional packages, and the required extensions used by
the Sphinx script are not documented.

Also, the Sphinx script and its build logic is a lot more fragile than 
the Makefile/xmlto that we use on DocBook, and this has nothing to do 
with adding extra perl/python scripts.

While it is clean for html output, it is very dirty when producing
a PDF output.

It starts by generating its own Makefile for PDF builds, at the output
directory, with we have little control on it. 

Also, it seems that almost all books will need hacks to produce proper PDF,
as neither ReST or Sphinx extensions currently have proper support to adjust
things provided on DocBook, like setting page properties, enabling 
image/table scaling, auto-numbering images/tables/examples or changing page
orientation in the middle of a document.

The biggest issue I found is related to table outputs in PDF format, as
it does a very poor job adjusting table margins to fit inside the paper
margins. Also, the auto-generated TOC index on PDF doesn't match the
numeration of the HTML output. Currently, I didn't find any solution
for the latter issue.

As Sphinx markup doesn't have any way to tell how the output would be
formatted, a lot of magic is required at Sphinx conf.py for PDF
output to start working. Worse than that, several tables require
extra tags for PDF output, specifying the column sizes, and forcing
them to be handled as longtables[1]. Also, if the table is too big,
the rst files require raw latex macros/code before/after such
tables, in order for them to fit inside a paper page - either by
changing their orientation or enabling auto-scale, if the table is
not a longtable. Currently, no way to tell Sphinx to enable auto-scale
on big tables. 

So, in practice, it means that Sphinx build is a house of cards, 
at least for PDF output, as every new book should be tested if
it will produce a proper PDF output, and add extra hacks inside
the rst files to fix them, when the defaults won't work.

I'm almost sure that we end by needing similar hacks for man
page output.

Thanks,
Mauro


[1] 

Sphinx script outputs table in LaTeX format using either
"tabularx" or "longtable". A "tabularx" table should fit into
one page, but it can be scaled to fit into a page using the
"adjustbox" LaTeX extension. A "longtable" can have multiple pages,
but can't be scaled.

The way the Sphinx script decides either to use tabularx or longtable 
is based *only* on the number of table rows: if bigger than 30, it
uses "longtable" - even if the table is small enough to fit on a single
page; if lower than 30, even if the table is very big, it will use
"tabularx".

There are several cases of tables with less than 30 rows that won't
fit on a single page, because each row has several lines. Every such
table requires an extra tag (".. cssclass:: longtable") for it to
be properly displayed at the PDF output.

However, the reverse is a lot worse: there are have several cases on
media where we have tables bigger than 30 rows that would fit well on
a single page, as there's just one line per how. Unfortunately,
Sphinx doesn't allow forcing a table to be output using "tabularx".
As "longtable" cannot be scaled using "adjustbox", the ones whose
lines won't fit into a page requires a magic raw latex spell in
order to force the LaTeX output to use a smaller font size, as ReST
doesn't have any markup to specify the text output size.

In practice, a typical "tabularx" table found on media require
those markups:

	.. raw:: latex

	   \begin{adjustbox}{width=\columnwidth}

	.. tabularcolumns:: |p{11.0cm}|p{10.0cm}|

	<some table>

	.. raw:: latex

	   \end{adjustbox}

And for some "longtable" (as found at Documentation/media/uapi/v4l/subdev-formats.rst):

	.. tabularcolumns:: <column sizes>

	.. _v4l2-mbus-pixelcode-rgb:

	.. raw:: latex

	    \begingroup
	    \tiny
	    \setlength{\tabcolsep}{2pt}

	<table>

	.. raw:: latex

	    \endgroup

With is very dirty and ugly, IMHO. This is a lot uglier than any extra
scripts added to the Sphinx script, either as via a generic kernel-cmd
script or via some Sphinx script extension.


