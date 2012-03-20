Return-path: <linux-media-owner@vger.kernel.org>
Received: from na3sys009aog111.obsmtp.com ([74.125.149.205]:40838 "EHLO
	na3sys009aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760533Ab2CTPPV convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Mar 2012 11:15:21 -0400
Received: by mail-gy0-f174.google.com with SMTP id r11so148170ghr.19
        for <linux-media@vger.kernel.org>; Tue, 20 Mar 2012 08:15:20 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1331033890-10350-1-git-send-email-t.stanislaws@samsung.com>
References: <1331033890-10350-1-git-send-email-t.stanislaws@samsung.com>
From: "Semwal, Sumit" <sumit.semwal@ti.com>
Date: Tue, 20 Mar 2012 20:45:00 +0530
Message-ID: <CAB2ybb_oJjykWstU3ib_ig_iB8GpvHzXGyg0GV0H5hK5PH+8UA@mail.gmail.com>
Subject: Re: [RFCv2 PATCH 0/9] Integration of videobuf2 with dmabuf
To: Tomasz Stanislawski <t.stanislaws@samsung.com>
Cc: linux-media@vger.kernel.org, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, hverkuil@xs4all.nl,
	laurent.pinchart@ideasonboard.com, daeinki@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Tomasz,

On Tue, Mar 6, 2012 at 5:08 PM, Tomasz Stanislawski
<t.stanislaws@samsung.com> wrote:
> Hello everyone,
> This patchset is an incremental patch to patchset created by Sumit Semwal [1].
> The patches are dedicated to help find a better solution for support of buffer
> sharing by V4L2 API.  It is expected to start discussion on the final
> installment for dma-buf in vb2-dma-contig allocator.  Current version of the
> patches contain little documentation. It is going to be fixed after achieving
> consensus about design for buffer exporting.  Moreover the API between vb2-core
> and the allocator should be revised.

I like your approach in general quite a bit.

May I request you, though, to maybe split it over into two portions -
the preparation patches, and the exporter portion. This would help as
the exporter portion is quite dependent on dma_get_pages and
dma-mapping patches. (Maybe also indirectly on DRM prime?)

With that split, we could try to target the preparation patches for
3.4 while we continue to debate on the exporter patches? I just saw
the dma-mapping pull request from Marek, so the dependencies might
become available soon.

If you agree, then I can post the patch version of my 'v4l2 as dma-buf
user' patches, [except the patch that you've included in this series]
so we can try to hit 3.4 merge window.
>
<snip>
Best regards,
~Sumit.
