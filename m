Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:51137 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932377AbdC3HMY (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 30 Mar 2017 03:12:24 -0400
Date: Thu, 30 Mar 2017 08:12:22 +0100
From: Sean Young <sean@mess.org>
To: A Sun <as1033x@comcast.net>
Cc: linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Subject: Re: [PATCH 1/3] [media] mceusb: RX -EPIPE (urb status = -32) lockup
 failure fix
Message-ID: <20170330071222.GA9579@gofer.mess.org>
References: <58D6A1DD.2030405@comcast.net>
 <20170326102748.GA1672@gofer.mess.org>
 <58D80838.8050809@comcast.net>
 <20170326203130.GA6070@gofer.mess.org>
 <58D8CAD9.80304@comcast.net>
 <20170328202516.GA27790@gofer.mess.org>
 <58DB1075.60302@comcast.net>
 <20170329210645.GA6080@gofer.mess.org>
 <58DC2F89.7000304@comcast.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <58DC2F89.7000304@comcast.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Mar 29, 2017 at 06:04:58PM -0400, A Sun wrote:
> On 3/29/2017 5:06 PM, Sean Young wrote:
> <snip>
> > 
> > Anyway, you're right and this patch looks ok. It would be nice to have the
> > tx case handled too though.
> > 
> > Thanks
> > Sean
> > 
> 
> Thanks; I'm looking at handling the tx case. If I can figure out the details, I'll post a new patch proposal separate, and likely dependent, on this one.
> 
> My main obstacle at the moment, is I'm looking for a way to get mceusb device to respond with a USB TX error halt/stall (rather than the typical ACK and NAK) on a TX endpoint, in order to test halt/stall error detection and recovery for TX. ..A Sun

If you send IR, the drivers send a usb packet. However, the kernel will
sleep for however long the IR is in ir_lirc_transmit_ir, so your other option
is to set the transmit carrier repeatedly instead. You'd have to set the
carrier to a different value every time.


{
	int fd, carrier;

	fd = open("/dev/lirc0", O_RDWR);
	carrier = 38000;
	for (;;) {
		ioctl(fd, LIRC_SET_SEND_CARRIER, &carrier);
		if (++carrier >= 40000)
			carrier = 38000;
	}
}


Sean
