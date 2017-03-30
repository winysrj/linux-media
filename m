Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:47261
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S933356AbdC3PpL (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 30 Mar 2017 11:45:11 -0400
Date: Thu, 30 Mar 2017 12:45:01 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Oliver Neukum <oneukum@suse.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        David Mosberger <davidm@egauge.net>,
        Jaejoong Kim <climbbb.kim@gmail.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        GregKroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-rpi-kernel@lists.infradead.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Wolfram Sang <wsa-dev@sang-engineering.com>,
        John Youn <johnyoun@synopsys.com>,
        Roger Quadros <rogerq@ti.com>,
        Linux Doc MailingList <linux-doc@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        USB list <linux-usb@vger.kernel.org>
Subject: Re: [PATCH 22/22] usb: document that URB transfer_buffer should be
 aligned
Message-ID: <20170330124501.6ba20ded@vento.lan>
In-Reply-To: <Pine.LNX.4.44L0.1703301024090.2186-100000@iolanthe.rowland.org>
References: <1490878570.11920.6.camel@suse.com>
        <Pine.LNX.4.44L0.1703301024090.2186-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 30 Mar 2017 10:26:32 -0400 (EDT)
Alan Stern <stern@rowland.harvard.edu> escreveu:

> On Thu, 30 Mar 2017, Oliver Neukum wrote:
> 
> > > Btw, I'm a lot more concerned about USB storage drivers. When I was
> > > discussing about this issue at the #raspberrypi-devel IRC channel,
> > > someone complained that, after switching from the RPi downstream Kernel
> > > to upstream, his USB data storage got corrupted. Well, if the USB
> > > storage drivers also assume that the buffer can be continuous,
> > > that can corrupt data.  
> 
> > 
> > They do assume that.  
> 
> Wait a minute.  Where does that assumption occur?
> 
> And exactly what is the assumption?  Mauro wrote "the buffer can be 
> continuous", but that is certainly not what he meant.

What I meant to say is that drivers like the uvcdriver (and maybe network and
usb-storage drivers) may allocate a big buffer and get data there on some
random order, e. g.: 

int get_from_buf_pos(char *buf, int pos, int size)
{
	/* or an equivalent call to usb_submit_urb() */
	usb_control_msg(..., buf + pos, size, ...);
}

some_function ()
{
	...

	chr *buf = kzalloc(4, GFP_KERNEL);

	/* 
	 * Access the bytes at the array on a random order, with random size,
	 * Like:
	 */
	get_from_buf_pos(buf, 2, 2);	/* should read 0x56, 0x78 */
	get_from_buf_pos(buf, 0, 2);	/* should read 0x12, 0x34 */

	/*
	 * the expected value for the buffer would be:
	 * 	{ 0x12, 0x34, 0x56, 0x78 }
	 */

E. g. they assume that the transfer URB can work with any arbitrary
pointer and size, without needing of pre-align them.

This doesn't work with HCD drivers like dwc2, as each USB_IN operation will
actually write 4 bytes to the buffer.

So, what happens, instead, is that each data transfer will get four
bytes. Due to a hack inside dwc2, with checks if the transfer_buffer
is DWORD aligned. So, the first transfer will do what's expected: it will
read 4 bytes to a temporary buffer, allocated inside the driver,
copying just two bytes to buf. So, after the first read, the
buffer content will be:

	buf = { 0x00, x00, 0x56, 0x78 }

But, on the second read, it won't be using any temporary
buffer. So, instead of reading a 16-bits word (0x5678),
it will actually read 32 bits, with 16-bits with some random value,
causing a buffer overflow. E. g. buffer content will now be:

	buf = { 0x12, x34, 0xde, 0xad }

In other words, the second transfer corrupted the data from the
first transfer.

Thanks,
Mauro
