Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:46197
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S932541AbdC3Kv7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 30 Mar 2017 06:51:59 -0400
Date: Thu, 30 Mar 2017 07:51:49 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        John Youn <johnyoun@synopsys.com>, linux-usb@vger.kernel.org,
        linux-rpi-kernel@lists.infradead.org,
        Jonathan Corbet <corbet@lwn.net>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        David Mosberger <davidm@egauge.net>,
        Oliver Neukum <oneukum@suse.com>,
        Roger Quadros <rogerq@ti.com>,
        Jaejoong Kim <climbbb.kim@gmail.com>,
        Wolfram Sang <wsa-dev@sang-engineering.com>
Subject: Re: [PATCH 22/22] usb: document that URB transfer_buffer should be
 aligned
Message-ID: <20170330075149.334d88a8@vento.lan>
In-Reply-To: <1832248.RT1uOmH7Wy@avalon>
References: <4f2a7480ba9a3c89e726869fddf17e31cf82b3c7.1490813422.git.mchehab@s-opensource.com>
        <1822963.cezI9HmAB6@avalon>
        <20170329220633.51692689@vento.lan>
        <1832248.RT1uOmH7Wy@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 30 Mar 2017 12:38:42 +0300
Laurent Pinchart <laurent.pinchart@ideasonboard.com> escreveu:

> Hi Mauro,
> 
> On Wednesday 29 Mar 2017 22:06:33 Mauro Carvalho Chehab wrote:
> > Em Thu, 30 Mar 2017 01:15:27 +0300 Laurent Pinchart escreveu:  
> > > On Wednesday 29 Mar 2017 15:54:21 Mauro Carvalho Chehab wrote:  
> > > > Several host controllers, commonly found on ARM, like dwc2,
> > > > require buffers that are CPU-word aligned for they to work.
> > > > 
> > > > Failing to do that will cause random troubles at the caller
> > > > drivers, causing them to fail.
> > > > 
> > > > Document it.
> > > > 
> > > > Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> > > > ---
> > > > 
> > > >  Documentation/driver-api/usb/URB.rst | 18 ++++++++++++++++++
> > > >  drivers/usb/core/message.c           | 15 +++++++++++++++
> > > >  include/linux/usb.h                  | 18 ++++++++++++++++++
> > > >  3 files changed, 51 insertions(+)
> > > > 
> > > > diff --git a/Documentation/driver-api/usb/URB.rst
> > > > b/Documentation/driver-api/usb/URB.rst index d9ea6a3996e7..b83b557e9891
> > > > 100644
> > > > --- a/Documentation/driver-api/usb/URB.rst
> > > > +++ b/Documentation/driver-api/usb/URB.rst
> > > > @@ -274,6 +274,24 @@ If you specify your own start frame, make sure it's
> > > > several frames in advance of the current frame.  You might want this
> > > > model
> > > > if you're synchronizing ISO data with some other event stream.
> > > > 
> > > > +.. note::
> > > > +
> > > > +   Several host drivers require that the ``transfer_buffer`` to be
> > > > aligned
> > > > +   with the CPU word size (e. g. DWORD for 32 bits, QDWORD for 64
> > > > bits).  
> > > 
> > > Is it the CPU word size or the DMA transfer size ? I assume the latter,
> > > and I wouldn't be surprised if the alignment requirement was 32-bit on at
> > > least some of the 64-bit platforms.  
> > 
> > Yeah, it is actually the DMA transfer size. Yet, worse case scenario is that
> > the DMA transfer size to be 64 bits on 64 bits CPU.
> >   
> > > > +   It is up to USB drivers should ensure that they'll only pass buffers
> > > > +   with such alignments.
> > > > +
> > > > +   Please also notice that, due to such restriction, the host driver  
> > > 
> > > s/notice/note/ (and below as well) ?  
> > 
> > OK.
> >   
> > > > +   may also override PAD bytes at the end of the ``transfer_buffer``,
> > > > up to the
> > > > +   size of the CPU word.  
> > > 
> > > "May" is quite weak here. If some host controller drivers require buffers
> > > to be aligned, then it's an API requirement, and all buffers must be
> > > aligned. I'm not even sure I would mention that some host drivers require
> > > it, I think we should just state that the API requires buffers to be
> > > aligned.  
> > 
> > What I'm trying to say here is that, on a 32-bits system, if the driver do
> > a USB_DIR_IN transfer using some code similar to:
> > 
> > 	size = 4;
> > 	buffer = kmalloc(size, GFP_KERNEL);
> > 
> > 	usb_control_msg(udev, pipe, req, type, val, idx, buffer + 2, 2,   
> timeout);
> > 	usb_control_msg(udev, pipe, req, type, val, idx, buffer, size,   
> timeout);
> > 
> > Drivers like dwc2 will mess with the buffer.
> > 
> > The first transfer will actually work, due to a workaround inside the
> > driver that will create a temporary DWORD-aligned buffer, avoiding it
> > to go past the buffer.
> > 
> > However, the second transfer will destroy the data received from the
> > first usb_control_msg(), as it will write 4 bytes at the buffer.
> > 
> > Not all drivers would do that, though.
> > 
> > Please notice that, as kmalloc will always return a CPU-aligned buffer,
> > if the client do something like:
> > 
> > 	size = 2;
> > 	buffer = kmalloc(size, GFP_KERNEL);
> > 
> > 	usb_control_msg(udev, pipe, req, type, val, idx, buffer, 2, timeout);
> > 
> > What happens there is that the DMA engine will still write 4 bytes at
> > the buffer, but the 2 bytes that go past the end of buffer will be
> > written on a memory that will never be used.  
> 
> I understand that, but stating that host controller drivers "may" do this 
> won't help much. If they *may*, all USB device drivers *must* align buffers 
> correctly. That's the part that needs to be documented. Let's not confuse 
> developers by only stating that something may happened, let's be clear and 
> tell what they must do.

