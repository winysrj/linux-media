Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:58898 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751369AbdJFIFl (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 6 Oct 2017 04:05:41 -0400
Date: Fri, 6 Oct 2017 11:05:38 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
        laurent.pinchart@ideasonboard.com
Subject: Re: [PATCH v5 1/7] media: add glossary.rst with a glossary of terms
 used at V4L2 spec
Message-ID: <20171006080538.2fcduqn2yiafj5qp@valkosipuli.retiisi.org.uk>
References: <cover.1503924361.git.mchehab@s-opensource.com>
 <65af989db9cc5479b863657add04940ae6de9d5c.1503924361.git.mchehab@s-opensource.com>
 <20170829074748.yldwq2gktgefzuaa@valkosipuli.retiisi.org.uk>
 <20170829100750.6852b64f@recife.lan>
 <20171005082107.i76vntyg5ku5hqr7@valkosipuli.retiisi.org.uk>
 <20171005153929.0433df38@recife.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171005153929.0433df38@recife.lan>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Oct 05, 2017 at 03:39:29PM -0300, Mauro Carvalho Chehab wrote:
> Em Thu, 5 Oct 2017 11:21:07 +0300
> Sakari Ailus <sakari.ailus@iki.fi> escreveu:
> 
> > Hi Mauro,
> > 
> > My apologies for the late reply.
> > 
> > On Tue, Aug 29, 2017 at 10:07:50AM -0300, Mauro Carvalho Chehab wrote:
> > > Em Tue, 29 Aug 2017 10:47:48 +0300
> > > Sakari Ailus <sakari.ailus@iki.fi> escreveu:
> > >   
> > > > Hi Mauro,
> > > > 
> > > > Thanks for the update. A few comments below.
> > > > 
> > > > On Mon, Aug 28, 2017 at 09:53:55AM -0300, Mauro Carvalho Chehab wrote:  
> > > > > Add a glossary of terms for V4L2, as several concepts are complex
> > > > > enough to cause misunderstandings.
> > > > > 
> > > > > Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> > > > > ---
> > > > >  Documentation/media/uapi/v4l/glossary.rst | 147 ++++++++++++++++++++++++++++++
> > > > >  Documentation/media/uapi/v4l/v4l2.rst     |   1 +
> > > > >  2 files changed, 148 insertions(+)
> > > > >  create mode 100644 Documentation/media/uapi/v4l/glossary.rst
> > > > > 
> > > > > diff --git a/Documentation/media/uapi/v4l/glossary.rst b/Documentation/media/uapi/v4l/glossary.rst
> > > > > new file mode 100644
> > > > > index 000000000000..0b6ab5adec81
> > > > > --- /dev/null
> > > > > +++ b/Documentation/media/uapi/v4l/glossary.rst
> > > > > @@ -0,0 +1,147 @@
> > > > > +========
> > > > > +Glossary
> > > > > +========
> > > > > +
> > > > > +.. note::
> > > > > +
> > > > > +   This goal of section is to standardize the terms used within the V4L2
> > > > > +   documentation. It is written incrementally as they are standardized in
> > > > > +   the V4L2 documentation. So, it is a Work In Progress.    
> > > > 
> > > > I'd leave the WiP part out.  
> > > 
> > > IMO, it is important to mention it, as the glossary, right now, covers
> > > only what's used on the first two sections of the API book. There are
> > > a lot more to be covered.  
> > 
> > Works for me.
> > 
> > >   
> > > >   
> > > > > +
> > > > > +.. Please keep the glossary entries in alphabetical order
> > > > > +
> > > > > +.. glossary::
> > > > > +
> > > > > +    Bridge driver
> > > > > +	The same as V4L2 main driver.    
> > > > 
> > > > I've understood bridges being essentially a bus receiver + DMA. Most ISPs
> > > > contain both but have more than that. How about:
> > > > 
> > > > A driver for a bus (e.g. parallel, CSI-2) receiver and DMA. Bridge drivers
> > > > typically act as V4L2 main drivers.  
> > > 
> > > No, only on some drivers the bridge driver has DMA. A vast amount of
> > > drivers (USB ones) don't implement any DMA inside the driver, as it is
> > > up to the USB host driver to implement support for DMA.
> > > 
> > > There are even some USB host drivers that don't always use DMA for I/O 
> > > transfers, using direct I/O if the message is smaller than a threshold
> > > or not multiple of the bus word. This is pretty common on SoC USB host
> > > drivers.
> > > 
> > > In any case, for the effect of this spec, and for all discussions we
> > > ever had about it, bridge driver == V4L2 main driver. I don't
> > > see any reason why to distinguish between them.  
> > 
> > I think you should precisely define what a bridge driver means. Generally
> > ISP drivers aren't referred to as bridge drivers albeit they, too, function
> > as V4L2 main drivers.
> 
> Btw, this is already defined, currently, at v4l2-subdev.h:
> 
>  * Sub-devices are devices that are connected somehow to the main bridge
>  * device. These devices are usually audio/video muxers/encoders/decoders or
>  * sensors and webcam controllers.
>  *
>  * Usually these devices are controlled through an i2c bus, but other busses
>  * may also be used.
> 
> Please notice that there it says: "main bridge" :-)
> 
> Such definition was added since the beginning of the subdev concept, back in
> 2008 and was reviewed by several V4L core developers:

A lot has happened since 2008. :-)

Anyway, I'll review the latest set.

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
