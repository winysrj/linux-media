Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:38810 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728411AbeJEWhJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 5 Oct 2018 18:37:09 -0400
Message-ID: <25d61645856120ad010b604ec4c14b0677ab9197.camel@collabora.com>
Subject: Re: [PATCH v6 0/6] Add Rockchip VPU JPEG encoder
From: Ezequiel Garcia <ezequiel@collabora.com>
To: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org, linux-rockchip@lists.infradead.org,
        Hans Verkuil <hans.verkuil@cisco.com>, kernel@collabora.com,
        Nicolas Dufresne <nicolas.dufresne@collabora.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Heiko Stuebner <heiko@sntech.de>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Miouyouyou <myy@miouyouyou.fr>
Date: Fri, 05 Oct 2018 12:37:43 -0300
In-Reply-To: <20181005091034.7d8399ed@coco.lan>
References: <20180917173022.9338-1-ezequiel@collabora.com>
         <7bd9573e-e0c6-71a6-84ed-deb0904593fd@xs4all.nl>
         <faca3960d0478610b73071b471acfa26df987985.camel@collabora.com>
         <5ce82f591ab9bd1a9a0a476f01bbf4f0fe4ab0e2.camel@collabora.com>
         <20181005091034.7d8399ed@coco.lan>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 2018-10-05 at 09:10 -0300, Mauro Carvalho Chehab wrote:
> Em Thu, 04 Oct 2018 20:39:31 -0300
> Ezequiel Garcia <ezequiel@collabora.com> escreveu:
> 
> > On Mon, 2018-10-01 at 14:54 -0300, Ezequiel Garcia wrote:
> > > On Fri, 2018-09-28 at 14:33 +0200, Hans Verkuil wrote:  
> > > > On 09/17/2018 07:30 PM, Ezequiel Garcia wrote:  
> > > > > This series adds support for JPEG encoding via the VPU block
> > > > > present in Rockchip platforms. Currently, support for RK3288
> > > > > and RK3399 is included.
> > > > > 
> > > > > Please, see the previous versions of this cover letter for
> > > > > more information.
> > > > > 
> > > > > Compared to v5, the only change is in the V4L2_CID_JPEG_QUANTIZATION
> > > > > control. We've decided to support only baseline profile,
> > > > > and only add 8-bit luma and chroma tables.
> > > > > 
> > > > > struct v4l2_ctrl_jpeg_quantization {
> > > > >        __u8    luma_quantization_matrix[64];
> > > > >        __u8    chroma_quantization_matrix[64];
> > > > > };
> > > > > 
> > > > > By doing this, it's clear that we don't currently support anything
> > > > > but baseline.
> > > > > 
> > > > > This series should apply cleanly on top of
> > > > > 
> > > > >   git://linuxtv.org/hverkuil/media_tree.git br-cedrus tag.
> > > > > 
> > > > > If everyone is happy with this series, I'd like to route the devicetree
> > > > > changes through the rockchip tree, and the rest via the media subsystem.  
> > > > 
> > > > OK, so I have what is no doubt an annoying question: do we really need
> > > > a JPEG_RAW format?
> > > >   
> > > 
> > > Not annoying, as it helps clarify a few things :-)
> > > I think we do need the JPEG_RAW format. The way I see it, using
> > > JPEG opens a can of worms...
> > >   
> > > > The JPEG header is really easy to parse for a decoder and really easy to
> > > > prepend to the compressed image for the encoder.
> > > > 
> > > > The only reason I can see for a JPEG_RAW is if the image must start at
> > > > some specific address alignment. Although even then you can just pad the
> > > > JPEG header that you will add according to the alignment requirements.
> > > > 
> > > > I know I am very late with this question, but I never looked all that
> > > > closely at what a JPEG header looks like. But this helped:
> > > > 
> > > > https://en.wikipedia.org/wiki/JPEG_File_Interchange_Format
> > > > 
> > > > and it doesn't seem difficult at all to parse or create the header.
> > > > 
> > > >   
> > > 
> > > ... I think that having JPEG_RAW as the compressed format
> > > is much more clear for userspace, as it explicitly specifies
> > > what is expected.
> > > 
> > > This way, for a stateless encoder, applications are required
> > > to set quantization and/or entropy tables, and are then in
> > > charge of using the compressed JPEG_RAW payload in whatever form
> > > they want. Stupid simple.
> > > 
> > > On the other side, if the stateless encoder driver supports
> > > JPEG (creating headers in-kernel), it means that:
> > > 
> > > *) applications should pass a quality control, if supported,
> > > and the driver will use hardcoded tables or...
> > > 
> > > *) applications pass quantization control and, if supported,
> > > entropy control. The kernel uses them to create the JPEG frame.
> > > But also, some drivers (e.g. Rockchip), use default entropy
> > > tables, which should now be in the kernel.
> > > 
> > > So the application would have to query controls to find out
> > > what to do. Not exactly hard, but I think having the JPEG_RAW
> > > is much simpler and more clear.
> > > 
> > > Now, for stateless decoders, supporting JPEG_RAW means
> > > the application has to pass quantization and entropy
> > > controls, probably using the Request API.
> > > Given the application has parsed the JPEG,
> > > it knows the width and height and can request
> > > buffers accordingly.
> > > 
> > > The hardware is stateless, and so is the driver.
> > > 
> > > On the other hand, supporting JPEG would mean that
> > > drivers will have to parse the image, extracting
> > > the quantization and entropy tables.
> > > 
> > > Format negotiation is now more complex,
> > > either we follow the stateful spec, introducing a little
> > > state machine in the driver... or we use the Request API,
> > > but that means parsing on both sides kernel and application.
> > > 
> > > Either way, using JPEG_RAW is just waaay simpler and puts
> > > things where they belong. 
> > >   
> > 
> > As discussed on IRC, I'm sending a v7 for this series,
> > fixing only the checkpatch issues and the extra line in the
> > binding document.
> > 
> > We've agreed to move forward with JPEG_RAW, for the reasons
> > stated above.
> > 
> > Plus, we've agreed to keep this in staging until the userspace
> > support for JPEG_RAW format is clear.
> 
> The problem is that a new format is actually a V4L2 core change, and
> not something for staging.
> 
> IMHO, it is prudent to wait for an userspace code before hushing
> merging this upstream.
> 
> -
> 
> I'm concerned about adding a JPEG_RAW format. We had this discussion
> in the past. On that time, it was opted to add a code inside the
> drivers that will be adding the jpeg headers, on the cases where
> the hardware was providing headerless frames.
> 

