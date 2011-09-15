Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:23216 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755388Ab1IOItN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 15 Sep 2011 04:49:13 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=ISO-8859-1
Received: from euspt2 ([210.118.77.14]) by mailout4.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0LRK008VU35ZNT00@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 15 Sep 2011 09:49:11 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LRK004OX35ZZR@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 15 Sep 2011 09:49:11 +0100 (BST)
Date: Thu, 15 Sep 2011 10:49:10 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [PATCH 4/4] v4l2: add blackfin capture bridge driver
In-reply-to: <CAHG8p1AM9HxRSfEOEc8_cuvSkRO8LvUw0DCAfcK+_SHD8yr=cg@mail.gmail.com>
To: Scott Jiang <scott.jiang.linux@gmail.com>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	uclinux-dist-devel@blackfin.uclinux.org
Message-id: <4E71BC06.5020401@samsung.com>
References: <1315938892-20243-1-git-send-email-scott.jiang.linux@gmail.com>
 <1315938892-20243-4-git-send-email-scott.jiang.linux@gmail.com>
 <Pine.LNX.4.64.1109130943021.17902@axis700.grange>
 <CAHG8p1AM9HxRSfEOEc8_cuvSkRO8LvUw0DCAfcK+_SHD8yr=cg@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/15/2011 08:37 AM, Scott Jiang wrote:
>>
>>> +
>>> +#define CAPTURE_DRV_NAME        "bfin_capture"
>>> +#define BCAP_MIN_NUM_BUF        2
>>> +
>>> +struct bcap_format {
>>> +     u8 *desc;
>>> +     u32 pixelformat;
>>> +     enum v4l2_mbus_pixelcode mbus_code;
>>> +     int bpp; /* bytes per pixel */
>>
>> Don't you think you might have to process 12 bpp formats at some point,
>> like YUV 4:2:0, or NV12? Maybe better calculate in bits from the beginning?
>>
> I have a question here. How to calculate bytesperline for planar format?
> According to v4l2 specification  width, height and bytesperline apply
> to largest plane.
> Does it mean bytesperline equal to Y plane distance between two line?

For planar formats - I think so.

> And so you can't use bytesperline x height to calculate sizeimage?

No, you can't. Please see this thread:
http://www.mail-archive.com/linux-media@vger.kernel.org/msg28957.html


Regards,
-- 
Sylwester Nawrocki
Samsung Poland R&D Center
