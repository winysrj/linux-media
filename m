Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:56485 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750891AbdBDQoF (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 4 Feb 2017 11:44:05 -0500
Subject: Re: Bug#854100: libdvbv5-0: fails to tune / scan
To: Gregor Jasny <gjasny@googlemail.com>
References: <148617570740.6827.6324247760769667383.reportbug@ixtlilton.netz.invalid>
 <0db3f8d1-0461-5d82-a92d-ecc3cfcfec71@googlemail.com>
 <8792984d-54c9-01a8-0f84-7a1f0312a12f@gmx.de>
 <CAJxGH0-ewWzxSJ1vE+n4FMkqv+pnmT9G0uAZS5oUYkhxWm+=5A@mail.gmail.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        mchehab@osg.samsung.com
From: Marcel Heinz <quisquilia@gmx.de>
Message-ID: <ba755934-7946-59ea-e900-fe76d4ea2f0a@gmx.de>
Date: Sat, 4 Feb 2017 17:43:54 +0100
MIME-Version: 1.0
In-Reply-To: <CAJxGH0-ewWzxSJ1vE+n4FMkqv+pnmT9G0uAZS5oUYkhxWm+=5A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Am 04.02.2017 um 15:57 schrieb Gregor Jasny:
> Thanks for sharing! Maybe you could try to bisect to find the breaking
> commit?

OK, I ended up with

d982b0d03b1f929269104bb716c9d4b50c945125 is the first bad commit
commit d982b0d03b1f929269104bb716c9d4b50c945125
Author: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Date:   Tue Dec 13 16:43:28 2016 -0200

    dvb-sat: change the LNBf logic to make it more generic

    There are some new LNBf models with more than two frequency
    ranges. Change the logic there to allow adding those new
    LNBf types.

    Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>

:040000 040000 5c0591da94959207f4b1573a40383b8143d12278
34df9c19cb42119706fce20dec00d18552ddf058 M      lib


This looks very related to the frequency range error I got from the kernel:

> | [42607.855196] b2c2_flexcop_pci 0000:09:00.0: DVB: adapter 0 frontend
> 0 frequency 12551500 out of range (950000..2150000)
> 
> This frequency range doesn't look like DVB-S at all...


Regards,
  Marcel
