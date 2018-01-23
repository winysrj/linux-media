Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:18311 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751334AbeAWGEe (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 23 Jan 2018 01:04:34 -0500
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20180123060432epoutp02e570718f21b7643001acda9a4d019cd1~MWzhzsH7m0880208802epoutp02J
        for <linux-media@vger.kernel.org>; Tue, 23 Jan 2018 06:04:32 +0000 (GMT)
Subject: Re: [Patch v6 00/12] Add MFC v10.10 support
From: Smitha T Murthy <smitha.t@samsung.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, kyungmin.park@samsung.com,
        kamil@wypas.org, jtp.park@samsung.com, a.hajda@samsung.com,
        mchehab@kernel.org, pankaj.dubey@samsung.com, krzk@kernel.org,
        m.szyprowski@samsung.com, s.nawrocki@samsung.com
In-Reply-To: <126f1982-060a-6fdb-e1b3-b5c81d65ca13@xs4all.nl>
Date: Tue, 23 Jan 2018 11:11:06 +0530
Message-ID: <1516686066.12482.148.camel@smitha-fedora>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
References: <CGME20171208093612epcas1p1eda138655cf5397893fe1f2b2152bd1f@epcas1p1.samsung.com>
        <1512724105-1778-1-git-send-email-smitha.t@samsung.com>
        <126f1982-060a-6fdb-e1b3-b5c81d65ca13@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 2018-01-22 at 13:18 +0100, Hans Verkuil wrote:
> Hi Smitha,
> 
> Thank you for this v6 series!
> 
> You can add my:
> 
> Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
> 
> to patches 1-9 and 11. See my review for patches 10 and 12. The comments
> are minor, so I hope I can Ack v7 once it's posted and this can be merged
> for 4.17.
> 
> Regards,
> 
> 	Hans
> 
Thank you so much for the review.
I will update the same by this week and post.

Regards,
Smitha
> On 08/12/17 10:08, Smitha T Murthy wrote:
> > This patch series adds MFC v10.10 support. MFC v10.10 is used in some
> > of Exynos7 variants.
> > 
> > This adds support for following:
> > 
> > * Add support for HEVC encoder and decoder
> > * Add support for VP9 decoder
> > * Update Documentation for control id definitions
> > * Update computation of min scratch buffer size requirement for V8 onwards
> > 
> > Changes since v5:
> >  - Addressed review comments by Kamil Debski <kamil@wypas.org>.
> >  - Addressed review comments by 
> >    Stanimir Varbanov <stanimir.varbanov@linaro.org>.
> >  - Addressed review comments by Hans Verkuil <hverkuil@xs4all.nl>.
> >  - Rebased on latest git://linuxtv.org/snawrocki/samsung.git
> >    for-v4.15/media/next.
> >  - Applied r-o-b from Andrzej, Stanimir on respective patches.
> >  - Applied acked-by from Kamil, Hans on respective patches.
> > 
> > Smitha T Murthy (12):
> >   [media] s5p-mfc: Rename IS_MFCV8 macro
> >   [media] s5p-mfc: Adding initial support for MFC v10.10
> >   [media] s5p-mfc: Use min scratch buffer size as provided by F/W
> >   [media] s5p-mfc: Support MFCv10.10 buffer requirements
> >   [media] videodev2.h: Add v4l2 definition for HEVC
> >   [media] v4l2-ioctl: add HEVC format description
> >   Documentation: v4l: Documentation for HEVC v4l2 definition
> >   [media] s5p-mfc: Add support for HEVC decoder
> >   [media] s5p-mfc: Add VP9 decoder support
> >   [media] v4l2: Add v4l2 control IDs for HEVC encoder
> >   [media] s5p-mfc: Add support for HEVC encoder
> >   Documention: v4l: Documentation for HEVC CIDs
> > 
> >  .../devicetree/bindings/media/s5p-mfc.txt          |   1 +
> >  Documentation/media/uapi/v4l/extended-controls.rst | 395 +++++++++++++++
> >  Documentation/media/uapi/v4l/pixfmt-compressed.rst |   5 +
> >  drivers/media/platform/s5p-mfc/regs-mfc-v10.h      |  88 ++++
> >  drivers/media/platform/s5p-mfc/regs-mfc-v8.h       |   2 +
> >  drivers/media/platform/s5p-mfc/s5p_mfc.c           |  28 ++
> >  drivers/media/platform/s5p-mfc/s5p_mfc_cmd_v6.c    |   9 +
> >  drivers/media/platform/s5p-mfc/s5p_mfc_common.h    |  68 ++-
> >  drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c      |   6 +-
> >  drivers/media/platform/s5p-mfc/s5p_mfc_dec.c       |  48 +-
> >  drivers/media/platform/s5p-mfc/s5p_mfc_enc.c       | 555 ++++++++++++++++++++-
> >  drivers/media/platform/s5p-mfc/s5p_mfc_opr.h       |  14 +
> >  drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c    | 397 +++++++++++++--
> >  drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.h    |  15 +
> >  drivers/media/v4l2-core/v4l2-ctrls.c               | 118 +++++
> >  drivers/media/v4l2-core/v4l2-ioctl.c               |   1 +
> >  include/uapi/linux/v4l2-controls.h                 |  92 +++-
> >  include/uapi/linux/videodev2.h                     |   1 +
> >  18 files changed, 1765 insertions(+), 78 deletions(-)
> >  create mode 100644 drivers/media/platform/s5p-mfc/regs-mfc-v10.h
> > 
> 
> 
> 
