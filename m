Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:55727 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751837AbZC0PU0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Mar 2009 11:20:26 -0400
Message-ID: <49CCEEAF.4000703@iki.fi>
Date: Fri, 27 Mar 2009 17:20:15 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: linux-media@vger.kernel.org, Stuart <mailing-lists@enginuities.com>
CC: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Patch for DigitalNow TinyTwin remote.
References: <200903140506.00723.mailing-lists@enginuities.com>	<49BEC65C.8070302@iki.fi> <200903171410.31856.mailing-lists@enginuities.com>
In-Reply-To: <200903171410.31856.mailing-lists@enginuities.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hei Stuart,
I would like to thank you!

>> Someone should really examine that more. Take some sniffs to see how
>> Windows handle that.
>> http://www.linuxtv.org/pipermail/linux-dvb/2008-November/030292.html
>> http://linuxtv.org/wiki/index.php/MSI_DigiVox_mini_II_V3.0
> 
> I had a look at the links, the problem I had did not stop after pressing a key on the keyboard. Also, with this kernel (2.6.29_rc7) using 'options usbhid quirks=0x13d3:0x3226:0x0004' had no effect, I believe there have been some changes to usbhid in 2.6.28, either way 
> the old macro '#define HID_QUIRK_IGNORE 0x00000004' is not in hid.h in this kernel version. The only way to stop it was to unplug the device. (Trying to type rmmod was impossible as the input from the remote would keep coming!)
> 
> I'd be happy to have a look in to usb sniffing, are there any decent tutorials on how to do this?

take sniff:
http://www.pcausa.com/Utilities/UsbSnoop/default.htm
use parser to sniff:
v4l2-apps/util/parse-sniffusb2.pl

and try to look parsed log. You can see USB-protocol rather easily by 
comparing driver code and sniff.

>> I am also not sure about HID changes.
>> And also could you test whether AzureWave IR-tables are OK because
>> device looks just same, even remote.
> 
> You're absolutely right! The TinyTwin worked with the AzureWave tables (af9015_rc_keys_twinhan and af9015_ir_table_twinhan).
> 
> I can see in af9015.h there is an ir table (af9015_ir_table_twinhan) with 50 entries, a key table (af9015_rc_keys_twinhan) with 53 entries and that while the remote has 53 keys, the device can only handle 50 of them (the first 50 in the ir table if > 50). I've also 
> found two ir tables from Windows drivers (one from the supplied CD and the one I previously mentioned for Windows MCE). This is an example entry in an ir table:

you are correct, 50 entries is max size.

>  1  ,  2  ,  3  ,  4  ,  5  ,  6  ,  7
> 0x00, 0xff, 0x16, 0xe9, 0x28, 0x0c, 0x00
> 
> I'm assuming columns 3 & 4 correspond to the key pressed and columns 5 & 6 correspond to the code returned when that key is pressed. In all tables, 3 & 4 are the same while 5 & 6 are sometimes different. I'm assuming that 5 & 6 are important if usbhid attaches itself 
> to the device, however, if dvb_usb_af9015 attaches itself then they seem somewhat arbitrary as the key table only needs to match the ir table to get the correct key press from af9015_rc_query.

bytes 1-4 are remote code, 1 & 2 is like device address and 3 & 4 
contains key code. Last 3 bytes are some data returned by chip, HID / 
key code.
http://www.sbprojects.com/knowledge/ir/rc6.htm
http://www.sbprojects.com/knowledge/ir/nec.htm

> I wrote a simple programme to look at all the ir and key tables. Looking at af9015_rc_keys_twinhan and af9015_ir_table_twinhan in af9015.h shows there is no entry in af9015_ir_table_twinhan for A/V, Zoom+ or Zoom- and there are two entries with '0x00, 0x0e' 
> corresponding to KEY_POWER and KEY_INFO (I believe the entry '{ 0x00, 0x0e, KEY_POWER }' should be '{ 0x00, 0x4d, KEY_STOP }') in af9015_rc_keys_twinhan.
> 
> I'm not sure if columns 5 & 6 need to be specific values, but I've attached a complete list (53 ir table entries and 53 corresponding key table entries). Of course, we can only use 50 of them at a time!
> 
> Also, how does the AzureWave handle the remote? Does it use the usbhid driver or dvb_usb_af9015? If it uses dvb_usb_af9015, then I think the TinyTwin should use it as well and it would be necessary to stop usbhid from attaching to the device.

When I added remote support the reason I used polling was that I didn't 
get HID working. I don't know why. And I haven't even sniffed how 
Windows driver handles that - only uploaded ir-table to the device as 
seen from sniffs.

Could you make patch that adds AzureWave remote to the TinyTwin? 2.6.30 
merge windows is now open. I will try to examine this remote issue 
during weekend. Use this tree http://linuxtv.org/hg/~anttip/af9015/

regards
Antti
-- 
http://palosaari.fi/
