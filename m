Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:63468 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933094Ab3EGOEO (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 7 May 2013 10:04:14 -0400
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout2.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MMF00HAZLOVBA00@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 07 May 2013 15:04:11 +0100 (BST)
Message-id: <518909DA.8000407@samsung.com>
Date: Tue, 07 May 2013 16:04:10 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media <linux-media@vger.kernel.org>,
	Volokh Konstantin <volokh84@gmail.com>,
	Pete Eberlein <pete@sensoray.com>,
	Ismael Luceno <ismael.luceno@corp.bluecherry.net>,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	Kamil Debski <k.debski@samsung.com>, sakari.ailus@iki.fi
Subject: Re: [RFC] Motion Detection API
References: <201304121736.16542.hverkuil@xs4all.nl>
 <201305061541.41204.hverkuil@xs4all.nl> <2428502.07isB1rKTR@avalon>
 <201305071435.30062.hverkuil@xs4all.nl>
In-reply-to: <201305071435.30062.hverkuil@xs4all.nl>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/07/2013 02:35 PM, Hans Verkuil wrote:
> A metadata plane works well if you have substantial amounts of data (e.g. histogram
> data) but it has the disadvantage of requiring you to use the MPLANE buffer types,
> something which standard apps do not support. I definitely think that is overkill
> for things like this.

Standard application could use the MPLANE interface through the libv4l-mplane
plugin [1]. And meta-data plane could be handled in libv4l, passed in raw form 
from the kernel.

There can be substantial amount of meta-data per frame and we were considering
e.g. creating separate buffer queue for meta-data, to be able to use mmaped 
buffer at user space, rather than parsing and copying data multiple times in 
the kernel until it gets into user space and is further processed there.

I'm actually not sure if performance is a real issue here, were are talking
of 1.5 KiB order amounts of data per frame. Likely on x86 desktop machines
it is not a big deal, for ARM embedded platforms we would need to do some
profiling.

I'm not sure myself yet how much such motion/object detection data should be 
interpreted in the kernel, rather than in user space. I suspect some generic
API like in your $subject RFC makes sense, it would cover as many cases as 
possible. But I was wondering how much it makes sense to design a sort of 
raw interface/buffer queue (similar to raw sockets concept), that would allow
user space libraries to parse meta-data.

The format of meta-data could for example have changed after switching to
a new version of device's firmware. It might be rare, I'm just trying to say 
I would like to avoid designing a kernel interface that might soon become a 
limitation.

Besides, I have been thinking of allowing application/libs to request an
additional meta-data plane, which would be driver-specific. For instance
it turns the Samsung S5C73M3 camera can send meta-data for YUV formats
as well as for interleaved JPEG/YUV.

[1] http://git.linuxtv.org/v4l-utils.git/commit/ced1be346fe4f61c864cba9d81f66089d4e32a56

Regards,
Sylwester
