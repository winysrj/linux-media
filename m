Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-2.cisco.com ([144.254.224.141]:45006 "EHLO
	ams-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756126Ab2EWHoJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 May 2012 03:44:09 -0400
From: Hans Verkuil <hansverk@cisco.com>
To: Andrzej Hajda <a.hajda@samsung.com>
Subject: Re: [PATCH 0/2] s5p-mfc: added encoder support for end of stream handling
Date: Wed, 23 May 2012 09:43:19 +0200
Cc: linux-media@vger.kernel.org, hans.verkuil@cisco.com,
	m.szyprowski@samsung.com, k.debski@samsung.com
References: <1337700835-13634-1-git-send-email-a.hajda@samsung.com>
In-Reply-To: <1337700835-13634-1-git-send-email-a.hajda@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201205230943.19410.hansverk@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Andrzej!

Thanks for the patch, but I do have two questions:

On Tue 22 May 2012 17:33:53 Andrzej Hajda wrote:
> Those patches add end of stream handling for s5p-mfc encoder.
> 
> The first patch was sent already to the list as RFC, but the discussion ended
> without any decision.
> This patch adds new v4l2_buffer flag V4L2_BUF_FLAG_EOS. Below short
> description of this change.
> 
> s5p_mfc is a mem-to-mem MPEG/H263/H264 encoder and it requires that the last
> incoming frame must be processed differently, it means the information about
> the end of the stream driver should receive NOT LATER than the last
> V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE buffer. Common practice
> of sending empty buffer to indicate end-of-stream do not work in such case.
> Setting V4L2_BUF_FLAG_EOS flag for the last V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE
> buffer seems to be the most straightforward solution here.
> 
> V4L2_BUF_FLAG_EOS flag should be used by application if driver requires it

How will the application know that?

> and it should be set only on V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE buffers.

Why only for this type?

Regards,

	Hans

> 
> The second patch implements end-of-stream handling in s5p-mfc.
> 
> Comments are welcome
> Andrzej Hajda
> 
