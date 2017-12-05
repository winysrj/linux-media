Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:50146 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752720AbdLENop (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 5 Dec 2017 08:44:45 -0500
Date: Tue, 5 Dec 2017 14:44:34 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
cc: linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [PATCH 3/3 v7] uvcvideo: add a metadata device node
In-Reply-To: <29678788.jfO5ktnOBC@avalon>
Message-ID: <alpine.DEB.2.20.1712051440590.22421@axis700.grange>
References: <1510156814-28645-1-git-send-email-g.liakhovetski@gmx.de> <2006709.83fRcNtr9s@avalon> <alpine.DEB.2.20.1712050918330.22421@axis700.grange> <29678788.jfO5ktnOBC@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 5 Dec 2017, Laurent Pinchart wrote:

> Hi Guennadi,
> 
> On Tuesday, 5 December 2017 12:56:53 EET Guennadi Liakhovetski wrote:
> > On Tue, 5 Dec 2017, Laurent Pinchart wrote:
> > > On Wednesday, 8 November 2017 18:00:14 EET Guennadi Liakhovetski wrote:
> > >> Some UVC video cameras contain metadata in their payload headers. This
> > >> patch extracts that data, adding more clock synchronisation information,
> > >> on both bulk and isochronous endpoints and makes it available to the
> > >> user space on a separate video node, using the V4L2_CAP_META_CAPTURE
> > >> capability and the V4L2_BUF_TYPE_META_CAPTURE buffer queue type. Even
> > >> though different cameras will have different metadata formats, we use
> > >> the same V4L2_META_FMT_UVC pixel format for all of them. Users have to
> > >> parse data, based on the specific camera model information. This
> > >> version of the patch only creates such metadata nodes for cameras,
> > >> specifying a UVC_QUIRK_METADATA_NODE quirk flag.
> > > 
> > > I don't think this is correct anymore, as we'll use different 4CCs for
> > > different vendor metadata. How would you like to rephrase the commit
> > > message ?
> > 
> > Something like
> > 
> > "
> > Some UVC video cameras contain metadata in their payload headers. This
> > patch extracts that data, adding more clock synchronisation information,
> > on both bulk and isochronous endpoints and makes it available to the user
> > space on a separate video node, using the V4L2_CAP_META_CAPTURE capability
> > and the V4L2_BUF_TYPE_META_CAPTURE buffer queue type. By default, only the
> > V4L2_META_FMT_UVC pixel format is available from those nodes. However,
> > cameras can be added to the device ID table to additionally specify their
> > own metadata format, in which case that format will also become available
> > from the metadata node.
> > "
> 
> Sounds good to me.
> 
> > >> Signed-off-by: Guennadi Liakhovetski <guennadi.liakhovetski@intel.com>
> > >> ---
> > >> 
> > >> v7: support up to two metadata formats per camera - the standard one and
> > >> an optional private one, if specified in device information
> > >> 
> > >>  drivers/media/usb/uvc/Makefile       |   2 +-
> > >>  drivers/media/usb/uvc/uvc_driver.c   |  15 +++
> > >>  drivers/media/usb/uvc/uvc_isight.c   |   2 +-
> > >>  drivers/media/usb/uvc/uvc_metadata.c | 204 +++++++++++++++++++++++++++++
> > >>  drivers/media/usb/uvc/uvc_queue.c    |  41 +++++--
> > >>  drivers/media/usb/uvc/uvc_video.c    | 127 ++++++++++++++++++++--
> > >>  drivers/media/usb/uvc/uvcvideo.h     |  19 +++-
> > >>  drivers/media/v4l2-core/v4l2-ioctl.c |   1 +
> > >>  include/uapi/linux/uvcvideo.h        |  26 +++++
> > >>  9 files changed, 416 insertions(+), 21 deletions(-)
> > >>  create mode 100644 drivers/media/usb/uvc/uvc_metadata.c
> [snip]
> 
> > >> diff --git a/drivers/media/usb/uvc/uvc_metadata.c
> > >> b/drivers/media/usb/uvc/uvc_metadata.c new file mode 100644
> > >> index 0000000..21eeee9
> > >> --- /dev/null
> > >> +++ b/drivers/media/usb/uvc/uvc_metadata.c
> 
> [snip]
> 
> > >> +static int uvc_meta_v4l2_querycap(struct file *file, void *fh,
> > >> +				  struct v4l2_capability *cap)
> > >> +{
> > >> +	struct v4l2_fh *vfh = file->private_data;
> > >> +	struct uvc_streaming *stream = video_get_drvdata(vfh->vdev);
> > >> +
> > >> +	strlcpy(cap->driver, "uvcvideo", sizeof(cap->driver));
> > >> +	strlcpy(cap->card, vfh->vdev->name, sizeof(cap->card));
> > >> +	usb_make_path(stream->dev->udev, cap->bus_info,
> > >> sizeof(cap->bus_info));
> > >> +
> > >> +	return 0;
> > >> +}
> > > 
> > > Do you think we could reuse uvc_ioctl_querycap() as-is ?
> > 
> > AFAICS it still has
> > 
> > 	cap->capabilities = V4L2_CAP_DEVICE_CAPS | V4L2_CAP_STREAMING
> > 			  | chain->caps;
> > 
> > in it, which doesn't suit the metadata node?
> 
> I'd say this is debatable, isn't the capabilities field supposed to include 
> all capabilities from all video nodes for the device ? chain->caps would need 
> to include metadata capability in that case.
> 
> Code reuse is not a big deal as the function is small, but getting the 
> capabilities value right is important regardless.

Hm, but that's how applications would naturally work - open a node, query 
its capabilities and handle it accordingly. What good would be having 
equal capabilities on all nodes? Why do you think that should be the case?

> > >> +
> > >> +static int uvc_meta_v4l2_get_format(struct file *file, void *fh,
> > >> +				    struct v4l2_format *format)
> > >> +{
> > >> +	struct v4l2_fh *vfh = file->private_data;
> > >> +	struct uvc_streaming *stream = video_get_drvdata(vfh->vdev);
> > >> +	struct v4l2_meta_format *fmt = &format->fmt.meta;
> > >> +
> > >> +	if (format->type != vfh->vdev->queue->type)
> > >> +		return -EINVAL;
> > >> +
> > >> +	memset(fmt, 0, sizeof(*fmt));
> > >> +
> > >> +	fmt->dataformat = stream->cur_meta_format;
> > >> +	fmt->buffersize = UVC_METATADA_BUF_SIZE;
> > > 
> > > You need to take the stream->mutex lock here to protect against races with
> > > the set format ioctl.
> > 
> > Well, strictly speaking you don't? The buffersize is constant and getting
> > the current metadata format is an atomic read.
> 
> I was concerned by the race condition due to lack of memory barriers, but if 
> userspace issues concurrent G_FMT and S_FMT calls the order isn't guaranteed 
> anyway, so you're right about that.
> 
> [snip]
> 
> > > > diff --git a/drivers/media/usb/uvc/uvc_queue.c
> > > > b/drivers/media/usb/uvc/uvc_queue.c index c8d78b2..b2998f5 100644
> > > > --- a/drivers/media/usb/uvc/uvc_queue.c
> > > > +++ b/drivers/media/usb/uvc/uvc_queue.c
> > 
> > [snip]
> > 
> > >> +	if (!meta_buf || length == 2 ||
> > >> +	    meta_buf->length - meta_buf->bytesused <
> > >> +	    length + sizeof(meta->ns) + sizeof(meta->sof))
> > >> +		return;
> > > 
> > > If the metadata buffer overflows should we also set the error bit like we
> > > do for video buffers ? I have mixed feelings about this, I'd appreciate
> > > your input.
> > 
> > I think it would be good to know if we ever run into such overruns.
> > Setting an error flag is more likely to be noticed and reported than a
> > printk()?
> 
> I believe so, yes.

OK, so we set an error.

Thanks
Guennadi
