Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:40612 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751873AbdHKJRV (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 11 Aug 2017 05:17:21 -0400
Date: Fri, 11 Aug 2017 12:17:18 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [GIT PULL for 4.14] Stream control documentation
Message-ID: <20170811091718.7tpf7oixvfdff2yh@valkosipuli.retiisi.org.uk>
References: <20170809080340.4c5b4jjypqiqyllp@valkosipuli.retiisi.org.uk>
 <20170809122917.0461db2c@vento.lan>
 <20170809125757.57cd8d2b@vento.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20170809125757.57cd8d2b@vento.lan>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On Wed, Aug 09, 2017 at 12:57:57PM -0300, Mauro Carvalho Chehab wrote:
> Em Wed, 9 Aug 2017 12:29:17 -0300
> Mauro Carvalho Chehab <mchehab@s-opensource.com> escreveu:
> 
> > Em Wed, 9 Aug 2017 11:03:40 +0300
> > Sakari Ailus <sakari.ailus@iki.fi> escreveu:
> > 
> > > Hi Mauro,
> > > 
> > > Add stream control documentation.
> > > 
> > > We have recently added support for hardware that makes it possible to have
> > > pipelines that are controlled by more than two drivers. This necessitates
> > > documenting V4L2 stream control behaviour for such pipelines.  
> > 
> > Perhaps I missed this one, but I'm not seeing any e-mail with
> > 	"docs-rst: media: Document s_stream() video op usage"
> > 
> > Please always submit patches via e-mail too, as it makes easier for
> > us to comment/review when needed.
> > 
> > In any case, I'm appending the patch contents here. I'll reply to it
> > on a next e-mail.
> > 
> > > From ef8e5d20b45b05290c56450d2130a0dc3c021c5a Mon Sep 17 00:00:00 2001
> > > From: Sakari Ailus <sakari.ailus@linux.intel.com>
> > > Date: Thu, 9 Mar 2017 15:07:57 +0200
> > > Subject: docs-rst: media: Document s_stream() video op usage
> > > MIME-Version: 1.0
> > > Content-Type: text/plain; charset=UTF-8
> > > Content-Transfer-Encoding: 8bit
> > > Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
> > >     Mauro Carvalho Chehab <mchehab@infradead.org>
> > > 
> > > As we begin to add support for systems with media pipelines controlled by
> > > more than one device driver, it is essential that we precisely define the
> > > responsibilities of each component in the stream control and common
> > > practices.
> 
> Not sure what you meant here. Currently, there is support already
> for multiple subdevs attached to a driver.

That's not really what this is about. This is about "pipelines controlled
by more than one device driver".

The core of the problem is in starting and stopping the streaming. This may
require performing operations on hardware *before* the pipeline upstream
hardware is started (by calling s_stream() op on that sub-device) as well
as afterwards. In a simple example:


		    parallel	  CSI-2
		      bus	   bus
		       |            |
hardware	sensor -> converter -> receiver + DMA

driver		A	  B	       C

If the s_stream() op on sensor driver A will be called by the driver C,
there is no way for the converter driver B to perform hardware
configurations before and after streaming has started on the sensor.

This is why s_stream() on A needs to be called by B.

> 
> As we're talking here about kAPI, it is quite common that a V4L2 the
> need to set multiple devices while stream. A typical non-MC device like
> bttv can set up to 4 types of devices:
> 	- tuner;
> 	- audio decoder;
> 	- video decoder;
> 	- video enhancers.
> 
> > > Specifically, this patch documents two things:
> > > 
> > > 1) streaming control is done per sub-device and sub-device drivers
> > > themselves are responsible for streaming setup in upstream sub-devices and
> 
> In the case of non-MC devices, it is the bridge driver that it is
> responsible to pass a "broadcast" message to all subdevices for
> them to be at "stream mode".

Yes, this need to be precised: it only applies to devices that have MC
controlled pipelines.

> 
> > > 
> > > 2) broken frames should be tolerated at streaming stop. It is the
> > > responsibility of the sub-device driver to stop the transmitter after
> > > itself if it cannot handle broken frames (and it should be probably be
> > > done anyway).
> 
> You should define what you mean by "transmitter".

