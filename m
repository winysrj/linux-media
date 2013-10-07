Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:1410 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751734Ab3JGObY (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 7 Oct 2013 10:31:24 -0400
Message-ID: <5252C5AF.5010308@xs4all.nl>
Date: Mon, 07 Oct 2013 16:31:11 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: =?UTF-8?B?S3J6eXN6dG9mIEhhxYJhc2E=?= <khalasa@piap.pl>
CC: linux-media <linux-media@vger.kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Pawel Osciak <pawel@osciak.com>
Subject: Re: V4L2_BUF_FLAG_NO_CACHE_*
References: <m3txgt8gh3.fsf@t19.piap.pl>
In-Reply-To: <m3txgt8gh3.fsf@t19.piap.pl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10/07/2013 01:31 PM, Krzysztof Hałasa wrote:
> Hi,
> 
> found them looking for my V4L2 + mmap + MIPS solution... Is the
> following intentional? Some out-of-tree code maybe?

No, this is intentional. Too bad this was never actually implemented in any
driver. Marek, Pawel, wouldn't it be possible to add support for these flags
in vb2? That seems the right place for this.

Regards,

	Hans

> 
> $ grep V4L2_BUF_FLAG_NO_CACHE_ * -r
> 
> Documentation/DocBook/media/v4l/io.xml:     <entry><constant>V4L2_BUF_FLAG_NO_CACHE_INVALIDATE</constant></entry>
> Documentation/DocBook/media/v4l/io.xml:     <entry><constant>V4L2_BUF_FLAG_NO_CACHE_CLEAN</constant></entry>
> Documentation/DocBook/media/v4l/vidioc-prepare-buf.xml:<constant>V4L2_BUF_FLAG_NO_CACHE_INVALIDATE</constant> and
> Documentation/DocBook/media/v4l/vidioc-prepare-buf.xml:<constant>V4L2_BUF_FLAG_NO_CACHE_CLEAN</constant> flags to skip the respective
> include/uapi/linux/videodev2.h:#define V4L2_BUF_FLAG_NO_CACHE_INVALIDATE        0x0800
> include/uapi/linux/videodev2.h:#define V4L2_BUF_FLAG_NO_CACHE_CLEAN             0x1000
> 

