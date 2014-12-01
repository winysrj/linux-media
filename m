Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:34576 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753105AbaLALAL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 1 Dec 2014 06:00:11 -0500
From: "Devshatwar, Nikhil" <nikhil.nd@ti.com>
To: Hans Verkuil <hverkuil@xs4all.nl>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: RE: [PATCH v3 1/4] media: ti-vpe: Use data offset for getting
 dma_addr for a plane
Date: Mon, 1 Dec 2014 11:00:05 +0000
Message-ID: <E60A9E1B4132A24DB80BD56ABC92684735027F16@DBDE04.ent.ti.com>
References: <1417256860-20233-1-git-send-email-nikhil.nd@ti.com>
 <1417256860-20233-2-git-send-email-nikhil.nd@ti.com>
 <547C4765.1040807@xs4all.nl>
In-Reply-To: <547C4765.1040807@xs4all.nl>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> -----Original Message-----
> From: Hans Verkuil [mailto:hverkuil@xs4all.nl]
> Sent: Monday, December 01, 2014 4:18 PM
> To: Devshatwar, Nikhil; linux-media@vger.kernel.org
> Subject: Re: [PATCH v3 1/4] media: ti-vpe: Use data offset for getting
> dma_addr for a plane
> 
> On 11/29/2014 11:27 AM, Nikhil Devshatwar wrote:
> > The data_offset in v4l2_planes structure will help us point to the
> > start of data content for that particular plane. This may be useful
> > when a single buffer contains the data for different planes e.g. Y
> > planes of two fields in the same buffer. With this, user space can
> > pass queue top field and bottom field with same dmafd and different
> data_offsets.
> >
> > Signed-off-by: Nikhil Devshatwar <nikhil.nd@ti.com>
> > ---
> > Changes from v2:
> >  * Use data_offset only for OUTPUT stream buffers
> >
> >  drivers/media/platform/ti-vpe/vpe.c |   10 +++++++++-
> >  1 file changed, 9 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/media/platform/ti-vpe/vpe.c
> > b/drivers/media/platform/ti-vpe/vpe.c
> > index 9a081c2..ba26b83 100644
> > --- a/drivers/media/platform/ti-vpe/vpe.c
> > +++ b/drivers/media/platform/ti-vpe/vpe.c
> > @@ -496,6 +496,14 @@ struct vpe_mmr_adb {
> >
> >  #define VPE_SET_MMR_ADB_HDR(ctx, hdr, regs, offset_a)	\
> >  	VPDMA_SET_MMR_ADB_HDR(ctx->mmr_adb, vpe_mmr_adb, hdr, regs,
> > offset_a)
> > +
> > +static inline dma_addr_t vb2_dma_addr_plus_data_offset(struct
> vb2_buffer *vb,
> > +	unsigned int plane_no)
> > +{
> > +	return vb2_dma_contig_plane_dma_addr(vb, plane_no) +
> > +		vb->v4l2_planes[plane_no].data_offset;
> > +}
> > +
> >  /*
> >   * Set the headers for all of the address/data block structures.
> >   */
> > @@ -1043,7 +1051,7 @@ static void add_in_dtd(struct vpe_ctx *ctx, int
> > port)
> >
> >  		vpdma_fmt = fmt->vpdma_fmt[plane];
> >
> > -		dma_addr = vb2_dma_contig_plane_dma_addr(vb, plane);
> > +		dma_addr = vb2_dma_addr_plus_data_offset(vb, plane);
> >  		if (!dma_addr) {
> >  			vpe_err(ctx->dev,
> >  				"acquiring input buffer(%d) dma_addr failed\n",
> >
> 
> Should there be a check somewhere that verifies that
> vb2_get_plane_payload() -
> vb->v4l2_planes[plane_no].data_offset is still large enough for the
> vb->image you
> want to copy?

Yes, it is done as part of the vb2_qbuf -> __buf_prepare -> __verify_length function
If the data_offset is high enough that it goes out of the length of that plane,
The qbuf ioctl should have failed, So we can safely assume the validity of data_offset here

> 
> Regards,
> 
> 	Hans
