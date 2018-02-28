Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f169.google.com ([209.85.216.169]:42673 "EHLO
        mail-qt0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752488AbeB1OtN (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 28 Feb 2018 09:49:13 -0500
Received: by mail-qt0-f169.google.com with SMTP id t6so3231704qtn.9
        for <linux-media@vger.kernel.org>; Wed, 28 Feb 2018 06:49:13 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <df78951777f4edb8f627b043a12c710f0ba2497d.1519753238.git.mchehab@s-opensource.com>
References: <df78951777f4edb8f627b043a12c710f0ba2497d.1519753238.git.mchehab@s-opensource.com>
From: Devin Heitmueller <dheitmueller@kernellabs.com>
Date: Wed, 28 Feb 2018 09:49:12 -0500
Message-ID: <CAGoCfixqh-p6YWV3Fb9hGpX5Wv=qiWHFseuFRva66XsYtGkgFQ@mail.gmail.com>
Subject: Re: [PATCH RFC] media: em28xx: don't use coherent buffer for DMA transfers
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Feb 27, 2018 at 12:42 PM, Mauro Carvalho Chehab
<mchehab@s-opensource.com> wrote:
> While coherent memory is cheap on x86, it has problems on
> arm. So, stop using it.
>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> ---
>
> I wrote this patch in order to check if this would make things better
> for ISOCH transfers on Raspberry Pi3. It didn't. Yet, keep using
> coherent memory at USB drivers seem an overkill.
>
> So, I'm actually not sure if we should either go ahead and merge it
> or not.
>
> Comments? Tests?

For what it's worth, while I haven't tested this patch you're
proposing, I've been running what is essentially the same change in a
private tree for several years in order for the device to work better
with several TI Davinci SOC platforms.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
