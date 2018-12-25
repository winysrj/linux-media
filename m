Return-Path: <SRS0=Hs4g=PC=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1ED0C43387
	for <linux-media@archiver.kernel.org>; Tue, 25 Dec 2018 21:13:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B99D821726
	for <linux-media@archiver.kernel.org>; Tue, 25 Dec 2018 21:13:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="AYp9ximD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725903AbeLYVNT (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 25 Dec 2018 16:13:19 -0500
Received: from mail-lj1-f194.google.com ([209.85.208.194]:36949 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725884AbeLYVNS (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 25 Dec 2018 16:13:18 -0500
Received: by mail-lj1-f194.google.com with SMTP id t18-v6so12590436ljd.4
        for <linux-media@vger.kernel.org>; Tue, 25 Dec 2018 13:13:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LUf4H07VFsiXZjCkOwiy66KZvhPPi/utGiiZL50k84E=;
        b=AYp9ximDGd35tTZQ8LCFAcjX2zHm6TuIJJ8rKbpVnGGWw+EiYLdL0rnqa8GGL1Uss4
         I0OjgsSW99/To0egR5WMA41xoovIVTCMExm0WDwOI/b6Qx+9ePqCwNaqqtDFvDGwrdta
         /0p535kClwEWK9BTtzxXu7ENxDiqPm3JOJq+M=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LUf4H07VFsiXZjCkOwiy66KZvhPPi/utGiiZL50k84E=;
        b=obYJUxHrjLOdVLJ4Fir8vPobYakqQ1UvHW0EzdCAgpq8gPF5GI+h6hDmC4/MWi9YsV
         RqrtUwxw7F/SssYOuvTPResCkc5RugJJu7hVk5hqt0xIm+wmy3Dpc3iM4hYIUhdCoxYq
         rVubLVXGZWjEdqkUQg1kezqSgqtJcWx/LmxhU3KMdPktJJk2vCFbxbClzAi3karW3zz0
         gJ9ghRuSonNcszL3jXCMEhpgFd4DoNAc9x/OVgkw3Gvz0gCLY097mQZnwkQAotT9EXiS
         rxHj/YXdMDWQ+w9laXM+aA/1HhD3AGSrLjgHpqQmlKBFcRYMjMrCiK7ehBOXFzLTZp+y
         ClZA==
X-Gm-Message-State: AJcUukeetiy7CGc77KZOf9cNz5Wd3Z6vWICdPvs9Urh+bZo6rMF+5uOT
        O64VtKvZmHL/0zTaT4S8cgzzKa608vY=
X-Google-Smtp-Source: ALg8bN7JWSPNx6gR3tNe9Y/GjFwmrpBBDAJV8zMy5cm53sTdERBzsMh9J4PnqjfkfIbv4Imuw+chOw==
X-Received: by 2002:a2e:5418:: with SMTP id i24-v6mr8300444ljb.51.1545772396184;
        Tue, 25 Dec 2018 13:13:16 -0800 (PST)
Received: from mail-lj1-f175.google.com (mail-lj1-f175.google.com. [209.85.208.175])
        by smtp.gmail.com with ESMTPSA id u11sm6948603lfb.85.2018.12.25.13.13.14
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 25 Dec 2018 13:13:15 -0800 (PST)
Received: by mail-lj1-f175.google.com with SMTP id k19-v6so12579682lji.11
        for <linux-media@vger.kernel.org>; Tue, 25 Dec 2018 13:13:14 -0800 (PST)
X-Received: by 2002:a2e:2c02:: with SMTP id s2-v6mr10058599ljs.118.1545772394436;
 Tue, 25 Dec 2018 13:13:14 -0800 (PST)
MIME-Version: 1.0
References: <20181220104544.72ee9203@coco.lan>
In-Reply-To: <20181220104544.72ee9203@coco.lan>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue, 25 Dec 2018 13:12:58 -0800
X-Gmail-Original-Message-ID: <CAHk-=wiqS_ShU4th7mKd4kLEXaKKyrnK5FkyJgdy=_=_wy1KGg@mail.gmail.com>
Message-ID: <CAHk-=wiqS_ShU4th7mKd4kLEXaKKyrnK5FkyJgdy=_=_wy1KGg@mail.gmail.com>
Subject: Re: [GIT PULL for v4.21] second set of media patches: ipu3 driver
To:     Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Thu, Dec 20, 2018 at 4:45 AM Mauro Carvalho Chehab
<mchehab+samsung@kernel.org> wrote:
>
> Also, it would be good if you merge first the docs-next pull request from
> Jon, as otherwise, you'll see some warnings when building documentation,
> due to an issue at scripts/kernel-doc, whose fix is at documentation tree.

I don't seem to have that in my pile of pull requests, so docs
creation will warn for a bit. Not a huge deal.

                     Linus
