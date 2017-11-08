Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:58634 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751786AbdKHKnw (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 8 Nov 2017 05:43:52 -0500
Date: Wed, 8 Nov 2017 11:43:46 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Subject: Re: [PATCH 2/6 v5] V4L: Add a UVC Metadata format
In-Reply-To: <17991420.GWclfaas9a@avalon>
Message-ID: <alpine.DEB.2.20.1711081126370.20370@axis700.grange>
References: <1501245205-15802-1-git-send-email-g.liakhovetski@gmx.de> <604abbde-1e2a-350b-efd4-2bbce08c1839@xs4all.nl> <alpine.DEB.2.20.1711061545090.26825@axis700.grange> <17991420.GWclfaas9a@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent, Hans,

On Tue, 7 Nov 2017, Laurent Pinchart wrote:

> Hi Guennadi,
> 
> On Monday, 6 November 2017 16:53:10 EET Guennadi Liakhovetski wrote:
> > On Mon, 30 Oct 2017, Hans Verkuil wrote:
> > > On 07/28/2017 02:46 PM, Hans Verkuil wrote:
> > >> On 07/28/2017 02:33 PM, Guennadi Liakhovetski wrote:
> > >>> Add a pixel format, used by the UVC driver to stream metadata.
> > >>> 
> > >>> Signed-off-by: Guennadi Liakhovetski <guennadi.liakhovetski@intel.com>
> > >>> ---
> > >>> 
> > >>>  Documentation/media/uapi/v4l/meta-formats.rst    |  1 +
> > >>>  Documentation/media/uapi/v4l/pixfmt-meta-uvc.rst | 39 +++++++++++++++++
> > >>>  include/uapi/linux/videodev2.h                   |  1 +
> > >>>  3 files changed, 41 insertions(+)
> > >>>  create mode 100644 Documentation/media/uapi/v4l/pixfmt-meta-uvc.rst
> > 
> > [snip]
> > 
> > >>> diff --git a/include/uapi/linux/videodev2.h
> > >>> b/include/uapi/linux/videodev2.h index 45cf735..0aad91c 100644
> > >>> --- a/include/uapi/linux/videodev2.h
> > >>> +++ b/include/uapi/linux/videodev2.h
> > >>> @@ -682,6 +682,7 @@ struct v4l2_pix_format {
> > >>> 
> > >>>  /* Meta-data formats */
> > >>>  #define V4L2_META_FMT_VSP1_HGO    v4l2_fourcc('V', 'S', 'P', 'H') /*
> > >>>  R-Car VSP1 1-D Histogram */ #define V4L2_META_FMT_VSP1_HGT   
> > >>>  v4l2_fourcc('V', 'S', 'P', 'T') /* R-Car VSP1 2-D Histogram */> >> 
> > >>> +#define V4L2_META_FMT_UVC         v4l2_fourcc('U', 'V', 'C', 'H') /*
> > >>> UVC Payload Header metadata */
> > > 
> > > I discussed this with Laurent last week and since the metadata for UVC
> > > starts with a standard header followed by vendor-specific data it makes
> > > sense to use V4L2_META_FMT_UVC for just the standard header. Any vendor
> > > specific formats should have their own fourcc which starts with the
> > > standard header followed by the custom data. The UVC driver would
> > > enumerate both the standard and the vendor specific fourcc. This would
> > > allow generic UVC applications to use the standard header. Applications
> > > that know about the vendor specific data can select the vendor specific
> > > format.
> > > 
> > > This change would make this much more convenient to use.
> > 
> > Then the driver should be able to decide, which private fourcc code to use
> > for each of those devices. A natural way to do that seems to be to put
> > that in the .driver_info field of struct usb_device_id. For that I'd
> > replace the current use of that field for quirks with a pointer to a
> > struct in a separate patch. Laurent, would that be acceptable? Then add a
> > field to that struct for a private metadata fourcc code.
> 
> I've been thinking about doing so for some time now. If you can write a patch 
> it would be great ! What I've been wondering is how to keep the code both 
> readable and small. If we declared those structures separately from the 
> devices array we could use one instance for multiple devices, but naming might 
> become awkward. On the other hand, if we defined them inline within the 
> devices array, we'd get rid of the naming issue, but at the expense of 
> increased memory usage.

We have in the meantime agreed to always use structs and to create named 
structs for reoccurring quirk flags and in-place structs for 
single-occurrance flags.

While implementing this I came across yet one more compromise, that we'll 
have to accept with this approach:

To recall the metadata buffer layout should be

struct uvc_meta_buf {
	uint64_t ns;
	uint16_t sof;
	uint8_t length;
	uint8_t flags;
	uint8_t buf[];
} __attribute__((packed));

where all the fields, beginning with "length" are a direct copy from the 
UVC payload header. If multiple such payload headers have arrived for a 
single frame, they will be appended and .bytesused will as usually have 
the total byte count, used up in this frame. An application would then 
calculate lengths of those individual metadata blocks as

sizeof(.ns) + sizeof(.sof) + .length

But this won't work with the "standard" UVC metadata format where any 
private data, following standard fields, are dropped. In that case 
applications would have to look at .flags and calculate the block length 
based on them. Another possibility would be to rewrite the .length field 
in the driver to only include standard fields, but I really don't think 
that would be a good idea.

Thanks
Guennadi

> One middle-ground option would be to allow storing either a structure pointer 
> or quirks flags in the field, relying on the fact that the low order bit of a 
> pointer will be NULL. We could repurpose flag BIT(0) to indicate that the 
> field contains flags instead of a pointer.
> 
> Maybe I'm over-engineering this and that the extra memory consumption won't be 
> too bad, or separately defined structures will be easy to name. I'd appreciate 
> your opinion on this matter.
> 
> -- 
> Regards,
> 
> Laurent Pinchart
> 
