Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:36091 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751219AbdBZUjc (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 26 Feb 2017 15:39:32 -0500
Received: by mail-wr0-f193.google.com with SMTP id o22so7304057wro.3
        for <linux-media@vger.kernel.org>; Sun, 26 Feb 2017 12:39:31 -0800 (PST)
Date: Sun, 26 Feb 2017 21:30:45 +0100
From: Daniel Vetter <daniel@ffwll.ch>
To: Mark Brown <broonie@kernel.org>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Linaro Kernel Mailman List <linaro-kernel@lists.linaro.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Laura Abbott <labbott@redhat.com>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "Clark, Rob" <robdclark@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [RFC simple allocator v2 1/2] Create Simple Allocator module
Message-ID: <20170226203045.vmzjkxix32nl2rzw@phenom.ffwll.local>
References: <1486997106-23277-1-git-send-email-benjamin.gaignard@linaro.org>
 <1967325.JRFDDRuil3@avalon>
 <CAKMK7uEoC6vrx-Yi0K0bFaPRctRNLmjgYrZN4thmX6a3Y0KU3A@mail.gmail.com>
 <2684010.GP2h2R50oJ@avalon>
 <20170215121526.ixtsms7fi4yps5yq@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170215121526.ixtsms7fi4yps5yq@sirena.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Feb 15, 2017 at 12:15:26PM +0000, Mark Brown wrote:
> On Tue, Feb 14, 2017 at 09:59:55PM +0200, Laurent Pinchart wrote:
> > On Tuesday 14 Feb 2017 20:44:44 Daniel Vetter wrote:
> 
> > > ADF was probably the best example in this. KMS also took a while until all
> > > the fbdev wheels have been properly reinvented (some are still the same old
> > > squeaky onces as fbdev had, e.g. fbcon).
> 
> > > And I don't think destaging ION is going to be hard, just a bit of
> > > work (could be a nice gsoc or whatever).
> 
> > Oh, technically speaking, it would be pretty simple. The main issue is to 
> > decide whether we want to commit to the existing ION API. I don't :-)
> 
> Right, we need to figure out what people should be doing and let them
> work on it.  At the minute anyone who wants to use this stuff in
> mainline is kind of stuck as attempts to add ION drivers get pushback
> 
>    https://lkml.org/lkml/2016/11/7/806
> 
> but so do attempts to do something different (there was a statement in
> that thread that new ION drivers could be added if we could ever figure
> out bindings but I'm not sure there's any prospect of that).  There's no
> clear direction for people to follow if they want to make progress.

Hm, this feels like a misunderstanding ... the unix device memory
allocator discussion is all about how to solve the userspace side on a
generic system (i.e. when you can't just hardcode everything in gralloc).
It's not really about where to actually allocate the kernel memory, for
that I think ION still looks as reasonable as anything else.

We just need to get around to working down the destaging todo items and
push it into something like drivers/gpu/ion or whatever. Feel free to cc
me and Laura and dri-devel on any such effort, this has been stuck way too
long.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
