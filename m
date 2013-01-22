Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:60065 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752758Ab3AVKhx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Jan 2013 05:37:53 -0500
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout3.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MH00053XW5GHG30@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 22 Jan 2013 10:37:51 +0000 (GMT)
Received: from [106.116.147.32] by eusync4.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTPA id <0MH000KPQW72JH30@eusync4.samsung.com> for
 linux-media@vger.kernel.org; Tue, 22 Jan 2013 10:37:51 +0000 (GMT)
Message-id: <50FE6BFB.3090102@samsung.com>
Date: Tue, 22 Jan 2013 11:37:47 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Kamil Debski <k.debski@samsung.com>
Cc: 'Sakari Ailus' <sakari.ailus@iki.fi>, linux-media@vger.kernel.org,
	arun.kk@samsung.com, mchehab@redhat.com,
	laurent.pinchart@ideasonboard.com, hans.verkuil@cisco.com,
	kyungmin.park@samsung.com
Subject: Re: [PATCH 3/3] v4l: Set proper timestamp type in selected drivers
 which use videobuf2
References: <1358156164-11382-1-git-send-email-k.debski@samsung.com>
 <1358156164-11382-4-git-send-email-k.debski@samsung.com>
 <20130119174329.GL13641@valkosipuli.retiisi.org.uk>
 <029c01cdf7e0$b64ce4c0$22e6ae40$%debski@samsung.com>
In-reply-to: <029c01cdf7e0$b64ce4c0$22e6ae40$%debski@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 01/21/2013 03:07 PM, Kamil Debski wrote:
>> How about making MONOTONIC timestamps default instead, or at least
>> assigning all drivers something else than UNKNOWN?
> 
> So why did you add the UNKNOWN flag?
> 
> The way I see it - UNKNOWN is the default and the one who coded the driver
> will set it to either MONOTONIC or COPY if it is one of these two. It won't
> be changed otherwise. There are drivers, which do not fill the timestamp
> field
> at all:
> - drivers/media/platform/coda.c
> - drivers/media/platform/exynos-gsc/gsc-m2m.c

Hmm, there is already a patch queued for this driver. It was intended
for v3.8 but has been delayed to 3.9.

http://git.linuxtv.org/media_tree.git/commitdiff/f60e160e126bdd8f0d928cd8b3fce54659597394

> - drivers/media/platform/m2m-deinterlace.c
> - drivers/media/platform/mx2_emmaprp.c
> - drivers/media/platform/s5p-fimc/fimc-m2m.c
> - drivers/media/platform/s5p-g2d.c
> - drivers/media/platform/s5p-jpeg/jpeg-core.c
>  
> The way you did it in your patches left no room for any kind of choice. I
> did
> comment at least twice about mem-2-mem devices in your RFCs, if I remember
> correctly. I think Sylwester was also writing about this. 
> Still everything got marked as MONOTONIC. 
> 
> If we were to assume that there were no other timestamp types then monotonic
> (which is not true, but this was your assumption), then what was the reason
> to add this timestamp framework?

Hmm, we could likely leave MONOTONIC as the default timestamp type. It
doesn't really matter what is the default, as long as drivers are provided
with an API to override it.

The reason why the above drivers don't do anything with v4l2_buffer::timestamp
field is there is no clear definitions at the specification for mem-to-mem
devices. We are working here on a Video Memory-to-memory Interface DocBook
documentation.

I think we will need a way to tell user space that timestamps are copied
from OUTPUT to CAPTURE buffer queue. At least that's what seems more
useful for applications. i.e. copying timestamps, rather than filling them
with the monotonic clock value.

OTOH I'm not certain what's the main purpose of such copied timestamps, is
it to identify which CAPTURE buffer comes from which OUTPUT buffer ?

--

Regards,
Sylwester
