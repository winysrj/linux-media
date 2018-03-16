Return-path: <linux-media-owner@vger.kernel.org>
Received: from resqmta-ch2-06v.sys.comcast.net ([69.252.207.38]:37452 "EHLO
        resqmta-ch2-06v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751757AbeCPT6Z (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 16 Mar 2018 15:58:25 -0400
Subject: [PATCH v3 0/1] media: mceusb: add IR learning support features (IR
 carrier frequency measurement and wide-band/short-range receiver)
To: Sean Young <sean@mess.org>
Cc: linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>
References: <20f4d234-c62f-12ab-5e15-639f7d981f56@comcast.net>
 <20180313103816.7oyjr7imb4hk7q65@gofer.mess.org>
 <aa4be7ab-b643-9dc9-6a06-7981d314583e@comcast.net>
 <20180315124606.yvugyfb4cn2f6byz@gofer.mess.org>
From: A Sun <as1033x@comcast.net>
Message-ID: <36aa55c1-b52f-581d-4af6-660f317da4b0@comcast.net>
Date: Fri, 16 Mar 2018 15:44:55 -0400
MIME-Version: 1.0
In-Reply-To: <20180315124606.yvugyfb4cn2f6byz@gofer.mess.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sean,
Thanks again for your review and notes. I'm forwarding PATCH v3 after this note. Please also see my notes below. ..A Sun

On 3/15/2018 8:46 AM, Sean Young wrote:
> On Wed, Mar 14, 2018 at 03:32:02PM -0400, A Sun wrote:
>> patch v2 revisions:
>>  . Carrier frequency measurement results were consistently low in patch v1.
>>    Improve measurement accuracy by adjusting IR carrier cycle count
>>    assuming 1 missed count per IR "on" pulse.
>>    Adjustments may need to be hardware specific, so future refinements
>>    may be necessary.
> 
> I've retested my four mceusb devices. Three of them, including the original
> microsoft mce ir receiver, need this fix. However, one with pid 0471 and
> vid 2093 produces correct results before this change, and starts giving
> carrier with numbers which are too high after this.
> 

Well, it appears the fix will need to be applied on a device specific basis.
In v3, I've added parameter "rx2" to mceusb_model to accomplish this.

I'm not sure how to proceed further with this. Many of the mceusb supported devices
would need to be checked to determine what "rx2" setting works best for the device.
I can only check two other mceusb devices I have access to. Maybe later, after we
complete this patch.

Can you identify your other mceusb devices by v/p-id? That would help too.

>>  . Remove unneeded argument "enable" validation in
>>    mceusb_set_rx_wideband() and mceusb_set_rx_carrier_report().
>>  . In mceusb_set_rx_carrier_report(), when enabling RX carrier report feature,
>>    also implicitly enable RX wide-band (short-range) receiver.
>>    Maintains consistency with winbond-cir, redrat3, ene-cir, IR receivers.
> 
> So if carrier reports are enabled, and then disabled again, in your code
> the wideband receiver remains enabled. Please can it be disabled again
> when carrier reports are turned off again (while learning mode is off).
> 

I've added code in V3 to revert to normal receiver after disabling carrier reports,
but only if learning mode (wideband receiver) was not explicitly turned on.


file mceusb-rx2-setting.txt:

Mceusb confirmed device dependent setting for rx2 which provides
the best results for learning mode IR receiver carrier frequency
measurement.

IR receiver only devices (no IR emitters (no_tx = 1)) are
unlikely, and not required by specification, to support IR learning mode.
So those devices may not need to be checked.

        * Original Microsoft MCE IR Transceiver (often HP-branded) *
          USB_DEVICE(VENDOR_MICROSOFT, 0x006d)
                rx2 = 2
        * Philips IR transceiver (Dell branded) *
          USB_DEVICE(VENDOR_PHILIPS, 0x2093)
                rx2 = 1
        * Pinnacle Remote Kit *
          USB_DEVICE(VENDOR_PINNACLE, 0x0225)
                rx2 = 2
