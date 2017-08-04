Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:60086 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752984AbdHDQjS (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 4 Aug 2017 12:39:18 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Cc: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        hans.verkuil@cisco.com, kieran.bingham@ideasonboard.com
Subject: Re: [PATCH v4 0/7] vsp1 partition algorithm improvements
Date: Fri, 04 Aug 2017 19:39:31 +0300
Message-ID: <1576481.bIWHKWdUO9@avalon>
In-Reply-To: <cover.b619f10db4b4618832ca73df5688ce9f2f36596b.1501864274.git-series.kieran.bingham+renesas@ideasonboard.com>
References: <cover.b619f10db4b4618832ca73df5688ce9f2f36596b.1501864274.git-series.kieran.bingham+renesas@ideasonboard.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kieran,

On Friday 04 Aug 2017 17:32:37 Kieran Bingham wrote:
> Hans, this series should be ready for integration now. Could you pick up
> these patches please?

Just a note for Hans: the series merges cleanly with Dave's drm-next branch 
(git://people.freedesktop.org/~airlied/linux) that contains a large series of 
VSP patches. There should thus be no merge conflict (at least none that git 
won't solve automatically) when merging upstream.

> Some updates and initial improvements for the VSP1 partition algorithm that
> remove redundant processing and variables, reducing the processing done in
> interrupt context slightly.
> 
> Patch 1, fixes up a bug to release buffers back to vb2 if errors occur in
> vsp1_video_start_streaming()
> 
> Patches 2, 3 and 4 clean up the calculation of the partition windows such
> that they are only calculated once at streamon.
> 
> Patch 5 improves the allocations with a new vsp1_partition object to track
> each window state.
> 
> Patches 6, and 7 then go on to enhance the partition algorithm by allowing
> each entity to calculate the requirements for it's pipeline predecessor to
> successfully generate the requested output window. This system allows the
> entity objects to specify what they need to fulfil the output for the next
> entity in the pipeline.
> 
> v2:
>  - Rebased to v4.12-rc1
>  - Partition tables dynamically allocated
>  - review fixups
> 
> v3:
>  - Review fixes and changes from Laurent
>  - v4l: vsp1: Release buffers in start_streaming error path
> 
> v4:
>  - (Final) fixups from Laurent's review, and picked up his reviewed-by tags.
> 
> Kieran Bingham (7):
>   v4l: vsp1: Release buffers in start_streaming error path
>   v4l: vsp1: Move vsp1_video_pipeline_setup_partitions() function
>   v4l: vsp1: Calculate partition sizes at stream start
>   v4l: vsp1: Remove redundant context variables
>   v4l: vsp1: Move partition rectangles to struct and operate directly
>   v4l: vsp1: Provide UDS register updates
>   v4l: vsp1: Allow entities to participate in the partition algorithm
> 
>  drivers/media/platform/vsp1/vsp1_entity.h |   7 +-
>  drivers/media/platform/vsp1/vsp1_pipe.c   |  22 +++-
>  drivers/media/platform/vsp1/vsp1_pipe.h   |  46 +++++-
>  drivers/media/platform/vsp1/vsp1_regs.h   |  14 ++-
>  drivers/media/platform/vsp1/vsp1_rpf.c    |  27 +--
>  drivers/media/platform/vsp1/vsp1_sru.c    |  26 +++-
>  drivers/media/platform/vsp1/vsp1_uds.c    |  57 ++++++-
>  drivers/media/platform/vsp1/vsp1_video.c  | 182 ++++++++++++-----------
>  drivers/media/platform/vsp1/vsp1_wpf.c    |  24 ++-
>  9 files changed, 289 insertions(+), 116 deletions(-)
> 
> base-commit: 520eccdfe187591a51ea9ab4c1a024ae4d0f68d9

-- 
Regards,

Laurent Pinchart
