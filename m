Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ed1-f67.google.com ([209.85.208.67]:39018 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732448AbeGaRNd (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 31 Jul 2018 13:13:33 -0400
From: Dmitry Osipenko <digetx@gmail.com>
To: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-tegra@vger.kernel.org, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1] media: staging: tegra-vde: Replace debug messages with trace points
Date: Tue, 31 Jul 2018 18:32:38 +0300
Message-ID: <5286387.GJUI5Hs7VI@dimapc>
In-Reply-To: <1779889.gZoAajBteF@dimapc>
References: <20180707162049.20407-1-digetx@gmail.com> <20180724213733.6c8b6b4b@coco.lan> <1779889.gZoAajBteF@dimapc>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wednesday, 25 July 2018 04:20:29 MSK Dmitry Osipenko wrote:
> On Wednesday, 25 July 2018 03:37:33 MSK Mauro Carvalho Chehab wrote:
> > Em Wed, 25 Jul 2018 01:38:37 +0300
> > 
> > Dmitry Osipenko <digetx@gmail.com> escreveu:
> > > On Wednesday, 25 July 2018 01:06:52 MSK Mauro Carvalho Chehab wrote:
> > > > Em Sat,  7 Jul 2018 19:20:49 +0300
> > > > 
> > > > Dmitry Osipenko <digetx@gmail.com> escreveu:
> > > > > Trace points are much more efficient than debug messages for
> > > > > extensive
> > > > > tracing and could be conveniently enabled / disabled dynamically,
> > > > > hence
> > > > > let's replace debug messages with the trace points.
> > > > 
> > > > This patch require some work:
> > > > 
> > > > $ make ARCH=i386  CF=-D__CHECK_ENDIAN__
> > > > CONFIG_DEBUG_SECTION_MISMATCH=y
> > > > C=1
> > > > W=1 CHECK='compile_checks' M=drivers/staging/media
> > > > 
> > > > ./include/linux/slab.h:631:13: error: undefined identifier
> > > > '__builtin_mul_overflow' ./include/linux/slab.h:631:13: warning: call
> > > > with
> > > > no type!
> > > > fixdep: error opening file: drivers/staging/media/tegra-vde/trace.h:
> > > > No
> > > > such file or directory
> > > > 
> > >   CHECK   drivers/staging/media/tegra-vde/tegra-vde.c
> > > 
> > > /bin/sh: compile_checks: command not found
> > > 
> > > Upstream kernel doesn't have "compile_checks" script and I can't find it
> > > anywhere else.
> > 
> > This is just a call for smatch/sparse:
> > 
> > #!/bin/bash
> > /devel/smatch/smatch -p=kernel $@
> > # This is too pedantic and produce lots of false-positives
> > #/devel/smatch/smatch --two-passes -- -p=kernel $@
> > /devel/sparse/sparse $@
> > 
> > However, the problem here is that you're doing a 64 bits division.
> > That causes compilation to break with 32 bits. you need to use
> > do_div & friends.
> 
> The tegra-vde driver code is fine, it is a known issue with the kernels
> checker [0]. Unfortunately the patch for the checker haven't been applied
> yet.
> 
> [0] https://www.spinics.net/lists/kernel/msg2824058.html

Mauro, are you going to un-reject patch [0] and apply it or there is some 
action needed from my side now?

[0] https://patchwork.linuxtv.org/patch/51002/
