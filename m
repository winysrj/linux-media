Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:18892 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751974Ab2GEPPn (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 Jul 2012 11:15:43 -0400
Received: from eusync3.samsung.com (mailout1.w1.samsung.com [210.118.77.11])
 by mailout1.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0M6P00CH512VHYB0@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 05 Jul 2012 16:16:07 +0100 (BST)
Received: from AMDN157 ([106.116.147.102])
 by eusync3.samsung.com (Oracle Communications Messaging Server 7u4-23.01
 (7.0.4.23.0) 64bit (built Aug 10 2011))
 with ESMTPA id <0M6P00IUK11Z2930@eusync3.samsung.com> for
 linux-media@vger.kernel.org; Thu, 05 Jul 2012 16:15:36 +0100 (BST)
From: Kamil Debski <k.debski@samsung.com>
To: 'Arun Kumar K' <arun.kk@samsung.com>, linux-media@vger.kernel.org
Cc: jtp.park@samsung.com, janghyuck.kim@samsung.com,
	jaeryul.oh@samsung.com, ch.naveen@samsung.com,
	Marek Szyprowski <m.szyprowski@samsung.com>
References: <1341405044-16051-1-git-send-email-arun.kk@samsung.com>
In-reply-to: <1341405044-16051-1-git-send-email-arun.kk@samsung.com>
Subject: RE: [PATCH v1] s5p-mfc: update MFC v4l2 driver to support MFC6.x
Date: Thu, 05 Jul 2012 17:15:35 +0200
Message-id: <000301cd5ac1$0749afb0$15dd0f10$%debski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Content-language: en-gb
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Arun,

First of all - your patch is incomplete. I cannot find a
modified videodev2.h file. Compilation fails with a lot of
undefined symbols - attached below.

Please supply this file, then I will be able to provide you with
more comments and a proper review.

Best wishes,
--
Kamil Debski
Linux Platform Group
Samsung Poland R&D Center


----------- Errors ----------------
In file included from drivers/media/video/s5p-mfc/s5p_mfc.c:25:
drivers/media/video/s5p-mfc/s5p_mfc_common.h:330: error: field 'hier_qp_type'
has incomplete type
drivers/media/video/s5p-mfc/s5p_mfc_common.h:335: error: field
'sei_fp_arrangement_type' has incomplete type
drivers/media/video/s5p-mfc/s5p_mfc_common.h:338: error: field 'fmo_map_type'
has incomplete type
drivers/media/video/s5p-mfc/s5p_mfc_common.h:340: error: field 'fmo_chg_dir'
has incomplete type
make[4]: *** [drivers/media/video/s5p-mfc/s5p_mfc.o] Error 1
make[4]: *** Waiting for unfinished jobs....
In file included from drivers/media/video/s5p-mfc/s5p_mfc_intr.c:21:
drivers/media/video/s5p-mfc/s5p_mfc_common.h:330: error: field 'hier_qp_type'
has incomplete type
drivers/media/video/s5p-mfc/s5p_mfc_common.h:335: error: field
'sei_fp_arrangement_type' has incomplete type
drivers/media/video/s5p-mfc/s5p_mfc_common.h:338: error: field 'fmo_map_type'
has incomplete type
drivers/media/video/s5p-mfc/s5p_mfc_common.h:340: error: field 'fmo_chg_dir'
has incomplete type
make[4]: *** [drivers/media/video/s5p-mfc/s5p_mfc_intr.o] Error 1
In file included from drivers/media/video/s5p-mfc/s5p_mfc_dec.c:27:
drivers/media/video/s5p-mfc/s5p_mfc_common.h:330: error: field 'hier_qp_type'
has incomplete type
drivers/media/video/s5p-mfc/s5p_mfc_common.h:335: error: field
'sei_fp_arrangement_type' has incomplete type
drivers/media/video/s5p-mfc/s5p_mfc_common.h:338: error: field 'fmo_map_type'
has incomplete type
drivers/media/video/s5p-mfc/s5p_mfc_common.h:340: error: field 'fmo_chg_dir'
has incomplete type
drivers/media/video/s5p-mfc/s5p_mfc_dec.c:38: error:
'V4L2_PIX_FMT_NV12MT_16X16' undeclared here (not in a function)
drivers/media/video/s5p-mfc/s5p_mfc_dec.c:59: error: 'V4L2_PIX_FMT_NV21M'
undeclared here (not in a function)
drivers/media/video/s5p-mfc/s5p_mfc_dec.c:73: error: 'V4L2_PIX_FMT_H264_MVC'
undeclared here (not in a function)
drivers/media/video/s5p-mfc/s5p_mfc_dec.c:129: error: 'V4L2_PIX_FMT_VP8'
undeclared here (not in a function)
drivers/media/video/s5p-mfc/s5p_mfc_dec.c: In function 'vidioc_try_fmt':
drivers/media/video/s5p-mfc/s5p_mfc_dec.c:377: warning: comparison between
pointer and integer
drivers/media/video/s5p-mfc/s5p_mfc_dec.c: In function 'vidioc_s_fmt':
drivers/media/video/s5p-mfc/s5p_mfc_dec.c:450: warning: comparison between
pointer and integer
make[4]: *** [drivers/media/video/s5p-mfc/s5p_mfc_dec.o] Error 1
In file included from drivers/media/video/s5p-mfc/s5p_mfc_enc.c:28:
drivers/media/video/s5p-mfc/s5p_mfc_common.h:330: error: field 'hier_qp_type'
has incomplete type
drivers/media/video/s5p-mfc/s5p_mfc_common.h:335: error: field
'sei_fp_arrangement_type' has incomplete type
drivers/media/video/s5p-mfc/s5p_mfc_common.h:338: error: field 'fmo_map_type'
has incomplete type
drivers/media/video/s5p-mfc/s5p_mfc_common.h:340: error: field 'fmo_chg_dir'
has incomplete type
drivers/media/video/s5p-mfc/s5p_mfc_enc.c:38: error:
'V4L2_PIX_FMT_NV12MT_16X16' undeclared here (not in a function)
drivers/media/video/s5p-mfc/s5p_mfc_enc.c:59: error: 'V4L2_PIX_FMT_NV21M'
undeclared here (not in a function)
drivers/media/video/s5p-mfc/s5p_mfc_enc.c:113: error:
'V4L2_MPEG_VIDEO_MULTI_SLICE_MODE_MAX_BITS' undeclared here (not in a
function)
drivers/media/video/s5p-mfc/s5p_mfc_enc.c:113: error: initializer element is
not constant
drivers/media/video/s5p-mfc/s5p_mfc_enc.c:113: error: (near initialization for
'controls[1].maximum')
drivers/media/video/s5p-mfc/s5p_mfc_enc.c:126: error:
'V4L2_CID_MPEG_VIDEO_MULTI_SLICE_MAX_BITS' undeclared here (not in a function)
drivers/media/video/s5p-mfc/s5p_mfc_enc.c:126: error: initializer element is
not constant
drivers/media/video/s5p-mfc/s5p_mfc_enc.c:126: error: (near initialization for
'controls[3].id')
drivers/media/video/s5p-mfc/s5p_mfc_enc.c:202: error:
'V4L2_CID_MPEG_VIDEO_VBV_DELAY' undeclared here (not in a function)
drivers/media/video/s5p-mfc/s5p_mfc_enc.c:202: error: initializer element is
not constant
drivers/media/video/s5p-mfc/s5p_mfc_enc.c:202: error: (near initialization for
'controls[12].id')
drivers/media/video/s5p-mfc/s5p_mfc_enc.c:572: error:
'V4L2_CID_MPEG_VIDEO_H264_SEI_FRAME_PACKING' undeclared here (not in a
function)
drivers/media/video/s5p-mfc/s5p_mfc_enc.c:572: error: initializer element is
not constant
drivers/media/video/s5p-mfc/s5p_mfc_enc.c:572: error: (near initialization for
'controls[55].id')
drivers/media/video/s5p-mfc/s5p_mfc_enc.c:580: error:
'V4L2_CID_MPEG_VIDEO_H264_SEI_FP_CURRENT_FRAME_0' undeclared here (not in a
function)
drivers/media/video/s5p-mfc/s5p_mfc_enc.c:580: error: initializer element is
not constant
drivers/media/video/s5p-mfc/s5p_mfc_enc.c:580: error: (near initialization for
'controls[56].id')
drivers/media/video/s5p-mfc/s5p_mfc_enc.c:588: error:
'V4L2_CID_MPEG_VIDEO_H264_SEI_FP_ARRANGEMENT_TYPE' undeclared here (not in a
function)
drivers/media/video/s5p-mfc/s5p_mfc_enc.c:588: error: initializer element is
not constant
drivers/media/video/s5p-mfc/s5p_mfc_enc.c:588: error: (near initialization for
'controls[57].id')
drivers/media/video/s5p-mfc/s5p_mfc_enc.c:590: error:
'V4L2_MPEG_VIDEO_H264_SEI_FP_ARRANGEMENT_TYPE_SIDE_BY_SIDE' undeclared here
(not in a function)
drivers/media/video/s5p-mfc/s5p_mfc_enc.c:590: error: initializer element is
not constant
drivers/media/video/s5p-mfc/s5p_mfc_enc.c:590: error: (near initialization for
'controls[57].minimum')
drivers/media/video/s5p-mfc/s5p_mfc_enc.c:591: error:
'V4L2_MPEG_VIDEO_H264_SEI_FP_ARRANGEMENT_TYPE_TEMPORAL' undeclared here (not
in a function)
drivers/media/video/s5p-mfc/s5p_mfc_enc.c:591: error: initializer element is
not constant
drivers/media/video/s5p-mfc/s5p_mfc_enc.c:591: error: (near initialization for
'controls[57].maximum')
drivers/media/video/s5p-mfc/s5p_mfc_enc.c:592: error: initializer element is
not constant
drivers/media/video/s5p-mfc/s5p_mfc_enc.c:592: error: (near initialization for
'controls[57].default_value')
drivers/media/video/s5p-mfc/s5p_mfc_enc.c:596: error:
'V4L2_CID_MPEG_VIDEO_H264_FMO' undeclared here (not in a function)
drivers/media/video/s5p-mfc/s5p_mfc_enc.c:596: error: initializer element is
not constant
drivers/media/video/s5p-mfc/s5p_mfc_enc.c:596: error: (near initialization for
'controls[58].id')
drivers/media/video/s5p-mfc/s5p_mfc_enc.c:604: error:
'V4L2_CID_MPEG_VIDEO_H264_FMO_MAP_TYPE' undeclared here (not in a function)
drivers/media/video/s5p-mfc/s5p_mfc_enc.c:604: error: initializer element is
not constant
drivers/media/video/s5p-mfc/s5p_mfc_enc.c:604: error: (near initialization for
'controls[59].id')
drivers/media/video/s5p-mfc/s5p_mfc_enc.c:606: error:
'V4L2_MPEG_VIDEO_H264_FMO_MAP_TYPE_INTERLEAVED_SLICES' undeclared here (not in
a function)
drivers/media/video/s5p-mfc/s5p_mfc_enc.c:606: error: initializer element is
not constant
drivers/media/video/s5p-mfc/s5p_mfc_enc.c:606: error: (near initialization for
'controls[59].minimum')
drivers/media/video/s5p-mfc/s5p_mfc_enc.c:607: error:
'V4L2_MPEG_VIDEO_H264_FMO_MAP_TYPE_WIPE_SCAN' undeclared here (not in a
function)
drivers/media/video/s5p-mfc/s5p_mfc_enc.c:607: error: initializer element is
not constant
drivers/media/video/s5p-mfc/s5p_mfc_enc.c:607: error: (near initialization for
'controls[59].maximum')
drivers/media/video/s5p-mfc/s5p_mfc_enc.c:608: error: initializer element is
not constant
drivers/media/video/s5p-mfc/s5p_mfc_enc.c:608: error: (near initialization for
'controls[59].default_value')
drivers/media/video/s5p-mfc/s5p_mfc_enc.c:610: error:
'V4L2_MPEG_VIDEO_H264_FMO_MAP_TYPE_FOREGROUND_WITH_LEFT_OVER' undeclared here
(not in a function)
drivers/media/video/s5p-mfc/s5p_mfc_enc.c:610: error: invalid operands to
binary << (have 'int' and 'struct s5p_mfc_fmt *')
drivers/media/video/s5p-mfc/s5p_mfc_enc.c:611: error:
'V4L2_MPEG_VIDEO_H264_FMO_MAP_TYPE_BOX_OUT' undeclared here (not in a
function)
drivers/media/video/s5p-mfc/s5p_mfc_enc.c:611: error: invalid operands to
binary << (have 'int' and 'struct s5p_mfc_fmt *')
drivers/media/video/s5p-mfc/s5p_mfc_enc.c:610: error: invalid operands to
binary | (have 'struct s5p_mfc_fmt *' and 'struct s5p_mfc_fmt *')
drivers/media/video/s5p-mfc/s5p_mfc_enc.c:612: error: initializer element is
not constant
drivers/media/video/s5p-mfc/s5p_mfc_enc.c:612: error: (near initialization for
'controls[59].menu_skip_mask')
drivers/media/video/s5p-mfc/s5p_mfc_enc.c:615: error:
'V4L2_CID_MPEG_VIDEO_H264_FMO_SLICE_GROUP' undeclared here (not in a function)
drivers/media/video/s5p-mfc/s5p_mfc_enc.c:615: error: initializer element is
not constant
drivers/media/video/s5p-mfc/s5p_mfc_enc.c:615: error: (near initialization for
'controls[60].id')
drivers/media/video/s5p-mfc/s5p_mfc_enc.c:623: error:
'V4L2_CID_MPEG_VIDEO_H264_FMO_CHANGE_DIRECTION' undeclared here (not in a
function)
drivers/media/video/s5p-mfc/s5p_mfc_enc.c:623: error: initializer element is
not constant
drivers/media/video/s5p-mfc/s5p_mfc_enc.c:623: error: (near initialization for
'controls[61].id')
drivers/media/video/s5p-mfc/s5p_mfc_enc.c:625: error:
'V4L2_MPEG_VIDEO_H264_FMO_CHANGE_DIR_RIGHT' undeclared here (not in a
function)
drivers/media/video/s5p-mfc/s5p_mfc_enc.c:625: error: initializer element is
not constant
drivers/media/video/s5p-mfc/s5p_mfc_enc.c:625: error: (near initialization for
'controls[61].minimum')
drivers/media/video/s5p-mfc/s5p_mfc_enc.c:626: error:
'V4L2_MPEG_VIDEO_H264_FMO_CHANGE_DIR_LEFT' undeclared here (not in a function)
drivers/media/video/s5p-mfc/s5p_mfc_enc.c:626: error: initializer element is
not constant
drivers/media/video/s5p-mfc/s5p_mfc_enc.c:626: error: (near initialization for
'controls[61].maximum')
drivers/media/video/s5p-mfc/s5p_mfc_enc.c:628: error: initializer element is
not constant
drivers/media/video/s5p-mfc/s5p_mfc_enc.c:628: error: (near initialization for
'controls[61].default_value')
drivers/media/video/s5p-mfc/s5p_mfc_enc.c:631: error:
'V4L2_CID_MPEG_VIDEO_H264_FMO_CHANGE_RATE' undeclared here (not in a function)
drivers/media/video/s5p-mfc/s5p_mfc_enc.c:631: error: initializer element is
not constant
drivers/media/video/s5p-mfc/s5p_mfc_enc.c:631: error: (near initialization for
'controls[62].id')
drivers/media/video/s5p-mfc/s5p_mfc_enc.c:639: error:
'V4L2_CID_MPEG_VIDEO_H264_FMO_RUN_LENGTH' undeclared here (not in a function)
drivers/media/video/s5p-mfc/s5p_mfc_enc.c:639: error: initializer element is
not constant
drivers/media/video/s5p-mfc/s5p_mfc_enc.c:639: error: (near initialization for
'controls[63].id')
drivers/media/video/s5p-mfc/s5p_mfc_enc.c:647: error:
'V4L2_CID_MPEG_VIDEO_H264_ASO' undeclared here (not in a function)
drivers/media/video/s5p-mfc/s5p_mfc_enc.c:647: error: initializer element is
not constant
drivers/media/video/s5p-mfc/s5p_mfc_enc.c:647: error: (near initialization for
'controls[64].id')
drivers/media/video/s5p-mfc/s5p_mfc_enc.c:655: error:
'V4L2_CID_MPEG_VIDEO_H264_ASO_SLICE_ORDER' undeclared here (not in a function)
drivers/media/video/s5p-mfc/s5p_mfc_enc.c:655: error: initializer element is
not constant
drivers/media/video/s5p-mfc/s5p_mfc_enc.c:655: error: (near initialization for
'controls[65].id')
drivers/media/video/s5p-mfc/s5p_mfc_enc.c:663: error:
'V4L2_CID_MPEG_VIDEO_H264_HIERARCHICAL_CODING' undeclared here (not in a
function)
drivers/media/video/s5p-mfc/s5p_mfc_enc.c:663: error: initializer element is
not constant
drivers/media/video/s5p-mfc/s5p_mfc_enc.c:663: error: (near initialization for
'controls[66].id')
drivers/media/video/s5p-mfc/s5p_mfc_enc.c:671: error:
'V4L2_CID_MPEG_VIDEO_H264_HIERARCHICAL_CODING_TYPE' undeclared here (not in a
function)
drivers/media/video/s5p-mfc/s5p_mfc_enc.c:671: error: initializer element is
not constant
drivers/media/video/s5p-mfc/s5p_mfc_enc.c:671: error: (near initialization for
'controls[67].id')
drivers/media/video/s5p-mfc/s5p_mfc_enc.c:673: error:
'V4L2_MPEG_VIDEO_H264_HIERARCHICAL_CODING_B' undeclared here (not in a
function)
drivers/media/video/s5p-mfc/s5p_mfc_enc.c:673: error: initializer element is
not constant
drivers/media/video/s5p-mfc/s5p_mfc_enc.c:673: error: (near initialization for
'controls[67].minimum')
drivers/media/video/s5p-mfc/s5p_mfc_enc.c:674: error:
'V4L2_MPEG_VIDEO_H264_HIERARCHICAL_CODING_P' undeclared here (not in a
function)
drivers/media/video/s5p-mfc/s5p_mfc_enc.c:674: error: initializer element is
not constant
drivers/media/video/s5p-mfc/s5p_mfc_enc.c:674: error: (near initialization for
'controls[67].maximum')
drivers/media/video/s5p-mfc/s5p_mfc_enc.c:676: error: initializer element is
not constant
drivers/media/video/s5p-mfc/s5p_mfc_enc.c:676: error: (near initialization for
'controls[67].default_value')
drivers/media/video/s5p-mfc/s5p_mfc_enc.c:679: error:
'V4L2_CID_MPEG_VIDEO_H264_HIERARCHICAL_CODING_LAYER' undeclared here (not in a
function)
drivers/media/video/s5p-mfc/s5p_mfc_enc.c:679: error: initializer element is
not constant
drivers/media/video/s5p-mfc/s5p_mfc_enc.c:679: error: (near initialization for
'controls[68].id')
drivers/media/video/s5p-mfc/s5p_mfc_enc.c:687: error:
'V4L2_CID_MPEG_VIDEO_H264_HIERARCHICAL_CODING_LAYER_QP' undeclared here (not
in a function)
drivers/media/video/s5p-mfc/s5p_mfc_enc.c:687: error: initializer element is
not constant
drivers/media/video/s5p-mfc/s5p_mfc_enc.c:687: error: (near initialization for
'controls[69].id')
drivers/media/video/s5p-mfc/s5p_mfc_enc.c: In function 'vidioc_s_fmt':
drivers/media/video/s5p-mfc/s5p_mfc_enc.c:1125: warning: comparison between
pointer and integer
drivers/media/video/s5p-mfc/s5p_mfc_enc.c: In function 's5p_mfc_enc_s_ctrl':
drivers/media/video/s5p-mfc/s5p_mfc_enc.c:1579: warning: statement with no
effect
drivers/media/video/s5p-mfc/s5p_mfc_enc.c:1585: warning: statement with no
effect
drivers/media/video/s5p-mfc/s5p_mfc_enc.c:1591: warning: statement with no
effect
drivers/media/video/s5p-mfc/s5p_mfc_enc.c:1612: warning: statement with no
effect
make[4]: *** [drivers/media/video/s5p-mfc/s5p_mfc_enc.o] Error 1
make[3]: *** [drivers/media/video/s5p-mfc] Error 2
make[2]: *** [drivers/media/video] Error 2
make[1]: *** [drivers/media] Error 2
make: *** [drivers] Error 2
-----------------------------------

--
Kamil Debski
Linux Platform Group
Samsung Poland R&D Center


> -----Original Message-----
> From: linux-media-owner@vger.kernel.org [mailto:linux-media-
> owner@vger.kernel.org] On Behalf Of Arun Kumar K
> Sent: 04 July 2012 14:31
> To: linux-media@vger.kernel.org
> Cc: jtp.park@samsung.com; janghyuck.kim@samsung.com;
> jaeryul.oh@samsung.com; ch.naveen@samsung.com; m.szyprowski@samsung.com;
> k.debski@samsung.com; arun.kk@samsung.com
> Subject: [PATCH v1] s5p-mfc: update MFC v4l2 driver to support MFC6.x
> 
> This patch is re-worked version of the original patch posted
> by Jeongtae Park for support of MFCv6.x
> The comment given by Kamil Debski can be found here:
> http://comments.gmane.org/gmane.linux.drivers.video-input-
> infrastructure/45189
> The crash issue reported on MFC 5.1 on applying this patch has been fixed.
> This is tested for decoding functionality on MFC 5.1 and MFC 6.5.
> Encoder functionality is not tested on Exynos5 yet.
> 
> Jeongtae Park (1):
>   [media] s5p-mfc: update MFC v4l2 driver to support MFC6.x
> 
>  drivers/media/video/Kconfig                  |   16 +-
>  drivers/media/video/s5p-mfc/Makefile         |    7 +-
>  drivers/media/video/s5p-mfc/regs-mfc-v6.h    |  676 ++++++++++
>  drivers/media/video/s5p-mfc/regs-mfc.h       |   29 +
>  drivers/media/video/s5p-mfc/s5p_mfc.c        |  163 ++-
>  drivers/media/video/s5p-mfc/s5p_mfc_cmd.c    |    6 +-
>  drivers/media/video/s5p-mfc/s5p_mfc_cmd.h    |    3 +
>  drivers/media/video/s5p-mfc/s5p_mfc_cmd_v6.c |   96 ++
>  drivers/media/video/s5p-mfc/s5p_mfc_common.h |  123 ++-
>  drivers/media/video/s5p-mfc/s5p_mfc_ctrl.c   |  160 ++-
>  drivers/media/video/s5p-mfc/s5p_mfc_ctrl.h   |    1 +
>  drivers/media/video/s5p-mfc/s5p_mfc_dec.c    |  210 +++-
>  drivers/media/video/s5p-mfc/s5p_mfc_dec.h    |    1 +
>  drivers/media/video/s5p-mfc/s5p_mfc_enc.c    |  377 +++++--
>  drivers/media/video/s5p-mfc/s5p_mfc_enc.h    |    1 +
>  drivers/media/video/s5p-mfc/s5p_mfc_intr.c   |    1 -
>  drivers/media/video/s5p-mfc/s5p_mfc_opr.c    |  282 +++--
>  drivers/media/video/s5p-mfc/s5p_mfc_opr.h    |   25 +-
>  drivers/media/video/s5p-mfc/s5p_mfc_opr_v6.c | 1697
> ++++++++++++++++++++++++++
>  drivers/media/video/s5p-mfc/s5p_mfc_opr_v6.h |  140 +++
>  drivers/media/video/s5p-mfc/s5p_mfc_pm.c     |    6 +-
>  drivers/media/video/s5p-mfc/s5p_mfc_shm.c    |   28 +-
>  drivers/media/video/s5p-mfc/s5p_mfc_shm.h    |   13 +-
>  23 files changed, 3661 insertions(+), 400 deletions(-)
>  create mode 100644 drivers/media/video/s5p-mfc/regs-mfc-v6.h
>  create mode 100644 drivers/media/video/s5p-mfc/s5p_mfc_cmd_v6.c
>  create mode 100644 drivers/media/video/s5p-mfc/s5p_mfc_opr_v6.c
>  create mode 100644 drivers/media/video/s5p-mfc/s5p_mfc_opr_v6.h
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

