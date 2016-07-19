Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp2.goneo.de ([85.220.129.33]:48564 "EHLO smtp2.goneo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752566AbcGSKAm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Jul 2016 06:00:42 -0400
Content-Type: text/plain; charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: Troubles with kernel-doc and RST files
From: Markus Heiser <markus.heiser@darmarit.de>
In-Reply-To: <20160718085420.314119a8@recife.lan>
Date: Tue, 19 Jul 2016 12:00:24 +0200
Cc: Jonathan Corbet <corbet@lwn.net>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-doc@vger.kernel.org, Jani Nikula <jani.nikula@intel.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <F6675307-05E6-4101-92E9-69BC0232A939@darmarit.de>
References: <20160717100154.64823d99@recife.lan> <20160717203719.6471fe03@lwn.net> <20160718085420.314119a8@recife.lan>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Am 18.07.2016 um 13:54 schrieb Mauro Carvalho Chehab <mchehab@s-opensource.com>:

> Em Sun, 17 Jul 2016 20:37:19 -0600
> Jonathan Corbet <corbet@lwn.net> escreveu:
> 
>> [Back home and trying to get going on stuff for real.  I'll look at the
>> issues listed in this message one at a time.]
>> 
>> On Sun, 17 Jul 2016 10:01:54 -0300
>> Mauro Carvalho Chehab <mchehab@s-opensource.com> wrote:
>> 
>>> 1) We now need to include each header file with documentation twice,
>>> one to get the enums, structs, typedefs, ... and another one for the
>>> functions:
>>> 
>>> 	.. kernel-doc:: include/media/media-device.h
>>> 
>>> 	.. kernel-doc:: include/media/media-entity.h
>>> 	   :export: drivers/media/media-entity.c  
>> 
>> So I'm a little confused here; you're including from two different header
>> files here.  Did you want media-entity.h in both directives?
> 
> Yeah, on my patch I was including every header twice. The first
> one to get the structs:
> 
> .. kernel-doc:: include/media/media-device.h
> 
> .. kernel-doc:: include/media/media-devnode.h
> 
> .. kernel-doc:: include/media/media-entity.h
> 
> And the next one to get the functions:
> 
> .. kernel-doc:: include/media/media-device.h
>   :export: drivers/media/media-device.c
> 
> .. kernel-doc:: include/media/media-entity.h
>   :export: drivers/media/media-entity.c
> 
> 
>> If I do a simple test with a single line:
>> 
>> 	.. kernel-doc:: include/media/media-entity.h
>> 
>> I get everything - structs, functions, etc. - as I would expect.  Are you
>> seeing something different?
> 
> Weird, now it worked... I noticed this issue because some of the cross
> references were broken if I didn't include everything twice, but it
> seems that including just one time is enough. Not sure what happened
> when I tested it.
> 
>> It probably would be nice to have an option for "data structures, doc
>> sections, and exported functions only" at some point.
> 
> Yeah. Well, actually, I ended by moving the doc sections from the
> headers, adding them as a separate rst file. This way, I don't have
> to workaround on some parsing issues that might happen with kernel-doc
> parsing. Also, IMHO, it makes easier to edit and keep it organized.

To have an option for "data structures etc." would be nice, but first
we should concentrate on the reST produced by kernel-doc and therefor
it is recommended to elaborate what we need to build man pages.
The man pages request will reveal what need e.g:

* using the cpp domain to handle more then one e.g. "ioctl" declaration
* structured markup with headers
* quoting pointers
* ...

IMHO yet, the main drawback of the current kernel-doc parser is, that
there are no header structures in the reST markup. E.g. the example
from Mauro (see below) is one big HTML page with no chapters and sections,
thats why there are no links generated in the left navigation bar.

These -- and the other request we discussed -- could be done with the
kernel-doc perl script, but we will see that it becomes harder
and harder to force it through a pipe communication.

I wrote a python version of the parser with an API which could cover all
theses and future aspects less complicated and more straight forward.
I tested this parser by building a complete source tree of documentation:

  http://return42.github.io/sphkerneldoc/linux_src_doc/index.html

and all books (aka DocBooks)

  http://return42.github.io/sphkerneldoc/#references-to-books

I recommend to consider to switch to the python version of the parser.
I know, that there is a natural shyness about a reimplementation in python
and thats why I offer to support it for a long time period .. it would
be a joy for me ;-)

If you interested in, I could send a RFC patch for this, if not please
give the reasons why not.


