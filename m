Return-path: <mchehab@pedra>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:45958 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757582Ab0JWP2B convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 23 Oct 2010 11:28:01 -0400
Received: by wyf28 with SMTP id 28so1907993wyf.19
        for <linux-media@vger.kernel.org>; Sat, 23 Oct 2010 08:27:59 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4CC25F60.7050106@redhat.com>
References: <4CC25F60.7050106@redhat.com>
From: Pawel Osciak <pawel@osciak.com>
Date: Sat, 23 Oct 2010 08:27:37 -0700
Message-ID: <AANLkTik-QN5wkgvAkmR-yDT9-pLqceAScoYCgRsA3Z9J@mail.gmail.com>
Subject: Re: V4L/DVB/IR patches pending merge
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: LMML <linux-media@vger.kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	kyungmin.park@samsung.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Mauro,

2010/10/22 Mauro Carvalho Chehab <mchehab@redhat.com>:
> This is the list of patches that weren't applied yet. I've made a big effort starting
> last weekend to handle everything I could. All pull requests were addressed. There are still
> 43 patches on my queue.
>
> Please help me to clean the list.

>                == Videobuf2 series ==
>
> Oct,20 2010: [7/7] v4l: videobuf2: add CMA allocator                                http://patchwork.kernel.org/patch/267521  Pawel Osciak <p.osciak@samsung.com>
> Oct,20 2010: [2/7] v4l: videobuf2: add generic memory handling routines             http://patchwork.kernel.org/patch/267531  Pawel Osciak <p.osciak@samsung.com>
> Oct,20 2010: [4/7] v4l: videobuf2: add DMA coherent allocator                       http://patchwork.kernel.org/patch/267541  Pawel Osciak <p.osciak@samsung.com>
> Oct,20 2010: [6/7] v4l: vivi: port to videobuf2                                     http://patchwork.kernel.org/patch/267551  Pawel Osciak <p.osciak@samsung.com>
> Oct,20 2010: [1/7] v4l: add videobuf2 Video for Linux 2 driver framework            http://patchwork.kernel.org/patch/267561  Pawel Osciak <p.osciak@samsung.com>
> Oct,20 2010: [3/7] v4l: videobuf2: add vmalloc allocator                            http://patchwork.kernel.org/patch/267571  Pawel Osciak <p.osciak@samsung.com>
> Oct,20 2010: [5/7] v4l: videobuf2: add read() emulator                              http://patchwork.kernel.org/patch/267581  Marek Szyprowski <m.szyprowski@samsung.com>
> Oct,13 2010: [1/4] MFC: Changes in include/linux/videodev2.h for MFC 5.1 codec      http://patchwork.kernel.org/patch/250371  Kamil Debski <k.debski@samsung.com>
> Oct,13 2010: [2/4] MFC: Add MFC 5.1 driver to plat-s5p                              http://patchwork.kernel.org/patch/250361  Kamil Debski <k.debski@samsung.com>
> Oct,13 2010: [3/4] MFC: Add MFC 5.1 V4L2 driver                                     http://patchwork.kernel.org/patch/250411  Kamil Debski <k.debski@samsung.com>
> Oct,13 2010: [4/4] s5pc110: Enable MFC 5.1 on Goni                                  http://patchwork.kernel.org/patch/250401  Kamil Debski <k.debski@samsung.com>
>
> Laurent wants more time to review videobuf2. I agree. reviewing API changes like this require some
> time and some tests. Also, i would like to see DMA Scatter/Gather version, as it allows testing with
> more complex devices.


Videobuf2 depends on multi-planar extensions. It of course works with
the "old" non-multiplanar API, but supports both. What is the status
of those patches? I see them as RFC in patchwork.
(I've been away those last couple of weeks, but trying to catch up.)

-- 
Best regards,
Pawel Osciak
