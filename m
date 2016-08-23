Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f51.google.com ([74.125.82.51]:38838 "EHLO
        mail-wm0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757306AbcHWNfh (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 23 Aug 2016 09:35:37 -0400
Received: by mail-wm0-f51.google.com with SMTP id o80so195756954wme.1
        for <linux-media@vger.kernel.org>; Tue, 23 Aug 2016 06:34:08 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160823070818.42ffec00@lwn.net>
References: <1471878705-3963-1-git-send-email-sumit.semwal@linaro.org>
 <1471878705-3963-3-git-send-email-sumit.semwal@linaro.org>
 <20160822124930.02dbbafc@vento.lan> <20160823060135.GJ24290@phenom.ffwll.local>
 <20160823070818.42ffec00@lwn.net>
From: Sumit Semwal <sumit.semwal@linaro.org>
Date: Tue, 23 Aug 2016 19:03:47 +0530
Message-ID: <CAO_48GG-svRna2Q326VjiTjgT12O5OEg2VPP+_5DkxWc30bO7w@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] Documentation/sphinx: link dma-buf rsts
To: Jonathan Corbet <corbet@lwn.net>
Cc: Daniel Vetter <daniel@ffwll.ch>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Markus Heiser <markus.heiser@darmarit.de>,
        linux-doc@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        DRI mailing list <dri-devel@lists.freedesktop.org>,
        Linaro MM SIG Mailman List <linaro-mm-sig@lists.linaro.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jon,

On 23 August 2016 at 18:38, Jonathan Corbet <corbet@lwn.net> wrote:
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
>

Thanks for your comments, and direction. I'll rework the patches on
top of yours then.
I'll have a look at your patches to think about how do we handle API
guides / detailed documentation as well.

> Thanks,
>
> jon

Best,
Sumit.
