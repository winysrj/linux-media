Return-path: <linux-media-owner@vger.kernel.org>
Received: from resqmta-ch2-11v.sys.comcast.net ([69.252.207.43]:59096 "EHLO
        resqmta-ch2-11v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751465AbdC0IUJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 27 Mar 2017 04:20:09 -0400
From: A Sun <as1033x@comcast.net>
Subject: Re: [PATCH 1/3] [media] mceusb: RX -EPIPE (urb status = -32) lockup
 failure fix
To: Sean Young <sean@mess.org>
References: <58D6A1DD.2030405@comcast.net>
 <20170326102748.GA1672@gofer.mess.org> <58D80838.8050809@comcast.net>
 <20170326203130.GA6070@gofer.mess.org>
Cc: linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Message-ID: <58D8CAD9.80304@comcast.net>
Date: Mon, 27 Mar 2017 04:18:33 -0400
MIME-Version: 1.0
In-Reply-To: <20170326203130.GA6070@gofer.mess.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 3/26/2017 4:31 PM, Sean Young wrote:
> On Sun, Mar 26, 2017 at 02:28:08PM -0400, A Sun wrote:
>> commit https://github.com/asunxx/linux/commit/17fe3b51f4ad5202a876ea4c92b5d99d4e166823
>> Author: A Sun <as1033x@comcast.net>
>> Date:   Sun, 26 Mar 2017 13:24:18 -0400 
> 
> Please don't include this.
> 
>>
...
>> mceusb 1-1.2:1.0: 2 tx ports (0x1 cabled) and 2 rx sensors (0x1 active)
> 
> It would be nice to have this tested against a mainline kernel. I thought
> that was entirely possible on raspberry pis nowadays.
...
>> +	/* kevent support */
>> +	struct work_struct kevent;
> 
> kevent is not a descriptive name. How about something like clear_halt?
> 
>> +	unsigned long kevent_flags;
>> +#		define EVENT_TX_HALT	0
>> +#		define EVENT_RX_HALT	1
> 
> EVENT_TX_HALT is never used, so kevent_flags is only ever set to 1. The
> entire field can be dropped.
> 
...
>> +	if (!schedule_work(&ir->kevent)) {
>> +		dev_err(ir->dev, "kevent %d may have been dropped", kevent);
>> +	} else {
>> +		dev_dbg(ir->dev, "kevent %d scheduled", kevent);
>> +	}
>> +}
> 
> Again name is not very descriptive.
> 
...
>> +		dev_err(ir->dev, "Error: urb status = %d (RX HALT)",
>> +			urb->status);
>> +		mceusb_defer_kevent(ir, EVENT_RX_HALT);
> 
> Here you could simply call schedule_work(). Note that EPIPE might also
> be returned for device disconnect for some host controllers.
> 
>> +		return;
...
>> +	int status;
>> +
>> +	if (test_bit(EVENT_RX_HALT, &ir->kevent_flags)) {
> 
> If condition can go.
> 
>> +		usb_unlink_urb(ir->urb_in);
>> +		status = usb_clear_halt(ir->usbdev, ir->pipe_in);

Hi Sean,

Thanks again for looking at this. This patch is based on similar error and recovery, with the USB ethernet driver usbnet (usbnet.c, usbnet.h).

In usbnet, they call "kevent" (kernel device event?) any kind of hardware state change or event in interrupt context that requires invoking non-interrupt code to handle. I'm not sure what else I should name it. Possible kevent-s are not limited to situations needing usb_clear_halt(). From usbnet:
 69 #               define EVENT_TX_HALT    0
 70 #               define EVENT_RX_HALT    1
 71 #               define EVENT_RX_MEMORY  2
 72 #               define EVENT_STS_SPLIT  3
 73 #               define EVENT_LINK_RESET 4
 74 #               define EVENT_RX_PAUSED  5
 75 #               define EVENT_DEV_ASLEEP 6
 76 #               define EVENT_DEV_OPEN   7
 77 #               define EVENT_DEVICE_REPORT_IDLE 8
 78 #               define EVENT_NO_RUNTIME_PM      9
 79 #               define EVENT_RX_KILL    10
 80 #               define EVENT_LINK_CHANGE        11
 81 #               define EVENT_SET_RX_MODE        12
So far, the first two are appearing applicable for mceusb.

The unused EVENT_TX_HALT and the apparently extra _kevent functions and kevent_flags are necessary for a later:
    [PATCH] [media] mceusb: TX -EPIPE lockup fix
...not yet written, transmit side equivalent bug. I respectfully recommend keeping these hooks in place.

For now, I think the transmit side EPIPE bug fix is less critical, since the TX bug avoids hanging the host/kernel, but would still cause lockup of the device.

In case of RX EPIPE on disconnect, the fix is still safe. Recovery attempt should fail (in usb_clear_halt() or usb_submit_urb()) and abort without further retry, and the recovery handler itself gets shutdown in mceusb_dev_disconnect().

Please let me know how to proceed. Thanks. ..A Sun
