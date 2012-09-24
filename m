Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:41817 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755828Ab2IXQvo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 24 Sep 2012 12:51:44 -0400
Received: from eusync2.samsung.com (mailout4.w1.samsung.com [210.118.77.14])
 by mailout4.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MAV0074W5J54G60@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 24 Sep 2012 17:52:17 +0100 (BST)
Received: from [106.116.147.32] by eusync2.samsung.com
 (Oracle Communications Messaging Server 7u4-23.01(7.0.4.23.0) 64bit (built Aug
 10 2011)) with ESMTPA id <0MAV008TE5I5M220@eusync2.samsung.com> for
 linux-media@vger.kernel.org; Mon, 24 Sep 2012 17:51:42 +0100 (BST)
Message-id: <50608F9D.40304@samsung.com>
Date: Mon, 24 Sep 2012 18:51:41 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org, a.hajda@samsung.com,
	laurent.pinchart@ideasonboard.com, hverkuil@xs4all.nl,
	kyungmin.park@samsung.com, sw0312.kim@samsung.com
Subject: Re: [PATCH RFC] V4L: Add s_rx_buffer subdev video operation
References: <1348493213-32278-1-git-send-email-s.nawrocki@samsung.com>
 <20120924134453.GH12025@valkosipuli.retiisi.org.uk>
In-reply-to: <20120924134453.GH12025@valkosipuli.retiisi.org.uk>
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On 09/24/2012 03:44 PM, Sakari Ailus wrote:
> How about useing a separate video buffer queue for the purpose? That would
> provide a nice way to pass it to the user space where it's needed. It'd also
> play nicely together with the frame layout descriptors.

It's tempting, but doing frame synchronisation in user space in this case
would have been painful, if at all possible in reliable manner. It would 
have significantly complicate applications and the drivers.

VIDIOC_STREAMON, VIDIOC_QBUF/DQBUF calls would have been at least roughly
synchronized, and applications would have to know somehow which video nodes
needs to be opened together. I guess things like that could be abstracted
in a library, but what do we really gain for such effort ?
And now I can just ask kernel for 2-planar buffers where everything is in
place..


Regards,
Sylwester
