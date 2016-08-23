Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-it0-f67.google.com ([209.85.214.67]:32792 "EHLO
        mail-it0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757503AbcHWNlH (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 23 Aug 2016 09:41:07 -0400
Received: by mail-it0-f67.google.com with SMTP id d65so8069618ith.0
        for <linux-media@vger.kernel.org>; Tue, 23 Aug 2016 06:41:01 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160823070818.42ffec00@lwn.net>
References: <1471878705-3963-1-git-send-email-sumit.semwal@linaro.org>
 <1471878705-3963-3-git-send-email-sumit.semwal@linaro.org>
 <20160822124930.02dbbafc@vento.lan> <20160823060135.GJ24290@phenom.ffwll.local>
 <20160823070818.42ffec00@lwn.net>
From: Daniel Vetter <daniel@ffwll.ch>
Date: Tue, 23 Aug 2016 15:28:55 +0200
Message-ID: <CAKMK7uFMDcwk=ovX9+_R4FBOx6=sYnaOZwHuHSdQixdk-5_hwg@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] Documentation/sphinx: link dma-buf rsts
To: Jonathan Corbet <corbet@lwn.net>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Markus Heiser <markus.heiser@darmarit.de>,
        linux-doc@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        "linaro-mm-sig@lists.linaro.org" <linaro-mm-sig@lists.linaro.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Aug 23, 2016 at 3:08 PM, Jonathan Corbet <corbet@lwn.net> wrote:
> On Tue, 23 Aug 2016 08:01:35 +0200
> Daniel Vetter <daniel@ffwll.ch> wrote:
>
>> I'm also not too sure about whether dma-buf really should be it's own
>> subdirectory. It's plucked from the device-drivers.tmpl, I think an
>> overall device-drivers/ for all the misc subsystems and support code would
>> be better. Then one toc there, which fans out to either kernel-doc and
>> overview docs.
>
> I'm quite convinced it shouldn't be.
>
> If you get a chance, could you have a look at the "RFC: The beginning of
> a proper driver-api book" series I posted yesterday (yes, I should have
> copied more of you, sorry)?  It shows the direction I would like to go
> with driver API documentation, and, assuming we go that way, I'd like the
> dma-buf documentation to fit into that.

Looks real pretty, ack on that. And we can always split up more, e.g.
by extracting dma-buf.rst (and merg the current dma-buffer-sharing.txt
into that one).

I think the more interesting story is, what's your plan with all the
other driver related subsystem? Especially the ones which already have
full directories of their own, like e.g. Documentation/gpio/. I think
those should be really part of the infrastructure section (or
something equally high-level), together with other awesome servies
like pwm, regman, irqchip, ... And then there's also the large-scale
subsystems like media or gpu. What's the plan to tie them all
together? Personally I'm leaning towards keeping the existing
directories (where they exist already), but inserting links into the
overall driver-api section.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
