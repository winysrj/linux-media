Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:59070 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752534AbcDRLQP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Apr 2016 07:16:15 -0400
Date: Mon, 18 Apr 2016 08:16:05 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Markus Heiser <markus.heiser@darmarIT.de>
Cc: Jonathan Corbet <corbet@lwn.net>,
	Jani Nikula <jani.nikula@intel.com>,
	Dan Allen <dan@opendevise.io>,
	Russel Winder <russel@winder.org.uk>,
	Keith Packard <keithp@keithp.com>,
	LKML <linux-kernel@vger.kernel.org>,
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
	Daniel Vetter <daniel.vetter@ffwll.ch>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	"linux-media@vger.kernel.org linux-media"
	<linux-media@vger.kernel.org>,
	Graham Whaley <graham.whaley@linux.intel.com>
Subject: Re: Kernel docs: muddying the waters a bit
Message-ID: <20160418081605.3fc5398b@recife.lan>
In-Reply-To: <279E616C-B743-4395-9E2B-9B371132B3B8@darmarIT.de>
References: <20160213145317.247c63c7@lwn.net>
	<87y49zr74t.fsf@intel.com>
	<20160303071305.247e30b1@lwn.net>
	<20160303155037.705f33dd@recife.lan>
	<86egbrm9hw.fsf@hiro.keithp.com>
	<1457076530.13171.13.camel@winder.org.uk>
	<CAKeHnO6sSV1x2xh_HgbD5ddZ8rp+SVvbdjVhczhudc9iv_-UCQ@mail.gmail.com>
	<87a8m9qoy8.fsf@intel.com>
	<20160308082948.4e2e0f82@recife.lan>
	<CAKeHnO7R25knFH07+3trdi0ZotsrEE+5ZzDZXdx33+DUW=q2Ug@mail.gmail.com>
	<20160308103922.48d87d9d@recife.lan>
	<20160308123921.6f2248ab@recife.lan>
	<20160309182709.7ab1e5db@recife.lan>
	<87fuvypr2h.fsf@intel.com>
	<20160310122101.2fca3d79@recife.lan>
	<AA8C4658-5361-4BE1-8A67-EB1C5F17C6B4@darmarit.de>
	<8992F589-5B66-4BDB-807A-79AC8644F006@darmarit.de>
	<20160412105850.50e02108@recife.lan>
	<279E616C-B743-4395-9E2B-9B371132B3B8@darmarIT.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 18 Apr 2016 10:10:17 +0200
Markus Heiser <markus.heiser@darmarIT.de> escreveu:

> Hi Mauro, hi kernel-doc authors, 
> 
> Am 12.04.2016 um 15:58 schrieb Mauro Carvalho Chehab <mchehab@osg.samsung.com>:
> 
> > Em Fri, 8 Apr 2016 17:12:27 +0200
> > Markus Heiser <markus.heiser@darmarit.de> escreveu:
> >   
> >> Hi kernel-doc authors,
> >> 
> >> motivated by this MT, I implemented a toolchain to migrate the kernel’s 
> >> DocBook XML documentation to reST markup. 
> >> 
> >> It converts 99% of the docs well ... to gain an impression how 
> >> kernel-docs could benefit from, visit my sphkerneldoc project page
> >> on github:
> >> 
> >> http://return42.github.io/sphkerneldoc/
> >> 
> >> The sources available at:
> >> 
> >> https://github.com/return42/sphkerneldoc
> >> 
> >> The work is underway, suggestions are welcome!
> >> 
> >> .. have a nice weekend ..  
> > 
> > Hi Markus,
> > 
> > Thanks for your work. I'm basically worried about the media docbook,
> > with has some complexities that I was not able to figure out a way to
> > convert it to reST.
> > 
> > So, let me pinpoint some issues that I noticed there, on a quick
> > look.
> > 
> > The first thing I noticed is that the index doesn't match what's
> > there, when generated from DocBook:
> > 	https://linuxtv.org/downloads/v4l-dvb-apis/v4l2spec.html
> > 
> > So, for instance, "Interfaces" is at the same level as "Input/Output".
> > 
> > This sounds like an something went wrong when dealing with the title
> > indentation levels during the conversion.
> >   
> 
> Yes, the hierarchical structure was broken by two causes. First was, that the
> *chunking* was wrong and the other was, that my DocBook-XML-filter (dbxml) placed
> all sections and sub(-sub)-sections at the same level (direct under chapter). This was
> not only broken in the linux_tv book, in the other books also.
> 
> Thanks for pointing and sorry that I have overlooked this (I was so much focused on
> on converting single elements to reST, that I not see the wood for the trees).
> 
> It is now fixed, may you give it a new try.

