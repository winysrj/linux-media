Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:52330
        "EHLO s-opensource.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754071AbcHWQlC (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 23 Aug 2016 12:41:02 -0400
Date: Tue, 23 Aug 2016 13:40:55 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Jonathan Corbet <corbet@lwn.net>
Cc: Daniel Vetter <daniel@ffwll.ch>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Markus Heiser <markus.heiser@darmarit.de>,
        linux-doc@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        "linaro-mm-sig@lists.linaro.org" <linaro-mm-sig@lists.linaro.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [PATCH v2 2/2] Documentation/sphinx: link dma-buf rsts
Message-ID: <20160823134055.252b4859@vento.lan>
In-Reply-To: <20160823081633.123ae938@lwn.net>
References: <1471878705-3963-1-git-send-email-sumit.semwal@linaro.org>
        <1471878705-3963-3-git-send-email-sumit.semwal@linaro.org>
        <20160822124930.02dbbafc@vento.lan>
        <20160823060135.GJ24290@phenom.ffwll.local>
        <20160823070818.42ffec00@lwn.net>
        <CAKMK7uFMDcwk=ovX9+_R4FBOx6=sYnaOZwHuHSdQixdk-5_hwg@mail.gmail.com>
        <20160823081633.123ae938@lwn.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 23 Aug 2016 08:16:33 -0600
Jonathan Corbet <corbet@lwn.net> escreveu:

> On Tue, 23 Aug 2016 15:28:55 +0200
> Daniel Vetter <daniel@ffwll.ch> wrote:
> 
> > I think the more interesting story is, what's your plan with all the
> > other driver related subsystem? Especially the ones which already have
> > full directories of their own, like e.g. Documentation/gpio/. I think
> > those should be really part of the infrastructure section (or
> > something equally high-level), together with other awesome servies
> > like pwm, regman, irqchip, ... And then there's also the large-scale
> > subsystems like media or gpu. What's the plan to tie them all
> > together? Personally I'm leaning towards keeping the existing
> > directories (where they exist already), but inserting links into the
> > overall driver-api section.  
> 
> To say I have a plan is to overstate things somewhat...
> 
> One objective I do have, though, is to declutter Documentation/.
> Presenting people looking for docs with a 270-file directory is
> unfriendly to say the least.  We don't organize the code that way; the
> average in the kernel is <... find | wc -l ... > about 15
> files/directory, which is rather more manageable.  Someday I'd like
> Documentation/ to look a lot more like the top-level directory.

Makes sense, although 15 files/dir doesn't seem feasible...

I actually grouped the media documentation on a more logical arrangement,
grouping things per API type.

Yet, just the V4L userspace docs (Documentation/media/uapi/v4l/)
has ~200 files :) 

And I think that a few of them, like the extended-controls.rst one
are too big and should likely be split in some future.

> 
> It seems to me that we have a few basic types of stuff here:
> 
>  - Driver API documentation, obviously, is a lot of it, and I would like
>    to organize it better and to move it out of the top-level directory.
> 
>  - Hardware usage information - module parameters, sysfs files, supported
>    hardware information, graphic descriptions of the ancestry of hardware
>    engineers, etc.  The readership for this stuff is quite different, and
>    I think it should be separate; often it's intertwined with API
>    information at the moment.

In the case or media, I ended by merging those into one subdir for V4L2
and another one for DVB (currently, we don't have hardware usage documents
for Remote Controllers or CEC devices).

I wouldn't mind moving them to some other place, although a few rst files
there are actually linked to kAPI documentation.

Btw, we have, at the media subsystem, several drivers using the
kernel-doc syntax to describe functions that are internal to a driver,
and even some alien markups using some Doxygen syntax out there.
Maybe some day we'll end by adding such documentation on some
driver-specific rst file, probably at a hardware section of the
documentation.

> 
>  - Other usage information - a lot of what's under filesystems/ for
>    example, and more.
> 
>  - Core API documentation.
> 
>  - Kernel development tools - the stuff I started pulling together into
>    the dev-tools/ subdirectory.
> 
>  - How to deal with this unruly mob - SubmittingPatches, CodingStyle,
>    development-process, etc.  There's process stuff, and general
>    development documents like volatile-considered-harmful.txt or
>    memory-barriers.txt

I would actually keep at the top-level directory only the build system 
main conf.py, makefiles & similar stuff), moving everything else to subdirs.

IMHO, there are a few advantages on that:

1) the Sphinx build system is oriented per subdir. We can't ask it to
   build just the stuff at the top dir without building the subdirs;

2) it makes easier to identify what was ported and what wasn't;

3) it makes things more organized, as the subdir will be an
   alias to the group of documents that will be part of the subdir.
> 
> We can go a long way by organizing this stuff within the formatted
> documentation, but I really think we need to organize the directory
> structure as well.  I see that as a slow-moving process that will take
> years, but I do think it's a direction we should go.

My suggestion is to create a directory structure for the
things that are currently under the top /Documentation dir
and at /Documentation/DocBook. Then, create an index.rst file for
each of them, initially with an "empty" content like:

	TODO: add stuff here

And then move stuff there as we finish the conversion.

I actually did something like that for the stuff that used to be at
/Documentation/video4linux and Documentation/dvb and worked fine,
IMHO.

Ah, btw, on my experience, converting a .txt file into a .rst one
is a way easier than converting the DocBooks, as there's just one
place to touch, while on DocBooks, you'll also need to touch at
the included files, to fix format issues at the kernel-doc macros
that won't work anymore with ReST.

If you want, I may get some of those non-subsystem specific
documentation (like the documents describing the submission
process) and convert into a book, in order to add some conversion
examples.

Regards,
Mauro
