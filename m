Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.kapsi.fi ([217.30.184.167] ident=Debian-exim)
	by mail.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <crope@iki.fi>) id 1Lp950-0002hX-PT
	for linux-dvb@linuxtv.org; Thu, 02 Apr 2009 00:38:45 +0200
Message-ID: <49D3ECE4.4030008@iki.fi>
Date: Thu, 02 Apr 2009 01:38:28 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Stuart <mailing-lists@enginuities.com>
References: <200903140506.00723.mailing-lists@enginuities.com>	<49D23920.5010903@iki.fi>
	<49D24315.8020107@iki.fi>
	<200904020043.48389.mailing-lists@enginuities.com>
In-Reply-To: <200904020043.48389.mailing-lists@enginuities.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Patch for DigitalNow TinyTwin remote.
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Hei Stuart,
Mainly I need your signed-off-by tag, please reply with tag.
http://kerneltrap.org/taxonomy/term/245
Signed-off-by: forename surname <email@address>

See comments below,
Stuart wrote:
>> But the reason I pressure you is that merge window for 2.6.30 is open
>> only few days. After that we cannot put new code / functionality until
>> 2.6.31 opens and it is very many months from that day.
>>
>> 1.) I suggest that you make very small patch adding basic support for
>> TinyTwin remote (mainly add device IDs to same places as TwinHan).
> 
> There are two patches in my last email which I believe achieve this. One simply 
> removes the if statement so that the AzureWave IR tables are assigned for the 
> TinyTwin. The other adds the TinyTwin to the HID ignore list so that there are 
> no repeat key presses. I've included them at the end of this email as well.
> 
>> 2.) Make other patch *later* that fix repeating issue. This one can be
>> added to the  2.6.30 later (there many release candidates in next
>> months) as bug fix.
> 
> I've been looking through usb sniffs when plugging the TinyTwin in and can't see 
> much that's different. There's a slight difference in the first 4 bytes of each 
> packet sent for the firmware, for example the first packet for each:
> 
> Linux:   00 51 00 00
> Windows: 38 51 00 c0

I think demodulator address field (0x38) is not valid - it is just don't 
care in that case.

> The IR table download is also sent slightly differently, in Linux it's:
> 
> 21 .. 00 9a 56 00 00 01 00
> 
> from
> 
> struct req_t req = {WRITE_MEMORY, 0, 0, 0, 0, 1, NULL};
> req.addr = 0x9a56
> 
> While Windows is:
> 
> 21 .. 38 9a 56 4e 80 01 00
> 
> which would be
> 
> struct req_t req = {WRITE_MEMORY, AF9015_I2C_DEMOD, 0, 4e, 80, 1, NULL};
> req.addr = 0x9a56

yes, but same here.

> I'm not sure what req.mbox = 0x4e or req.addr_len = 0x80 mean.

hmm, not sure if mbox have meaning. I doubt no meaning, if I remember 
correctly it is also used only by demodulator. Same probably for 
addr_len. But I check those later.

> There are also a few addresses either different or missing (0xd508, 0xd73a, 
> 0xaeff, ...) in various . I'm not sure if any of them could have anything to do 
> with how the IR behaves...

I doubt no.

> I'll try and check these to see if they make any difference when I get a chance.

Thank. You have done rather much work for this :)

> 
> Regards,
> 
> Stuart
> 
> af9015-b0ba0a6dfca1_tinytwin_remote.patch:

This patch is fine, I will apply it when got your signed-off-by.

> kernel-2.6.29_tinytwin_remote_patch.diff:
> --- orig/drivers/hid/hid-core.c	2009-03-24 10:12:14.000000000 +1100
> +++ new/drivers/hid/hid-core.c	2009-03-31 15:08:13.000000000 +1100

> --- orig/drivers/hid/hid-ids.h	2009-03-24 10:12:14.000000000 +1100
> +++ new/drivers/hid/hid-ids.h	2009-03-31 15:09:05.000000000 +1100

I don't like to touch other than dvb-modules :o I will not apply this to 
my tree / pull-request until whole repeating issue is clear. Why it 
comes and why it does not occur every machine.

regards
Antti
-- 
http://palosaari.fi/

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
