Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:48308 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727467AbeHVVAB (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 22 Aug 2018 17:00:01 -0400
Message-ID: <8a4dba99d73e46eb6885b852110d9eac2b041db7.camel@collabora.com>
Subject: Re: [RFC] Request API and V4L2 capabilities
From: Ezequiel Garcia <ezequiel@collabora.com>
To: Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Date: Wed, 22 Aug 2018 14:33:59 -0300
In-Reply-To: <8b603c5a27c55e30e4ac3f1b9bb6b6d8515e2331.camel@bootlin.com>
References: <621896b1-f26e-3239-e7e7-e8c9bc4f3fe8@xs4all.nl>
         <43c3d4b79377e9481ca29308cf1c160d57902d8c.camel@bootlin.com>
         <5f1a88aa-9ad9-9669-b8b9-78c921282279@xs4all.nl>
         <ee7e5b404c895d01682700d815a6cec89c2221a1.camel@bootlin.com>
         <186fd3ca-7759-7648-6870-4e5274a9680d@xs4all.nl>
         <05d52a4a3ed33a057e050d1f79dc0d873f31f21e.camel@bootlin.com>
         <CAAFQd5C0bwbZ74rpCTmXVNGPdp2TDJcb+YzRfevwuxvvK7Lbzg@mail.gmail.com>
         <8b603c5a27c55e30e4ac3f1b9bb6b6d8515e2331.camel@bootlin.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 2018-08-22 at 16:10 +0200, Paul Kocialkowski wrote:
> Hi,
> 
> On Tue, 2018-08-21 at 17:52 +0900, Tomasz Figa wrote:
> > Hi Hans, Paul,
> > 
> > On Mon, Aug 6, 2018 at 6:29 PM Paul Kocialkowski
> > <paul.kocialkowski@bootlin.com> wrote:
> > > 
> > > On Mon, 2018-08-06 at 11:23 +0200, Hans Verkuil wrote:
> > > > On 08/06/2018 11:13 AM, Paul Kocialkowski wrote:
> > > > > Hi,
> > > > > 
> > > > > On Mon, 2018-08-06 at 10:32 +0200, Hans Verkuil wrote:
> > > > > > On 08/06/2018 10:16 AM, Paul Kocialkowski wrote:
> > > > > > > On Sat, 2018-08-04 at 15:50 +0200, Hans Verkuil wrote:
> > > > > > > > Regarding point 3: I think this should be documented next to the pixel format. I.e.
> > > > > > > > the MPEG-2 Slice format used by the stateless cedrus codec requires the request API
> > > > > > > > and that two MPEG-2 controls (slice params and quantization matrices) must be present
> > > > > > > > in each request.
> > > > > > > > 
> > > > > > > > I am not sure a control flag (e.g. V4L2_CTRL_FLAG_REQUIRED_IN_REQ) is needed here.
> > > > > > > > It's really implied by the fact that you use a stateless codec. It doesn't help
> > > > > > > > generic applications like v4l2-ctl or qv4l2 either since in order to support
> > > > > > > > stateless codecs they will have to know about the details of these controls anyway.
> > > > > > > > 
> > > > > > > > So I am inclined to say that it is not necessary to expose this information in
> > > > > > > > the API, but it has to be documented together with the pixel format documentation.
> > > > > > > 
> > > > > > > I think this is affected by considerations about codec profile/level
> > > > > > > support. More specifically, some controls will only be required for
> > > > > > > supporting advanced codec profiles/levels, so they can only be
> > > > > > > explicitly marked with appropriate flags by the driver when the target
> > > > > > > profile/level is known. And I don't think it would be sane for userspace
> > > > > > > to explicitly set what profile/level it's aiming at. As a result, I
> > > > > > > don't think we can explicitly mark controls as required or optional.
> > 
> > I'm not sure this is entirely true. The hardware may need to be
> > explicitly told what profile the video is. It may even not be the
> > hardware, but the driver itself too, given that the profile may imply
> > the CAPTURE pixel format, e.g. for VP9 profiles:
> > 
> > profile 0
> > color depth: 8 bit/sample, chroma subsampling: 4:2:0
> > profile 1
> > color depth: 8 bit, chroma subsampling: 4:2:0, 4:2:2, 4:4:4
> > profile 2
> > color depth: 10–12 bit, chroma subsampling: 4:2:0
> > profile 3
> > color depth: 10–12 bit, chroma subsampling: 4:2:0, 4:2:2, 4:4:4
> > 
> > (reference: https://en.wikipedia.org/wiki/VP9#Profiles)
> 
> I think it would be fair to expect userspace to select the right
> destination format (and maybe have the driver error if there's a
> mismatch with the meta-data) instead of having the driver somewhat
> expose what format should be used.
> 
> But maybe this would be an API violation, since all the enumerated
> formats are probably supposed to be selectable?
> 
> We could also look at it the other way round and consider that selecting
> an exposed format is always legit, but that it implies passing a
> bitstream that matches it or the driver will error (because of an
> invalid bitstream passed, not because of a "wrong" selected format).
> 

The API requires the user to negotiate via TRY_FMT/S_FMT. The driver
usually does not return error on invalid formats, and simply return
a format it can work with. I think the kernel-user contract has to
guarantee if the driver accepted a given format, it won't fail to
encoder or decode.

I think that's why it makes sense for stateless drivers to set the
profile/levels for a given job, in order to properly negotiate
the input and output formats (for both encoders and decoders).  

[1] https://linuxtv.org/downloads/v4l-dvb-apis/uapi/v4l/vidioc-g-fmt.html