I suspect such discussion was held on completely different hardware.
What we are trying to support here has specific needs, and thus
why we need new formats.

> Among the reasons, different drivers may be requiring different
> logic to add the jpeg headers, depending on how they interpret
> the quality parameters and on the Huffmann tables used by an
> specific codec.
> 
> I can't see why this couldn't be done on a stateless codec. I mean:
> in the specific case of JPEG, each frame is independently coded.
> It doesn't need to store anything from a previous frame in order to
> produce a JPEG header.
> 

Well, this can be done. But since it's the wrong architecture,
it will bring a more complex API and more complex implementation.

In the case of a stateless decoder, it will mean a really cumbersome
API. As I have explained above, using JPEG format on hardware
than can only deal with JPEG_RAW format means:

1) Userspace sets JPEG format on the OUTPUT queue (sink)

2) Userspace needs to know the raw format, but it has
to wait for the driver to parse it first.

So, 3) it will QBUF a JPEG buffer, and 4) get the V4L2_EVENT_SOURCE_CHANGE
event in order to move forward. This implies a stateful machinery in the
driver. Like I said, more complex API, more complex implementation...
and only to avoid a new pixelformat? Doesn't sound a good deal :-)

In comparison, a proper stateless decoder driver will expose
a simpler API, provide a 1:1 output/capture buffer relationship,
and expose the full capabilities to userspace.

> So, from my side, at least for the first version of this driver,
> please make it produce a full JPEG frame with the headers, and
> use V4L2_PIX_FMT_JPEG format.
> 

This means using some form of JPEG quantization tables and huffman
tables in the kernel, such as in drivers/media/usb/gspca/topro.c.

Really doesn't sound like the best choice, violating the
mechanism/policy separation, as now the kernel is deciding
the tables for the user.

The hardware can take any quantization table, and allowing userspace
flexible usage, but we are going to restrict that to just a specific
usage and a specific set of tables... again, only to avoid a new
pixelformat? 

> That should allow us to add this driver on staging without adding
> a new JPEG_RAW format.
> 

AFAIK, Rockchip and Allwinner JPEG codecs handle so-called JPEG_RAW
format, i.e. the payload of a SOF segment. I think having these
two cases should be enough reason to add a new format.

> If you still think we'll need a V4L2_PIX_FMT_JPEG_RAW, I'd like
> to merge it by the time we also have a decoder for libv4l. I
> would also like to see, at the Kernel patch series, the addition
> of such support for already existing non-staging camera
> drivers that internally receive headless JPEG headers from the
> hardware. This will allow us to test the userspace code with
> different models and proof that a generic JPEG_RAW decoder on
> userspace is doable.
> 

We can add a libv4l2 plugin for this decoder if that helps moving
forward. Although I suspect it will just fall into oblivion,
as chromeos and android will do their own thing.

JPEG is a very well known format, and it's trivial for applications
to add the headers.

Thanks,
Eze
