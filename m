Return-Path: <SRS0=FDnu=P7=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2A61C282C0
	for <linux-media@archiver.kernel.org>; Wed, 23 Jan 2019 16:08:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 707A921855
	for <linux-media@archiver.kernel.org>; Wed, 23 Jan 2019 16:08:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="edYGiGQl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726140AbfAWQIP (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 23 Jan 2019 11:08:15 -0500
Received: from mail-lf1-f68.google.com ([209.85.167.68]:44675 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726009AbfAWQIP (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 23 Jan 2019 11:08:15 -0500
Received: by mail-lf1-f68.google.com with SMTP id z13so1955431lfe.11;
        Wed, 23 Jan 2019 08:08:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Vd1MKcPy0BDvFNxVNSx9BU8GHDAYo18C3C0eAMYtnCg=;
        b=edYGiGQlP9zEbfPRLqwCbHh0QJS0T80No0ZAK/4494Hy8+s8U+cDqx2kCMklxiJrFP
         oXOK/ojP5yCr3rVVCcI6/fej4znK68WT8hoLnCMTNPprgLkxfXamdMgriIclmtvl3u0K
         1ow7AG96ypHTug7FKjklDqhG0/gutEQEU57n13w2TXVxVPZ1UcGTpLvgV1PBrM2w/2N/
         2RaUpLMBGm/qOIZYO9VbCtJdUhArpF8sJtYk+e7tMCJwoeChF5rEXe1cNSj+vDOX1g3h
         fR52OSvBOZV25rHiYc7si+72UAC8iZJI7xF2Y5cCl4Xn3FIWjfZSHOuj080++h/3xZoK
         fGMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Vd1MKcPy0BDvFNxVNSx9BU8GHDAYo18C3C0eAMYtnCg=;
        b=qwfHRVlAO3JhwxDhyv2gxHbUKgU+5ZnJSE91Stw9gPP2Abu9rRwkNw0QFjY1kwQF8O
         TFJgR5P93cZlElUwkJZnydYokzPLCAW9n64wrASVT+f6ezGmuqh11/E1reL+aobCyQzY
         4maBBo02BeQ7HxTgHzcFWsSzqsbxAvvIRh4xrougjmzcnfauX3c6PYFpe7nr/8zVs4fJ
         u1LEt4vRB92dxmQOftpyzD+c9Z3EXQczeZ/EAIf+VfJwo96CFtSDv/gjvRHFPPVm8s+v
         kYTB9SsFU6xJRQVlkcmcf2y7peIYTPLOumuozr7TNAyXZ7UUoYFm8rasYE4v3HOYbAcr
         LEJw==
X-Gm-Message-State: AJcUukcgXZhvB13IsVZtvdKna0z+ySU/tOExxzngQ8I1et2/syR3UJ5o
        8lPb/zBqtBQvHXwtxzDPoRy7Z2cwga3QPX2AJAg=
X-Google-Smtp-Source: ALg8bN5BblVOcG4MjhYckYd+4iewjE5bSXOHCHVnJedoW3tFAe3TnfFE99KldI0v1zaA3LjkjKQZvszru8+je5lgbv8=
X-Received: by 2002:ac2:53b1:: with SMTP id j17mr2258927lfh.167.1548259692148;
 Wed, 23 Jan 2019 08:08:12 -0800 (PST)
MIME-Version: 1.0
References: <20181103145532.9323-1-user.vdr@gmail.com> <766230a305f54a37e9d881779a0d81ec439f8bd8.camel@hadess.net>
 <CAA7C2qhCmaJJ1F8D6zz0-9Sp+OspPE2h=KYRYO7seMUrs2q=sA@mail.gmail.com>
 <20190119085252.GA187380@dtor-ws> <CAA7C2qiKOTKSWgmK_9ZyPC-JaBp+vW0nhoJMPJzHCmV_wsg8_A@mail.gmail.com>
 <9e3eccabfafe830f7d30249a18e9d076e1868e4c.camel@hadess.net>
In-Reply-To: <9e3eccabfafe830f7d30249a18e9d076e1868e4c.camel@hadess.net>
From:   VDR User <user.vdr@gmail.com>
Date:   Wed, 23 Jan 2019 08:07:56 -0800
Message-ID: <CAA7C2qiwNuFqjamv4m5KdQ+J_vH8wAvzkF8G9853An7+rc=TUg@mail.gmail.com>
Subject: Re: [PATCH v2] Input: Add missing event codes for common IR remote buttons
To:     Bastien Nocera <hadess@hadess.net>
Cc:     Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-input@vger.kernel.org, Sean Young <sean@mess.org>,
        mchehab+samsung@kernel.org,
        "mailing list: linux-media" <linux-media@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Bastian,

> > There are multiple MENU keys I assume for clarity purposes and to
> > give
> > some kind of relation between the key definition and the action/event
> > that occurs when you use it. I would say it's more a matter of
> > convenience rather that need, similar to KEY_ROOT_MENU &
> > KEY_MEDIA_TOP_MENU; It's not a necessity that these two exist, but
> > they do out of convenience. You could still make things work if one
> > of
> > them vanished.
>
> Those 2 keys were added because they were present on DVD player remotes
> nearly 20 years ago ("Root menu" vs. "Top Menu"), and do different
> things.

That's true as it pertains to DVD players, but usage has changed over
time. These days it's common to have pc-based alternatives to
standalone players. Beyond that, pc-based setups that replace multiple
standalone devices. I personally use `root menu` to jump to the root
dir of my lan in file browsing mode and `top menu` to jump out to the
top-most menu of the playback menus. I mentioned neither of these _has
to_ exist but do for the sake of convenience. That's because the end
result in both cases could be achieved by pressing `back` X number of
times. But that's slow & inconvenient.

> > > > KEY_DISPLAY_FORMAT doesn't open any menus and is used to cycle
> > > > through
> > > > how video is displayed on-screen to the user; full, zoomed,
> > > > letterboxed, stretched, etc. KEY_CONTEXT_MENU would be for
> > > > something
> > > > like bringing up a playback menu where you'd set things like
> > > > upscaling, deinterlacing, audio mixdown/mixup, etc.
> > >
> > > KEY_ASPECT_RATIO (formerly KEY_SCREEN).
> >
> > Physical displays have a single set aspect ratio (W/H). Images have
> > their own aspect ratios. When the AR of the video to be display and
> > the display itself are mismatched, you have to do something
> > (letterbox, pillarbox, windowbox) to the video to maintain the
> > correct
> > video aspect ratio. You can't change the displays AR, and you aren't
> > changing the videos AR so using KEY_ASPECT_RATIO makes no sense. AR
> > isn't being touched/altered/manipulated, but how the video is being
> > displayed is. Stretching and filling to match the display AR alters
> > the video AR so there is makes sense, but then zooming may not. So,
> > since "aspect ratio" kind of makes sense in a couple cases, and makes
> > no sense in the rest, the more suitable KEY_DISPLAY_FORMAT is my
> > suggestion.
>
> The "Aspect Ratio" or "Ratio" key on loads of remotes have been doing
> this exact thing since the days of the first 16:9/cinema displays. I
> really don't think you need a new key here.

You can throw "Display" buttons and buttons with simply an icon
implying display manipulation in there as well. I've explained why
KEY_ASPECT_RATIO simply doesn't apply, and why KEY_DISPLAY_FORMAT
does. If people are against adding KEY_DISPLAY_FORMAT, then
KEY_ASPECT_RATIO should be renamed again & as such to properly reflect
the intended action. I suspect whomever started labeling this as
"aspect" or "aspect ratio" on remotes was some hardware designer that
didn't know how to accurately explain what the button does and took
his best (poor) guess.

Generally speaking, I think it's important to keep key definitions
close to what the intended action/result is. When it comes to pc-based
solutions, they are taking on more simultaneous roles and have to
cover a wider range of stuff. It's common these days to find people
using small boxes which perform local media functions & playback,
recording, streaming, interactive tv, web browsing access, etc. The
whole reason I made these suggestions was because I found I was
assigning keys which either didn't properly describe the event, or
were completely unrelated to it, and then having to change the
definition in software to match the actual use. Picture-In-Picture is
a great example of this. There's no defines that cover any of the PIP
stuff so you're forced to use something totally unrelated
(KEY_WHATEVER) and then alter software so when you press KEY_WHATEVER,
what you really mean is <some PIP function here>.

Best regards,
Derek
