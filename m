Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:46359
	"EHLO s-opensource.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750717AbcGLN2A (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 12 Jul 2016 09:28:00 -0400
Date: Tue, 12 Jul 2016 10:27:51 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Sean Young <sean@mess.org>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH 08/20] [media] doc-rst: document ioctl LIRC_GET_REC_MODE
Message-ID: <20160712102751.57086859@recife.lan>
In-Reply-To: <20160712130159.GA10242@gofer.mess.org>
References: <cover.1468327191.git.mchehab@s-opensource.com>
	<dbe678dd213ea1793ab72885e9ce1b1c8978ebf8.1468327191.git.mchehab@s-opensource.com>
	<20160712130159.GA10242@gofer.mess.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 12 Jul 2016 14:01:59 +0100
Sean Young <sean@mess.org> escreveu:

> On Tue, Jul 12, 2016 at 09:42:02AM -0300, Mauro Carvalho Chehab wrote:
> > Move the documentation of this ioctl from lirc_ioctl to its
> > own file, and add a short description about the pulse mode
> > used by IR RX.
> > 
> > Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> > ---
> >  Documentation/media/uapi/rc/lirc-get-rec-mode.rst  | 59 ++++++++++++++++++++++
> >  .../media/uapi/rc/lirc_device_interface.rst        |  1 +
> >  Documentation/media/uapi/rc/lirc_ioctl.rst         |  9 ----
> >  3 files changed, 60 insertions(+), 9 deletions(-)
> >  create mode 100644 Documentation/media/uapi/rc/lirc-get-rec-mode.rst
> > 
> > diff --git a/Documentation/media/uapi/rc/lirc-get-rec-mode.rst b/Documentation/media/uapi/rc/lirc-get-rec-mode.rst
> > new file mode 100644
> > index 000000000000..d46a488594c9
> > --- /dev/null
> > +++ b/Documentation/media/uapi/rc/lirc-get-rec-mode.rst
> > @@ -0,0 +1,59 @@
> > +.. -*- coding: utf-8; mode: rst -*-
> > +
> > +.. _lirc_get_rec_mode:
> > +
> > +***********************
> > +ioctl LIRC_GET_REC_MODE
> > +***********************
> > +
> > +Name
> > +====
> > +
> > +LIRC_GET_REC_MODE - Get supported receive modes.
> > +
> > +Synopsis
> > +========
> > +
> > +.. cpp:function:: int ioctl( int fd, int request, __u32 rx_modes)
> > +
> > +Arguments
> > +=========
> > +
> > +``fd``
> > +    File descriptor returned by open().
> > +
> > +``request``
> > +    LIRC_GET_REC_MODE
> > +
> > +``rx_modes``
> > +    Bitmask with the supported transmit modes.
> > +
> > +Description
> > +===========
> > +
> > +Get supported receive modes.
> > +
> > +Supported receive modes
> > +=======================
> > +
> > +.. _lirc-mode-mode2:
> > +
> > +``LIRC_MODE_MODE2``
> > +
> > +    The driver returns a sequence of pulse and space codes to userspace.
> > +
> > +.. _lirc-mode-lirccode:
> > +
> > +``LIRC_MODE_LIRCCODE``
> > +
> > +    The IR signal is decoded internally by the receiver. The LIRC interface
> > +    returns the scancode as an integer value. This is the usual mode used
> > +    by several TV media cards.  
> 
> Actually rc devices that produce scancodes (rather than raw IR) do have not
> have an associated lirc device so no LIRC_MODE_LIRCCODE there.

Yeah, I noticed. Yet, the core reports feature = LIRC_MODE_LIRCCODE if the
driver doesn't set features.

> The exception 
> to this is the lirc_sasem and lirc_zilog drivers in staging; those two are the 
> only drivers that use LIRC_MODE_LIRCCODE at all.
> 
> The lirc_sasem driver should be ported to rc-core, but I've never been able
> to find the hardware for it. When it is ported it won't need LIRCCODE any
> more.
> 
> The lirc_zilog driver is just for sending and also should be ported to 
> rc-core. The hardware supports sending raw IR, I just do not know how so
> I can't port it.

Still, it makes sense to have LIRC_MODE_LIRCCODE supported for IR send,
in order to support HDMI CEC. That's why I opted to keep it documented.

Regards,
Mauro
