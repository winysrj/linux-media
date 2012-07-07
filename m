Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:35148 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750949Ab2GGJm6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 7 Jul 2012 05:42:58 -0400
Message-ID: <4FF80499.4010808@iki.fi>
Date: Sat, 07 Jul 2012 12:42:49 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Hin-Tak Leung <hintak_leung@yahoo.co.uk>
CC: mchehab@redhat.com, linux-media@vger.kernel.org
Subject: Re: unload/unplugging (Re: success! (Re: media_build and Terratec
 Cinergy T Black.))
References: <1341627993.41434.YahooMailClassic@web29403.mail.ird.yahoo.com>
In-Reply-To: <1341627993.41434.YahooMailClassic@web29403.mail.ird.yahoo.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Hin-Tak

On 07/07/2012 05:26 AM, Hin-Tak Leung wrote:
> BTW, I tried just pulling the USB stick out while mplayer is running. Strangely enough mplayer did not notice it gone and kept going for some 5 to 10 seconds. Probably buffering?

yes

> The only sign about it is two lines in dmesg (other than the usual usb messages about device being unplug).
>
> [227690.953311] rtl2832: i2c rd failed=-19 reg=01 len=1
> [227710.818089] usb 1-2: dvb_usbv2: streaming_ctrl() failed=-19

Jul  7 12:40:42 localhost kernel: [  906.030829] usb 2-2: USB 
disconnect, device number 4
Jul  7 12:40:42 localhost kernel: [  906.035518] rtl2832: i2c rd 
failed=-19 reg=01 len=1

Next application kills (I think so) and closes file nodes => device is 
unloaded:

Jul  7 12:40:49 localhost kernel: [  912.751437] usb 2-2: dvb_usbv2: 
streaming_ctrl() failed=-19
Jul  7 12:40:49 localhost kernel: [  912.751981] usb 2-2: dvb_usbv2: 
'Terratec Cinergy T Stick Black' successfully deinitialized and disconnected


> I also have quite a few :
>
> [224773.229293] DVB: adapter 0 frontend 0 frequency 2 out of range (174000000..862000000)
>
> This seems to come from running w_scan.

yes, those warnings are coming when application request illegal 
frequency. Setting frequency as a 2 Hz is something totally wrong, wild 
guess, it is some other value set accidentally as frequency.


> The kernel seems happy while having the device physically pulled out. But the kernel module does not like to be unloaded (modprobe -r) while mplayer is running, so we need to fix that.

Yep, seems to refuse unload. I suspect it is refused since there is 
ongoing USB transmission as it streams video. But should we allow that? 
And is removing open device nodes OK as applications holds those?

regards
Antti


-- 
http://palosaari.fi/


