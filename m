Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:39732 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754230Ab3GANYI (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 1 Jul 2013 09:24:08 -0400
Message-ID: <51D182CD.2040502@iki.fi>
Date: Mon, 01 Jul 2013 16:23:25 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Oliver Schinagl <oliver+list@schinagl.nl>
CC: Bogdan Oprea <bogdaninedit@yahoo.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: drivers:media:tuners:fc2580c fix for Asus U3100Mini Plus error
 while loading driver (-19)
References: <1372660460.41879.YahooMailNeo@web162304.mail.bf1.yahoo.com> <1372661590.52145.YahooMailNeo@web162304.mail.bf1.yahoo.com> <51D1352A.2080107@schinagl.nl>
In-Reply-To: <51D1352A.2080107@schinagl.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/01/2013 10:52 AM, Oliver Schinagl wrote:
> On 01-07-13 08:53, Bogdan Oprea wrote:
>> this is a fix for this type of error
>>
>> [18384.579235] usb 6-5: dvb_usb_v2: 'Asus U3100Mini Plus' error while
>> loading driver (-19)
>> [18384.580621] usb 6-5: dvb_usb_v2: 'Asus U3100Mini Plus' successfully
>> deinitialized and disconnected
>>
> This isn't really a fix, I think i mentioned this on the ML ages ago,

Argh, I just replied that same. Oliver, do you has that same device? Is 
it working? Could you tweak to see if I2C readings are working at all?


regards
Antti


-- 
http://palosaari.fi/