On a data bus such as CSI-2. I'll add that to next version.

> 
> > > 
> > > Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> > > Acked-by: Niklas S�derlund <niklas.soderlund+renesas@ragnatech.se>
> > > ---
> > >  Documentation/media/kapi/v4l2-subdev.rst | 36 ++++++++++++++++++++++++++++++++
> > >  1 file changed, 36 insertions(+)
> > > 
> > > diff --git a/Documentation/media/kapi/v4l2-subdev.rst b/Documentation/media/kapi/v4l2-subdev.rst
> > > index e1f0b726e438..100ffc783f72 100644
> > > --- a/Documentation/media/kapi/v4l2-subdev.rst
> > > +++ b/Documentation/media/kapi/v4l2-subdev.rst
> > > @@ -262,6 +262,42 @@ is called. After all subdevices have been located the .complete() callback is
> > >  called. When a subdevice is removed from the system the .unbind() method is
> > >  called. All three callbacks are optional.
> > >  
> > > +Streaming control
> > > +^^^^^^^^^^^^^^^^^
> > > +
> > > +Starting and stopping the stream are somewhat complex operations that
> > > +often require walking the media graph to enable streaming on
> > > +sub-devices which the pipeline consists of. This involves interaction
> > > +between multiple drivers, sometimes more than two.
> > > +
> > > +The ``.s_stream()`` op in :c:type:`v4l2_subdev_video_ops` is responsible
> > > +for starting and stopping the stream on the sub-device it is called on.
> > > +Additionally, if there are sub-devices further up in the pipeline, i.e.
> > > +connected to that sub-device's sink pads through enabled links, the
> > > +sub-device driver must call the ``.s_stream()`` video op of all such
> > > +sub-devices. The sub-device driver is thus in control of whether the
> > > +upstream sub-devices start (or stop) streaming before or after the
> > > +sub-device itself is set up for streaming.
> 
> Why the sub-device? Even in the MC case, the stream on operation is
> usually called via the v4l devnode, where the DMA engine is.

This works as long as there are two drivers only involved. We're beginning
to have cases with more than that --- please see my first reply chunk.

> 
> > > +
> > > +.. note::
> > > +
> > > +   As the ``.s_stream()`` callback is called recursively through the
> > > +   sub-devices along the pipeline, it is important to keep the
> > > +   recursion as short as possible. To this end, drivers are encouraged
> > > +   not to internally call ``.s_stream()`` recursively in order to make
> > > +   only a single additional recursion per driver in the pipeline. This
> > > +   greatly reduces stack usage.
> 
> what "drivers" are encouraged not to ...?

If a driver consists of multiple sub-devices that are in the same pipeline,
then the driver is basically free to choose how to implement s_stream()
call it got from the downstream driver in the pipeline. This statement is
added to decrease stack usage; pipelines can be long but there are still
just a few drivers involved. Let me see if I can find a better wording for
that.

> 
> > > +
> > > +Stopping the transmitter
> > > +^^^^^^^^^^^^^^^^^^^^^^^^
> 
> What is a transmitter? There are only two places inside kAPI that
> uses the word "transmitter":
> 	Documentation/media/kapi/cec-core.rst
> 	Documentation/media/kapi/csi2.rst
> 
> On both documents, the meaning of the term is clear, but I can't
> understand what you mean by "transmitter" at the subdev's core
> documentation. Is it the tuner? the bridge driver? a CSI bus?
> the DMA engine? all of them?

It's on a data bus that typically exists between hardware blocks the
pipeline through which is controlled through MC. I'll fix that for the next
version.

> 
> > > +
> > > +A transmitter stops sending the stream of images as a result of
> > > +calling the ``.s_stream()`` callback. Some transmitters may stop the
> > > +stream at a frame boundary whereas others stop immediately,
> > > +effectively leaving the current frame unfinished. The receiver driver
> > > +should not make assumptions either way, but function properly in both
> > > +cases.
> > > +
> > >  V4L2 sub-device userspace API
> > >  -----------------------------
> > >  

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
