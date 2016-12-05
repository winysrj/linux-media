Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:33546 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751530AbcLEWF6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 5 Dec 2016 17:05:58 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [PATCH v2 3/3] uvcvideo: add a metadata device node
Date: Tue, 06 Dec 2016 00:06:18 +0200
Message-ID: <1591074.dEgMGVxATZ@avalon>
In-Reply-To: <Pine.LNX.4.64.1612051617340.7221@axis700.grange>
References: <Pine.LNX.4.64.1606241312130.23461@axis700.grange> <2361420.98YnhAaLcS@avalon> <Pine.LNX.4.64.1612051617340.7221@axis700.grange>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

On Monday 05 Dec 2016 16:35:39 Guennadi Liakhovetski wrote:
> On Mon, 5 Dec 2016, Laurent Pinchart wrote:
> > On Friday 02 Dec 2016 11:53:23 Guennadi Liakhovetski wrote:
> >> Some UVC video cameras contain metadata in their payload headers. This
> >> patch extracts that data, skipping the standard part of the header, on
> >> both bulk and isochronous endpoints and makes it available to the user
> >> space on a separate video node, using the V4L2_CAP_META_CAPTURE
> >> capability and the V4L2_BUF_TYPE_META_CAPTURE buffer queue type. Even
> >> though different cameras will have different metadata formats, we use
> >> the same V4L2_META_FMT_UVC pixel format for all of them. Users have to
> >> parse data, based on the specific camera model information.
> >> 
> >> Signed-off-by: Guennadi Liakhovetski <guennadi.liakhovetski@intel.com>
> >> ---
> >> 
> >> v2:
> >> - updated to the current media/master
> >> - removed superfluous META capability from capture nodes
> >> - now the complete UVC payload header is copied to buffers, including
> >>   standard fields
> >> 
> >> Still open for discussion: is this really OK to always create an
> >> additional metadata node for each UVC camera or UVC video interface.
> 
> [snip]
> 
> >> +	/*
> >> +	 * Register a metadata node. TODO: shall this only be enabled for some
> >> +	 * cameras?
> >> +	 */
> >> +	if (!(dev->quirks & UVC_QUIRK_BUILTIN_ISIGHT))
> >> +		uvc_meta_register(stream);
> >> +
> > 
> > I think so, only for the cameras that can produce metadata.
> 
> Every UVC camera produces metadata, but most cameras only have standard
> fields there. Whether we should stream standard header fields from the
> metadata node will be discussed later. If we do decide to stream standard
> header fields, then every USB camera gets metadata nodes. If we decide not
> to include standard fields, how do we know whether the camera has any
> private fields in headers without streaming from it? Do you want a quirk
> for such cameras?

Unless they can be detected in a standard way that's probably the best 
solution. Please remember that the UVC specification doesn't allow vendors to 
extend headers in a vendor-specific way. This is an abuse of the 
specification, so a quirk is probably the best option.

> [snip]
> 
> > > +static struct vb2_ops uvc_meta_queue_ops = {
> > > +	.queue_setup = meta_queue_setup,
> > > +	.buf_prepare = meta_buffer_prepare,
> > > +	.buf_queue = meta_buffer_queue,
> > > +	.wait_prepare = vb2_ops_wait_prepare,
> > > +	.wait_finish = vb2_ops_wait_finish,
> > > +	.start_streaming = meta_start_streaming,
> > > +	.stop_streaming = meta_stop_streaming,
> > > +};
> > 
> > How about reusing the uvc_queue.c implementation, with a few new checks
> > for metadata buffers where needed, instead of duplicating code ? At first
> > sight the changes don't seem to be too intrusive (but I might have
> > overlooked something).
> 
> I thought about that in the beginning and even started implementing it
> that way, but at some point it became too inconvenient, so, I switched
> over to a separate implementation. I'll think about it more and either
> explain, why I didn't want to do that, or unite them.
> 
> [snip]
> 
> > > +{
> > > +	size_t nbytes;
> > > +
> > > +	if (!meta_buf || !length)
> > > +		return;
> > > +
> > > +	nbytes = min_t(unsigned int, length, meta_buf->length);
> > > +
> > > +	meta_buf->buf.sequence = buf->buf.sequence;
> > > +	meta_buf->buf.field = buf->buf.field;
> > > +	meta_buf->buf.vb2_buf.timestamp = buf->buf.vb2_buf.timestamp;
> > > +
> > > +	memcpy(meta_buf->mem, mem, nbytes);
> > 
> > Do you need the whole header ? Shouldn't you strip the part already
> > handled by the driver ?
> 
> My original version did that, but we also need the timestamp from the
> header. The driver does parse it, but the implementation there has
> multiple times been reported as buggy and noone has been able to fix it so
> far :)

-ENOTIME I'm afraid, but feel free to give it a go :-) On the other hand 
supplying the PTS and SCR values to userspace would be useful to implement a 
high-accuracy clock translation algorithm that could make use of floating 
point operations.

> So, I ended up pulling the complete header to the user-space. Unless time-
> stamp processing is fixed in the kernel, I don't think we can frop this.

SCR and PTS should be provided to userspace in a standard way.

> >> +	meta_buf->bytesused = nbytes;
> >> +	meta_buf->state = UVC_BUF_STATE_READY;
> >> +
> >> +	uvc_queue_next_buffer(&stream->meta.queue, meta_buf);
> > 
> > This essentially means that you'll need one buffer per isochronous packet.
> > Given the number of isochronous packets that make a complete image the
> > cost seem prohibitive to me. You should instead gather metadata from all
> > headers into a single buffer.
> 
> Hm, I only worked with cameras, using bulk transfers, so, didn't consider
> ISOC implications. Will have to think about this.

-- 
Regards,

Laurent Pinchart