Thanks! It looks good now.

> > I would also like to see the titles numbered in chapters (and, if
> > possible, in sections and items) and to be properly indented at the 
> > index.  
> 
> BTW a few words about differences between DockBook and reST (Sphinx).
> 
> With DocBook you write *books*, the protocol (the DocBook application) has
> no facility to *chunk* and interconnect several documents. The external ENTITY 
> is a workaround on the SGML layer, not on XML nor on the DB-application layer.
> Thats the reason, why so many XML-tools don't handle this entities and
> many DocBook to (e.g.) reST tools are fail.
> 
> With **standard** reST it is nearly the same, except there is a "include"
> directive on the application layer. But this directive is very simple,
> comparable to the C preprocessor "#include" directive.
> 
> With the **superset** reST-markup of Sphinx-doc you get a the "toctree" directive,
> which lets you control how a document-tree should be build.
> 
>  http://www.sphinx-doc.org/en/stable/markup/toctree.html
> 
> @Mauro: you mentioned a docutils (rst2*) experience in your mail 
>       http://marc.info/?l=linux-doc&m=145735316012094&w=2
> 
>       Because the "toctree" directive -- and other directives
>       we use -- are a part of a superset of the **standard** 
>       reST, the standard docutils (like rst2*) will not work.
> 
> OK, back to your requirements: within the toctree directive you can
> set options like "maxdepth" and "numbered". It is a decision, how
> deep TOCs should go and if they should be numbered. IMO, in a
> HTML rendered page, with a proper navigation bar on the side, deep 
> TOCs in the running text have no pros, they only blow up the running
> text and bring more scrolling with. In my sense numbering chapters
> make only sense in books, not in HTML pages, where you have hyperlinks.
> 
> Just for demonstration, I added numbering in the linux-tv book:
> 
> https://github.com/return42/sphkerneldoc/commit/468ded71f62d497ac71aead1a6d50de7ef77c3c3
> 
> May be, I will drop it later, because all reST sources are generated
> by a make target and I always commit the whole reST tree. As I said, 
> it is a decision which might be made later, when the migration takes 
> places.

This is the uAPI spec DocBook, that we modify frequently, as we add
more features to the Kernel, and as we make sure that all drivers will
behave the same. So, from time to time, we need to clarify some topics
at the documentation. By having a numeration, it is easier for us to
discuss things like:
	"1.2.10.14. V4L2_PIX_FMT_VYUY (‘VYUY’)" is not properly
described and requires some sort of clarification.

Ok, one could also refer to it via a hyperlink, but several Kernel
media maintainers prefer to generate a single big html file, as it
makes easier to locate everything it is needed on it.

So, with the item number, they can just seek for "1.2.10.14. " string
to find the item that is under discussion.

> > Also, it seems that there's still a lot of work to do, as there are several
> > tables that are missing conversion, like the table for "struct v4l2_pix_format":
> > 	https://return42.github.io/sphkerneldoc/books/linux_tv/media/v4l/pixfmt.html
> > 
> > and the big tables at:
> > 	https://return42.github.io/sphkerneldoc/books/linux_tv/media/v4l/pixfmt-packed-rgb.html
> > 	https://return42.github.io/sphkerneldoc/books/linux_tv/media/v4l/pixfmt-packed-yuv.html
> > 	https://return42.github.io/sphkerneldoc/books/linux_tv/media/v4l/subdev-formats.html
> >   
> 
> Yes, I marked them as TODO: 
> 
>  https://github.com/return42/sphkerneldoc/blob/master/scripts/media.py#L262
> 
> aspect *authoring tables* (see below)
> 
> > Also, some tables that are not so big like:
> > 	https://return42.github.io/sphkerneldoc/books/linux_tv/media/v4l/pixfmt-y41p.html
> > 
> > don't look nice, at least on my browser, as the "white" area is too small,
> > and some cells seem to be broken in two, because of the color changes in the middle
> > of the cell.  
> 
> aspect *layout* (see below)

