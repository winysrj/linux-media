Return-path: <linux-media-owner@vger.kernel.org>
Received: from resqmta-ch2-03v.sys.comcast.net ([69.252.207.35]:58894 "EHLO
        resqmta-ch2-03v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751000AbeCNTZX (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 14 Mar 2018 15:25:23 -0400
Subject: [PATCH v2 0/1] media: mceusb: add IR learning support features (IR
 carrier frequency measurement and wide-band/short-range receiver)
To: Sean Young <sean@mess.org>
Cc: linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>
References: <20f4d234-c62f-12ab-5e15-639f7d981f56@comcast.net>
 <20180313103816.7oyjr7imb4hk7q65@gofer.mess.org>
From: A Sun <as1033x@comcast.net>
Message-ID: <3b3b9f4b-3573-136a-8aa7-22bb0d2a5934@comcast.net>
Date: Wed, 14 Mar 2018 15:25:11 -0400
MIME-Version: 1.0
In-Reply-To: <20180313103816.7oyjr7imb4hk7q65@gofer.mess.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sean,
Thanks again for your review and notes. I'm forwarding PATCH v2 after this note. Please also see my notes below. ..A Sun

On 3/13/2018 6:38 AM, Sean Young wrote:
> Hi,
> 
> On Sun, Mar 11, 2018 at 05:40:28AM -0400, A Sun wrote:
>>

>>
>> Add mceusb driver support to select the short range IR receiver
>> and enable pass through of its IR carrier frequency measurements.
>>
>> RC and LIRC already support these mceusb driver additions.
> 
> That's great, this feature has been missing for a long time. 
> 
> I've tested it with my four mceusb devices, and I get carrier reports with
> all of them. Please see the notes below.
> 
>> Test platform:

>> ...
>> pulse 600
>> space 600
>> pulse 1250
>> space 550
>> pulse 650
>> space 600
>> pulse 550
>> space 600
>> pulse 600
>> space 600
>> pulse 650
>> carrier 38803
> 
> Sony protocol remotes have a 40000Hz carrier, and I am getting lower values
> for the carrier with other carrier frequencies as well. Any idea why?
> 

I'm also seeing consistently low Hz results myself. My guess is the mceusb hardware may be under counting carrier cycles during IR pulse "on" it sees. I see the following data from the receiver for a spurious IR:

[  329.602445] mceusb 1-1.2:1.0: RX carrier frequency 0 Hz (pulse count = 1, duration = 2, cycles = 0)

To see a pulse, there must exist a carrier, so the IR carrier cycle count should be > 0.

In patch v2, I'm assuming the mceusb hardware misses 1 carrier cycle count for every IR on pulse it sees and adjusted the carrier freq calculations accordingly. The adjustments needed may turn out to be hardware specific, so further refinements may be needed.

Did you see low Hz values for all your four mceusb devices?


>> +	/*
>> +	 * cmdbuf[2] is receiver port number
>> +	 * port 1 is long range receiver
>> +	 * port 2 is short range receiver
>> +	 */
>> +	cmdbuf[2] = enable + 1;
> 
> You could do enable ? 2 : 1 here and do away with the check above. Enable
> always is 0 or 1 anyway.
> 
>> +	dev_dbg(ir->dev, "select %s-range receive sensor",
>> +		enable ? "short" : "long");
>> +	mce_async_out(ir, cmdbuf, sizeof(cmdbuf));
>> +
>> +	return 0;
>> +}
>> +
>> +/*
>> + * Enable/disable receiver carrier frequency pass through reporting.
>> + * Frequency measurement only works with the short-range receiver.
>> + * The long-range receiver always reports no carrier frequency
>> + * (MCE_RSP_EQIRRXCFCNT, 0, 0) so we always ignore its report.
>> + */
>> +static int mceusb_set_rx_carrier_report(struct rc_dev *dev, int enable)
>> +{
>> +	struct mceusb_dev *ir = dev->priv;
>> +
>> +	if (enable != 0 && enable != 1)
>> +		return -EINVAL;
> 
> This is only called from lirc_dev.c, where the expression is:
> 
> 	ret = dev->s_carrier_report(dev, !!val);
> 
> There is no need to check for enable being not 0 or 1.
> 
>> +
>> +	dev_dbg(ir->dev, "%s short-range receiver carrier reporting",
>> +		enable ? "enable" : "disable");
>> +	ir->carrier_report_enabled = (enable == 1);
> 
> Since enable is 0 or 1, there is no need for the enable == 1 expression.
> 
> Note that the other drivers that support carrier reports (winbond-cir,
> redrat3, ene-cir) all enable the wideband receiver when carrier reports
> are turned on. You won't get carrier reports with the narrowband
> receiver, so if the user does:
> 
> ir-ctl -r -m
> 
> Then they will get nothing. It should really be consistent with the other
> drivers and enable wideband implicitly.
> 

I've added to patch v2 to implicitly enable the wide-band receiver when enabling carrier reporting. Plus additional revisions from your other comments.
