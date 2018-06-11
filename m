Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:60817 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754010AbeFKJTd (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 11 Jun 2018 05:19:33 -0400
Message-ID: <1528708771.3818.7.camel@pengutronix.de>
Subject: Re: [PATCH] gpu: ipu-v3: Allow negative offsets for interlaced
 scanning
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Steve Longerbeam <slongerbeam@gmail.com>,
        linux-media@vger.kernel.org
Cc: Krzysztof =?UTF-8?Q?Ha=C5=82asa?= <khalasa@piap.pl>,
        kernel@pengutronix.de,
        Javier Martinez Canillas <javierm@redhat.com>
Date: Mon, 11 Jun 2018 11:19:31 +0200
In-Reply-To: <ebada35f-23c1-6ca4-5228-d3d91bad48bc@gmail.com>
References: <20180601131316.18728-1-p.zabel@pengutronix.de>
         <ebada35f-23c1-6ca4-5228-d3d91bad48bc@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Steve,

On Sun, 2018-06-10 at 17:08 -0700, Steve Longerbeam wrote:
> Hi Philipp,
> 
> On 06/01/2018 06:13 AM, Philipp Zabel wrote:
> > The IPU also supports interlaced buffers that start with the bottom field.
> > To achieve this, the the base address EBA has to be increased by a stride
> > length and the interlace offset ILO has to be set to the negative stride.
> > 
> > Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> > ---
> >   drivers/gpu/ipu-v3/ipu-cpmem.c | 8 +++++++-
> >   1 file changed, 7 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/gpu/ipu-v3/ipu-cpmem.c b/drivers/gpu/ipu-v3/ipu-cpmem.c
> > index 9f2d9ec42add..c1028f38c553 100644
> > --- a/drivers/gpu/ipu-v3/ipu-cpmem.c
> > +++ b/drivers/gpu/ipu-v3/ipu-cpmem.c
> > @@ -269,8 +269,14 @@ EXPORT_SYMBOL_GPL(ipu_cpmem_set_uv_offset);
> >   
> >   void ipu_cpmem_interlaced_scan(struct ipuv3_channel *ch, int stride)
> >   {
> > +	u32 ilo;
> > +
> >   	ipu_ch_param_write_field(ch, IPU_FIELD_SO, 1);
> > -	ipu_ch_param_write_field(ch, IPU_FIELD_ILO, stride / 8);
> > +	if (stride >= 0)
> > +		ilo = stride / 8;
> > +	else
> > +		ilo = 0x100000 - (-stride / 8);
> > +	ipu_ch_param_write_field(ch, IPU_FIELD_ILO, ilo);
> >   	ipu_ch_param_write_field(ch, IPU_FIELD_SLY, (stride * 2) - 1);
> 
> This should be "(-stride * 2) - 1" for SLY when stride is negative.
> 
> After fixing that, interweaving seq-bt -> interlaced-bt works fine for
> packed pixel formats,

Ouch, thanks.

>  but there is still some problem for planar.
> I haven't tracked down the issue with planar yet,

Just with the negative stride line? Only for YUV420 or also for NV12?
The problem could be that we also have to change UBO/VBO for planar
formats with a chroma stride (SLUV) that is half the luma stride (SLY)
when we move both Y and U/V frame start by a line length.

>  but the corresponding
> changes to imx-media that allow interweaving with line swapping are at
> 
> e9dd81da20 ("media: imx: Allow interweave with top/bottom lines swapped")
> 
> in branch fix-csi-interlaced.3 in my media-tree fork on github. Please 
> have a
> look and let me know if you see anything obvious.

In commit a19126a80d13 ("gpu: ipu-csi: Swap fields according to
input/output field types"), swap_fields = true is only set for
seq-bt -> seq-tb and seq-tb -> seq-bt. I think it should also be
enabled for alternate -> seq-bt (PAL) and alternate -> seq-tb (NTSC).

I've been made aware [1] that recently V4L2_FIELD_ALTERNATE has been
clarified [2] to specify that v4l2_mbus_fmt.height should contain the
number of lines per field, not per frame:

[1] https://patchwork.linuxtv.org/patch/50166/
[2] 0018147c964e ("media: v4l: doc: Clarify v4l2_mbus_fmt height
    definition")

regards
Philipp
