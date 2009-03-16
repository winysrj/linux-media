Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:37046 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759838AbZCPVgc (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Mar 2009 17:36:32 -0400
Message-ID: <49BEC65C.8070302@iki.fi>
Date: Mon, 16 Mar 2009 23:36:28 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: linux-media@vger.kernel.org, Stuart <mailing-lists@enginuities.com>
CC: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Patch for DigitalNow TinyTwin remote.
References: <200903140506.00723.mailing-lists@enginuities.com>
In-Reply-To: <200903140506.00723.mailing-lists@enginuities.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

hei Stuart,

Stuart wrote:
> First of all, thanks to those involved in getting the TinyTwin working!
> 
> I haven't found any support for the remote control yet so I would like to offer what I've managed to do so far (in case I've done something wrong as this is the first time I've tried to submit a patch).
> 
> The remote I'm referring to is pictured here (albeit with a few buttons labeled differently):
> 
> http://www.digitalnow.com.au/images/ProRemote.jpg

Same remote as TwinHan AzureWave AD-TU700(704J).
This is just same device as AzureWave.

> I extracted an ir table from the .bin file located in:
> 
> http://www.digitalnow.com.au/DNTV/TinyTwinRemote4MCE.zip
> (listed at the bottom of http://www.digitalnow.com.au/downloads.html)
> 
> After changing linux/drivers/media/dvb/dvb-usb/af9015.[ch] I got a response from the remote, however, it would auto-repeat indefinitely. I believe this is caused by no "key up" event with the usbhid driver. To stop usbhid from attaching to the device I've modified a 
> couple of files in the kernel. This appears to leave dvb-usb-af9015 in charge of creating events for the remote by polling (is this the correct method to go about it?).

Someone should really examine that more. Take some sniffs to see how 
Windows handle that.
http://www.linuxtv.org/pipermail/linux-dvb/2008-November/030292.html
http://linuxtv.org/wiki/index.php/MSI_DigiVox_mini_II_V3.0

> Some keys don't work (I don't know if it's possible to get them working with a revised ir table), they're labeled on the remote as:
> 
> Tab, Capture, PIP, L/R, Recall, Zoom-, Red
> 
> The included patches apply to the following versions:
> 
> af9015: a57ea2073e77
> kernel: 2.6.29_rc7
> 
> I'm not sure if this is the correct approach, however, it seems to be working for me so any feedback would be appreciated!

I am also not sure about HID changes.
And also could you test whether AzureWave IR-tables are OK because 
device looks just same, even remote.

regards
Antti
-- 
http://palosaari.fi/
