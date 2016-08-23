Return-path: <linux-media-owner@vger.kernel.org>
Received: from tex.lwn.net ([70.33.254.29]:50393 "EHLO vena.lwn.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1757331AbcHWOQh (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 23 Aug 2016 10:16:37 -0400
Date: Tue, 23 Aug 2016 08:16:33 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Daniel Vetter <daniel@ffwll.ch>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Markus Heiser <markus.heiser@darmarit.de>,
        linux-doc@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        "linaro-mm-sig@lists.linaro.org" <linaro-mm-sig@lists.linaro.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [PATCH v2 2/2] Documentation/sphinx: link dma-buf rsts
Message-ID: <20160823081633.123ae938@lwn.net>
In-Reply-To: <CAKMK7uFMDcwk=ovX9+_R4FBOx6=sYnaOZwHuHSdQixdk-5_hwg@mail.gmail.com>
References: <1471878705-3963-1-git-send-email-sumit.semwal@linaro.org>
        <1471878705-3963-3-git-send-email-sumit.semwal@linaro.org>
        <20160822124930.02dbbafc@vento.lan>
        <20160823060135.GJ24290@phenom.ffwll.local>
        <20160823070818.42ffec00@lwn.net>
        <CAKMK7uFMDcwk=ovX9+_R4FBOx6=sYnaOZwHuHSdQixdk-5_hwg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 23 Aug 2016 15:28:55 +0200
Daniel Vetter <daniel@ffwll.ch> wrote:

> I think the more interesting story is, what's your plan with all the
> other driver related subsystem? Especially the ones which already have
> full directories of their own, like e.g. Documentation/gpio/. I think
> those should be really part of the infrastructure section (or
> something equally high-level), together with other awesome servies
> like pwm, regman, irqchip, ... And then there's also the large-scale
> subsystems like media or gpu. What's the plan to tie them all
> together? Personally I'm leaning towards keeping the existing
> directories (where they exist already), but inserting links into the
> overall driver-api section.

To say I have a plan is to overstate things somewhat...

One objective I do have, though, is to declutter Documentation/.
Presenting people looking for docs with a 270-file directory is
unfriendly to say the least.  We don't organize the code that way; the
average in the kernel is <... find | wc -l ... > about 15
files/directory, which is rather more manageable.  Someday I'd like
Documentation/ to look a lot more like the top-level directory.

It seems to me that we have a few basic types of stuff here:

 - Driver API documentation, obviously, is a lot of it, and I would like
   to organize it better and to move it out of the top-level directory.

 - Hardware usage information - module parameters, sysfs files, supported
   hardware information, graphic descriptions of the ancestry of hardware
   engineers, etc.  The readership for this stuff is quite different, and
   I think it should be separate; often it's intertwined with API
   information at the moment.

 - Other usage information - a lot of what's under filesystems/ for
   example, and more.

 - Core API documentation.

 - Kernel development tools - the stuff I started pulling together into
   the dev-tools/ subdirectory.

 - How to deal with this unruly mob - SubmittingPatches, CodingStyle,
   development-process, etc.  There's process stuff, and general
   development documents like volatile-considered-harmful.txt or
   memory-barriers.txt

We can go a long way by organizing this stuff within the formatted
documentation, but I really think we need to organize the directory
structure as well.  I see that as a slow-moving process that will take
years, but I do think it's a direction we should go.

jon
