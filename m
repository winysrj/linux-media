Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:42158 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964892AbbHKODV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Aug 2015 10:03:21 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Junghak Sung <jh1009.sung@samsung.com>,
	linux-media@vger.kernel.org, mchehab@osg.samsung.com,
	sakari.ailus@iki.fi, pawel@osciak.com, inki.dae@samsung.com,
	sw0312.kim@samsung.com, nenggun.kim@samsung.com,
	sangbae90.lee@samsung.com, rany.kwon@samsung.com
Subject: Re: [RFC PATCH v2 4/5] media: videobuf2: Define vb2_buf_type and vb2_memory
Date: Tue, 11 Aug 2015 17:04:14 +0300
Message-ID: <1984978.8NWP8Sj4WI@avalon>
In-Reply-To: <55C9FFC7.8030308@xs4all.nl>
References: <1438332277-6542-1-git-send-email-jh1009.sung@samsung.com> <30625903.5XtBkRR4hc@avalon> <55C9FFC7.8030308@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Tuesday 11 August 2015 15:59:35 Hans Verkuil wrote:
> On 08/11/15 15:56, Laurent Pinchart wrote:
> > Hijacking this e-mail thread a bit, would it make sense for the new
> > vb2-core to support different memory allocation for different planes ?
> > I'm foreseeing use cases for buffers that bundle image data with
> > meta-data, where image data should be captured to a dma-buf imported
> > buffer, but meta-data doesn't need to be shared. In that case it wouldn't
> > be easy for userspace to find a dma-buf provider for the meta-data
> > buffers in order to import all planes. Being able to use dma-buf import
> > for the image plane(s) and mmap for the meta-data plane would be easier.
> 
> Yes, that would make sense, but I'd postpone that until someone actually
> needs it.

I might need it soon. Looks like my cunning plan to let someone else implement 
it failed ;-)

> The biggest hurdle would be how to adapt the V4L2 API to this, and not the
> actual vb2 core code.

Changes will be needed in both, but I agree that in-kernel changes should be 
less of a hassle.

-- 
Regards,

Laurent Pinchart

