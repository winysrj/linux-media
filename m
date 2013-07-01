Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:38593 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754776Ab3GAUwM (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 1 Jul 2013 16:52:12 -0400
Message-ID: <51D1EBCF.60708@iki.fi>
Date: Mon, 01 Jul 2013 23:51:27 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Oliver Schinagl <oliver+list@schinagl.nl>
CC: Bogdan Oprea <bogdaninedit@yahoo.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: drivers:media:tuners:fc2580c fix for Asus U3100Mini Plus error
 while loading driver (-19)
References: <1372660460.41879.YahooMailNeo@web162304.mail.bf1.yahoo.com> <1372661590.52145.YahooMailNeo@web162304.mail.bf1.yahoo.com> <51D1352A.2080107@schinagl.nl> <51D182CD.2040502@iki.fi> <51D1839B.1010007@schinagl.nl> <51D1E8F8.9030402@schinagl.nl>
In-Reply-To: <51D1E8F8.9030402@schinagl.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/01/2013 11:39 PM, Oliver Schinagl wrote:
> On 07/01/13 15:26, Oliver Schinagl wrote:
>> On 01-07-13 15:23, Antti Palosaari wrote:
>>> On 07/01/2013 10:52 AM, Oliver Schinagl wrote:
>>>> On 01-07-13 08:53, Bogdan Oprea wrote:
>>>>> this is a fix for this type of error
>>>>>
>>>>> [18384.579235] usb 6-5: dvb_usb_v2: 'Asus U3100Mini Plus' error while
>>>>> loading driver (-19)
>>>>> [18384.580621] usb 6-5: dvb_usb_v2: 'Asus U3100Mini Plus' successfully
>>>>> deinitialized and disconnected
>>>>>
>>>> This isn't really a fix, I think i mentioned this on the ML ages ago,
>>>
>>> Argh, I just replied that same. Oliver, do you has that same device? Is
>>> it working? Could you tweak to see if I2C readings are working at all?
>> I have the same device, but mine works normally (though I haven't
>> checked for ages), I will try it tonight when I'm at home and don't
>> forget what happens with my current kernel.
>
> Hard to test when it 'just works (tm)' :)

> The bad firmware wories me, no clue where that error is from, using:
> 862604ab3fec0c94f4bf22b4cffd0d89  /lib/firmware/dvb-usb-af9035-02.fw

It means firmware is too short or long what is calculated. I added that 
printing to notify users firmware is broken and could cause problems.


I suspect it is same issue what is with MxL5007t tuners too.
Maybe that kind of fix is needed:
https://patchwork.kernel.org/patch/2418471/

Someone should really find out whether or not these are coming with 
register read operation with REPEATED START of STOP condition. Attach 
hardware sniffer to device tuner I2C bus and look what kind of messages 
there is actually.

regards
Antti

-- 
http://palosaari.fi/
