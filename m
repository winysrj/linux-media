Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-it0-f44.google.com ([209.85.214.44]:35249 "EHLO
        mail-it0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753128AbdEJNSl (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 10 May 2017 09:18:41 -0400
Received: by mail-it0-f44.google.com with SMTP id c15so24325264ith.0
        for <linux-media@vger.kernel.org>; Wed, 10 May 2017 06:18:41 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5912EB71.9090104@samsung.com>
References: <CGME20170420091406eucas1p24c50a0015545105081257d880727386c@eucas1p2.samsung.com>
 <1492679620-12792-1-git-send-email-m.szyprowski@samsung.com>
 <2541347.TzHdYYQVhG@avalon> <711bf4a5-7e57-6720-d00b-66e97a81e5ec@samsung.com>
 <20170425222124.GA7456@valkosipuli.retiisi.org.uk> <59126BB4.6050309@samsung.com>
 <CAAFQd5CPNQ5hDDXPwo2v54VcoOMeDszuvoHZPYQYNJsMJk41Ww@mail.gmail.com>
 <5912B2B6.4050605@samsung.com> <CAAFQd5D1-ZsXNcArXBf5=a=ukjnLHehHmvQg_zJc+b_WLka6rQ@mail.gmail.com>
 <5912EB71.9090104@samsung.com>
From: Daniel Vetter <daniel@ffwll.ch>
Date: Wed, 10 May 2017 15:18:39 +0200
Message-ID: <CAKMK7uEdPaPsPtO368oXNsqUF2=fZJUA9rJDmeDkouJzSF8HFw@mail.gmail.com>
Subject: Re: [RFC 0/4] Exynos DRM: add Picture Processor extension
To: Inki Dae <inki.dae@samsung.com>
Cc: Tomasz Figa <tfiga@chromium.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        Tobias Jakobi <tjakobi@math.uni-bielefeld.de>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@intel.com>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, May 10, 2017 at 12:29 PM, Inki Dae <inki.dae@samsung.com> wrote:
>> This kind of contradicts with response Marek received from DRM
>> community about his proposal. Which drivers in particular you have in
>> mind?
>
> You can check vmw_overlay_ioctl of vmwgfx driver and intel_overlay_put_image_ioctl of i915 driver. These was all I could find in mainline.
> Seems the boundaries of whether we have to implement pre/post post processing mem2mem driver in V4L2 or DRM are really vague.

These aren't picture processors, but overlay plane support merged
before we had the core drm overlay support. Please do not emulate them
at all, your patch will be rejected :-)
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
