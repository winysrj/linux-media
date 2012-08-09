Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:2887 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752310Ab2HINT0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 9 Aug 2012 09:19:26 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Richard Zhao <richard.zhao@freescale.com>
Subject: Re: __video_register_device: warning cannot be reached if warn_if_nr_in_use
Date: Thu, 9 Aug 2012 15:19:19 +0200
Cc: linux-media@vger.kernel.org
References: <20120809125501.GD3824@b20223-02.ap.freescale.net>
In-Reply-To: <20120809125501.GD3824@b20223-02.ap.freescale.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201208091519.19254.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu August 9 2012 14:55:02 Richard Zhao wrote:
> In file drivers/media/video/v4l2-dev.c
> 
> int __video_register_device(struct video_device *vdev, int type, int nr,
> 		int warn_if_nr_in_use, struct module *owner)
> {
> [...]
> 	vdev->minor = i + minor_offset;
> 878:	vdev->num = nr;
> 
> vdev->num is set to nr here. 
> [...]
> 	if (nr != -1 && nr != vdev->num && warn_if_nr_in_use)
> 		printk(KERN_WARNING "%s: requested %s%d, got %s\n", __func__,
> 			name_base, nr, video_device_node_name(vdev));
> 
> so nr != vdev->num is always false. The warning can never be printed.

Hmm, true. The question is, should we just fix this, or drop the warning altogether?
Clearly nobody missed that warning.

I'm inclined to drop the warning altogether and so also the video_register_device_no_warn
inline function.

What do others think?

	Hans
