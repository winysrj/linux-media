Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:44966 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751376AbdJPNLu (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 16 Oct 2017 09:11:50 -0400
Subject: Re: Exynos MFC issues on 4.14-rc4
To: Marian Mihailescu <mihailescu2m@gmail.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Marek Szyprowski <m.szyprowski@samsung.com>
Message-id: <ee79d4b3-49c8-24b1-2bfa-05e8322a88e5@samsung.com>
Date: Mon, 16 Oct 2017 15:11:46 +0200
MIME-version: 1.0
In-reply-to: <CAM3PiRzaj=Vku-rBcroHzP+vMBgdYy_V+6+QBwGYypHanu=gbQ@mail.gmail.com>
Content-type: text/plain; charset="utf-8"; format="flowed"
Content-transfer-encoding: 7bit
Content-language: en-US
References: <CGME20171012004917epcas5p3c1bdb44fd2af15ec38be5de72239f844@epcas5p3.samsung.com>
        <CAM3PiRzaj=Vku-rBcroHzP+vMBgdYy_V+6+QBwGYypHanu=gbQ@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Marian,

On 2017-10-12 02:49, Marian Mihailescu wrote:
> I've been testing 4.14-rc4 on Odroid-XU4, and here's a kernel
> complaint when running:
>
> gst-launch-1.0 filesrc location=bunny_trailer_1080p.mov ! parsebin !
> v4l2video4dec capture-io-mode=dmabuf ! v4l2video6convert
> output-io-mode=dmabuf-import capture-io-mode=dmabuf ! kmssink
>
> http://paste.debian.net/990353/

This is rather harmless and it happens on v4.14-rcX, because LOCKDEP has
been enabled by default in the exynos_defconfig. For more information
see https://lkml.org/lkml/2017/10/13/974

> PS: on kernel 4.9 patched with MFC & GSC updates (almost up to date
> with 4.14 I think) there was no "Wrong buffer/video queue type (1)"
> message either

I will check it and let you know if this is something we should worry about.

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland
