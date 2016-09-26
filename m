Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:44116 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S932653AbcIZVlB (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 26 Sep 2016 17:41:01 -0400
Date: Tue, 27 Sep 2016 00:40:51 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, gjasny@googlemail.com
Subject: Re: [v4l-utils PATCH 1/1] Fix static linking of v4l2-compliance and
 v4l2-ctl
Message-ID: <20160926214051.GB3225@valkosipuli.retiisi.org.uk>
References: <1474282225-31559-1-git-send-email-sakari.ailus@linux.intel.com>
 <20160919082226.43cd1bc9@vento.lan>
 <57DFE65A.5040607@linux.intel.com>
 <20160919111912.6e7ceac6@vento.lan>
 <20160926154640.GA3225@valkosipuli.retiisi.org.uk>
 <20160926135945.351384ca@vento.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20160926135945.351384ca@vento.lan>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On Mon, Sep 26, 2016 at 01:59:45PM -0300, Mauro Carvalho Chehab wrote:
> Em Mon, 26 Sep 2016 18:46:40 +0300
> Sakari Ailus <sakari.ailus@iki.fi> escreveu:
> 
> > Hi Mauro,
> > 
> > On Mon, Sep 19, 2016 at 11:19:12AM -0300, Mauro Carvalho Chehab wrote:
> > > Em Mon, 19 Sep 2016 16:21:30 +0300
> > > Sakari Ailus <sakari.ailus@linux.intel.com> escreveu:
> > >   
> > > > Hi Mauro,
> > > > 
> > > > On 09/19/16 14:22, Mauro Carvalho Chehab wrote:  
> > > > > Em Mon, 19 Sep 2016 13:50:25 +0300
> > > > > Sakari Ailus <sakari.ailus@linux.intel.com> escreveu:
> > > > >     
> > > > >> v4l2-compliance and v4l2-ctl depend on librt and libpthread. The symbols
> > > > >> are found by the linker only if these libraries are specified after the
> > > > >> objects that depend on them.
> > > > >>
> > > > >> As LDFLAGS variable end up expanded on libtool command line before LDADD,
> > > > >> move the libraries to LDADD after local objects. -lpthread is added as on
> > > > >> some systems librt depends on libpthread. This is the case on Ubuntu 16.04
> > > > >> for instance.
> > > > >>
> > > > >> After this patch, creating a static build using the command
> > > > >>
> > > > >> LDFLAGS="--static -static" ./configure --disable-shared --enable-static    
> > > > > 
> > > > > It sounds weird to use LDFLAGS="--static -static" here, as the
> > > > > configure options are already asking for static.
> > > > > 
> > > > > IMHO, the right way would be to change configure.ac to add those LDFLAGS
> > > > > when --disable-shared is used.    
> > > > 
> > > > That's one option, but then shared libraries won't be built at all.  
> > > 
> > > Well, my understanding is that  --disable-shared is meant to disable
> > > building the shared library build :)
> > >   
> > > > I'm
> > > > not sure what would be the use cases for that, though: static linking
> > > > isn't very commonly needed except when you need to run the binaries
> > > > elsewhere (for whatever reason) where you don't have the libraries you
> > > > linked against available.  
> > > 
> > > Yeah, that's the common usage. It is also interesting if someone
> > > wants to build 2 versions of the same utility, each using a
> > > different library, for testing purposes.
> > > 
> > > The usecase I can't see is to use --disable-shared but keeping
> > > using the dynamic library for the exec files.  
> > 
> > There are three primary options here,
> > 
> > 1. build an entirely static binary,
> > 2. build a binary that relies on dynamic libraries as well and
> > 3. build a binary that relies on dynamic libraries outside v4l-utils package
> >    but that links v4l-utils originating libraries statically.
> > 
> > If you say 3. is not needed then we could just use --disable-shared also to
> > tell that static binaries are to be built.
> > 
> > 3. is always used for libv4l2subdev and libmediactl as the libraries do not
> > have stable APIs.
> 
> Sakari,
> 
> I can't see what you mean by scenario (2). I mean, if 
> --disable-shared is called, it *should not* use dynamic libraries
> for any library provided by v4l-utils, as the generated binaries will
> either:
> 
> a) don't work, because those libraries weren't built;
> b) will do the wrong thing, as they'll be dynamically linked
>    to an older version of the library.
> 
> So, there are only 3 possible scenarios, IMHO:
> 
> 1) dynamic libraries, dynamic execs
> 2) static v4l-utils libraries, static execs
> 3) static v4l-utils libraries, static links for v4l-utils libs, dyn for the rest.
> 
> In practice, I don't see any reason for keeping support for both (2)
> and (3), as all usecases for (3) can be covered by a fully static
> exec. It is also very confusing for one to understand that.
> For example, right now, we have those static/shared options:
> 
>   --enable-static[=PKGS]  build static libraries [default=yes]
>   --enable-shared[=PKGS]  build shared libraries [default=yes]
> 
> with, IMHO, sounds confusing, as those options don't seem to be
> orthogonal. I mean, what happens someone calls ./configure with:
> 
> 	./configure --disable-static --disable-shared

That doesn't make much sense --- to disable the build for both static and
dynamic libraries.

What would you prefer? Link binaries statically iff shared libraries are not
built? I'd just like to get this fixed. Currently building static binaries
is simply broken.

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
