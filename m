Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:57376 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752644AbeBVJCk (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 22 Feb 2018 04:02:40 -0500
Date: Thu, 22 Feb 2018 11:02:37 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Gregor Jasny <gjasny@googlemail.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org
Subject: Re: [v4l-utils PATCH 2/2] Add --with-static-binaries option to link
 binaries statically
Message-ID: <20180222090236.reeb4ywf44m5t334@valkosipuli.retiisi.org.uk>
References: <1474282225-31559-1-git-send-email-sakari.ailus@linux.intel.com>
 <1474291350-15655-1-git-send-email-sakari.ailus@linux.intel.com>
 <20160919112150.4c3eef98@vento.lan>
 <efd3b769-3079-c164-e948-d9ce8b1d6e10@googlemail.com>
 <20160926150253.558e0693@vento.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20160926150253.558e0693@vento.lan>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi guys,

On Mon, Sep 26, 2016 at 03:02:53PM -0300, Mauro Carvalho Chehab wrote:
> Em Mon, 26 Sep 2016 19:41:39 +0200
> Gregor Jasny <gjasny@googlemail.com> escreveu:
> 
> > On 19/09/2016 16:21, Mauro Carvalho Chehab wrote:
> > > Em Mon, 19 Sep 2016 16:22:30 +0300
> > > Sakari Ailus <sakari.ailus@linux.intel.com> escreveu:
> > >   
> > >> Add a new variable STATIC_LDFLAGS to add the linker flags required for
> > >> static linking for each binary built.
> > >>
> > >> Static and dynamic libraries are built by default but the binaries are
> > >> otherwise linked dynamically. --with-static-binaries requires that static
> > >> libraries are built.
> > >>  
> > > Instead of adding STATIC_LDFLAGS to all LDFLAGS, wouldn't be better to
> > > add the flags to LDFLAGS on configure.ac?  
> > 
> > I don't really like adding all those build variants into the configure
> > script itself. It is already way too complex and adding another
> > dimension does not make it better.
> > 
> > Why is passing --disable-shared --enable-static LDLAGS="--static
> > -static" to configure not sufficient?
> 
> That sounds better than adding an extra STATIC_LDFLAGS option, but,
> IMHO, this sounds confusing, and it is not documented.
> 
> The advantage of having an option is that the expected behavior
> can be documented in a way that the user will know what each option
> would be doing by calling ./configure --help. Yet, IMHO, the above
> parameters don't make clear about what type of output for executable
> files (static, dynamic, "partially" dynamic).
> 
> We could (should?) also print, at the ./configure "summary" what
> kind of libraries will be generated and what kind of executables.

It's an old thread... anyway, the INSTALL file is another option to put
this. I'd just like that it'd be easy for people to find this information
rather than require them to figure it out somehow. Not everyone is an expert
in autoconf / automake --- certainly not me at least.

Another advantage of documenting this is that it tends to get tested more
widely and if it doesn't work, it's obvious that it's broken rather than
v4l-utils is being built the wrong way.

So, configure help text or INSTALL?

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi
