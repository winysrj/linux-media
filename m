Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50157 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751523AbaJFPlm (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 6 Oct 2014 11:41:42 -0400
Date: Mon, 6 Oct 2014 08:41:41 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: stable@vger.kernel.org,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] media/vb2: fix VBI/poll regression
Message-ID: <20141006154141.GE30730@kroah.com>
References: <543241DE.6090507@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <543241DE.6090507@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Oct 06, 2014 at 09:16:46AM +0200, Hans Verkuil wrote:
> This is a backport of mainline commit 58d75f4b1ce26324b4d809b18f94819843a98731
> for kernels 3.15 and 3.16. 
> 
> The recent conversion of saa7134 to vb2 uncovered a poll() bug that
> broke the teletext applications alevt and mtt. These applications
> expect that calling poll() without having called VIDIOC_STREAMON will
> cause poll() to return POLLERR. That did not happen in vb2.
> 
> This patch fixes that behavior. It also fixes what should happen when
> poll() is called when STREAMON is called but no buffers have been
> queued. In that case poll() will also return POLLERR.
> 
> This brings the vb2 behavior in line with the old videobuf behavior.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

Thanks for all 3 backports, now applied.

greg k-h