Ok.

> > On a side comment, I really think that editing those big tables using
> > ASCIIart would be a real pain. It would be a way better to use some other
> > table format at its source code.  
> 
> It is the same to me (aspect *authoring tables*). IMO, it is a pain in
> every markup not only in ASCII art. Markup tables by hand is good enough
> for small tables and reST brings some variation to markup:
> 
>  https://return42.github.io/sphkerneldoc/articles/table_concerns.html

Writing complex tables is painful, no matter what format it is use, but
doing ASCIIart would mean that, even a simple addition of a new column
may end by the need of adding additional whitespaces to every other column
in that table. That would be really painful for the developer, but not
only for him: All reviewers and maintainers will have troubles to identify
what are the relevant changes, and what changes are there just to make
reST happy.

Let me show you the big picture here: one thing that it is very common at
this book is that we frequently add new rows to the existing tables, in order
to add a new fourcc format, some new control, or some new colorspace format,
like this one:
	https://git.linuxtv.org/media_tree.git/commit/?id=7146a9cfa499ac3bfaea18555d67afb04cac40c3

With has two new rows on one table:

--- a/Documentation/DocBook/media/v4l/pixfmt.xml
+++ b/Documentation/DocBook/media/v4l/pixfmt.xml
@@ -540,6 +540,10 @@ colorspaces except for BT.2020 which uses limited range R'G'B' quantization.</pa
            <entry>See <xref linkend="col-bt2020" />.</entry>
          </row>
          <row>
+           <entry><constant>V4L2_COLORSPACE_DCI_P3</constant></entry>
+           <entry>See <xref linkend="col-dcip3" />.</entry>
+         </row>
+         <row>
            <entry><constant>V4L2_COLORSPACE_SMPTE240M</constant></entry>
            <entry>See <xref linkend="col-smpte-240m" />.</entry>
          </row>
@@ -601,6 +605,10 @@ colorspaces except for BT.2020 which uses limited range R'G'B' quantization.</pa
            <entry><constant>V4L2_XFER_FUNC_NONE</constant></entry>
            <entry>Do not use a transfer function (i.e. use linear RGB values).</entry>
          </row>
+         <row>
+           <entry><constant>V4L2_XFER_FUNC_DCI_P3</constant></entry>
+           <entry>Use the DCI-P3 transfer function.</entry>
+         </row>
        </tbody>
       </tgroup>
     </table>

We don't want to see any changes on the patch touching other rows in
the table but the ones adding those new colorspace formats.

On the other hand, we seldom add new columns to the existing tables.
I can't remember any patch doing that on the last years. So, we
accept the extra pain to review patches adding/removing columns.

With that sense, the "List tables" format is also not good, as
one row addition would generate several hunks (one for each column
of the table), making harder to review the patch by just looking at
the diff.

The "CSV table" format seems to be the better one, as the produced
patches when a new one new row is added will be the best, except
that it currently reST CSV table format doesn't support cell span, 
with is something that several of our tables use.

> There are also work-arounds like raw-html tables, but I'am not happy with 
> all this solutions.

Yes, we might use raw-html tables, but that means that we'll never be
able to generate pdf. Well, for pdf generation, we would need to have a
tag at the markup language to tell to generate a "portrait" page for
some big tables. We used to have that before merging the V4L2 DocBook
upstream on some tables. Anyway, I would prefer to not add any
output format specific solution here.

So, I guess the best would be to extend reST language to do something
better. On the tests I did with AsciiDoc, I found the way it describes
tables good enough for the uses we have. Not sure if that approach
could be added or extended to reST/Sphinx. 

There, a table with cell spans[1] would look like:

[width="100%",cols=",,,,",]
|===========================================
|start + 0: |Y'~00~ |Y'~01~ |Y'~02~ |Y'~03~
|start + 4: |Y'~10~ |Y'~11~ |Y'~12~ |Y'~13~
|start + 8: |Y'~20~ |Y'~21~ |Y'~22~ |Y'~23~
|start + 12: |Y'~30~ |Y'~31~ |Y'~32~ |Y'~33~
|start + 16: |Cr~00~ 3+|
|start + 17: |Cb~00~ 3+|
|===========================================

[1] https://mchehab.fedorapeople.org/media-kabi-docs-test/asciidoc_tests/pixfmt-yuv410.adoc

