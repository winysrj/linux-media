Return-path: <mchehab@pedra>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:49092 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752365Ab1BQJX6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Feb 2011 04:23:58 -0500
Received: by fxm20 with SMTP id 20so2374739fxm.19
        for <linux-media@vger.kernel.org>; Thu, 17 Feb 2011 01:23:57 -0800 (PST)
Message-ID: <4D5CE929.4050102@gmail.com>
Date: Thu, 17 Feb 2011 10:23:53 +0100
From: poma <pomidorabelisima@gmail.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org, Antti Palosaari <crope@iki.fi>,
	andrew.williams@joratech.com, lindsay.mathieson@gmail.com,
	skandalfo@gmail.com, news004@upsilon.org.uk
Subject: Re: Afatech AF9015 & dual tuner - dual_mode B.R.O.K.E.N.
References: <4D5B5FE2.5000302@gmail.com>
In-Reply-To: <4D5B5FE2.5000302@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

poma wrote:
> To num_adapters = 2, or num_adapters = 1: that is the question!

In dual tuner mode, after a while device become unrensponsive,
eventually after S5 aka 'Soft Off' system doesn't even boot!
Didn't even mention all sorts of 'mumbo-jumbo' with S3 aka 'Suspend to RAM'.
Antti, please consider adding 'dual_mode' parameter back.

"dvb_usb_af9015 dual_mode=0"

Devices to consider:

Not Only TV/LifeView DUAL DVB-T USB LV52T
(equivalent to TerraTec Cinergy T Stick Dual RC)
Afatech AF9013/AF9015 & 2x MaxLinear MxL5007T
http://www.notonlytv.net/p_lv52t.html

KWorld USB Dual DVB-T TV Stick (DVB-T 399U)
Afatech AF9013/AF9015 & 2x MaxLinear MxL5003S
http://www.kworld-global.com/main/prod_in.aspx?mnuid=1248&modid=6&prodid=73

DigitalNow TinyTwin DVB-T Receiver
Afatech AF9013/AF9015 & 2x MaxLinear MxL5005S
http://www.digitalnow.com.au/product_pages/TinyTwin.html

http://www.spinics.net/lists/linux-dvb/msg31616.html
http://www.spinics.net/lists/linux-dvb/msg31621.html

rgds,
poma
