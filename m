Return-path: <linux-media-owner@vger.kernel.org>
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:44756 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753438Ab2AEQya (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 5 Jan 2012 11:54:30 -0500
Received: from compute3.internal (compute3.nyi.mail.srv.osa [10.202.2.43])
	by gateway1.nyi.mail.srv.osa (Postfix) with ESMTP id E608620F01
	for <linux-media@vger.kernel.org>; Thu,  5 Jan 2012 11:54:29 -0500 (EST)
Date: Thu, 5 Jan 2012 08:43:58 -0800
From: Greg KH <greg@kroah.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	kernel-janitors@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [patch -longterm v2] V4L/DVB: v4l2-ioctl: integer overflow in
 video_usercopy()
Message-ID: <20120105164358.GA26153@kroah.com>
References: <20111215063445.GA2424@elgon.mountain>
 <4EE9BC25.7020303@infradead.org>
 <201112151033.35153.hverkuil@xs4all.nl>
 <4EE9C2E6.1060304@infradead.org>
 <20120103205539.GC17131@kroah.com>
 <20120105062822.GB10230@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120105062822.GB10230@mwanda>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Jan 05, 2012 at 09:28:22AM +0300, Dan Carpenter wrote:
> If p->count is too high the multiplication could overflow and
> array_size would be lower than expected.  Mauro and Hans Verkuil
> suggested that we cap it at 1024.  That comes from the maximum
> number of controls with lots of room for expantion.
> 
> $ grep V4L2_CID include/linux/videodev2.h | wc -l
> 211
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

So this patch is only for 2.6.32?  But the original needs to get into
Linus's tree first (which is what I'm guessing the other patch you sent
is, right?)

thanks,

greg k-h
