Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f176.google.com ([209.85.128.176]:35259 "EHLO
        mail-wr0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932895AbdGKPaS (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 11 Jul 2017 11:30:18 -0400
Received: by mail-wr0-f176.google.com with SMTP id k67so3867804wrc.2
        for <linux-media@vger.kernel.org>; Tue, 11 Jul 2017 08:30:17 -0700 (PDT)
Date: Tue, 11 Jul 2017 17:30:13 +0200
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: Ralph Metzler <rjkm@metzlerbros.de>
Cc: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com, jasmin@anw.at, d_spingler@gmx.de
Subject: Re: [PATCH 00/14] ddbridge: bump to ddbridge-0.9.29
Message-ID: <20170711173013.25741b86@audiostation.wuest.de>
In-Reply-To: <22884.38463.374508.270284@morden.metzler>
References: <20170709194221.10255-1-d.scheller.oss@gmail.com>
        <22883.13973.46880.749847@morden.metzler>
        <20170710173124.653286e7@audiostation.wuest.de>
        <22884.38463.374508.270284@morden.metzler>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am Tue, 11 Jul 2017 11:11:27 +0200
schrieb Ralph Metzler <rjkm@metzlerbros.de>:

> Daniel Scheller writes:
>  > 
>  > IIRC this was -main.c, and basically the code split, but no
>  > specific file. However, each of the additionals (hw, io, irq) were
>  > done with a reason (please also see their commit messages at
>  > patches 4-6):
>  > [...]
> 
> As I wrote before, changes like this will break other things like the
> OctopusNet build tree. So, I cannot use them like this or without
> changes at other places. And even if I wanted to, I cannot pull
> anything into the public dddvb repository.

Ok, you probably have seen the PRs I created against dddvb, as they
apply basically the same as is contained in this patchset, and even
fixes a few minors. Thus, lets not declare this as merge-blocker for
this patches, please.

It'd of course be very valuable if you continue to commit incremental
changes to your drivers, so we can move on with the plan to keep the
in-kernel-driver (if merged) uptodate in a timely manner. After
over 1.5years I believe I know the driver quite well now so I won't get
troubles picking up things by hand.

Best regards,
Daniel Scheller
-- 
https://github.com/herrnst
