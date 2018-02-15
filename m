Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51818 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754851AbeBOHjh (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 15 Feb 2018 02:39:37 -0500
Date: Thu, 15 Feb 2018 08:39:38 +0100
From: Greg KH <gregkh@linuxfoundation.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: stable@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [PATCH for v4.14 00/13] v4l2-compat-ioctl32.c: remove
 set_fs(KERNEL_DS)
Message-ID: <20180215073938.GA16402@kroah.com>
References: <20180214114434.26842-1-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180214114434.26842-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Feb 14, 2018 at 12:44:21PM +0100, Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> This patch series fixes a number of bugs and culminates in the removal
> of the set_fs(KERNEL_DS) call in v4l2-compat-ioctl32.c.
> 
> This was tested with a VM running 4.14, the vivid driver (since that
> emulates almost all V4L2 ioctls that need to pass through v4l2-compat-ioctl32.c)
> and a 32-bit v4l2-compliance utility since that exercises almost all ioctls
> as well. Combined this gives good test coverage.
> 
> Most of the v4l2-compat-ioctl32.c do cleanups and fix subtle issues that
> v4l2-compliance complained about. The purpose is to 1) make it easy to
> verify that the final patch didn't introduce errors by first eliminating
> errors caused by other bugs, and 2) keep the final patch at least somewhat
> readable.

All now queued up, thanks.

greg k-h
