Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:53276
        "EHLO s-opensource.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750869AbcISOTT (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Sep 2016 10:19:19 -0400
Date: Mon, 19 Sep 2016 11:19:12 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org, gjasny@googlemail.com
Subject: Re: [v4l-utils PATCH 1/1] Fix static linking of v4l2-compliance and
 v4l2-ctl
Message-ID: <20160919111912.6e7ceac6@vento.lan>
In-Reply-To: <57DFE65A.5040607@linux.intel.com>
References: <1474282225-31559-1-git-send-email-sakari.ailus@linux.intel.com>
        <20160919082226.43cd1bc9@vento.lan>
        <57DFE65A.5040607@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 19 Sep 2016 16:21:30 +0300
Sakari Ailus <sakari.ailus@linux.intel.com> escreveu:

> Hi Mauro,
> 
> On 09/19/16 14:22, Mauro Carvalho Chehab wrote:
> > Em Mon, 19 Sep 2016 13:50:25 +0300
> > Sakari Ailus <sakari.ailus@linux.intel.com> escreveu:
> >   
> >> v4l2-compliance and v4l2-ctl depend on librt and libpthread. The symbols
> >> are found by the linker only if these libraries are specified after the
> >> objects that depend on them.
> >>
> >> As LDFLAGS variable end up expanded on libtool command line before LDADD,
> >> move the libraries to LDADD after local objects. -lpthread is added as on
> >> some systems librt depends on libpthread. This is the case on Ubuntu 16.04
> >> for instance.
> >>
> >> After this patch, creating a static build using the command
> >>
> >> LDFLAGS="--static -static" ./configure --disable-shared --enable-static  
> > 
> > It sounds weird to use LDFLAGS="--static -static" here, as the
> > configure options are already asking for static.
> > 
> > IMHO, the right way would be to change configure.ac to add those LDFLAGS
> > when --disable-shared is used.  
> 
> That's one option, but then shared libraries won't be built at all.

Well, my understanding is that  --disable-shared is meant to disable
building the shared library build :)

> I'm
> not sure what would be the use cases for that, though: static linking
> isn't very commonly needed except when you need to run the binaries
> elsewhere (for whatever reason) where you don't have the libraries you
> linked against available.

Yeah, that's the common usage. It is also interesting if someone
wants to build 2 versions of the same utility, each using a
different library, for testing purposes.

The usecase I can't see is to use --disable-shared but keeping
using the dynamic library for the exec files.

> That's still a separate issue from what this patch fixes.
> 
> Ideally it should be possible to link the binaries statically while
> still building shared libraries: both are built by default right now,
> yet shared libraries are always used for linking unless you disable
> shared libraries.

Well, the point is: if dynamic library build is disabled, it should
be doing static links that are produced by the build, instead of using
an already existing set of dynamic libraries present on the system
(that may not contain the symbols needed by the tool, or miss some
patches that were on -git).

> Most of the time this makes sense but not always.
> 
> I'm sending a separate patch to fix that by adding
> --with-static-binaries option.
> 



Thanks,
Mauro