> Yet, still it could be interesting to be able of putting data structs
> on a separate page than the functions. One of the (minor) issues.
> What I'm noticing now is that some HTML pages are becoming too big,
> as Sphinx is associating one output page per one input page.

Yes, that is right. Changing this 1:1 associations could be done 
by feature the kernel-doc directive. But a can't recommend this, since
this breaks some basic rules sphinx implementations expect.

I recommend to split the kernel-doc directives into separate rst-files.

Over all: IMHO "Explicit is better than implicit." ... its is better to
name each function, struct etc. e.g: 

.. kernel-doc:: include/media/tuner.h
    :functions: tuner_mode

Being explicit gives the parser the chance to log errors if a
declaration not or no longer exists.

Yes, I know there are use cases which will be covered better
by being implicit ... the decision is left to the author.


> It means that, for something like the V4L2 core:
> 
> Video2Linux devices
> -------------------
> 
> .. kernel-doc:: include/media/tuner.h
> 
> .. kernel-doc:: include/media/tuner-types.h
> 
> .. kernel-doc:: include/media/tveeprom.h
> 
> .. kernel-doc:: include/media/v4l2-async.h
> 
> .. kernel-doc:: include/media/v4l2-ctrls.h
> 
> .. kernel-doc:: include/media/v4l2-dv-timings.h
> 
> .. kernel-doc:: include/media/v4l2-event.h
> 
> .. kernel-doc:: include/media/v4l2-flash-led-class.h
> 
> .. kernel-doc:: include/media/v4l2-mc.h
> 
> .. kernel-doc:: include/media/v4l2-mediabus.h
> 
> .. kernel-doc:: include/media/v4l2-mem2mem.h
> 
> .. kernel-doc:: include/media/v4l2-of.h
> 
> .. kernel-doc:: include/media/v4l2-rect.h
> 
> .. kernel-doc:: include/media/v4l2-subdev.h
> 
> .. kernel-doc:: include/media/videobuf2-core.h
> 
> .. kernel-doc:: include/media/videobuf2-v4l2.h
> 
> .. kernel-doc:: include/media/videobuf2-memops.h
> 
> It produces a 337.4KB document with 3739 lines:
> 
>  3739  24703 337487 /devel/v4l/patchwork/Documentation/output/html/media/kapi/v4l2-core.html
> 
> 
> Btw, if you want to see how the media conversion to ReST is going,
> I have it altogether at:
> 	https://linuxtv.org/downloads/v4l-dvb-apis-new/index.html
> 
> Almost everything is there already, including all documents that
> were at Documentation/dvb, and almost all that were at
> Documentation/video4linux/. There are just 30 documents left that I still
> need to handle, and that requires more care to be ported:
> 
> Documentation/video4linux/
> ├── bttv
> │   ├── Cards
> │   ├── CONTRIBUTORS
> │   ├── ICs
> │   ├── Insmod-options
> │   ├── MAKEDEV
> │   ├── Modprobe.conf
> │   ├── Modules.conf
> │   ├── PROBLEMS
> │   ├── README
> │   ├── README.freeze
> │   ├── README.quirks
> │   ├── README.WINVIEW
> │   ├── Sound-FAQ
> │   ├── Specs
> │   ├── THANKS
> │   └── Tuners
> ├── cx2341x
> │   ├── fw-calling.txt
> │   ├── fw-decoder-api.txt
> │   ├── fw-decoder-regs.txt
> │   ├── fw-dma.txt
> │   ├── fw-encoder-api.txt
> │   ├── fw-memory.txt
> │   ├── fw-osd-api.txt
> │   ├── fw-upload.txt
> │   ├── README.hm12
> │   └── README.vbi
> ├── cx88
> │   └── hauppauge-wintv-cx88-ir.txt
> ├── hauppauge-wintv-cx88-ir.txt
> ├── lifeview.txt
> └── not-in-cx2388x-datasheet.txt
> 
> 3 directories, 30 files
> 
> My plan is to handle those today, likely merging some text files
> into a few ones.
> 
> I still need to do a second round of review on the kAPI book and at the
> V4L and DVB drivers books, to make them to look more like a single
> document, and not a "Frankenstein" glue.

:-)

> Some documents are too outdated too. So, their contents need to be
> adjusted. My plan is to do an extra review on that for 4.9, in
> order to either update or drop them.
> 
> Thanks,
> Mauro
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

