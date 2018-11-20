Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga05.intel.com ([192.55.52.43]:63558 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725950AbeKTUbb (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 20 Nov 2018 15:31:31 -0500
Date: Tue, 20 Nov 2018 12:03:10 +0200
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Ezequiel Garcia <ezequiel@collabora.com>,
        Nicolas Dufresne <nicolas@ndufresne.ca>,
        Tomasz Figa <tfiga@chromium.org>
Subject: Re: [PATCH] videodev2.h: add
 V4L2_BUF_CAP_SUPPORTS_PREPARE_BUF/CREATE_BUFS
Message-ID: <20181120100310.z5xerjvsf76qqtcd@paasikivi.fi.intel.com>
References: <68a6a7d3-cf0b-f631-f113-e388ebb7f5a4@xs4all.nl>
 <20181120092724.yfzxfjxom7ygln3p@paasikivi.fi.intel.com>
 <8711051e-df50-181f-d5e3-677d63d63465@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8711051e-df50-181f-d5e3-677d63d63465@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Nov 20, 2018 at 10:41:42AM +0100, Hans Verkuil wrote:
> On 11/20/2018 10:27 AM, Sakari Ailus wrote:
> > Hi Hans,
> > 
> > On Tue, Nov 20, 2018 at 09:58:43AM +0100, Hans Verkuil wrote:
> >> Add new buffer capability flags to indicate if the VIDIOC_PREPARE_BUF or
> >> VIDIOC_CREATE_BUFS ioctls are supported.
> > 
> > Are there practical benefits from the change for the user space?
> 
> The more important ioctl to know about is PREPARE_BUF. I noticed this when working
> on v4l2-compliance: the only way to know for an application if PREPARE_BUF exists
> is by trying it, but then you already have prepared a buffer. That's not what you
> want in the application, you need a way to know up front if prepare_buf is present
> or not without having to actually execute it.
> 
> CREATE_BUFS was added because not all drivers support it. It can be dropped since
> it is possible to test for the existence of CREATE_BUFS without actually allocating
> anything, but if I'm adding V4L2_BUF_CAP_SUPPORTS_PREPARE_BUF anyway, then it is
> trivial to add V4L2_BUF_CAP_SUPPORTS_CREATE_BUFS as well to avoid an additional
> ioctl call.
> 
> Hmm, I should have explained this in the commit log.

Please add:

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

-- 
Sakari Ailus
sakari.ailus@linux.intel.com
