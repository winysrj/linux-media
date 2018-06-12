Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:50805 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933733AbeFLQnk (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 12 Jun 2018 12:43:40 -0400
Message-ID: <1528821817.5280.10.camel@pengutronix.de>
Subject: Re: [PATCH] gpu: ipu-v3: Allow negative offsets for interlaced
 scanning
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Steve Longerbeam <slongerbeam@gmail.com>,
        linux-media@vger.kernel.org
Cc: Krzysztof =?UTF-8?Q?Ha=C5=82asa?= <khalasa@piap.pl>,
        kernel@pengutronix.de,
        Javier Martinez Canillas <javierm@redhat.com>
Date: Tue, 12 Jun 2018 18:43:37 +0200
In-Reply-To: <6780e24e-891d-3583-6e38-d1abd69c8a0d@gmail.com>
References: <20180601131316.18728-1-p.zabel@pengutronix.de>
         <ebada35f-23c1-6ca4-5228-d3d91bad48bc@gmail.com>
         <1528708771.3818.7.camel@pengutronix.de>
         <6780e24e-891d-3583-6e38-d1abd69c8a0d@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 2018-06-11 at 14:06 -0700, Steve Longerbeam wrote:
> 
> On 06/11/2018 02:19 AM, Philipp Zabel wrote:
> > Hi Steve,
> > 
> > On Sun, 2018-06-10 at 17:08 -0700, Steve Longerbeam wrote:
> > > Hi Philipp,
> > > 
> > > On 06/01/2018 06:13 AM, Philipp Zabel wrote:
> > > > The IPU also supports interlaced buffers that start with the bottom field.
> > > > To achieve this, the the base address EBA has to be increased by a stride
> > > > length and the interlace offset ILO has to be set to the negative stride.
> > > > 
> > > > Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> > > > ---
> > > >    drivers/gpu/ipu-v3/ipu-cpmem.c | 8 +++++++-
> > > >    1 file changed, 7 insertions(+), 1 deletion(-)
> > > > 
> > > > diff --git a/drivers/gpu/ipu-v3/ipu-cpmem.c b/drivers/gpu/ipu-v3/ipu-cpmem.c
> > > > index 9f2d9ec42add..c1028f38c553 100644
> > > > --- a/drivers/gpu/ipu-v3/ipu-cpmem.c
> > > > +++ b/drivers/gpu/ipu-v3/ipu-cpmem.c
> > > > @@ -269,8 +269,14 @@ EXPORT_SYMBOL_GPL(ipu_cpmem_set_uv_offset);
> > > >    
> > > >    void ipu_cpmem_interlaced_scan(struct ipuv3_channel *ch, int stride)
> > > >    {
> > > > +	u32 ilo;
> > > > +
> > > >    	ipu_ch_param_write_field(ch, IPU_FIELD_SO, 1);
> > > > -	ipu_ch_param_write_field(ch, IPU_FIELD_ILO, stride / 8);
> > > > +	if (stride >= 0)
> > > > +		ilo = stride / 8;
> > > > +	else
> > > > +		ilo = 0x100000 - (-stride / 8);
> > > > +	ipu_ch_param_write_field(ch, IPU_FIELD_ILO, ilo);
> > > >    	ipu_ch_param_write_field(ch, IPU_FIELD_SLY, (stride * 2) - 1);
> > > 
> > > This should be "(-stride * 2) - 1" for SLY when stride is negative.
> > > 
> > > After fixing that, interweaving seq-bt -> interlaced-bt works fine for
> > > packed pixel formats,
> > 
> > Ouch, thanks.
> > 
> > >   but there is still some problem for planar.
> > > I haven't tracked down the issue with planar yet,
> > 
> > Just with the negative stride line?
> 
> Correct, planar is broken (bad colors in captured frames) when
> negative stride is enabled for interweave. Planar works fine otherwise.
> 
> >   Only for YUV420 or also for NV12?
> 
> I tested YV12 (three planes YUV420). I can't remember if I tested
> NV12 (two planes). I'm currently not able to test as I'm away from
> the hardware but I will try on Wednesday.
> 
> > The problem could be that we also have to change UBO/VBO for planar
> > formats with a chroma stride (SLUV) that is half the luma stride (SLY)
> > when we move both Y and U/V frame start by a line length.
> 
> Right, and I think I am doing that, by setting image.rect.top = 1
> before calling ipu_cpmem_set_image(). And when dequeuing a
> new v4l2_buffer, I am adding one luma stride to the buffer address
> when calling ipu_cpmem_set_buffer() (grep for interweave_offset).

Oh, ok. Yes, that looks superficially correct, if a bit intransparent.

> > >   but the corresponding
> > > changes to imx-media that allow interweaving with line swapping are at
> > > 
> > > e9dd81da20 ("media: imx: Allow interweave with top/bottom lines swapped")
> > > 
> > > in branch fix-csi-interlaced.3 in my media-tree fork on github. Please
> > > have a
> > > look and let me know if you see anything obvious.
> > 
> > In commit a19126a80d13 ("gpu: ipu-csi: Swap fields according to
> > input/output field types"), swap_fields = true is only set for
> > seq-bt -> seq-tb and seq-tb -> seq-bt. I think it should also be
> > enabled for alternate -> seq-bt (PAL) and alternate -> seq-tb (NTSC).
> 
> It is, see ipu_csi_translate_field() -- it will translate alternate
> to seq-bt or seq-tb before determining swap_fields.

Right, I missed that too.

> > 
> > I've been made aware [1] that recently V4L2_FIELD_ALTERNATE has been
> > clarified [2] to specify that v4l2_mbus_fmt.height should contain the
> > number of lines per field, not per frame:
> 
> Yep! That was nagging at me as well. I noticed at least one other
> platform (omap3isp) that doubles the source pad frame height
> when the sensor reports ALTERNATE field mode, to capture a
> whole frame. Makes sense. I think the crop height will need to
> be doubled from the sink height in imx-media-csi.c to support
> ALTERNATE.

Yes.

> That also means sink height can't be used to
> guess at input video standard (480 becomes 240 for NTSC).

Well, the v4l2_std_id heuristic in ipu_csi_set_bt_interlaced_codes just
needs to check infmt->field == ALTERNATE.

regards
Philipp
