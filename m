Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-it0-f67.google.com ([209.85.214.67]:34807 "EHLO
        mail-it0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750938AbdGGNWy (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 7 Jul 2017 09:22:54 -0400
MIME-Version: 1.0
In-Reply-To: <1499428551.5590.15.camel@linux.intel.com>
References: <20170707115044.21744-1-gehariprasath@gmail.com> <1499428551.5590.15.camel@linux.intel.com>
From: hari prasath <gehariprasath@gmail.com>
Date: Fri, 7 Jul 2017 18:52:52 +0530
Message-ID: <CAHHWPbfxGrbTy4zWnSEWLLd1oi24BtQzKKC_6UfzbpCaD=ufWw@mail.gmail.com>
Subject: Re: [PATCH] staging: atomisp: replace kmalloc & memcpy with kmemdup
To: Alan Cox <alan@linux.intel.com>
Cc: linux-media@vger.kernel.org, Julia Lawall <julia.lawall@lip6.fr>,
        mchehab@kernel.org, linux-kernel@vger.kernel.org,
        SIMRAN SINGHAL <singhalsimran0@gmail.com>,
        rvarsha016@gmail.com, devel@driverdev.osuosl.org,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07-Jul-2017 5:25 PM, "Alan Cox" <alan@linux.intel.com> wrote:

On Fri, 2017-07-07 at 17:20 +0530, Hari Prasath wrote:
> kmemdup can be used to replace kmalloc followed by a memcpy.This was
> pointed out by the coccinelle tool.

And kstrdup could do the job even better I think ?
> Yes & thanks for pointing me that. I will send a v2 version.

-Hari
