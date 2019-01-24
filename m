Return-Path: <SRS0=42/h=QA=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7614C282C3
	for <linux-media@archiver.kernel.org>; Thu, 24 Jan 2019 16:21:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 768ED218AF
	for <linux-media@archiver.kernel.org>; Thu, 24 Jan 2019 16:21:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dsuJrOSN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727893AbfAXQVU (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 24 Jan 2019 11:21:20 -0500
Received: from mail-lf1-f66.google.com ([209.85.167.66]:43741 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727690AbfAXQVU (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 24 Jan 2019 11:21:20 -0500
Received: by mail-lf1-f66.google.com with SMTP id u18so4729544lff.10;
        Thu, 24 Jan 2019 08:21:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=iBiADSjLJGYr0+vo802vI08UxBMzyh0TibpPpEvVMFs=;
        b=dsuJrOSNEkU7pugUsfqwGkaxMGKLe2ToX+uHdBM1+anDMltus9tmm7sD8t/78cOY0Y
         Py5OFx+2fFQziFWkiulxhPm44AjrWdNTj9Ul9sPIvzDGxWhDfrsu+JkPLM2Kvs51ACnI
         1W518UZSXFDVUo5jSE5JPH1pNeBmkR1i4jlgjIDvJYvV9sUErT642I2yuepfhyBQmdEp
         FRdmcYko2AlLfTU4MHNsEAFyYGckcWBzu7SxwXPjU7m0nfhHEqEdnmoWm7zCJKtAzq9Z
         4ukWm3pPK5F9fEFEf50u+VrmfbpUQRALwTXNgDGIV8HgUHkwBeUOHT+YbkiUAEUxeEkM
         gA8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=iBiADSjLJGYr0+vo802vI08UxBMzyh0TibpPpEvVMFs=;
        b=g+tVZ0GdOmXY0d3J5naxzWD8ffPnK2Qr11Y26jQg8j3lXz/WJnD0zL3Fkxqb8J0GTP
         u3bXD0XQPxAI+iI0pdJApvFRDr+mMuarY+9an2UDVRJivDMMM1qoebQT4wioU0vUmCzC
         qElObp90ZdlJG6OlwC8G90+CpGZAdKdqBSB5l6Q+oRsWL2F5jkaZ83HC8WPLDZiP5vii
         VsA+CtxY6DioAsTqxjV5FvyxmjExHefkRq6W7brQbA+lQosvzQ/YQ1ASi8sunVkmonhT
         1UFeePcdmP8pOrOalK+Sk2TjFhXZLd1FJuyfkTHG2NIAEqBLWs3vdD7vWU8lXNmnKxdq
         Bedg==
X-Gm-Message-State: AJcUukfiwQPkV+k3D7IPUZNuXzZk6Z/K5OwjkrEEM1wQc6aFVUG7hpuf
        JbYSgUMhcacxebwL3hujWGYg91b4LH6OKwGxxKY=
X-Google-Smtp-Source: ALg8bN6BHQvLQo6HF6ToTLJAug0gTDqyybYZ4YCccCHDTVE1Kh/FClulDpDfaKO2swaFd5YOHp3d9aVHT6zazGjkCpI=
X-Received: by 2002:a19:4849:: with SMTP id v70mr6175365lfa.62.1548346877923;
 Thu, 24 Jan 2019 08:21:17 -0800 (PST)
MIME-Version: 1.0
References: <20181103145532.9323-1-user.vdr@gmail.com> <766230a305f54a37e9d881779a0d81ec439f8bd8.camel@hadess.net>
 <CAA7C2qhCmaJJ1F8D6zz0-9Sp+OspPE2h=KYRYO7seMUrs2q=sA@mail.gmail.com>
 <20190119085252.GA187380@dtor-ws> <CAA7C2qiKOTKSWgmK_9ZyPC-JaBp+vW0nhoJMPJzHCmV_wsg8_A@mail.gmail.com>
 <20190124083742.GB139904@dtor-ws>
In-Reply-To: <20190124083742.GB139904@dtor-ws>
From:   VDR User <user.vdr@gmail.com>
Date:   Thu, 24 Jan 2019 08:21:05 -0800
Message-ID: <CAA7C2qhympiM2H==9e7Rq9am=2YzM3UoU3S-CbLX0ka+M52YDw@mail.gmail.com>
Subject: Re: [PATCH v2] Input: Add missing event codes for common IR remote buttons
To:     Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc:     Bastien Nocera <hadess@hadess.net>, linux-input@vger.kernel.org,
        Sean Young <sean@mess.org>, mchehab+samsung@kernel.org,
        "mailing list: linux-media" <linux-media@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

> > > KEY_ASPECT_RATIO (formerly KEY_SCREEN).
> >
> > Physical displays have a single set aspect ratio (W/H). Images have
> > their own aspect ratios. When the AR of the video to be display and
> > the display itself are mismatched, you have to do something
> > (letterbox, pillarbox, windowbox) to the video to maintain the correct
> > video aspect ratio. You can't change the displays AR, and you aren't
> > changing the videos AR so using KEY_ASPECT_RATIO makes no sense. AR
> > isn't being touched/altered/manipulated, but how the video is being
> > displayed is. Stretching and filling to match the display AR alters
> > the video AR so there is makes sense, but then zooming may not. So,
> > since "aspect ratio" kind of makes sense in a couple cases, and makes
> > no sense in the rest, the more suitable KEY_DISPLAY_FORMAT is my
> > suggestion.
>
> No, we will not be renaming this key. We try to have parity with the
> HUT, which has the following to say:
>
> "Aspect OSC - Selects the next available supported aspect ratio option
> on a device which outputs or displays video.  For example, common
> aspect ratio options are 4:3 (standard definition), 16:9 (often used
> to stretch a standard definition source signal to a 16:9 video screen),
> letter-box and anamorphic widescreen.The order in which the aspect
> ratios are selected is implementation specific."

Hi Dmitry,

The suggestion to rename KEY_ASPECT_RATIO was a `last resort` in the
event people are against a more suitable and accurate key to what
happens to the actual content. The root issue is in not making any
distinction between content AR, frame AR, and display AR. As
previously described, letterbox/pillarbox/windowbox is used to
*maintain* the correct AR, not alter it. Stretching may or may not
alter AR, zooming may or may not alter AR. There are more scenarios
where AR is unaffected than otherwise so more often KEY_ASPECT_RATIO
makes no sense than does. However, in all cases (except where content
& display match and you wouldn't use this key) how the frames are
being displayed *is* altered, which is where KEY_DISPLAY_FORMAT comes
from.

Best regards,
Derek
