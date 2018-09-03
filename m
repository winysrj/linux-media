Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:38436 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728279AbeICVgw (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 3 Sep 2018 17:36:52 -0400
Message-ID: <f7f1249779d660a06b902bdaf3166cda910e48e1.camel@collabora.com>
Subject: Re: [PATCH v4 5/6] media: Add controls for JPEG quantization tables
From: Ezequiel Garcia <ezequiel@collabora.com>
To: Ian Arkver <ian.arkver.dev@gmail.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org, linux-rockchip@lists.infradead.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>, kernel@collabora.com,
        Nicolas Dufresne <nicolas.dufresne@collabora.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Heiko Stuebner <heiko@sntech.de>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Miouyouyou <myy@miouyouyou.fr>,
        Shunqian Zheng <zhengsq@rock-chips.com>
Date: Mon, 03 Sep 2018 14:15:20 -0300
In-Reply-To: <1d0c0685-7d91-b422-7e34-b6472a090eb2@gmail.com>
References: <20180831155245.19235-1-ezequiel@collabora.com>
         <ec1dab04-1890-5555-44cf-2cdadc79c1a6@xs4all.nl>
         <b5715198-eff0-30d2-6f84-cd1441d3f7ba@gmail.com>
         <8d9cb4b73c4dc4af66ace5205bd6af5fc193d72a.camel@collabora.com>
         <0beecc48-6974-c12f-00a2-3823690108c0@xs4all.nl>
         <1d0c0685-7d91-b422-7e34-b6472a090eb2@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 2018-09-03 at 16:51 +0100, Ian Arkver wrote:
> Hi Hans, Ezequiel,
> 
> On 03/09/2018 16:33, Hans Verkuil wrote:
> > On 09/03/2018 05:27 PM, Ezequiel Garcia wrote:
> > > Hi Ian, Hans:
> > > 
> > > On Mon, 2018-09-03 at 14:29 +0100, Ian Arkver wrote:
> > > > Hi,
> > > > 
> > > > On 03/09/2018 10:50, Hans Verkuil wrote:
> > > > > On 08/31/2018 05:52 PM, Ezequiel Garcia wrote:
> > > > > > From: Shunqian Zheng <zhengsq@rock-chips.com>
> > > > > > 
> > > > > > Add V4L2_CID_JPEG_QUANTIZATION compound control to allow userspace
> > > > > > configure the JPEG quantization tables.
> > > > > > 
> > > > > > Signed-off-by: Shunqian Zheng <zhengsq@rock-chips.com>
> > > > > > Signed-off-by: Ezequiel Garcia <ezequiel@collabora.com>
> > > > > > ---
> > > > > >    .../media/uapi/v4l/extended-controls.rst      | 23 +++++++++++++++++++
> > > > > >    .../media/videodev2.h.rst.exceptions          |  1 +
> > > > > >    drivers/media/v4l2-core/v4l2-ctrls.c          | 10 ++++++++
> > > > > >    include/uapi/linux/v4l2-controls.h            |  5 ++++
> > > > > >    include/uapi/linux/videodev2.h                |  1 +
> > > > > >    5 files changed, 40 insertions(+)
> > > > > > 
> > > > > > diff --git a/Documentation/media/uapi/v4l/extended-controls.rst b/Documentation/media/uapi/v4l/extended-controls.rst
> > > > > > index 9f7312bf3365..e0dd03e452de 100644
> > > > > > --- a/Documentation/media/uapi/v4l/extended-controls.rst
> > > > > > +++ b/Documentation/media/uapi/v4l/extended-controls.rst
> > > > > > @@ -3354,7 +3354,30 @@ JPEG Control IDs
> > > > > >        Specify which JPEG markers are included in compressed stream. This
> > > > > >        control is valid only for encoders.
> > > > > >    
> > > > > > +.. _jpeg-quant-tables-control:
> > > > > >    
> > > > > > +``V4L2_CID_JPEG_QUANTIZATION (struct)``
> > > > > > +    Specifies the luma and chroma quantization matrices for encoding
> > > > > > +    or decoding a V4L2_PIX_FMT_JPEG_RAW format buffer. The two matrices
> > > > > > +    must be set in JPEG zigzag order, as per the JPEG specification.
> > > > > 
> > > > > Can you change "JPEG specification" to a reference to the JPEG spec entry
> > > > > in bibio.rst?
> > > > > 
> > > > > > +
> > > > > > +
> > > > > > +.. c:type:: struct v4l2_ctrl_jpeg_quantization
> > > > > > +
> > > > > > +.. cssclass:: longtable
> > > > > > +
> > > > > > +.. flat-table:: struct v4l2_ctrl_jpeg_quantization
> > > > > > +    :header-rows:  0
> > > > > > +    :stub-columns: 0
> > > > > > +    :widths:       1 1 2
> > > > > > +
> > > > > > +    * - __u8
> > > > > > +      - ``luma_quantization_matrix[64]``
> > > > > > +      - Sets the luma quantization table.
> > > > > > +
> > > > > > +    * - __u8
> > > > > > +      - ``chroma_quantization_matrix[64]``
> > > > > > +      - Sets the chroma quantization table.
> > > > > 
> > > > > Just checking: the JPEG standard specifies this as unsigned 8-bit values as well?
> > > 
> > > I thought this was already discussed, but I think the only thing I've added
> > > is this comment in one of the driver's headers:
> > > 
> > >   JPEG encoder
> > >   ------------
> > >   The VPU JPEG encoder produces JPEG baseline sequential format.
> > >   The quantization coefficients are 8-bit values, complying with
> > >   the baseline specification. Therefore, it requires application-defined
> > >   luma and chroma quantization tables. The hardware does entrophy
> > >   encoding using internal Huffman tables, as specified in the JPEG
> > >   specification.
> > > 
> > > Certainly controls should be specified better.
> > > 
> > > > As far as I can see ISO/IEC 10918-1 does not specify the precision or
> > > > signedness of the quantisation value Qvu. The default tables for 8-bit
> > > > baseline JPEG all fit into __u8 though.
> > > > 
> > > 
> > > Paragraph 4.7 of that spec, indicates the "sample" precision:
> > > 8-bit for baseline; 8-bit or 12-bit for extended.
> > > 
> > > For the quantization coefficients, the DQT segment contains a bit
> > > that indicates if the quantization coefficients are 8-bit or 16-bit.
> > > See B.2.4.1 for details.
> 
> See below (and Tq which follows the Pq field)
> 
> > > 
> > > > However there can be four sets of tables in non-baseline JPEG and it's
> > > 
> > > You lost me here, which four sets of tables are you refering to?
> > > 
> > > > not clear (to me) whether 12-bit JPEG would need more precision (I'd
> > > > guess it would).
> > > 
> > > It seems it would. From B.2.4.1:
> > > 
> > > "An 8-bit DCT-based process shall not use a 16-bit precision quantization table."
> > > 
> > > > Since this patch is defining UAPI I think it might be
> > > > good to build in some additional information, eg. number of tables,
> > > > element size. Maybe this can all be inferred from the selected pixel
> > > > format? If so then it would need documented that the above structure
> > > > only applies to baseline.
> > > > 
> > > 
> > > For quantization coefficients, I can only see two tables: one for luma
> > > one for chroma. Huffman coefficients are a different story and we are
> > > not really adding them here.
> 
> I was looking at the definition of Tqi in the frame header in B.2.2 
> which seems to allow up to four (sets of?) quantization tables. 
> Rereading it, it seems these are per component. Table B.2 implies that 
> this applies to Baseline Sequential too. In the DQT marker description 
> there's a Tq field to specify the destination for the new table. I think 
> this means that an encoder can use up to four (sets of) tables and a 
> decoder should be able to store four from the stream.
> 
> This may well not be relevant to the encoder under discussion, but if 
> it's not allowed for in UAPI it's almost a given that it'll need to be 
> added later.
> 

Hm, I think it's not really relevant for us, either on the encoding
or decoding side. Let me explain how I read the spec.

First of all, keep in mind it seems to be written with streams
in mind, which explains different start-of-image and start-of-frames
segments (SOI and SOF).

The way I read the four tables thing, the decoder expects to be first
transmitted a set of quantization tables, via DQT segments. Each DQT
segment contains a 4-bit index (0-3), allowing up to four quantization
tables to be defined.

Then, each frame is transmitted in a SOF segment. The SOF header
contains an 8-bit field (Tq_i) indicating which quantization table has
to be used for this frame.

In Video4Linux, we are frame-based, and the JPEG segments have no meaning,
because these controls are meant to be used with the JPEG RAW format,
as specified.

For the decoder side, the application is expected to parse all the segments,
and set quantization tables and compressed bitstream, via legacy or
request APIs (probably the latter).

Same goes for encoding, the user will set a quantization table for the
encoding process and then take care of the JPEG segments creation.

> BTW, my copy of the spec is dated 1993(E). Maybe it's out of date?
> 

My copy is also 1992, so even more dated :-)

> > 
> > Since (if I understand this correctly) we would need u16 for extended precision
> > JPEG, shouldn't we use u16 instead of u8? That makes the control more generic.
> 
> This seems like a safer option to me.
> 

Yes, I agree too.

> 
> > 
> > BTW, are the coefficients always unsigned? I think so, but I never read the
> > JPEG spec.
> > 

I don't think signed quantization coefficients make sense, so perhaps
this is not explicitly specified?

Regards,
Eze