Ok, rewrote the entire text. Please see if the new version
works better.

> 
> > > > +   Please notice that ancillary routines that transfer URBs, like
> > > > +   usb_control_msg() also have such restriction.
> > > > +
> > > > +   Such word alignment condition is normally ensured if the buffer is
> > > > +   allocated with kmalloc(), but this may not be the case if the driver
> > > > +   allocates a bigger buffer and point to a random place inside it.
> > > > +
> > > > 
> > > >  How to start interrupt (INT) transfers?
> > > >  =======================================
> > > > 
> > > > diff --git a/drivers/usb/core/message.c b/drivers/usb/core/message.c
> > > > index 4c38ea41ae96..1662a4446475 100644
> > > > --- a/drivers/usb/core/message.c
> > > > +++ b/drivers/usb/core/message.c
> > > > @@ -128,6 +128,21 @@ static int usb_internal_control_msg(struct
> > > > usb_device
> > > > *usb_dev, * make sure your disconnect() method can wait for it to
> > > > complete.
> > > > Since you * don't have a handle on the URB used, you can't cancel the
> > > > request. *
> > > > + * .. note::
> > > > + *
> > > > + *   Several host drivers require that the @data buffer to be aligned
> > > > + *   with the CPU word size (e. g. DWORD for 32 bits, QDWORD for 64
> > > > bits).
> > > > + *   It is up to USB drivers should ensure that they'll only pass
> > > > buffers
> > > > + *   with such alignments.
> > > > + *
> > > > + *   Please also notice that, due to such restriction, the host driver
> > > > + *   may also override PAD bytes at the end of the @data buffer, up to
> > > > the
> > > > + *   size of the CPU word.
> > > > + *
> > > > + *   Such word alignment condition is normally ensured if the buffer is
> > > > + *   allocated with kmalloc(), but this may not be the case if the
> > > > driver
> > > > + *   allocates a bigger buffer and point to a random place inside it.
> > > > + *
> > > > 
> > > >   * Return: If successful, the number of bytes transferred. Otherwise, a
> > > > 
> > > > negative * error number.
> > > > 
> > > >   */
> > > > 
> > > > diff --git a/include/linux/usb.h b/include/linux/usb.h
> > > > index 7e68259360de..8b5ad6624708 100644
> > > > --- a/include/linux/usb.h
> > > > +++ b/include/linux/usb.h
> > > > @@ -1373,6 +1373,24 @@ typedef void (*usb_complete_t)(struct urb *);
> > > > 
> > > >   * capable, assign NULL to it, so that usbmon knows not to use the
> > > >   value.
> > > >   * The setup_packet must always be set, so it cannot be located in
> > > >   highmem.
> > > > 
> > > > *
> > > > + * .. note::
> > > > + *
> > > > + *   Several host drivers require that the @transfer_buffer to be
> > > > aligned
> > > > + *   with the CPU word size (e. g. DWORD for 32 bits, QDWORD for 64
> > > > bits).
> > > > + *   It is up to USB drivers should ensure that they'll only pass
> > > > buffers
> > > > + *   with such alignments.
> > > > + *
> > > > + *   Please also notice that, due to such restriction, the host driver
> > > > + *   may also override PAD bytes at the end of the @transfer_buffer, up
> > > > to
> > > > the + *   size of the CPU word.
> > > > + *
> > > > + *   Please notice that ancillary routines that start URB transfers,
> > > > like
> > > > + *   usb_control_msg() also have such restriction.
> > > > + *
> > > > + *   Such word alignment condition is normally ensured if the buffer is
> > > > + *   allocated with kmalloc(), but this may not be the case if the
> > > > driver
> > > > + *   allocates a bigger buffer and point to a random place inside it.
> > > > + *  
> > > 
> > > Couldn't we avoid three copies of the same text ? The chance they will get
> > > out-of-sync is quite high.  
> > 
> > IMHO, it is better to document it at those 3 parts, as this issue
> > cause buffer overflows, which is pretty serious, as it corrupts data.
> > 
> > The URB.rst file contains a quick overview of the URB data transfers,
> > and it is likely where a kernel newbie would read first. Experienced
> > programmers will look at urb.h.
> > 
> > usb_control_msg() is a different function, that one might not be
> > expecting to have the same issues.  
> 
> If you add the complete explanation to URB.rst, you can then reference it from 
> the functions' kerneldoc instead of copying it.

True, but URB.txt has a note saying that the document may not be
fully updated, implying that urb.h header is the main reference.

So, I stand that the best here is to have this warning duplicated,
as this is a pretty serious issue and will require people to review
all USB drivers.

Thanks,
Mauro