On the above, the 3+| means that the cell will merge 3 columns.
Easy to write, easy to patch.

Also, it allows adding lines on big cells, so the above could be
written as:

[width="100%",cols=",,,,",]
|===========================================
|start + 0:
|Y'~00~ |Y'~01~ |Y'~02~ |Y'~03~
|start + 4: |Y'~10~ |Y'~11~ |Y'~12~ |Y'~13~
|start + 8: |Y'~20~ |Y'~21~ |Y'~22~ |Y'~23~
|start + 12:
|Y'~30~ |Y'~31~ |Y'~32~ |Y'~33~
|start + 16: |Cr~00~ 3+|
|start + 17: |Cb~00~ 3+|
|===========================================

And would produce the same output. That's actually a very good thing, as
we don't like to have lines with more than 80 columns withing the Kernel.

Another option would be to add some logic at the CSV to describe cell
spans at the existing reST markup format and add support on the CSV
format to break long lines (if not already supported). 

A third approach would be to make sphinx to be able to fully understand
HTML tables and convert them to PDF and other formats, but I guess this
would be too much work (as, otherwise, someone would have done that
already).

> Authoring tables and the *layout aspect* are TOPICs I 
> will review later. I hope you see that I'am working on, but let me first 
> focus on other TOPICs like:
> 
> * man pages
> * pdf
> * kernel-doc reST output (done)
> * etc ...

Yeah, I know that there are many things to be addressed.

Yet, for media maintainers, handling complex tables is a critical part for
the media books to be converted upstream. So, I'm a little anxious on that,
specially since I was unable to find a way to address with the current
markup language used on reST (except for raw-html, but, as I said before,
there are issues with that).

> > 
> > Still on tables, you took an interesting approach with the tables with
> > cell spans, like the control ones:
> > 	https://return42.github.io/sphkerneldoc/books/linux_tv/media/v4l/controls.html
> >   
> 
> marginal note: due to redesigned chunks, link has changed:
> 
>  https://return42.github.io/sphkerneldoc/books/linux_tv/media/v4l/extended-controls.html
> 

Noted.

> > Basically, you broke each control table (except for the first one) into a set
> > of tables. Not sure if I liked it, but it is certainly a way of doing it.  
> 
> Tables like: "Table 1.2. Codec Control IDs"
> 
> * http://www.linuxtv.org/downloads/v4l-dvb-apis/extended-controls.html
> 
> are definition lists. Thats why I implemented handles for these tables
> which made definition list from:
> 
> * https://github.com/return42/sphkerneldoc/blob/master/scripts/media.py#L432
> * https://github.com/return42/sphkerneldoc/blob/master/scripts/media.py#L496
> 
> The "table" markup here is used to get and/or influence a specific layout.
> I'am with you. As the time I wrote DocBooks, I also packed many things into
> tables, but I had to realized, that not everything is a table. Please, be 
> openness for to change, I will be open for your requirements, except they 
> are IMHO wrong. Placing definition list into table is IMO wrong.

Yeah, I see your point. I guess your strategy would work. We'll likely
need to change a little bit the text for those "ex-tables" to make it
look better.

> 
> > There are also some "simple" tables at the media controller side that are
> > missing conversion, like "struct media_v2_entity" at:
> > 	https://return42.github.io/sphkerneldoc/books/linux_tv/media/v4l/media-ioc-g-topology.html  
> 
> marginal note: due to redesigned chunks, link has changed:
> 
> * https://return42.github.io/sphkerneldoc/books/linux_tv/media/v4l/media-ioc-g-topology.html?highlight=media_v2_entity#struct-media-v2-entity

Noted.

> > I would expect this to be easy to be converted, as there's not much
> > weirdness on that.  
> 
> Yes, no problem to convert them, but as I said, let me review all tables
> later and focus first on the other TOPICs I mentioned above.

Ok.

> > There are also some things that didn't seem to be properly converted
> > at:
> > 	https://return42.github.io/sphkerneldoc/books/linux_tv/media/v4l/fdl-appendix.html
> >   
> 
> What's wrong with the license note? I can't remember tho old version, 
> but the new version should be OK?
> 
> * http://www.linuxtv.org/downloads/v4l-dvb-apis/fdl.html
> * https://return42.github.io/sphkerneldoc/books/linux_tv/media/v4l/fdl-appendix.html

