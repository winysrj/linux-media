Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:35404 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751030AbaJIWIR (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 9 Oct 2014 18:08:17 -0400
Date: Thu, 9 Oct 2014 17:08:16 -0500
From: Benoit Parrot <bparrot@ti.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: <linux-media@vger.kernel.org>
Subject: Re: v4l2-compliance revision vs Kernel version
Message-ID: <20141009220816.GG973@ti.com>
References: <20141009214536.GF973@ti.com>
 <54370615.9030107@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <54370615.9030107@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Hans Verkuil <hverkuil@xs4all.nl> wrote on Fri [2014-Oct-10 00:03:01 +0200]:
> Hi Benoit,
> 
> On 10/09/2014 11:45 PM, Benoit Parrot wrote:
> >Hi,
> >
> >Can someone point me toward a mapping of v4l2-compliance release vs kernel version?
> 
> There isn't any. It's trial and error, I'm afraid. The primary use-case of v4l2-compliance is
> testing drivers in the bleeding-edge media_tree.git repo.

Thanks for the quick reply.
I had a feeling that was going to be the case, but had to check.
> 
> >
> >I am currently working with a 3.14 kernel and would like to find the matching v4l2-compliance version.
> >I am  using git://linuxtv.org/v4l-utils.git commit id:
> >3719cef libdvbv5: reimplement the logic that gets a full section
> >
> >But on 3.14 running that version against vivi.ko shows a few failures and a bunch of "Not Supported".
> 
> "Not Supported" is not an error. It just means that the driver doesn't support that ioctl, so
> no compliance tests for that ioctl are done.

Yeah I know but i am getting those even for simple stuff like:

Buffer ioctls:
	test VIDIOC_REQBUFS/CREATE_BUFS/QUERYBUF: OK
	test VIDIOC_EXPBUF: OK (Not Supported)
	test read/write: OK
	test MMAP: OK (Not Supported)
	test USERPTR: OK (Not Supported)
	test DMABUF: OK (Not Supported)

 
Regards,
Benoit
