Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ed1-f68.google.com ([209.85.208.68]:34336 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388506AbeGXXrT (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 24 Jul 2018 19:47:19 -0400
From: Dmitry Osipenko <digetx@gmail.com>
To: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-tegra@vger.kernel.org, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1] media: staging: tegra-vde: Replace debug messages with trace points
Date: Wed, 25 Jul 2018 01:38:37 +0300
Message-ID: <3929419.8vW2TRoUPb@dimapc>
In-Reply-To: <20180724190652.2befcaf6@coco.lan>
References: <20180707162049.20407-1-digetx@gmail.com> <20180724190652.2befcaf6@coco.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wednesday, 25 July 2018 01:06:52 MSK Mauro Carvalho Chehab wrote:
> Em Sat,  7 Jul 2018 19:20:49 +0300
> 
> Dmitry Osipenko <digetx@gmail.com> escreveu:
> > Trace points are much more efficient than debug messages for extensive
> > tracing and could be conveniently enabled / disabled dynamically, hence
> > let's replace debug messages with the trace points.
> 
> This patch require some work:
> 
> $ make ARCH=i386  CF=-D__CHECK_ENDIAN__ CONFIG_DEBUG_SECTION_MISMATCH=y C=1
> W=1 CHECK='compile_checks' M=drivers/staging/media
> 
> ./include/linux/slab.h:631:13: error: undefined identifier
> '__builtin_mul_overflow' ./include/linux/slab.h:631:13: warning: call with
> no type!
> fixdep: error opening file: drivers/staging/media/tegra-vde/trace.h: No such
> file or directory

  CHECK   drivers/staging/media/tegra-vde/tegra-vde.c
/bin/sh: compile_checks: command not found

Upstream kernel doesn't have "compile_checks" script and I can't find it 
anywhere else.
