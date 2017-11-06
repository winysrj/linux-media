Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:53652 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752276AbdKFOxV (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 6 Nov 2017 09:53:21 -0500
Date: Mon, 6 Nov 2017 15:53:10 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
cc: linux-media@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [PATCH 2/6 v5] V4L: Add a UVC Metadata format
In-Reply-To: <604abbde-1e2a-350b-efd4-2bbce08c1839@xs4all.nl>
Message-ID: <alpine.DEB.2.20.1711061545090.26825@axis700.grange>
References: <1501245205-15802-1-git-send-email-g.liakhovetski@gmx.de> <1501245205-15802-3-git-send-email-g.liakhovetski@gmx.de> <17361c20-0390-e8ae-9773-c5db58e07caa@xs4all.nl> <604abbde-1e2a-350b-efd4-2bbce08c1839@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thanks for the comments.

On Mon, 30 Oct 2017, Hans Verkuil wrote:

> Hi Guennadi,
> 
> On 07/28/2017 02:46 PM, Hans Verkuil wrote:
> > On 07/28/2017 02:33 PM, Guennadi Liakhovetski wrote:
> >> Add a pixel format, used by the UVC driver to stream metadata.
> >>
> >> Signed-off-by: Guennadi Liakhovetski <guennadi.liakhovetski@intel.com>
> >> ---
> >>  Documentation/media/uapi/v4l/meta-formats.rst    |  1 +
> >>  Documentation/media/uapi/v4l/pixfmt-meta-uvc.rst | 39 ++++++++++++++++++++++++
> >>  include/uapi/linux/videodev2.h                   |  1 +
> >>  3 files changed, 41 insertions(+)
> >>  create mode 100644 Documentation/media/uapi/v4l/pixfmt-meta-uvc.rst

[snip]

> >> diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
> >> index 45cf735..0aad91c 100644
> >> --- a/include/uapi/linux/videodev2.h
> >> +++ b/include/uapi/linux/videodev2.h
> >> @@ -682,6 +682,7 @@ struct v4l2_pix_format {
> >>  /* Meta-data formats */
> >>  #define V4L2_META_FMT_VSP1_HGO    v4l2_fourcc('V', 'S', 'P', 'H') /* R-Car VSP1 1-D Histogram */
> >>  #define V4L2_META_FMT_VSP1_HGT    v4l2_fourcc('V', 'S', 'P', 'T') /* R-Car VSP1 2-D Histogram */
> >> +#define V4L2_META_FMT_UVC         v4l2_fourcc('U', 'V', 'C', 'H') /* UVC Payload Header metadata */
> 
> I discussed this with Laurent last week and since the metadata for UVC starts
> with a standard header followed by vendor-specific data it makes sense to
> use V4L2_META_FMT_UVC for just the standard header. Any vendor specific formats
> should have their own fourcc which starts with the standard header followed by
> the custom data. The UVC driver would enumerate both the standard and the vendor
> specific fourcc. This would allow generic UVC applications to use the standard
> header. Applications that know about the vendor specific data can select the
> vendor specific format.
> 
> This change would make this much more convenient to use.

Then the driver should be able to decide, which private fourcc code to use 
for each of those devices. A natural way to do that seems to be to put 
that in the .driver_info field of struct usb_device_id. For that I'd 
replace the current use of that field for quirks with a pointer to a 
struct in a separate patch. Laurent, would that be acceptable? Then add a 
field to that struct for a private metadata fourcc code.

Thanks
Guennadi

> Regards,
> 
> 	Hans
> 
> >>  /* priv field value to indicates that subsequent fields are valid. */
> >>  #define V4L2_PIX_FMT_PRIV_MAGIC		0xfeedcafe
