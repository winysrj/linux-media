Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:33961 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758484AbcEFRGr (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 6 May 2016 13:06:47 -0400
Date: Fri, 6 May 2016 14:06:38 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Markus Heiser <markus.heiser@darmarit.de>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>,
	Jonathan Corbet <corbet@lwn.net>,
	Grant Likely <grant.likely@secretlab.ca>,
	Jani Nikula <jani.nikula@intel.com>,
	Dan Allen <dan@opendevise.io>,
	Russel Winder <russel@winder.org.uk>,
	Keith Packard <keithp@keithp.com>,
	LKML <linux-kernel@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Graham Whaley <graham.whaley@linux.intel.com>,
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
	LMML linux-media <linux-media@vger.kernel.org>
Subject: Re: Kernel docs: muddying the waters a bit
Message-ID: <20160506140638.33f68622@recife.lan>
In-Reply-To: <F5762B74-23D6-46CB-80EA-3D6F82510A70@darmarit.de>
References: <20160213145317.247c63c7@lwn.net>
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
	<20160412094620.4fbf05c0@lwn.net>
	<CACxGe6ueYTEZjmVwV2P1JQea8b9Un5jLca6+MdUkAHOs2+jiMA@mail.gmail.com>
	<CAKMK7uFPSaH7swp4F+=KhMupFa_6SSPoHMTA4tc8J7Ng1HzABQ@mail.gmail.com>
	<54CDCFE8-45C3-41F6-9497-E02DB4184048@darmarit.de>
	<20160504131529.0be6a9c3@recife.lan>
	<FAC968D4-0A71-418C-90A2-3843D46526D0@darmarit.de>
	<20160506080304.56307066@recife.lan>
	<F5762B74-23D6-46CB-80EA-3D6F82510A70@darmarit.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 6 May 2016 18:26:10 +0200
Markus Heiser <markus.heiser@darmarit.de> escreveu:

> Hi Mauro,
> 
> Am 06.05.2016 um 13:03 schrieb Mauro Carvalho Chehab <mchehab@osg.samsung.com>:
> > Yeah, it looks better, however table truncation seem to be
> > happening also on other parts, like the tables on this page:
> > 
> > 	https://return42.github.io/sphkerneldoc/books/linux_tv/media/v4l/pixfmt-packed-rgb.html
> > 	(original table: https://linuxtv.org/downloads/v4l-dvb-apis/packed-rgb.html)
> > This table should contain 32 bits, but only the first 7 bits are shown
> > 
> > and those (among others):
> > 	https://return42.github.io/sphkerneldoc/books/linux_tv/media/v4l/pixfmt-y41p.html
> > 	https://return42.github.io/sphkerneldoc/books/linux_tv/media/v4l/dev-sliced-vbi.html
> > 	https://return42.github.io/sphkerneldoc/books/linux_tv/media/v4l/subdev-formats.html
> > 
> > Hmm... after looking more carefully, it added a horizontal scroll bar.
> > That looks ugly, IMHO, and makes harder to understand its contents. The
> > last one, in particular (https://return42.github.io/sphkerneldoc/books/linux_tv/media/v4l/subdev-formats.html),
> > is a big table on both horiz and vert dimensions. Try to read how the
> > bits are packed on a random line in the middle of the table, like
> > MEDIA_BUS_FMT_BGR565_2X8_LE and you'll understand what I mean.  
> 
> I know what you mean ;-) ... I'am also unhappy, but I will address this point
> later when it goes to finish the layout.
> 
> Currently lets focus on contend and (the two)extensions.

OK.

> > The table here looks weird (although it is correct):
> > 	https://return42.github.io/sphkerneldoc/books/linux_tv/media/v4l/pixfmt-srggb10p.html
> > 	(original table: https://linuxtv.org/downloads/v4l-dvb-apis/pixfmt-srggb10p.html)
> >   
> 
> I validated this and the other tables you mentioned above ... these are 
> all correct migrated ... it is 1:1 translated from DocBook ... they
> might be show different to this what you know from your docbook
> toolchain, because in the docbook-html you have no table grids and 
> wrong cellspans are not clear ... sometimes, like in the last example 
> you gave:
> 
> 	    <tgroup cols="5" align="center">
> 	      <colspec align="left" colwidth="2*" />
> 	      <tbody valign="top">
> 
> a colspec might ambiguous ... so there is no clear role to migrate.

Ok, that's what I was thinking. Ok, this can be fixed later manually,
where needed. Of course one way would be to disable grids on those
tables, but I would instead fix it.

> 
> > It seems that Sphinx is assuming something like "A4 portrait" for
> > the margins, while those big tables would only fit (in PDF) as
> > "A4 landscape".  
> 
> No, no, no ;-)
> 
> Sphinx assumes nothing about the layout, sphinx and the underlying
> docutils mostly juggling with nodes and the writers in e.g. the
> html-writer, outputs a clear HTML without any style but with classified 
> HTML tags. Styling is done in the presentation layer, in HTML, it is 
> done in CSS.

Hmm... Then there's something deadly wrong at CSS template, as it is
shown texts only at half of my horizontal res (1920).

Probably this is the culpit:

      .container { margin: 50px auto 40px auto; width: 600px; text-align: center; }

width is set to 600px, instead of using a percentage, like 100%
(or 90%).

> 
> > I guess the better would be to not limit the right
> > margin or to change it where those big tables happen, in order to
> > allow PDF generation.  
> 
> Generating PDF has nothing to do with generating HTML. To generate
> PDF there is a other writer, the latex2e writer, which produce 
> LaTeX markup from which you build PDF or other printed-like medias.

Ok.

>  
> > 
> > There are also some tables that went wrong. See the Color Sample
> > Location table at:
> > 	https://return42.github.io/sphkerneldoc/books/linux_tv/media/v4l/pixfmt-yuv444m.html
> > I'm pretty sure we'll need to fix some cases like that manually.
> > I didn't check, but perhaps, in this case, the DocBook were using 
> > empty columns just to make the table bigger. If so, this is not a
> > problem with the conversion, and should be manually fixed later.  
> 
> +1
> 
> Yes, lets do it manually later ... what I have in my POC is a automated
> process, it is hard to consider individuals in an automatic process.
> Making details *nicer* and making ambiguous markups clear is manually
> done in minutes where I need hours to implement this in a automated
> process.

Yeah, we should not try to fix everything via auto-scripts, and
spending time right now with manual fixes will be wasted, as we need
to run it at the latest media documentation, as changes might have
happened upstream.

> 
> Aside, from:  http://docutils.sourceforge.net/docs/peps/pep-0258.html
> 
> Docutils Project Model -- Project components and data flow:
> 
>                  +---------------------------+
>                  |        Docutils:          |
>                  | docutils.core.Publisher,  |
>                  | docutils.core.publish_*() |
>                  +---------------------------+
>                   /            |            \
>                  /             |             \
>         1,3,5   /        6     |              \ 7
>        +--------+       +-------------+       +--------+
>        | READER | ----> | TRANSFORMER | ====> | WRITER |
>        +--------+       +-------------+       +--------+
>         /     \\                                  |
>        /       \\                                 |
>  2    /      4  \\                             8  |
> +-------+   +--------+                        +--------+
> | INPUT |   | PARSER |                        | OUTPUT |
> +-------+   +--------+                        +--------+
> 
> 
> This is a bit simplified, because we use sphinx, which 
> has "builders" and sits on top of this architecture.
> But it might help to see, that processes like reading,
> transforming and writing are discrete.
> 
> In short: readers (the reST file reader) are creating node trees,
> which are transformed by a transformer (e.g. a HTML transformer),
> the writer only writes the output to a file (and copies some files
> like CSS files).
> 
> If I say "HTML-writer" I address the unity off the HTML-transformer
> plus the HTML-writer. In Sphinx terminus/architecture, replace the
> word writer with the word "builder" ... there you have (e.g.) a 
> "HTML builder" and a "LaTeX builder".
> 
> --Markus--
> 
> 
> 
> 
> 


-- 
Thanks,
Mauro