I'm actually referring to this:
	https://www.linuxtv.org/downloads/v4l-dvb-apis/fdl-section4.html

The item numbering there on section 4 got weird on the conversion, as,
instead of:

". A.  Use in the Title Page (and on the covers, if any) a title distinct from that of the Document, and from those of previous versions (which should, if there were any, be listed in the History section of the Document). You may use the same title as a previous version if the original publisher of that version gives permission. "

It became:

". A.

Use in the Title Page (and on the covers, if any) a title distinct from that of the Document, and from those of previous versions (which should, if there were any, be listed in the History section of the Document). You may use the same title as a previous version if the original publisher of that version gives permission."

Not a big issue. Just something for the TODO list.

> > Do you see a way to fix the above issues with reST markup language, or
> > this is something that can't be fixed?  
> 
> In general: "Yes we can" ;-)
> 
> There will be points like tables we will have more discussions. With the
> not yet covered points like pdf, man-pages and so force we will get more 
> questions to answer.
> 
> As long as we not try to reimplement DocBook in reST and with a focus on 
> productivity (which means, lets tend to pickup standards) we will find 
> suitable solutions.
> 
> I hope I could build confidence in reST. Please stay tuned and communicate
> your requirements  ...

As I said, from my side, the big issue with reST is still tables format,
as I was not able yet to see a solution that would fit well for our
needs.

