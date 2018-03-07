Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vk0-f66.google.com ([209.85.213.66]:38503 "EHLO
        mail-vk0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933746AbeCGROH (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 7 Mar 2018 12:14:07 -0500
Received: by mail-vk0-f66.google.com with SMTP id s1so1770841vke.5
        for <linux-media@vger.kernel.org>; Wed, 07 Mar 2018 09:14:06 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1520442688.19980.1.camel@gmail.com>
References: <1520442688.19980.1.camel@gmail.com>
From: Bjorn Pagen <bjornpagen@gmail.com>
Date: Wed, 7 Mar 2018 12:14:05 -0500
Message-ID: <CAARz7_gSDbpeNfw+etEJCDXGG6iRU9TPXSm9E7VLMjCg9S4ZSQ@mail.gmail.com>
Subject: Re: v4l-utils fails to build against musl libc (with patch)
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Here's the link again and it's tinyurl, since the link seems to be
borked because of line wraparounds:

https://git.alpinelinux.org/cgit/aports/tree/community/v4l-utils/0001-ir-ctl-fixes-for-musl-compile.patch
https://tinyurl.com/y7gr6eju

On Wed, Mar 7, 2018 at 12:11 PM,  <bjornpagen@gmail.com> wrote:
> Hey all,
>
> v4l-utils currently fails to build against musl libc, since musl, and
> POSIX, both do not define TEMP_FAILURE_RETRY() or strndupa().
>
> This can be fixed with a small patch from https://git.alpinelinux.org/c
> git/aports/tree/community/v4l-utils/0001-ir-ctl-fixes-for-musl-compile.
> patch.
>
> Please email me back with any questions or concerns about the patch or
> musl.
>
> Thanks,
> Bjorn Pagen



-- 
Bjorn Pagen
