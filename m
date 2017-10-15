Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.anw.at ([195.234.101.228]:60361 "EHLO mail.anw.at"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750924AbdJONLB (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 15 Oct 2017 09:11:01 -0400
Subject: Re: [PATCH] build: Fixed patches partly for Kernel 2.6.32
To: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Cc: d.scheller@gmx.net
References: <1507938731-23816-1-git-send-email-jasmin@anw.at>
 <fd99fe5a-81a8-8c6b-20c7-7c4b277432fa@anw.at>
 <8435b63d-bded-2a5b-ab94-c8d4369973c1@xs4all.nl>
From: "Jasmin J." <jasmin@anw.at>
Message-ID: <97fd54e7-6c74-f825-7451-91a176004d03@anw.at>
Date: Sun, 15 Oct 2017 15:10:57 +0200
MIME-Version: 1.0
In-Reply-To: <8435b63d-bded-2a5b-ab94-c8d4369973c1@xs4all.nl>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Hans!

> Do you need build support for kernels < 2.6.36?
I don't, but I have the headers laying around on my disk and I simply tried to
fix the build ;)

> I gave up supporting such old kernels 2 or 3 years ago.
It seems so. I just learned, that RHEL 6.x does still use 2.6.32.
But there is RHEL 7 out since 3 years now and they use 3.10, so there is no
real need to support this Kernel version.
But I personally want to support back to 2.6.36, because this is also the last
Version which is supported by Digitial Devices with their drivers. And my
media-build DKMS should compile back to the same version.

> I'm holding off on merging this patch and the 2.6.35 patch until I
> have a better idea of why you want to support those kernels.
The patch for 2.6.35 could be applied without any problems and should also
work. It is not much effort to merge it, I guess.

> The other patches I just merged.
THX!

BR,
   Jasmin
