Return-Path: <SRS0=RQn6=Q2=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B83FC43381
	for <linux-media@archiver.kernel.org>; Tue, 19 Feb 2019 19:14:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 017522147C
	for <linux-media@archiver.kernel.org>; Tue, 19 Feb 2019 19:14:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726305AbfBSTO1 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 19 Feb 2019 14:14:27 -0500
Received: from mail-qt1-f194.google.com ([209.85.160.194]:45560 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725827AbfBSTO1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Feb 2019 14:14:27 -0500
Received: by mail-qt1-f194.google.com with SMTP id d18so14409182qtg.12;
        Tue, 19 Feb 2019 11:14:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/210U5IkjRO1hXJC1CGNnrH8MlJ9MxI+N5HDmjpk2xI=;
        b=cAm6bPBw5IaG6fbfn2qEs+wmQPIuRt9/TjbiY8zw+gseaLmgt1pYesBDA2x5iovreR
         AYaEMrwlroY6GhCp8gIZe1kEneKTUTdgfJ2zqZDUu7lvnSuSAmNeVArMkwnhwry2DLd7
         jrg065PT8KhF2qYSRtAyn8N9V9lL6Te8aPIt5T39R4j2Kap2JHYqflAIlWEf+O88ncPZ
         4Fgm6h2aFL1SYWyelAHwDSHgO19zrH5nIe4ZGCHZLdnS5ZyLD4SLAjbjJfXfPUKT9/jt
         4NmJts1MT7tbFADYYXOnAj/tXPZ0k7hulYFQa1x+TJuoaykE7Gb4/T8whXqfUtvlIM7V
         V77g==
X-Gm-Message-State: AHQUAuaf6b9DKVtPr1rdCXbvHQs/bDLLvYzu2zGTGcpLw4VhCCxDgYBT
        ofwpWIZMe+mBZAYK/6I3QCvnpQFNcInyl2VhXBI=
X-Google-Smtp-Source: AHgI3IZ/ij3A9bvRQq+XFi1w+mSJN16HGEFAD5RJeqi5kI3k5IkSMjuNPac34/znEITNhLytgjdp9m+wnpFmdWgdz6U=
X-Received: by 2002:ac8:33f1:: with SMTP id d46mr23480568qtb.319.1550603665558;
 Tue, 19 Feb 2019 11:14:25 -0800 (PST)
MIME-Version: 1.0
References: <20190219170209.4180739-1-arnd@arndb.de> <20190219170209.4180739-2-arnd@arndb.de>
 <CAKwvOdm2fr6Xh9Tezexq4RGinkJy6P0_L6jQOMoZfArbgmaKJQ@mail.gmail.com>
In-Reply-To: <CAKwvOdm2fr6Xh9Tezexq4RGinkJy6P0_L6jQOMoZfArbgmaKJQ@mail.gmail.com>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Tue, 19 Feb 2019 20:14:08 +0100
Message-ID: <CAK8P3a0C6V0e8Z0uFSwrQ9V0pHqHWKwsHaQ5pVXDEpun5SVh3w@mail.gmail.com>
Subject: Re: [PATCH 2/3] media: vicodec: avoic clang frame size warning
To:     Nick Desaulniers <ndesaulniers@google.com>
Cc:     Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Mark Brown <broonie@kernel.org>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Dafna Hirschfeld <dafna3@gmail.com>,
        Tom aan de Wiel <tom.aandewiel@gmail.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Tue, Feb 19, 2019 at 8:02 PM Nick Desaulniers
<ndesaulniers@google.com> wrote:
> On Tue, Feb 19, 2019 at 9:02 AM Arnd Bergmann <arnd@arndb.de> wrote:
> >
> > Clang-9 makes some different inlining decisions compared to gcc, which
> > leads to a warning about a possible stack overflow problem when building
> > with CONFIG_KASAN, including when setting asan-stack=0, which avoids
> > most other frame overflow warnings:
> >
> > drivers/media/platform/vicodec/codec-fwht.c:673:12: error: stack frame size of 2224 bytes in function 'encode_plane'
> >
> > Manually adding noinline_for_stack annotations in those functions
>
> Thanks for the fix! In general, for -Wstack-frame-larger-than=
> warnings, is it possible that these sets of stack frames are already
> too large if entered?  Sure, inlining was a little aggressive, causing
> more stack space use than maybe otherwise necessary at runtime, but
> isn't it also possible that "no inlining" a stack frame can still be a
> problem should the stack frame be entered?  Doesn't the kernel have a
> way of estimating the stack depth for any given frame?  I guess I was
> always curious if the best fix for these kind of warnings was to
> non-stack allocate (kmalloc) certain locally allocated structs, or
> no-inline the function.  Surely there's cases where no-inlining is
> safe, but I was curious if it's still maybe dangerous to enter the
> problematic child most stack frame?

What I think is happening here is that llvm fails to combine the
stack allocations for the inlined functions in certain conditions,
while gcc can reuse it here. We had similar issues in gcc
a few years ago, and they got fixed there, but I have not looked
at this one in more detail. My guess is that it's related to
the bug I mentioned in patch 3.

      Arnd
