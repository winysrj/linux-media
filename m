Return-path: <linux-media-owner@vger.kernel.org>
Received: from resqmta-ch2-08v.sys.comcast.net ([69.252.207.40]:40940 "EHLO
        resqmta-ch2-08v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932749AbdC3QfZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 30 Mar 2017 12:35:25 -0400
Subject: Re: [PATCH 1/3] [media] mceusb: RX -EPIPE (urb status = -32) lockup
 failure fix
To: Sean Young <sean@mess.org>
References: <58D6A1DD.2030405@comcast.net>
 <20170326102748.GA1672@gofer.mess.org> <58D80838.8050809@comcast.net>
 <20170326203130.GA6070@gofer.mess.org> <58D8CAD9.80304@comcast.net>
 <20170328202516.GA27790@gofer.mess.org> <58DB1075.60302@comcast.net>
 <20170329210645.GA6080@gofer.mess.org> <58DC2F89.7000304@comcast.net>
 <20170330071222.GA9579@gofer.mess.org>
Cc: linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>
From: A Sun <as1033x@comcast.net>
Message-ID: <58DD33C5.2020202@comcast.net>
Date: Thu, 30 Mar 2017 12:35:17 -0400
MIME-Version: 1.0
In-Reply-To: <20170330071222.GA9579@gofer.mess.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 3/30/2017 3:12 AM, Sean Young wrote:
> On Wed, Mar 29, 2017 at 06:04:58PM -0400, A Sun wrote:
>> On 3/29/2017 5:06 PM, Sean Young wrote:
>> <snip>
>>>
>>> Anyway, you're right and this patch looks ok. It would be nice to have the
>>> tx case handled too though.
>>>
>>> Thanks
>>> Sean
>>>
>>
>> Thanks; I'm looking at handling the tx case. If I can figure out the details, I'll post a new patch proposal separate, and likely dependent, on this one.
>>
>> My main obstacle at the moment, is I'm looking for a way to get mceusb device to respond with a USB TX error halt/stall (rather than the typical ACK and NAK) on a TX endpoint, in order to test halt/stall error detection and recovery for TX. ..A Sun
> 
> If you send IR, the drivers send a usb packet. However, the kernel will
> sleep for however long the IR is in ir_lirc_transmit_ir, so your other option
> is to set the transmit carrier repeatedly instead. You'd have to set the
> carrier to a different value every time.
> 
> 
> {
> 	int fd, carrier;
> 
> 	fd = open("/dev/lirc0", O_RDWR);
> 	carrier = 38000;
> 	for (;;) {
> 		ioctl(fd, LIRC_SET_SEND_CARRIER, &carrier);
> 		if (++carrier >= 40000)
> 			carrier = 38000;
> 	}
> }
> 
> 
> Sean
> 

Thanks, this is good to know, for testing where multiple TX I/Os are pending prior to fault. 

I found a way to set up the TX -EPIPE fault administratively:

	retval = usb_control_msg(ir->usbdev, usb_sndctrlpipe(ir->usbdev, 0),
		USB_REQ_SET_FEATURE, USB_RECIP_ENDPOINT,
		USB_ENDPOINT_HALT, usb_pipeendpoint(ir->pipe_out),
		NULL, 0, USB_CTRL_SET_TIMEOUT);
	dev_dbg(ir->dev, "set halt retval, %d", retval);
	
and have replications now for TX error and lock -out. Error occurs for every TX. No message flooding otherwise, as we expect. The RX side remains working.

...
[  249.986174] mceusb 1-1.2:1.0: requesting 38000 HZ carrier
[  249.986210] mceusb 1-1.2:1.0: send request called (size=0x4)
[  249.986256] mceusb 1-1.2:1.0: send request complete (res=0)
[  249.986403] mceusb 1-1.2:1.0: Error: request urb status = -32 (TX HALT)
[  249.999885] mceusb 1-1.2:1.0: send request called (size=0x3)
[  249.999929] mceusb 1-1.2:1.0: send request complete (res=0)
[  250.000013] mceusb 1-1.2:1.0: Error: request urb status = -32 (TX HALT)
[  250.019830] mceusb 1-1.2:1.0: send request called (size=0x21)
[  250.019868] mceusb 1-1.2:1.0: send request complete (res=0)
[  250.020007] mceusb 1-1.2:1.0: Error: request urb status = -32 (TX HALT)
...
