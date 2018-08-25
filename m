Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:48886 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726555AbeHYQhQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 25 Aug 2018 12:37:16 -0400
Date: Sat, 25 Aug 2018 15:58:21 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCHv18 22/35] videodev2.h: Add request_fd field to v4l2_buffer
Message-ID: <20180825125820.w3myq267rwtmaivg@valkosipuli.retiisi.org.uk>
References: <20180814142047.93856-1-hverkuil@xs4all.nl>
 <20180814142047.93856-23-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180814142047.93856-23-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Aug 14, 2018 at 04:20:34PM +0200, Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> When queuing buffers allow for passing the request that should
> be associated with this buffer.
> 
> If V4L2_BUF_FLAG_REQUEST_FD is set, then request_fd is used as
> the file descriptor.
> 
> If a buffer is stored in a request, but not yet queued to the
> driver, then V4L2_BUF_FLAG_IN_REQUEST is set.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> Reviewed-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
