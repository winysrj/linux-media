Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:60647 "EHLO
        epoutp01.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751215AbdDCGOA (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 3 Apr 2017 02:14:00 -0400
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
        by epoutp01.samsung.com (KnoxPortal) with ESMTP id 20170403061358epoutp01661b378db26f289e6ea39cff936bc524~xzoi7Yshs1392113921epoutp01q
        for <linux-media@vger.kernel.org>; Mon,  3 Apr 2017 06:13:58 +0000 (GMT)
Subject: Re: [Patch v3 00/11] Add MFC v10.10 support
From: Smitha T Murthy <smitha.t@samsung.com>
To: Andrzej Hajda <a.hajda@samsung.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, kyungmin.park@samsung.com,
        kamil@wypas.org, jtp.park@samsung.com, mchehab@kernel.org,
        pankaj.dubey@samsung.com, krzk@kernel.org,
        m.szyprowski@samsung.com, s.nawrocki@samsung.com
In-Reply-To: <6a5fa537-0977-b18b-70be-56ad771a0c03@samsung.com>
Date: Mon, 03 Apr 2017 11:45:47 +0530
Message-ID: <1491200147.24095.21.camel@smitha-fedora>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
References: <CGME20170331090425epcas1p4de8762ee73be91312a76a73638bac253@epcas1p4.samsung.com>
        <1490951200-32070-1-git-send-email-smitha.t@samsung.com>
        <6a5fa537-0977-b18b-70be-56ad771a0c03@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 2017-03-31 at 15:29 +0200, Andrzej Hajda wrote:
> Hi Smitha,
> 
> On 31.03.2017 11:06, Smitha T Murthy wrote:
> > This patch series adds MFC v10.10 support. MFC v10.10 is used in some
> > of Exynos7 variants.
> 
> Patch does not apply, please rebase on top of:
>    
> 
> git://linuxtv.org/snawrocki/samsung.git for-v4.12/media/next
> 
> 
I had not checked on this git. Thank you for pointing it out. I am
downloading the code from github, will rebase on top of it and check the
patches and push the next version correspondingly.

> Additionally quick test shows you do not handle V4L2_CID_MPEG_VIDEO_HEVC_HIERARCHICAL_CODING_LAYER_CH in s5p_mfc_enc_s_ctrl.
> Regards
> Andrzej
> 

I could not sufficient details on
V4L2_CID_MPEG_VIDEO_HEVC_HIERARCHICAL_CODING_LAYER_CH in the User Manual
to implement this CID. Hence I wanted to remove it in v3 itself, I will
take care of this in next version.

Regards,
Smitha T Murthy
> >
> > This adds support for following:
> >
> > * Add support for HEVC encoder and decoder
> > * Add support for VP9 decoder
> > * Update Documentation for control id definitions
> > * Update computation of min scratch buffer size requirement for V8 onwards
> >
> > Changes since v2:
> >  - Addressed review comments by Andrzej Hajda.
> >  - Rebased on latest krzk/for-next tree.
> >  - This patches are tested on top of Marek's patch v2 [1]
> >  - Applied acked-by and r-o-b from Andrzej on respective patches.
> >  - Applied acked-by from Rob Herring on respective patch.
> >
> > [1]: http://www.mail-archive.com/linux-media@vger.kernel.org/msg108520.html
> >
> > Smitha T Murthy (11):
> >   [media] s5p-mfc: Rename IS_MFCV8 macro
> >   [media] s5p-mfc: Adding initial support for MFC v10.10
> >   [media] s5p-mfc: Use min scratch buffer size as provided by F/W
> >   [media] s5p-mfc: Support MFCv10.10 buffer requirements
> >   [media] videodev2.h: Add v4l2 definition for HEVC
> >   [media] s5p-mfc: Add support for HEVC decoder
> >   Documentation: v4l: Documentation for HEVC v4l2 definition
> >   [media] s5p-mfc: Add VP9 decoder support
> >   [media] v4l2: Add v4l2 control IDs for HEVC encoder
> >   [media] s5p-mfc: Add support for HEVC encoder
> >   Documention: v4l: Documentation for HEVC CIDs
> >
> >  .../devicetree/bindings/media/s5p-mfc.txt          |   1 +
> >  Documentation/media/uapi/v4l/extended-controls.rst | 355 ++++++++++++
> >  Documentation/media/uapi/v4l/pixfmt-013.rst        |   5 +
> >  drivers/media/platform/s5p-mfc/regs-mfc-v10.h      |  88 +++
> >  drivers/media/platform/s5p-mfc/regs-mfc-v8.h       |   2 +
> >  drivers/media/platform/s5p-mfc/s5p_mfc.c           |  33 ++
> >  drivers/media/platform/s5p-mfc/s5p_mfc_cmd_v6.c    |   9 +
> >  drivers/media/platform/s5p-mfc/s5p_mfc_common.h    |  71 ++-
> >  drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c      |   6 +-
> >  drivers/media/platform/s5p-mfc/s5p_mfc_dec.c       |  50 +-
> >  drivers/media/platform/s5p-mfc/s5p_mfc_enc.c       | 616 ++++++++++++++++++++-
> >  drivers/media/platform/s5p-mfc/s5p_mfc_opr.h       |  14 +
> >  drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c    | 410 ++++++++++++--
> >  drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.h    |  15 +
> >  drivers/media/v4l2-core/v4l2-ctrls.c               | 103 ++++
> >  include/uapi/linux/v4l2-controls.h                 | 133 +++++
> >  include/uapi/linux/videodev2.h                     |   1 +
> >  17 files changed, 1835 insertions(+), 77 deletions(-)
> >  create mode 100644 drivers/media/platform/s5p-mfc/regs-mfc-v10.h
> >
> 
> 