> 
> --Markus--
> 
> 
> 
> >> --M--
> >> 
> >> 
> >> Am 13.03.2016 um 16:33 schrieb Markus Heiser <markus.heiser@darmarIT.de>:
> >>   
> >>> 
> >>> Am 10.03.2016 um 16:21 schrieb Mauro Carvalho Chehab <mchehab@osg.samsung.com>:
> >>>   
> >>>> Em Thu, 10 Mar 2016 12:25:58 +0200
> >>>> Jani Nikula <jani.nikula@intel.com> escreveu:
> >>>>   
> >>>>> TL;DR? Skip to the last paragraph.
> >>>>> 
> >>>>> On Wed, 09 Mar 2016, Mauro Carvalho Chehab <mchehab@osg.samsung.com> wrote:    
> >>>>>> I guess the conversion to asciidoc format is now in good shape,
> >>>>>> at least to demonstrate that it is possible to use this format for the
> >>>>>> media docbook. Still, there are lots of broken references.      
> >>>>> 
> >>>>> Getting references right with asciidoc is a big problem in the
> >>>>> kernel-doc side. As I wrote before, the proofs of concept only worked
> >>>>> because everything was processed as one big file (via includes). The
> >>>>> Asciidoctor inter-document references won't help, because we won't know
> >>>>> the target document name while processing kernel-doc.    
> >>>> 
> >>>> I was able to produce chunked htmls here with:
> >>>> 
> >>>> 	asciidoctor -b docbook45 media_api.adoc
> >>>> 	xmlto -o html-dir html media_api.xml
> >>>> 
> >>>> The results are at:
> >>>> 	https://mchehab.fedorapeople.org/media-kabi-docs-test/asciidoc_tests/chunked/
> >>>> 
> >>>> But yeah, all references seem to be broken there. It could be due to some
> >>>> conversion issue (I didn't actually tried to check what's wrong there),
> >>>> but I think that there's something not ok with docbook45
> >>>> output for multi-part documents (on both AsciiDoc and Asciidoctor).
> >>>>   
> >>>>> Sphinx is massively better at handling cross references for
> >>>>> kernel-doc. We can use domains (C language) and roles (e.g. functions,
> >>>>> types, etc.) for the references, which provide kind of
> >>>>> namespaces. Sphinx warns for referencing non-existing targets, but
> >>>>> doesn't generate broken links in the result like Asciidoctor does.
> >>>>> 
> >>>>> For example, in the documentation for a function that has struct foo as
> >>>>> parameter or return type, a cross reference to struct foo is added
> >>>>> automagically, but only if documentation for struct foo actually
> >>>>> exists. In Asciidoctor, we would have to blindly generate the references
> >>>>> ourselves, and try to resolve broken links ourselves by somehow
> >>>>> post-processing the result.
> >>>>>   
> >>>>>> Yet, from my side, if we're willing to get rid of DocBook, then
> >>>>>> Asciidoctor seems to be the *only* alternative so far to parse the
> >>>>>> complex media documents.      
> >>>>> 
> >>>>> I think you mean, "get rid of DocBook as source format", not altogether?
> >>>>> I'm yet to be convinved we could rely on Asciidoctor's native formats.    
> >>>> 
> >>>> What I mean is that, right now, I see only two alternatives for the
> >>>> media uAPI documentation:
> >>>> 	1) keep using DocBook;
> >>>> 	2) AsciiDoc/Asciidoctor.
> >>>> 
> >>>> Sphinx doesn't have what's needed to support the complexity of the
> >>>> media books, specially since cell span seems to be possible only
> >>>> by using asciiArt formats. Writing a big table using asciiArt is
> >>>> something that is a *real pain*. Also, as tested, if the table is
> >>>> too big, it fails to parse such asciiArt tables. So, while Sphinx
> >>>> doesn't have a decent way to describe tables, we can't use it.    
> >>> 
> >>> 
> >>> Huge tables and cell-spans are the *real pain* ;-) ... with sphinx-doc,
> >>> (mostly) you have more then one choice .. e.g. import csv tables .. 
> >>> but this should be discussed by example ...
> >>> 
> >>>   
> >>>> If it starts implementing it, then we can check if the other
> >>>> features used by the media documentation are also supported.
> >>>> Probably, multi-part books would be another pain with Sphinx.
> >>>> We have actually 4 books inside a common body. A few chapters
> >>>> (like book licensing, bibliography, error codes) are shared
> >>>> by all 4 documents.
> >>>> 
> >>>> But, so far, I can't see any way to port media books without
> >>>> lots of lot of work to develop new features at the Sphinx code.    
> >>> 
> >>> 
> >>> may I can help you ...
> >>> 
> >>>   
> >>>>> The toolchain gets faster, easier to debug and simplified a lot with
> >>>>> DocBook out of the equation completely. Sphinx itself is stable, widely
> >>>>> available, and well documented. IMO there's sufficient native output
> >>>>> format support. There are plenty of really nice extensions
> >>>>> available. There's a possibility of doing kernel-doc as an extension in
> >>>>> the future (either by calling current kernel-doc from the extension or
> >>>>> by rewriting it).    
> >>>> 
> >>>> Well, if we go to Sphinx for kernel-doc, that means that we'll need
> >>>> 2 different tools for the documentation:
> >>>> 	- Sphinx for kernel-doc
> >>>> 	- either DocBook or Asciidoctor/AsciiDoc for media.
> >>>> 
> >>>> IMHO, this is the worse scenario, as we'll keep depending on
> >>>> DocBook plus requiring Sphinx, but it is up to Jon to decide.
> >>>>   
> >>> 
> >>> The migration of kernel-doc is a long term project, not a
> >>> one shot job. The scope of documents to migrate is not limited
> >>> to the files with DocBook markup in, most documents have not
> >>> a real markup.
> >>> 
> >>> Please take a look at my thoughts and efforts about migration.
> >>> 
> >>> * https://sphkerneldoc.readthedocs.org
> >>> 
> >>> * https://github.com/return42/sphkerneldoc.git
> >>> 
> >>> sphkerneldoc.git is a small project started this weekend, within
> >>> this project I show you, how migration could be done and
> >>> we can discuss concerns like "tables and cell-spans" by example. 
> >>> 
> >>> Believe me, most concerns discussed in this thread are a leak of
> >>> knowledge. I'am working with sphinx-doc since 7 years, switched
> >>> over from DocBook (escaped from a 8 years lasting XML hell).
> >>> DocBook and sphinx-doc are complete different, so sphinx-doc
> >>> might feels odd in the first time, but if you have switched 
> >>> like me, you will never go back again.
> >>>   
> >>>>> Dan keeps bringing up the active community in Asciidoctor, and how
> >>>>> they're fixing things up as we speak... which is great, but Sphinx is
> >>>>> here now, packaged and shipping in distros ready to use. It seems that
> >>>>> of the two, an Asciidoctor based toolchain is currently more in need of
> >>>>> hacking and extending to meet our needs. Which brings us to the
> >>>>> implementation language, Python vs. Ruby.
> >>>>> 
> >>>>> I won't make the mistake of comparing the relative merits of the
> >>>>> languages, but I'll boldly claim the set of kernel developers who know
> >>>>> Python is likely larger than the set of kernel developers who know Ruby
> >>>>> [citation needed]. AFAICT there are no Ruby tools in the kernel tree,
> >>>>> but there is a bunch of Python. My own very limited and subjective
> >>>>> experience with other tools around the kernel is that Python is much
> >>>>> more popular than Ruby. So my claim here is that we're in a better
> >>>>> position to hack on Sphinx extensions ourselves than Asciidoctor.    
> >>>> 
> >>>> Sorry, but I don't buy it. Python is, IMHO, a mess: each new version
> >>>> is incompatible with the previous one, and requires the source to
> >>>> change, in order to use a newer version than the one used to write
> >>>> the code. So, when talking about Python, we're actually talking about
> >>>> several different dialects that don't talk well to each other.    
> >>> 
> >>> Sorry, you are complete wrong ... I'am 15 years python programmer,
> >>> shipped out huge projects with my customers ... we never have seen
> >>> these problems ... sorry ...
> >>> 
> >>>   
> >>>> I don't know about Ruby. So far, I don't have anything against (or in
> >>>> favor) of it. I bet most Kernel developers would actually prefer a
> >>>> toolchain in C. If such tool doesn't exist, anything else seems
> >>>> equally the same ;)    
> >>> 
> >>> Why we are talking about script languages? What needed is a 
> >>> authoring system, which is as near as possible to the developers,
> >>> which are the authors.
> >>> 
> >>> Sphinx-Doc is a standard authoring-tool versioned, maintained 
> >>> and extended by thousands of developers ...
> >>> 
> >>>   
> >>>>> My conclusion is that Sphinx covers the vast majority of the needs of
> >>>>> our documentation producers and consumers, in an amazing way, out of the
> >>>>> box, better than Asciidoctor.
> >>>>> 
> >>>>> Which brings us to the minority and the parts where Sphinx falls short,
> >>>>> media documentation in particular. It's complex documentation, with very
> >>>>> specific requirements on the output, especially that many things remain
> >>>>> exactly as they are now. It also feels like the target is more to have
> >>>>> standalone media documentation, and not so much to be aligned with and
> >>>>> be part of the rest of the kernel documentation.
> >>>>> 
> >>>>> I want to question the need to have all kernel documentation use tools
> >>>>> that meet the strict requirements of the outlier, when there's a better
> >>>>> alternative for the vast majority of the documentation. Especially when
> >>>>> Asciidoctor isn't a ready solution for media documentation either.
> >>>>> 
> >>>>> In summary, my proposal is to go with Sphinx, leave media docs as
> >>>>> DocBook for now, and see if and how they can be converted to
> >>>>> Sphinx/reStructuredText later on when we have everything else in
> >>>>> place. It's not the perfect outcome, but IMHO it's the best overall
> >>>>> choice.    
> >>>> 
> >>>> Well, this could be done. We don't have any good reason to move
> >>>> the media docs out of DocBook.    
> >>> 
> >>> Sorry but again wrong: you lost many of the authors which are 
> >>> frustrated by a XML markup and you lost many developers to improve
> >>> the toolchain, frustrated by a complicated DocBook-XML XSLT
> >>> toolchain with SGML markup from the middle of the last epoch.
> >>>   
> >>>> On the contrary, this means an extra
> >>>> work. The only advantage is that it is a way simpler to write
> >>>> documentation with a markup language, but converting from the PoC
> >>>> to its integration at the Kernel tree still require lots of work,
> >>>> specially due to the cross-refs "magic" scripts that we have under
> >>>> Documentation/DocBook/media/Makefile.    
> >>> 
> >>> Yes, you are right, migration is a process not a one shot 
> >>> job, as I mentioned before. You are a great programmer, your 
> >>> documentation is also great, this invest should be preserved.
> >>> So lets take a try. It would be a honor for me to show 
> >>> you all theses steps by example on my repository (see above).
> >>>   
> >>>> As I said, the only big drawback is to keep depending on two
> >>>> different tools for kernel-doc and for media documentation.    
> >>> 
> >>> -- Markus --  
> > 
> > -- 
> > Thanks,
> > Mauro  
> 


-- 
Thanks,
Mauro
