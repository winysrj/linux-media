Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f47.google.com ([74.125.82.47]:49241 "EHLO
        mail-wm0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753181AbdJPSJq (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 16 Oct 2017 14:09:46 -0400
Received: by mail-wm0-f47.google.com with SMTP id b189so5622002wmd.4
        for <linux-media@vger.kernel.org>; Mon, 16 Oct 2017 11:09:45 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <ee79d4b3-49c8-24b1-2bfa-05e8322a88e5@samsung.com>
References: <CGME20171012004917epcas5p3c1bdb44fd2af15ec38be5de72239f844@epcas5p3.samsung.com>
 <CAM3PiRzaj=Vku-rBcroHzP+vMBgdYy_V+6+QBwGYypHanu=gbQ@mail.gmail.com> <ee79d4b3-49c8-24b1-2bfa-05e8322a88e5@samsung.com>
From: Shuah Khan <shuahkhan@gmail.com>
Date: Mon, 16 Oct 2017 12:09:44 -0600
Message-ID: <CAKocOONdqnrFxe_Y5PN2rDoHneV0TPtJ9Mu-=u6GwAy4vsC-BQ@mail.gmail.com>
Subject: Re: Exynos MFC issues on 4.14-rc4
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Marian Mihailescu <mihailescu2m@gmail.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Oct 16, 2017 at 7:11 AM, Marek Szyprowski
<m.szyprowski@samsung.com> wrote:
> Hi Marian,
>
> On 2017-10-12 02:49, Marian Mihailescu wrote:
>>
>> I've been testing 4.14-rc4 on Odroid-XU4, and here's a kernel
>> complaint when running:
>>
>> gst-launch-1.0 filesrc location=bunny_trailer_1080p.mov ! parsebin !
>> v4l2video4dec capture-io-mode=dmabuf ! v4l2video6convert
>> output-io-mode=dmabuf-import capture-io-mode=dmabuf ! kmssink
>>
>> http://paste.debian.net/990353/
>
>
> This is rather harmless and it happens on v4.14-rcX, because LOCKDEP has
> been enabled by default in the exynos_defconfig. For more information
> see https://lkml.org/lkml/2017/10/13/974
>
>> PS: on kernel 4.9 patched with MFC & GSC updates (almost up to date
>> with 4.14 I think) there was no "Wrong buffer/video queue type (1)"
>> message either
>
>
> I will check it and let you know if this is something we should worry about.

I am seeing this messages. It appears to be harmless. However, it
would be good to look into this. It doesn't appear to cause any
problems for capture/output.

thanks,
-- Shuah
