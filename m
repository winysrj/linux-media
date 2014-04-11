Return-path: <linux-media-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:37595 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754422AbaDKMsq (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Apr 2014 08:48:46 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gldv-linux-media@m.gmane.org>)
	id 1WYast-0005wj-V8
	for linux-media@vger.kernel.org; Fri, 11 Apr 2014 14:48:43 +0200
Received: from 217-67-201-162.itsa.net.pl ([217.67.201.162])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Fri, 11 Apr 2014 14:48:43 +0200
Received: from t.stanislaws by 217-67-201-162.itsa.net.pl with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Fri, 11 Apr 2014 14:48:43 +0200
To: linux-media@vger.kernel.org
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: Re: [REVIEWv2 PATCH 02/13] vb2: fix handling of data_offset and v4l2_plane.reserved[]
Date: Fri, 11 Apr 2014 14:48:30 +0200
Message-ID: <5347E49E.6020302@samsung.com>
References: <1396876272-18222-1-git-send-email-hverkuil@xs4all.nl> <1396876272-18222-3-git-send-email-hverkuil@xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: pawel@osciak.com, Hans Verkuil <hans.verkuil@cisco.com>
In-Reply-To: <1396876272-18222-3-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/07/2014 03:11 PM, Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> The videobuf2-core did not zero the 'planes' array in __qbuf_userptr()
> and __qbuf_dmabuf(). That's now memset to 0. Without this the reserved
> array in struct v4l2_plane would be non-zero, causing v4l2-compliance
> errors.
> 
> More serious is the fact that data_offset was not handled correctly:
> 
> - for capture devices it was never zeroed, which meant that it was
>   uninitialized. Unless the driver sets it it was a completely random
>   number. With the memset above this is now fixed.
> 
> - __qbuf_dmabuf had a completely incorrect length check that included
>   data_offset.

Hi Hans,

I may understand it wrongly but IMO allowing non-zero data offset
simplifies buffer sharing using dmabuf.
I remember a problem that occurred when someone wanted to use
a single dmabuf with multiplanar API.

For example, MFC shares a buffer with DRM. Assume that DRM device
forces the whole image to be located in one dmabuf.

The MFC uses multiplanar API therefore application must use
the same dmabuf to describe luma and chroma planes.

It is intuitive to use the same dmabuf for both planes and
data_offset=0 for luma plane and data_offset = luma_size
for chroma offset.

The check:

> -		if (planes[plane].length < planes[plane].data_offset +
> -		    q->plane_sizes[plane]) {

assured that the logical plane does not overflow the dmabuf.

Am I wrong?

Regards,
Tomasz Stanislawski

> 
> - in __fill_vb2_buffer in the DMABUF case the data_offset field was
>   unconditionally copied from v4l2_buffer to v4l2_plane when this
>   should only happen in the output case.
> 
> - in the single-planar case data_offset was never correctly set to 0.
>   The single-planar API doesn't support data_offset, so setting it
>   to 0 is the right thing to do. This too is now solved by the memset.
> 
> All these issues were found with v4l2-compliance.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>


