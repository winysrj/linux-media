Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:49504 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750858AbZIJQtA (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Sep 2009 12:49:00 -0400
Message-ID: <4AA92DF6.80107@iki.fi>
Date: Thu, 10 Sep 2009 19:48:54 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Devin Heitmueller <dheitmueller@kernellabs.com>
CC: "Aleksandr V. Piskunov" <aleksandr.v.piskunov@gmail.com>,
	Markus Rechberger <mrechberger@gmail.com>,
	Clinton Meyer <clintonmeyer22@gmail.com>,
	Linux Media <linux-media@vger.kernel.org>
Subject: Re: LinuxTV firmware blocks all wireless connections / traffic
References: <62013cda0909091443g72ebdf1bge3994b545a86c854@mail.gmail.com>	 <d9def9db0909100358o14f07362n550b95a033c8a798@mail.gmail.com>	 <20090910124549.GA18426@moon> <20090910124807.GB18426@moon>	 <4AA8FB2F.2040504@iki.fi> <20090910134139.GA20149@moon>	 <4AA9038B.8090404@iki.fi> <4AA911B6.2040301@iki.fi>	 <829197380909100826i3e2f8315yd6a0258f38a6c7b9@mail.gmail.com>	 <4AA92160.5080200@iki.fi> <829197380909100912xdb34da0s55587f6fe9c0f1d5@mail.gmail.com>
In-Reply-To: <829197380909100912xdb34da0s55587f6fe9c0f1d5@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Devin Heitmueller wrote:
> On Thu, Sep 10, 2009 at 11:55 AM, Antti Palosaari<crope@iki.fi> wrote:
>> Devin Heitmueller wrote:
>>> The URB size is something that varies on a device-by-device basis,
>>> depending on the bridge chipset.   There really is no
>>> "one-size-fits-all" value you can assume.
>> I doubt no. I tested last week rather many USB chips and all I tested
>> allowed to set it as x188 or x512 bytes. If it is set something than chip
>> does not like it will give errors or packets that are not as large as
>> requested. You can test that easily, look dvb-usb module debug uxfer and use
>> powertop.
>>
>>> I usually take a look at a USB trace of the device under Windows, and
>>> then use the same value.
>> I have seen logs where different sizes of urbs used even same chip.
> 
> Yes, the URB size can change depending on who wrote the driver, or
> what the required throughput is.  For example, the em28xx has a
> different URB size depending on whether the target application is
> 19Mbps ATSC or 38Mbps QAM.  That just reinforces what I'm saying - the
> size selected in many cases is determined by the requirements of the
> chipset.

Yes thats just what I tried to say for. Look my previous thread where 
all currently sizes are listed. We need to define suitable values that 
are used. For example USB2.0 DVB-C, DVB-T, ATSC and same values for 
USB1.1 too. And stream size can vary much depending used transmission 
parameters too but I think such kind resolution logic is not needed.

Currently there is almost everything between 512 to 65k used for DVB-T 
that makes huge difference to load device causing.

Does anyone know if there is some table which says what are good USB 
transmission parameters for each bandwidth needed?

> Making it some multiple of 188 for DVB is logical since that's the
> MPEG packet size.  That seems pretty common in the bridges I have
> worked with.
> 
> Devin


Antti
-- 
http://palosaari.fi/
