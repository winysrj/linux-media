Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:48817 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751678AbaLBKCF (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 2 Dec 2014 05:02:05 -0500
Message-ID: <547D8E1A.5050307@iki.fi>
Date: Tue, 02 Dec 2014 12:02:02 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Akihiro TSUKADA <tskd08@gmail.com>,
	Benjamin Larsson <benjamin@southpole.se>,
	linux-media@vger.kernel.org
Subject: Re: Random memory corruption of fe[1]->dvb pointer
References: <547BAC79.50702@southpole.se> <547CF9FC.5010101@southpole.se> <547D8AA0.4000403@gmail.com>
In-Reply-To: <547D8AA0.4000403@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 12/02/2014 11:47 AM, Akihiro TSUKADA wrote:
>> So at first it would be nice if someone could confirm my findings.
>> Applying the same kind of code like my patch and unplug something that
>> uses the affected frontend should be enough.
>
> I tried that for tc90522, and I could remove earth-pt3
> (which uses tc90522), tc90522 and tuner modules without any problem,
> although earth-pt3 is a pci driver and does not use dvb-usb-v2.
>
>>From your log(?) output,
> I guess that rtl28xxu_exit() removed the attached demod module
> (mn88472) and thus free'ed fe BEFORE calling dvb_usbv2_exit(),
> from where dvb_unregister_frontend(fe) is called.
> I think that the demod i2c device is removed automatically by
> dvb_usbv2_i2c_exit() in dvb_usbv2_exit(), if you registered
> the demod i2c device, and your adapter/bridge driver
> should not try to remove it.

Yes. You must unregister frontend before you remove driver. I have 
already added new callbacks detach tuner and frontend to avoid that, but 
there was yet again new issue as it removes rtl2832 demod driver first 
and mn88472 slave demod was put to i2c bus / adapter which is owned by 
rtl2832. So it will crash too. Solution is to convert rtl2832 to I2C 
binding (or convert mn88472 legacy DVB binding (which I don't allow :)). 
When rtl2832 driver is converted to I2C model it is not unloaded 
automatically and you could remove those in a correct order.

But hey, mn88472 is still on staging :D

regards
Antti

-- 
http://palosaari.fi/
