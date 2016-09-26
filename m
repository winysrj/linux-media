Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:50348
        "EHLO s-opensource.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1034290AbcIZSC6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 26 Sep 2016 14:02:58 -0400
Date: Mon, 26 Sep 2016 15:02:53 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Gregor Jasny <gjasny@googlemail.com>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org
Subject: Re: [v4l-utils PATCH 2/2] Add --with-static-binaries option to link
 binaries statically
Message-ID: <20160926150253.558e0693@vento.lan>
In-Reply-To: <efd3b769-3079-c164-e948-d9ce8b1d6e10@googlemail.com>
References: <1474282225-31559-1-git-send-email-sakari.ailus@linux.intel.com>
        <1474291350-15655-1-git-send-email-sakari.ailus@linux.intel.com>
        <20160919112150.4c3eef98@vento.lan>
        <efd3b769-3079-c164-e948-d9ce8b1d6e10@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 26 Sep 2016 19:41:39 +0200
Gregor Jasny <gjasny@googlemail.com> escreveu:

> On 19/09/2016 16:21, Mauro Carvalho Chehab wrote:
> > Em Mon, 19 Sep 2016 16:22:30 +0300
> > Sakari Ailus <sakari.ailus@linux.intel.com> escreveu:
> >   
> >> Add a new variable STATIC_LDFLAGS to add the linker flags required for
> >> static linking for each binary built.
> >>
> >> Static and dynamic libraries are built by default but the binaries are
> >> otherwise linked dynamically. --with-static-binaries requires that static
> >> libraries are built.
> >>  
> > Instead of adding STATIC_LDFLAGS to all LDFLAGS, wouldn't be better to
> > add the flags to LDFLAGS on configure.ac?  
> 
> I don't really like adding all those build variants into the configure
> script itself. It is already way too complex and adding another
> dimension does not make it better.
> 
> Why is passing --disable-shared --enable-static LDLAGS="--static
> -static" to configure not sufficient?

That sounds better than adding an extra STATIC_LDFLAGS option, but,
IMHO, this sounds confusing, and it is not documented.

The advantage of having an option is that the expected behavior
can be documented in a way that the user will know what each option
would be doing by calling ./configure --help. Yet, IMHO, the above
parameters don't make clear about what type of output for executable
files (static, dynamic, "partially" dynamic).

We could (should?) also print, at the ./configure "summary" what
kind of libraries will be generated and what kind of executables.

Thanks,
Mauro
