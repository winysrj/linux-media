Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f46.google.com ([209.85.215.46]:50770 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751705Ab2JKJKw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Oct 2012 05:10:52 -0400
Received: by mail-la0-f46.google.com with SMTP id h6so1053398lag.19
        for <linux-media@vger.kernel.org>; Thu, 11 Oct 2012 02:10:51 -0700 (PDT)
Message-ID: <50768D18.3060500@gmail.com>
Date: Thu, 11 Oct 2012 11:10:48 +0200
From: Maarten Lankhorst <m.b.lankhorst@gmail.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Dave Airlie <airlied@gmail.com>,
	Robert Morell <rmorell@nvidia.com>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>,
	linaro-mm-sig@lists.linaro.org, rob@ti.com,
	Sumit Semwal <sumit.semwal@linaro.org>,
	dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org
Subject: Re: [PATCH] dma-buf: Use EXPORT_SYMBOL
References: <1349884592-32485-1-git-send-email-rmorell@nvidia.com> <20121010221119.6a623417@redhat.com> <201210110920.12560.hverkuil@xs4all.nl> <201210110951.23059.hverkuil@xs4all.nl>
In-Reply-To: <201210110951.23059.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Op 11-10-12 09:51, Hans Verkuil schreef:
>>> my understaning is
>>> that the drivers/media/ authors should also ack with this licensing
>>> (possible) change. I am one of the main contributors there. Alan also has 
>>> copyrights there, and at other parts of the Linux Kernel, including the driver's
>>> core, from where all Linux Kernel drivers are derivative work, including this one.
>>>
>>> As Alan well said, many other core Linux Kernel authors very likely share 
>>> this point of view.
>>>
>>> So, developers implicitly or explicitly copied in this thread that might be
>>> considering the usage of dmabuf on proprietary drivers should consider
>>> this email as a formal notification of my viewpoint: e. g. that I consider
>>> any attempt of using DMABUF or media core/drivers together with proprietary
>>> Kernelspace code as a possible GPL infringement.
>> As long as dmabuf uses EXPORT_SYMBOL_GPL that is definitely correct. Does your
>> statement also hold if dmabuf would use EXPORT_SYMBOL? (Just asking)
>>
>> BTW, we should consider changing the control framework API to EXPORT_SYMBOL_GPL.
>> The number of contributors to v4l2-ctrls.c is very limited, and I have no
>> problem moving that to GPL. For me dmabuf is the rare exception where I prefer
>> EXPORT_SYMBOL to prevent the worse evil of forcing vendors to create incompatible
>> APIs. It's a sad but true that many GPU drivers are still closed source,
>> particularly in the embedded world for which dmabuf was primarily designed.
> One thing I am also worried about is that if vendors can't use dmabuf for their
> closed-source GPU driver, then they may not bother making GPL V4L drivers and
> instead stick to a proprietary solution (e.g. OpenMAX), Which would be a shame
> since we are making good progress with convincing vendors (esp. SoC vendors) to
> create GPL V4L2 drivers for their hardware.
Powervr is probably the most well known and I knwo of at least one BSD/GPL driver,
iirc tegra does similar so it should be possible to do similar for their x86 counterparts.
They can still do whatever they want in userspace and are not required to disclose
source for their super secret opengl/cuda/vdpau sauce, cf COPYING.

Usual disclaimer applies, I'm not a lawyer, and speaking for myself here.

~Maarten

