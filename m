Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:48922 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751394AbdBNABF (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 13 Feb 2017 19:01:05 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Cc: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        kieran.bingham@ideasonboard.com
Subject: Re: [PATCH 0/8] v4l: vsp1: Partition phase developments
Date: Tue, 14 Feb 2017 02:01:29 +0200
Message-ID: <19588925.WvKlmrXXy5@avalon>
In-Reply-To: <cover.ff94a00847faf7ed37768cea68c474926bfc8bd9.1486758327.git-series.kieran.bingham+renesas@ideasonboard.com>
References: <cover.ff94a00847faf7ed37768cea68c474926bfc8bd9.1486758327.git-series.kieran.bingham+renesas@ideasonboard.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kieran,

Thank you for the patches.

On Friday 10 Feb 2017 20:27:28 Kieran Bingham wrote:
> This series presents ongoing work with the scaler partition algorithm.
> 
> It is based upon the previous partition algorithm improvements submission
> [0] This series has been pushed to a tag [1] for convenience in testing.
> 
> Patches 1-3, provide fixes and additions to the register definitions needed
> for controlling the phases of the UDS.
> 
> Patches 4 and 5 rework the partition data configuration storage, opening the
> path for Patch 6 to implement a new entity operation API. This new
> '.partition' operation gives each entity an opportunity to adapt the
> partition data based on its configuration.
> 
> A new helper function "vsp1_pipeline_propagate_partition()" is provided by
> the vsp1_pipe to walk the pipeline in reverse, with each entity having the
> opportunity to define it's input requirements to the predecessors.
> 
> Partition data is stored somewhat inefficiently in this series, whilst the
> process is established and can be considered for improvement later.
> 
> Patch 7 begins the implementation of calculating the phase values in the
> UDS, and applying them in the VI6_UDS_HPHASE register appropriately. Phase
> calculations have been established from the partition algorithm pseudo code
> provided by renesas, although the 'end phase' is always set as 0 in this
> code, it is yet to be determined if this has an effect.
> 
> Finally Patch 8, begins to allow the UDS entity to perform extra overlap at
> the partition borders to provide the filters with the required data to
> generate clean transitions from one partition to the next.

I've consolidated the two series, included all my review comments, and pushed 
the result to

	git://linuxtv.org/pinchartl/media.git vsp1/partition

The result is laid out as follows.

[PATCH 01/10] v4l: vsp1: Move vsp1_video_pipeline_setup_partitions() function
[PATCH 02/10] v4l: vsp1: Calculate partition sizes at stream start
[PATCH 03/10] v4l: vsp1: Remove redundant context variables
[PATCH 04/10] v4l: vsp1: Provide UDS register updates
[PATCH 05/10] v4l: vsp1: Correct image partition parameters
[PATCH 06/10] v4l: vsp1: Move partition rectangles to struct
[PATCH 07/10] v4l: vsp1: Allow entities to participate in the partition 
algorithm
[PATCH 08/10] v4l: vsp1: Calculate UDS phase for partitions
[PATCH 09/10] v4l: vsp1: Implement left edge partition algorithm overlap
[PATCH 10/10] v4l: vsp1: Implement partition algorithm restrictions

Patches 01/10 to 06/10 look good to me, although I'm wondering whether we 
should rename vsp1_pipeline::partitions to vsp1_pipeline::num_partitions and 
vsp1_pipeline::part_table to vsp1_pipeline::partitions.

Patch 07/10 is mostly fine, I'm just a bit annoyed by the explicit pipeline 
description in struct vsp1_partition. We've discussed that previously and 
decided not to bother for now, so let's keep it as-is and revisit it when the 
rest of the series will be ready.

Patches 08/10 and 09/10 require more documentation, I don't understand what 
they do. I've rebased them on top of the review comments but haven't tested 
them yet.

Patch 10/10 needs to be reworked as the force_identity_mode mechanism doesn't 
work as explained in my review. We might also want to relax the restrictions a 
bit, based on feedback we will receive from Renesas. I'm fine merging hard 
restrictions first and relaxing them later, but at least force_identity_mode 
needs to be fixed.

You will notice that the branch I've pushed doesn't contain the suspend/resume 
fixes yet, I'll work on that next.

> [0]
> https://www.mail-archive.com/linux-renesas-soc@vger.kernel.org/msg08631.htm
> l [1]
> https://git.kernel.org/pub/scm/linux/kernel/git/kbingham/rcar.git#vsp1/pa-p
> hases-2017-02-10
> 
> Kieran Bingham (8):
>   v4l: vsp1: Provide UDS register updates
>   v4l: vsp1: Track the SRU entity in the pipeline
>   v4l: vsp1: Correct image partition parameters
>   v4l: vsp1: Move partition rectangles to struct
>   v4l: vsp1: Operate on partition struct data directly
>   v4l: vsp1: Allow entities to participate in the partition algorithm
>   v4l: vsp1: Calculate UDS phase for partitions
>   v4l: vsp1: Implement left edge partition algorithm overlap
> 
>  drivers/media/platform/vsp1/vsp1_entity.h |   8 +-
>  drivers/media/platform/vsp1/vsp1_pipe.c   |  22 ++++-
>  drivers/media/platform/vsp1/vsp1_pipe.h   |  49 +++++++-
>  drivers/media/platform/vsp1/vsp1_regs.h   |  14 ++-
>  drivers/media/platform/vsp1/vsp1_rpf.c    |  40 +++---
>  drivers/media/platform/vsp1/vsp1_sru.c    |  29 +++++-
>  drivers/media/platform/vsp1/vsp1_uds.c    | 144 ++++++++++++++++++++++-
>  drivers/media/platform/vsp1/vsp1_video.c  |  82 ++++++++-----
>  drivers/media/platform/vsp1/vsp1_wpf.c    |  34 +++--
>  9 files changed, 364 insertions(+), 58 deletions(-)
> 
> base-commit: 0c3b6ad6a559391f367879fd4be6d2d85625bd5a

-- 
Regards,

Laurent Pinchart
