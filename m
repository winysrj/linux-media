Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:46984 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751916AbZIJPzS (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Sep 2009 11:55:18 -0400
Message-ID: <4AA92160.5080200@iki.fi>
Date: Thu, 10 Sep 2009 18:55:12 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Devin Heitmueller <dheitmueller@kernellabs.com>
CC: "Aleksandr V. Piskunov" <aleksandr.v.piskunov@gmail.com>,
	Markus Rechberger <mrechberger@gmail.com>,
	Clinton Meyer <clintonmeyer22@gmail.com>,
	Linux Media <linux-media@vger.kernel.org>
Subject: Re: LinuxTV firmware blocks all wireless connections / traffic
References: <62013cda0909091443g72ebdf1bge3994b545a86c854@mail.gmail.com>	 <829197380909091459x5367e95dnbd15f23e8377cf33@mail.gmail.com>	 <20090910091400.GA15105@moon>	 <d9def9db0909100358o14f07362n550b95a033c8a798@mail.gmail.com>	 <20090910124549.GA18426@moon> <20090910124807.GB18426@moon>	 <4AA8FB2F.2040504@iki.fi> <20090910134139.GA20149@moon>	 <4AA9038B.8090404@iki.fi> <4AA911B6.2040301@iki.fi> <829197380909100826i3e2f8315yd6a0258f38a6c7b9@mail.gmail.com>
In-Reply-To: <829197380909100826i3e2f8315yd6a0258f38a6c7b9@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Devin Heitmueller wrote:
> The URB size is something that varies on a device-by-device basis,
> depending on the bridge chipset.   There really is no
> "one-size-fits-all" value you can assume.

I doubt no. I tested last week rather many USB chips and all I tested 
allowed to set it as x188 or x512 bytes. If it is set something than 
chip does not like it will give errors or packets that are not as large 
as requested. You can test that easily, look dvb-usb module debug uxfer 
and use powertop.

> I usually take a look at a USB trace of the device under Windows, and
> then use the same value.

I have seen logs where different sizes of urbs used even same chip.

regards
Antti
-- 
http://palosaari.fi/
