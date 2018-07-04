Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:54059 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752237AbeGDRIi (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 4 Jul 2018 13:08:38 -0400
Received: by mail-wm0-f65.google.com with SMTP id b188-v6so7048290wme.3
        for <linux-media@vger.kernel.org>; Wed, 04 Jul 2018 10:08:38 -0700 (PDT)
Date: Wed, 4 Jul 2018 19:08:32 +0200
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com, Jonathan Corbet <corbet@lwn.net>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v3 0/3] IOCTLs in ddbridge.
Message-ID: <20180704190832.17141b60@lt530>
In-Reply-To: <20180704130831.1073f094@coco.lan>
References: <20180512112432.30887-1-d.scheller.oss@gmail.com>
        <20180704130831.1073f094@coco.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am Wed, 4 Jul 2018 13:08:31 -0300
schrieb Mauro Carvalho Chehab <mchehab+samsung@kernel.org>:

> Em Sat, 12 May 2018 13:24:29 +0200
> Daniel Scheller <d.scheller.oss@gmail.com> escreveu:
> 
> > From: Daniel Scheller <d.scheller@gmx.net>
> > 
> > Third iteration of the IOCTL patches for ddbridge, split into multiple
> > patches:
> > 
> > Patch 1 just adds the reservation/information of the used IOCTLs into
> > ioctl-numbers.txt in the Docs dir. Doc, s390 and LKML are Cc'ed on
> > this patch.  
> 
> Patch looks ok, although it would be great to get some acks there.
> I don't know who currently maintains Documentation/ioctl/ioctl-number.txt.
> 
> Just in case, I would explicitly c/c LKML, Andrew Morton and Jonathan Corbet.
> Please c/c them [...]

I did in patch 1 explicitly asking esp. the s390 guys since they're on
0xDD too but at a lower range, no response in two months, from anyone.

> on a next respin. [...] What I miss here is a forth patch to Documentation/media/dvb-drivers/,
> adding a documentation for ddbridge, in special explaining those new
> ioctls.

If you're fine with anything else in this series, please be so kind and
pick this stuff up and I'll shove such doc up afterwards as a separate
patch. This whole thing is being posted for over a year now, I waited
another two months, and I'm not interested in waiting for another such
long time (or even more) regarding this (remember I even asked for
review for the 4.18 merge window).

Best regards,
Daniel Scheller
-- 
https://github.com/herrnst
