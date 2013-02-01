Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ie0-f179.google.com ([209.85.223.179]:36843 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751973Ab3BACWW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 31 Jan 2013 21:22:22 -0500
Received: by mail-ie0-f179.google.com with SMTP id k11so1818547iea.24
        for <linux-media@vger.kernel.org>; Thu, 31 Jan 2013 18:22:22 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1359627936-14918-1-git-send-email-hverkuil@xs4all.nl>
References: <1359627936-14918-1-git-send-email-hverkuil@xs4all.nl>
Date: Fri, 1 Feb 2013 10:22:22 +0800
Message-ID: <CAMiH66HAGRuPUYhbxm8_DUOPFfbKW832eJ4n-qq+-cNDMYr+9A@mail.gmail.com>
Subject: Re: [RFC PATCH 00/18] tlg2300: various v4l2-compliance fixes
From: Huang Shijie <shijie8@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans:

On Thu, Jan 31, 2013 at 6:25 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> Hi all,
>
> Last year I worked on this driver to improve it and fix v4l2-compliance
> issues.

I am glad to know that there are still some people use the
tlg2300. thanks a lot.

>
> It required a lot of effort to even find a USB stick with this chipset
> (telegent no longer exists) and unfortunately at some point I managed
> to break the USB stick, so I am no longer able to work on it.
>
> This patch series represents that part of the work I've done that has
> been tested. I have additional patches in my tlg2300-wip branch:
>
> http://git.linuxtv.org/hverkuil/media_tree.git/shortlog/refs/heads/tlg2300-wip
>
> but since I am no longer certain at what point in those remaining patches
> things broke down I've decided not to post them for upstreaming. If I or
> someone else ever manages to get a working tlg2300 that code might be used
> for further work.

Could you tell me how did you test your patch set?
did you test the hibernate and suspend/resume?




>
> Huang Shijie, are you still able to act as maintainer? If not, then I can
> put my name in. The MAINTAINER status should probably move to 'Odd Fixes'

Yes, you can put your name in.
I am busy some other drivers recently.

thanks
Huang Shijie

> as well.
>
> Regards,
>
>         Hans
>
