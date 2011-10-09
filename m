Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:51595 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751222Ab1JINak convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 9 Oct 2011 09:30:40 -0400
Received: by yxl31 with SMTP id 31so4711517yxl.19
        for <linux-media@vger.kernel.org>; Sun, 09 Oct 2011 06:30:40 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CA+2YH7tF10xeEW+M2QzdPyjN9F+h8PY+JCha6KY8+ocovobjhg@mail.gmail.com>
References: <1318127853-1879-1-git-send-email-martinez.javier@gmail.com>
 <1318127853-1879-3-git-send-email-martinez.javier@gmail.com>
 <201110091202.16086.laurent.pinchart@ideasonboard.com> <CA+2YH7tF10xeEW+M2QzdPyjN9F+h8PY+JCha6KY8+ocovobjhg@mail.gmail.com>
From: Javier Martinez Canillas <martinez.javier@gmail.com>
Date: Sun, 9 Oct 2011 15:30:20 +0200
Message-ID: <CAAwP0s07xs8pCCPsBAKCKhREdV8dZPr0kkSP_Vru2cak-UvAYQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] omap3isp: ccdc: Add support to ITU-R BT.656 video
 data format
To: Enrico <ebutera@users.berlios.de>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Gary Thomas <gary@mlbassoc.com>,
	Adam Pledger <a.pledger@thermoteknix.com>,
	Deepthy Ravi <deepthy.ravi@ti.com>, linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Oct 9, 2011 at 2:58 PM, Enrico <ebutera@users.berlios.de> wrote:
> On Sun, Oct 9, 2011 at 12:02 PM, Laurent Pinchart
> <laurent.pinchart@ideasonboard.com> wrote:
>> Hi Javier,
>>
>> Thanks for the patch.
>
> Laurent, apart from the specific comments on Javier code, did you have
> a look at Deepthy patches too?
>
> I say this because asking Javier for fixes means (to me) that you are
> going to merge his patches (if testing will confirm it works of
> course). Am i wrong?

I don't think these patches are in merge-able state because I only
compile tested.
Now based on Laurent's comments I just sent a v2 patch-set based in
one of our earlier changes.

This was before we decide to move the logic to VD1 so the patch-set is
less intrusive and will be easier to review.

Also, now I check for fldmode not bt656, Laurent's is right that
bt.656 is interlaced but not every interlaced video is bt.656.

>
> Btw i'm trying to get these patches on 3.1.0rc9 (from igep repository,
> that should be just like mainline 3.1.0rc9 with some bsp patches), i
> hope i will report good news.
>
> Enrico
>

Great, thank you very much for your efforts Enrico.

Best regards,

-- 
Javier Martínez Canillas
(+34) 682 39 81 69
Barcelona, Spain
