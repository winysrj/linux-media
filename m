Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:61023 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750853Ab1JIPsW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 9 Oct 2011 11:48:22 -0400
Received: by ggnv2 with SMTP id v2so3879793ggn.19
        for <linux-media@vger.kernel.org>; Sun, 09 Oct 2011 08:48:21 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CA+2YH7tF10xeEW+M2QzdPyjN9F+h8PY+JCha6KY8+ocovobjhg@mail.gmail.com>
References: <1318127853-1879-1-git-send-email-martinez.javier@gmail.com>
 <1318127853-1879-3-git-send-email-martinez.javier@gmail.com>
 <201110091202.16086.laurent.pinchart@ideasonboard.com> <CA+2YH7tF10xeEW+M2QzdPyjN9F+h8PY+JCha6KY8+ocovobjhg@mail.gmail.com>
From: Javier Martinez Canillas <martinez.javier@gmail.com>
Date: Sun, 9 Oct 2011 17:48:01 +0200
Message-ID: <CAAwP0s2Ze4J=4w2oimqNOahPE5yCYw6RvLWD+xkfL7d1J_T7vw@mail.gmail.com>
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
>
> Btw i'm trying to get these patches on 3.1.0rc9 (from igep repository,
> that should be just like mainline 3.1.0rc9 with some bsp patches), i
> hope i will report good news.
>
> Enrico
>

I just created a repository on my personal github account to keep the
patches [1] and make it more easily accessible to people that want to
try.
These already have the fix to the fact that ccdc_input_is_fldmode()
was returning pdata->bt655 instead of pdata->fldmode.

I will try to test the patches tomorrow when I have access to the
hardware but I can't promise because I have lots of other tasks to do.

[1]: https://github.com/martinezjavier/omap3isp/tree/master/omap3isp-yuv-patches

Best regards,

-- 
Javier Martínez Canillas
(+34) 682 39 81 69
Barcelona, Spain
