Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.anw.at ([195.234.101.228]:51676 "EHLO mail.anw.at"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750746AbeEKUCX (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 11 May 2018 16:02:23 -0400
Subject: Re: [PATCH 7/7] Add config-compat.h override config-mycompat.h
To: Brad Love <brad@nextdimension.cc>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
References: <1524763162-4865-1-git-send-email-brad@nextdimension.cc>
 <1524763162-4865-8-git-send-email-brad@nextdimension.cc>
 <c20ac1dd-153c-5d43-f0fd-ade27c548f86@xs4all.nl>
 <777ec77a-1a1c-138b-b5ca-33201649acc7@nextdimension.cc>
From: "Jasmin J." <jasmin@anw.at>
Message-ID: <3a039830-6ae8-406b-ede6-77553d7f45dd@anw.at>
Date: Fri, 11 May 2018 22:02:18 +0200
MIME-Version: 1.0
In-Reply-To: <777ec77a-1a1c-138b-b5ca-33201649acc7@nextdimension.cc>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Brad!

> and which the media_build system does not pick up on for whatever
> reason.
Maybe it would be better to analyse why "make_config_compat.pl" selects
wrongly the compatibility code.

> It seems there is quite often at least one backport I must disable,
> and some target kernels require multiple backports disabled.
This sounds strange. media-build should handle those cases correctly
in my opinion and should be fixed.
At least we should check why this happens.

Patch 7/7 sounds like a workaround for me.
If there is really no other solution, than we need to implement this
possibility for distro maintainers.

On the other hand, why is media-build used by distro maintainers at all?
I thought distro Kernels are built with a full tree and thus doesn't
need media-build.

BR,
   Jasmin
