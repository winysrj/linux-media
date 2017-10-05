Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:47727 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751421AbdJESjt (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 5 Oct 2017 14:39:49 -0400
Date: Thu, 5 Oct 2017 15:39:29 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
        laurent.pinchart@ideasonboard.com
Subject: Re: [PATCH v5 1/7] media: add glossary.rst with a glossary of terms
 used at V4L2 spec
Message-ID: <20171005153929.0433df38@recife.lan>
In-Reply-To: <20171005082107.i76vntyg5ku5hqr7@valkosipuli.retiisi.org.uk>
References: <cover.1503924361.git.mchehab@s-opensource.com>
        <65af989db9cc5479b863657add04940ae6de9d5c.1503924361.git.mchehab@s-opensource.com>
        <20170829074748.yldwq2gktgefzuaa@valkosipuli.retiisi.org.uk>
        <20170829100750.6852b64f@recife.lan>
        <20171005082107.i76vntyg5ku5hqr7@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 5 Oct 2017 11:21:07 +0300
Sakari Ailus <sakari.ailus@iki.fi> escreveu:

> Hi Mauro,
> 
> My apologies for the late reply.
> 
> On Tue, Aug 29, 2017 at 10:07:50AM -0300, Mauro Carvalho Chehab wrote:
> > Em Tue, 29 Aug 2017 10:47:48 +0300
> > Sakari Ailus <sakari.ailus@iki.fi> escreveu:
> >   
> > > Hi Mauro,
> > > 
> > > Thanks for the update. A few comments below.
> > > 
> > > On Mon, Aug 28, 2017 at 09:53:55AM -0300, Mauro Carvalho Chehab wrote:  
> > > > Add a glossary of terms for V4L2, as several concepts are complex
> > > > enough to cause misunderstandings.
> > > > 
> > > > Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> > > > ---
> > > >  Documentation/media/uapi/v4l/glossary.rst | 147 ++++++++++++++++++++++++++++++
> > > >  Documentation/media/uapi/v4l/v4l2.rst     |   1 +
> > > >  2 files changed, 148 insertions(+)
> > > >  create mode 100644 Documentation/media/uapi/v4l/glossary.rst
> > > > 
> > > > diff --git a/Documentation/media/uapi/v4l/glossary.rst b/Documentation/media/uapi/v4l/glossary.rst
> > > > new file mode 100644
> > > > index 000000000000..0b6ab5adec81
> > > > --- /dev/null
> > > > +++ b/Documentation/media/uapi/v4l/glossary.rst
> > > > @@ -0,0 +1,147 @@
> > > > +========
> > > > +Glossary
> > > > +========
> > > > +
> > > > +.. note::
> > > > +
> > > > +   This goal of section is to standardize the terms used within the V4L2
> > > > +   documentation. It is written incrementally as they are standardized in
> > > > +   the V4L2 documentation. So, it is a Work In Progress.    
> > > 
> > > I'd leave the WiP part out.  
> > 
> > IMO, it is important to mention it, as the glossary, right now, covers
> > only what's used on the first two sections of the API book. There are
> > a lot more to be covered.  
> 
> Works for me.
> 
> >   
> > >   
> > > > +
> > > > +.. Please keep the glossary entries in alphabetical order
> > > > +
> > > > +.. glossary::
> > > > +
> > > > +    Bridge driver
> > > > +	The same as V4L2 main driver.    
> > > 
> > > I've understood bridges being essentially a bus receiver + DMA. Most ISPs
> > > contain both but have more than that. How about:
> > > 
> > > A driver for a bus (e.g. parallel, CSI-2) receiver and DMA. Bridge drivers
> > > typically act as V4L2 main drivers.  
> > 
> > No, only on some drivers the bridge driver has DMA. A vast amount of
> > drivers (USB ones) don't implement any DMA inside the driver, as it is
> > up to the USB host driver to implement support for DMA.
> > 
> > There are even some USB host drivers that don't always use DMA for I/O 
> > transfers, using direct I/O if the message is smaller than a threshold
> > or not multiple of the bus word. This is pretty common on SoC USB host
> > drivers.
> > 
> > In any case, for the effect of this spec, and for all discussions we
> > ever had about it, bridge driver == V4L2 main driver. I don't
> > see any reason why to distinguish between them.  
> 
> I think you should precisely define what a bridge driver means. Generally
> ISP drivers aren't referred to as bridge drivers albeit they, too, function
> as V4L2 main drivers.

Btw, this is already defined, currently, at v4l2-subdev.h:

 * Sub-devices are devices that are connected somehow to the main bridge
 * device. These devices are usually audio/video muxers/encoders/decoders or
 * sensors and webcam controllers.
 *
 * Usually these devices are controlled through an i2c bus, but other busses
 * may also be used.

Please notice that there it says: "main bridge" :-)

Such definition was added since the beginning of the subdev concept, back in
2008 and was reviewed by several V4L core developers:

commit 2a1fcdf08230522bd5024f91da24aaa6e8d81f59
Author: Hans Verkuil <hverkuil@xs4all.nl>
Date:   Sat Nov 29 21:36:58 2008 -0300

    V4L/DVB (9820): v4l2: add v4l2_device and v4l2_subdev structs to the v4l2 framework.
    
    Start implementing a proper v4l2 framework as discussed during the
    Linux Plumbers Conference 2008.
    
    Introduces v4l2_device (for device instances) and v4l2_subdev (representing
    sub-device instances).
    
    Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
    Reviewed-by: Laurent Pinchart <laurent.pinchart@skynet.be>
    Reviewed-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
    Reviewed-by: Andy Walls <awalls@radix.net>
    Reviewed-by: David Brownell <david-b@pacbell.net>
    Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>


Thanks,
Mauro
