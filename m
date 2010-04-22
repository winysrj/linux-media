Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:44680 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752972Ab0DVJ1Z (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Apr 2010 05:27:25 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Pawel Osciak <p.osciak@samsung.com>
Subject: Re: [PATCH] v4l: videobuf: qbuf now uses relevant v4l2_buffer fields for OUTPUT types
Date: Thu, 22 Apr 2010 11:29:10 +0200
Cc: linux-media@vger.kernel.org,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	kyungmin.park@samsung.com
References: <1271843067-23496-1-git-send-email-p.osciak@samsung.com> <201004221114.41737.laurent.pinchart@ideasonboard.com> <001501cae1fd$a9d2f230$fd78d690$%osciak@samsung.com>
In-Reply-To: <001501cae1fd$a9d2f230$fd78d690$%osciak@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201004221129.11164.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Pawel,

On Thursday 22 April 2010 11:24:52 Pawel Osciak wrote:
> >Laurent Pinchart <laurent.pinchart@ideasonboard.com> wrote:
> >> According to the V4L2 specification, applications set bytesused, field
> >> and timestamp fields of struct v4l2_buffer when the buffer is intended
> >> for output and memory type is MMAP. This adds proper copying of those
> >> values to videobuf_buffer so drivers can use them.
> >
> >Why only for the MMAP memory type ? Don't drivers need the information for
> >USERPTR buffers as well ?
> 
> It is only mentioned for the MMAP memory type:
> http://linuxtv.org/downloads/video4linux/API/V4L2_API/spec-single/v4l2.html
> #vidioc-qbuf although it would make sense to do this for USERPTR as well.
> Maybe I am trying too hard to stay 100% faithful to the documentation, I
> guess it should be corrected as well then?

This wouldn't be the first time the spec is wrong :-) I'd like other people's 
opinion on this, but I think we should fix the spec and copy the values for 
both MMAP and USERPTR.

-- 
Regards,

Laurent Pinchart
