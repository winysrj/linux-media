Return-path: <linux-media-owner@vger.kernel.org>
Received: from 7of9.schinagl.nl ([88.159.158.68]:34522 "EHLO 7of9.schinagl.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752695Ab3GAN1y (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 1 Jul 2013 09:27:54 -0400
Message-ID: <51D1839B.1010007@schinagl.nl>
Date: Mon, 01 Jul 2013 15:26:51 +0200
From: Oliver Schinagl <oliver+list@schinagl.nl>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>
CC: Bogdan Oprea <bogdaninedit@yahoo.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: drivers:media:tuners:fc2580c fix for Asus U3100Mini Plus error
 while loading driver (-19)
References: <1372660460.41879.YahooMailNeo@web162304.mail.bf1.yahoo.com> <1372661590.52145.YahooMailNeo@web162304.mail.bf1.yahoo.com> <51D1352A.2080107@schinagl.nl> <51D182CD.2040502@iki.fi>
In-Reply-To: <51D182CD.2040502@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01-07-13 15:23, Antti Palosaari wrote:
> On 07/01/2013 10:52 AM, Oliver Schinagl wrote:
>> On 01-07-13 08:53, Bogdan Oprea wrote:
>>> this is a fix for this type of error
>>>
>>> [18384.579235] usb 6-5: dvb_usb_v2: 'Asus U3100Mini Plus' error while
>>> loading driver (-19)
>>> [18384.580621] usb 6-5: dvb_usb_v2: 'Asus U3100Mini Plus' successfully
>>> deinitialized and disconnected
>>>
>> This isn't really a fix, I think i mentioned this on the ML ages ago,
>
> Argh, I just replied that same. Oliver, do you has that same device? Is
> it working? Could you tweak to see if I2C readings are working at all?
I have the same device, but mine works normally (though I haven't 
checked for ages), I will try it tonight when I'm at home and don't 
forget what happens with my current kernel.
>
>
> regards
> Antti
>
>

