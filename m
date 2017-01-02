Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:55866 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S932407AbdABLH4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 2 Jan 2017 06:07:56 -0500
Date: Mon, 2 Jan 2017 13:07:15 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: ayaka <ayaka@soulik.info>
Cc: dri-devel@lists.freedesktop.org, daniel.vetter@intel.com,
        jani.nikula@linux.intel.com, seanpaul@chromium.org,
        airlied@linux.ie, linux-kernel@vger.kernel.org,
        randy.li@rock-chips.com, mchehab@kernel.org,
        linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com
Subject: Re: [PATCH 2/2] [media] v4l: Add 10-bits per channel YUV pixel
 formats
Message-ID: <20170102110715.GH3958@valkosipuli.retiisi.org.uk>
References: <1483347004-32593-1-git-send-email-ayaka@soulik.info>
 <1483347004-32593-3-git-send-email-ayaka@soulik.info>
 <20170102091013.GG3958@valkosipuli.retiisi.org.uk>
 <70da89ca-c184-aee5-e133-c13b3bbf6be9@soulik.info>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <70da89ca-c184-aee5-e133-c13b3bbf6be9@soulik.info>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On Mon, Jan 02, 2017 at 06:53:16PM +0800, ayaka wrote:
> 
> 
> On 01/02/2017 05:10 PM, Sakari Ailus wrote:
> >Hi Randy,
> >
> >Thanks for the patch.
> >
> >On Mon, Jan 02, 2017 at 04:50:04PM +0800, Randy Li wrote:
> >>The formats added by this patch are:
> >>	V4L2_PIX_FMT_P010
> >>	V4L2_PIX_FMT_P010M
> >>Currently, none of driver uses those format, but some video device
> >>has been confirmed with could as those format for video output.
> >>The Rockchip's new decoder has supported those format for profile_10
> >>HEVC/AVC video.
> >>
> >>Signed-off-by: Randy Li <ayaka@soulik.info>
> >If the format resembles the existing formats but on a different bit depth,
> >it should be named in similar fashion.
> Do you mean it would be better if it is called as NV12_10?

If it otherwise resembles NV12 but just has 10 bits per pixel, I think
NV12_10 is a good name for it.

> >
> >Could you also add ReST documentation for the format, please?
> I will.
> >
> >The common requirement for merging patches that change interfaces has been
> >that there's a user for that change. It'll still help you to get this
> The kernel used in rockchip has supported that format in drm driver, but
> just we don't have a agreement about the pixel format. As the Gstreamer and
> some others would call it with a P010_ prefix, but Mark(rockchip's drm
> author) prefer the something like NV12_10, that is why I sent out those
> patches, I want the upstream decided its final name.

Ack.

I think we haven't really tried to unify the format naming in the past
between the two subsystems. If existing conventions exist on both regarding
this format, then it's probably better to follow those.

Cc Laurent as well.

> >reviewed now so the interface that the future hopefully-in-mainline driver
> >provides will not change.
> >
> >>---
> >>  include/uapi/linux/videodev2.h | 2 ++
> >>  1 file changed, 2 insertions(+)
> >>
> >>diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
> >>index 46e8a2e3..9e03f20 100644
> >>--- a/include/uapi/linux/videodev2.h
> >>+++ b/include/uapi/linux/videodev2.h
> >>@@ -551,6 +551,7 @@ struct v4l2_pix_format {
> >>  #define V4L2_PIX_FMT_NV61    v4l2_fourcc('N', 'V', '6', '1') /* 16  Y/CrCb 4:2:2  */
> >>  #define V4L2_PIX_FMT_NV24    v4l2_fourcc('N', 'V', '2', '4') /* 24  Y/CbCr 4:4:4  */
> >>  #define V4L2_PIX_FMT_NV42    v4l2_fourcc('N', 'V', '4', '2') /* 24  Y/CrCb 4:4:4  */
> >>+#define V4L2_PIX_FMT_P010    v4l2_fourcc('P', '0', '1', '0') /* 15  Y/CbCr 4:2:0, 10 bits per channel */
> >>  /* two non contiguous planes - one Y, one Cr + Cb interleaved  */
> >>  #define V4L2_PIX_FMT_NV12M   v4l2_fourcc('N', 'M', '1', '2') /* 12  Y/CbCr 4:2:0  */
> >>@@ -559,6 +560,7 @@ struct v4l2_pix_format {
> >>  #define V4L2_PIX_FMT_NV61M   v4l2_fourcc('N', 'M', '6', '1') /* 16  Y/CrCb 4:2:2  */
> >>  #define V4L2_PIX_FMT_NV12MT  v4l2_fourcc('T', 'M', '1', '2') /* 12  Y/CbCr 4:2:0 64x32 macroblocks */
> >>  #define V4L2_PIX_FMT_NV12MT_16X16 v4l2_fourcc('V', 'M', '1', '2') /* 12  Y/CbCr 4:2:0 16x16 macroblocks */
> >>+#define V4L2_PIX_FMT_P010M   v4l2_fourcc('P', 'M', '1', '0') /* 15  Y/CbCr 4:2:0, 10 bits per channel */
> >>  /* three planes - Y Cb, Cr */
> >>  #define V4L2_PIX_FMT_YUV410  v4l2_fourcc('Y', 'U', 'V', '9') /*  9  YUV 4:1:0     */
> 

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
