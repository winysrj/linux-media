Return-path: <linux-media-owner@vger.kernel.org>
Received: from foss.arm.com ([217.140.101.70]:46710 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752504AbcJJNB1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 10 Oct 2016 09:01:27 -0400
Date: Mon, 10 Oct 2016 14:51:37 +0200
From: John Einar Reitan <john.reitan@foss.arm.com>
To: Rob Clark <robdclark@gmail.com>
Cc: Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        Cc Ma <cc.ma@mediatek.com>,
        Joakim Bech <joakim.bech@linaro.org>,
        Burt Lien <burt.lien@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Linaro MM SIG Mailman List <linaro-mm-sig@lists.linaro.org>,
        Linaro Kernel Mailman List <linaro-kernel@lists.linaro.org>
Subject: Re: [PATCH v10 0/3] Secure Memory Allocation Framework
Message-ID: <20161010125136.GA2844@e106921-lin.trondheim.arm.com>
References: <1475581644-10600-1-git-send-email-benjamin.gaignard@linaro.org>
 <20161005131959.GE20761@phenom.ffwll.local>
 <CA+M3ks5vZyrxzF84t2fX0CK33LWq2A-uM=6rDFru-AO0mAyKQA@mail.gmail.com>
 <CAF6AEGto6iuNSG3Q3sBk1-wedhkPaJxM=Ru=ZcwfB63GwH7mhw@mail.gmail.com>
 <CA+M3ks6BkGuwKMYZXHPBeawB-5m+O1HxZvPpfbjO6voyoVJyZg@mail.gmail.com>
 <CAF6AEGtH+sgSHgmjK2-jCrsuV-Uz0bOz32s1w2Wy41RnTS0t1g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAF6AEGtH+sgSHgmjK2-jCrsuV-Uz0bOz32s1w2Wy41RnTS0t1g@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Oct 07, 2016 at 10:42:17AM -0400, Rob Clark wrote:
> probably should keep the discussion on github (USAGE.md was updated a
> bit more and merged into https://github.com/cubanismo/allocator so
> look there for the latest)..
> 
> but briefly:
> 
> 1) my expectation is if the user is implementing some use-case, it
> knows what devices and APIs are involved, otherwise it wouldn't be
> able to pass a buffer to that device/API..

As I described at Linaro Connect late-connected devices could cause new
constrains to appear. I.e. some (additonal) HDMI connection or WiFi Display etc.
Including all the might-happen devices might lead to unoptimal buffers
just to be able to handle some rarely-happen events.

I guess the easy resolve here is for the user to do a reallocation with
the new constraints added and replace the buffer(s) in question, but
with a slight lag in enabling the new device.

John
