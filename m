Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:38838 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727558AbeJETJK (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 5 Oct 2018 15:09:10 -0400
Date: Fri, 5 Oct 2018 09:10:34 -0300
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: Ezequiel Garcia <ezequiel@collabora.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org, linux-rockchip@lists.infradead.org,
        Hans Verkuil <hans.verkuil@cisco.com>, kernel@collabora.com,
        Nicolas Dufresne <nicolas.dufresne@collabora.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Heiko Stuebner <heiko@sntech.de>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Miouyouyou <myy@miouyouyou.fr>
Subject: Re: [PATCH v6 0/6] Add Rockchip VPU JPEG encoder
Message-ID: <20181005091034.7d8399ed@coco.lan>
In-Reply-To: <5ce82f591ab9bd1a9a0a476f01bbf4f0fe4ab0e2.camel@collabora.com>
References: <20180917173022.9338-1-ezequiel@collabora.com>
        <7bd9573e-e0c6-71a6-84ed-deb0904593fd@xs4all.nl>
        <faca3960d0478610b73071b471acfa26df987985.camel@collabora.com>
        <5ce82f591ab9bd1a9a0a476f01bbf4f0fe4ab0e2.camel@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 04 Oct 2018 20:39:31 -0300
Ezequiel Garcia <ezequiel@collabora.com> escreveu:

> On Mon, 2018-10-01 at 14:54 -0300, Ezequiel Garcia wrote:
> > On Fri, 2018-09-28 at 14:33 +0200, Hans Verkuil wrote:  
> > > On 09/17/2018 07:30 PM, Ezequiel Garcia wrote:  
> > > > This series adds support for JPEG encoding via the VPU block
> > > > present in Rockchip platforms. Currently, support for RK3288
> > > > and RK3399 is included.
> > > > 
> > > > Please, see the previous versions of this cover letter for
> > > > more information.
> > > > 
> > > > Compared to v5, the only change is in the V4L2_CID_JPEG_QUANTIZATION
> > > > control. We've decided to support only baseline profile,
> > > > and only add 8-bit luma and chroma tables.
> > > > 
> > > > struct v4l2_ctrl_jpeg_quantization {
> > > >        __u8    luma_quantization_matrix[64];
> > > >        __u8    chroma_quantization_matrix[64];
> > > > };
> > > > 
> > > > By doing this, it's clear that we don't currently support anything
> > > > but baseline.
> > > > 
> > > > This series should apply cleanly on top of
> > > > 
> > > >   git://linuxtv.org/hverkuil/media_tree.git br-cedrus tag.
> > > > 
> > > > If everyone is happy with this series, I'd like to route the devicetree
> > > > changes through the rockchip tree, and the rest via the media subsystem.  
> > > 
> > > OK, so I have what is no doubt an annoying question: do we really need
> > > a JPEG_RAW format?
> > >   
> > 
> > Not annoying, as it helps clarify a few things :-)
> > I think we do need the JPEG_RAW format. The way I see it, using
> > JPEG opens a can of worms...
> >   
> > > The JPEG header is really easy to parse for a decoder and really easy to
> > > prepend to the compressed image for the encoder.
> > > 
> > > The only reason I can see for a JPEG_RAW is if the image must start at
> > > some specific address alignment. Although even then you can just pad the
> > > JPEG header that you will add according to the alignment requirements.
> > > 
> > > I know I am very late with this question, but I never looked all that
> > > closely at what a JPEG header looks like. But this helped:
> > > 
> > > https://en.wikipedia.org/wiki/JPEG_File_Interchange_Format
> > > 
> > > and it doesn't seem difficult at all to parse or create the header.
> > > 
> > >   
> > 
> > ... I think that having JPEG_RAW as the compressed format
> > is much more clear for userspace, as it explicitly specifies
> > what is expected.
> > 
> > This way, for a stateless encoder, applications are required
> > to set quantization and/or entropy tables, and are then in
> > charge of using the compressed JPEG_RAW payload in whatever form
> > they want. Stupid simple.
> > 
> > On the other side, if the stateless encoder driver supports
> > JPEG (creating headers in-kernel), it means that:
> > 
> > *) applications should pass a quality control, if supported,
> > and the driver will use hardcoded tables or...
> > 
> > *) applications pass quantization control and, if supported,
> > entropy control. The kernel uses them to create the JPEG frame.
> > But also, some drivers (e.g. Rockchip), use default entropy
> > tables, which should now be in the kernel.
> > 
> > So the application would have to query controls to find out
> > what to do. Not exactly hard, but I think having the JPEG_RAW
> > is much simpler and more clear.
> > 
> > Now, for stateless decoders, supporting JPEG_RAW means
> > the application has to pass quantization and entropy
> > controls, probably using the Request API.
> > Given the application has parsed the JPEG,
> > it knows the width and height and can request
> > buffers accordingly.
> > 
> > The hardware is stateless, and so is the driver.
> > 
> > On the other hand, supporting JPEG would mean that
> > drivers will have to parse the image, extracting
> > the quantization and entropy tables.
> > 
> > Format negotiation is now more complex,
> > either we follow the stateful spec, introducing a little
> > state machine in the driver... or we use the Request API,
> > but that means parsing on both sides kernel and application.
> > 
> > Either way, using JPEG_RAW is just waaay simpler and puts
> > things where they belong. 
> >   
> 
> As discussed on IRC, I'm sending a v7 for this series,
> fixing only the checkpatch issues and the extra line in the
> binding document.
> 
> We've agreed to move forward with JPEG_RAW, for the reasons
> stated above.
> 
> Plus, we've agreed to keep this in staging until the userspace
> support for JPEG_RAW format is clear.

The problem is that a new format is actually a V4L2 core change, and
not something for staging.

IMHO, it is prudent to wait for an userspace code before hushing
merging this upstream.

-

I'm concerned about adding a JPEG_RAW format. We had this discussion
in the past. On that time, it was opted to add a code inside the
drivers that will be adding the jpeg headers, on the cases where
the hardware was providing headerless frames.

Among the reasons, different drivers may be requiring different
logic to add the jpeg headers, depending on how they interpret
the quality parameters and on the Huffmann tables used by an
specific codec.

I can't see why this couldn't be done on a stateless codec. I mean:
in the specific case of JPEG, each frame is independently coded.
It doesn't need to store anything from a previous frame in order to
produce a JPEG header.

So, from my side, at least for the first version of this driver,
please make it produce a full JPEG frame with the headers, and
use V4L2_PIX_FMT_JPEG format.

That should allow us to add this driver on staging without adding
a new JPEG_RAW format.

If you still think we'll need a V4L2_PIX_FMT_JPEG_RAW, I'd like
to merge it by the time we also have a decoder for libv4l. I
would also like to see, at the Kernel patch series, the addition
of such support for already existing non-staging camera
drivers that internally receive headless JPEG headers from the
hardware. This will allow us to test the userspace code with
different models and proof that a generic JPEG_RAW decoder on
userspace is doable.

Thanks,
Mauro
