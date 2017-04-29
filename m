Return-path: <linux-media-owner@vger.kernel.org>
Received: from resqmta-ch2-04v.sys.comcast.net ([69.252.207.36]:47036 "EHLO
        resqmta-ch2-04v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2997833AbdD2QFB (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 29 Apr 2017 12:05:01 -0400
From: A Sun <as1033x@comcast.net>
Subject: [PATCH 0/1] [media] mceusb: coding style & comments update, for
 -EPIPE error patches
To: Sean Young <sean@mess.org>
References: <58EEC1CB.7030806@comcast.net> <58EF3197.9060707@comcast.net>
 <20170427205424.GA18688@gofer.mess.org>
Cc: linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Message-ID: <5904B984.1040208@comcast.net>
Date: Sat, 29 Apr 2017 12:04:20 -0400
MIME-Version: 1.0
In-Reply-To: <20170427205424.GA18688@gofer.mess.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Hi Sean,
Thanks for the comments for:
[PATCH v2] [media] mceusb: TX -EPIPE (urb status = -32) lockup fix
I received another email indicating the patch in accepted state, so I'm following up with a subsequent patch for cosmetic (coding style and comment) changes to incorporate your review comments.

On 4/27/2017 4:54 PM, Sean Young wrote:
> On Thu, Apr 13, 2017 at 04:06:47AM -0400, A Sun wrote:
<snip>
>> @@ -1220,16 +1221,28 @@ static void mceusb_deferred_kevent(struct work_struct *work)
>>  		if (status < 0) {
>>  			dev_err(ir->dev, "rx clear halt error %d",
>>  				status);
>> -			return;
>> +			goto done_rx_halt;
> 
> This function can easily be re-written without gotos and it will be
> much more readible.
> 
>>  		}

I've left this goto for now (framework to abort error handling in deeply nested if statements), since I'm testing the following possible future enhancement:

@@ -1222,7 +1222,15 @@ static void mceusb_deferred_kevent(struc
                if (status < 0) {
                        dev_err(ir->dev, "rx clear halt error %d",
                                status);
-                       goto done_rx_halt;
+
+                       /* usb_reset_configuration() also resets tx */
+                       status = usb_reset_configuration(ir->usbdev);
+                       if (status < 0) {
+                               dev_err(ir->dev, "rx usb reset configuration error %d",
+                                       status);
+                               goto done_rx_halt;
+                       }
+                       clear_bit(EVENT_TX_HALT, &ir->kevent_flags);
                }
                clear_bit(EVENT_RX_HALT, &ir->kevent_flags);
                status = usb_submit_urb(ir->urb_in, GFP_KERNEL);

I have since discovered and observed usb clear halt can fail too during normal usage while running the non-debug mceusb driver.

Apr 18 00:07:43 raspberrypi kernel: [ 11.627760] Bluetooth: BNEP socket layer initialized
Apr 18 19:49:22 raspberrypi kernel: [70890.799375] mceusb 1-1.2:1.0: Error: urb status = -32 (RX HALT)
Apr 18 19:49:22 raspberrypi kernel: [70890.800789] mceusb 1-1.2:1.0: rx clear halt error -32

This is the only time I saw this over several weeks. I don't know the cause or condition for replication. So whether 2nd stage error recovery with usb_reset_configuration() is effective is not yet known.

Thanks, ..A Sun
