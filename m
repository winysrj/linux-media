Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:58512 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390487AbeHPN0M (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 16 Aug 2018 09:26:12 -0400
Date: Thu, 16 Aug 2018 07:28:25 -0300
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org,
        Alexandre Courbot <acourbot@chromium.org>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCHv18 01/35] Documentation: v4l: document request API
Message-ID: <20180816072825.274c9654@coco.lan>
In-Reply-To: <2eb63571-dd07-b00e-4e42-38fc2f42530b@xs4all.nl>
References: <20180814142047.93856-1-hverkuil@xs4all.nl>
        <20180814142047.93856-2-hverkuil@xs4all.nl>
        <2183957.pVXMYXPWuc@avalon>
        <2eb63571-dd07-b00e-4e42-38fc2f42530b@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 16 Aug 2018 11:58:09 +0200
Hans Verkuil <hverkuil@xs4all.nl> escreveu:
  
> >> This is set by the user when
> >> calling
> >> +	:ref:`ioctl VIDIOC_QBUF <VIDIOC_QBUF>` and ignored by other ioctls.  
> > 
> > Shouldn't other ioctls return an error when V4L2_BUF_FLAG_REQUEST_FD is set ?  
> 
> Should they? I'd like to know what others think.

I don't see any reason why to add an extra validation logic checking
if V4L2_BUF_FLAG_REQUEST_FD is set just to return an error.

It might make sense to ask apps to not set it on other ioctls, just in 
eventual case we might want to use this flag there (although I don't
foresee any such usage).


Thanks,
Mauro
