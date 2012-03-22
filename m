Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:53710 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751667Ab2CVL0q (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Mar 2012 07:26:46 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: "Semwal, Sumit" <sumit.semwal@ti.com>
Cc: Tomasz Stanislawski <t.stanislaws@samsung.com>,
	linux-media@vger.kernel.org, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, hverkuil@xs4all.nl, daeinki@gmail.com
Subject: Re: [RFCv2 PATCH 0/9] Integration of videobuf2 with dmabuf
Date: Thu, 22 Mar 2012 12:27:16 +0100
Message-ID: <3309194.6POOTfvvKF@avalon>
In-Reply-To: <CAB2ybb_oJjykWstU3ib_ig_iB8GpvHzXGyg0GV0H5hK5PH+8UA@mail.gmail.com>
References: <1331033890-10350-1-git-send-email-t.stanislaws@samsung.com> <CAB2ybb_oJjykWstU3ib_ig_iB8GpvHzXGyg0GV0H5hK5PH+8UA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sumit,

On Tuesday 20 March 2012 20:45:00 Semwal, Sumit wrote:
> On Tue, Mar 6, 2012 at 5:08 PM, Tomasz Stanislawski wrote:
> > Hello everyone,
> > This patchset is an incremental patch to patchset created by Sumit Semwal
> > [1]. The patches are dedicated to help find a better solution for support
> > of buffer sharing by V4L2 API.  It is expected to start discussion on the
> > final installment for dma-buf in vb2-dma-contig allocator.  Current
> > version of the patches contain little documentation. It is going to be
> > fixed after achieving consensus about design for buffer exporting.
> >  Moreover the API between vb2-core and the allocator should be revised.
> 
> I like your approach in general quite a bit.
> 
> May I request you, though, to maybe split it over into two portions -
> the preparation patches, and the exporter portion. This would help as
> the exporter portion is quite dependent on dma_get_pages and
> dma-mapping patches. (Maybe also indirectly on DRM prime?)
> 
> With that split, we could try to target the preparation patches for
> 3.4 while we continue to debate on the exporter patches? I just saw
> the dma-mapping pull request from Marek, so the dependencies might
> become available soon.
> 
> If you agree, then I can post the patch version of my 'v4l2 as dma-buf
> user' patches, [except the patch that you've included in this series]
> so we can try to hit 3.4 merge window.

I've raised a couple of questions regarding the first patch, I'm afraid we 
will likely miss 3.4 :-/ If you consider important to get the patches in 3.4 I 
can try working with Tomasz to fix them ASAP.

-- 
Regards,

Laurent Pinchart

