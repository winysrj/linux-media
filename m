Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:52412 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728931AbeKOVsR (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 15 Nov 2018 16:48:17 -0500
Date: Thu, 15 Nov 2018 13:40:45 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Tomasz Figa <tfiga@chromium.org>,
        Nicolas Dufresne <nicolas@ndufresne.ca>
Subject: Re: [PATCH v3] media: vb2: Allow reqbufs(0) with "in use" MMAP
 buffers
Message-ID: <20181115114045.rhnazegufyeppxlq@valkosipuli.retiisi.org.uk>
References: <20181114150449.23487-1-p.zabel@pengutronix.de>
 <7953197.5dbdkFljzD@avalon>
 <c64434d8-8f51-e67a-0883-e052a6599622@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c64434d8-8f51-e67a-0883-e052a6599622@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Nov 15, 2018 at 11:29:35AM +0100, Hans Verkuil wrote:
> On 11/14/18 20:59, Laurent Pinchart wrote:
> > Hi Philipp,
> > 
> > Thank you for the patch.
> > 
> > On Wednesday, 14 November 2018 17:04:49 EET Philipp Zabel wrote:
> >> From: John Sheu <sheu@chromium.org>
> >>
> >> Videobuf2 presently does not allow VIDIOC_REQBUFS to destroy outstanding
> >> buffers if the queue is of type V4L2_MEMORY_MMAP, and if the buffers are
> >> considered "in use".  This is different behavior than for other memory
> >> types and prevents us from deallocating buffers in following two cases:
> >>
> >> 1) There are outstanding mmap()ed views on the buffer. However even if
> >>    we put the buffer in reqbufs(0), there will be remaining references,
> >>    due to vma .open/close() adjusting vb2 buffer refcount appropriately.
> >>    This means that the buffer will be in fact freed only when the last
> >>    mmap()ed view is unmapped.
> > 
> > While I agree that we should remove this restriction, it has helped me in the 
> > past to find missing munmap() in userspace. This patch thus has the potential 
> > of causing memory leaks in userspace. Is there a way we could assist 
> > application developers with this ?
> 
> Should we just keep the debug message? (rephrased of course)
> 
> That way you can enable debugging and see that this happens.
> 
> It sounds reasonable to me.

Makes sense IMO.

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
