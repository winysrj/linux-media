Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:47978 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752450AbZIJNsC (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Sep 2009 09:48:02 -0400
Message-ID: <4AA9038B.8090404@iki.fi>
Date: Thu, 10 Sep 2009 16:47:55 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: "Aleksandr V. Piskunov" <aleksandr.v.piskunov@gmail.com>
CC: Markus Rechberger <mrechberger@gmail.com>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	Clinton Meyer <clintonmeyer22@gmail.com>,
	Linux Media <linux-media@vger.kernel.org>
Subject: Re: LinuxTV firmware blocks all wireless connections / traffic
References: <62013cda0909091443g72ebdf1bge3994b545a86c854@mail.gmail.com> <829197380909091459x5367e95dnbd15f23e8377cf33@mail.gmail.com> <20090910091400.GA15105@moon> <d9def9db0909100358o14f07362n550b95a033c8a798@mail.gmail.com> <20090910124549.GA18426@moon> <20090910124807.GB18426@moon> <4AA8FB2F.2040504@iki.fi> <20090910134139.GA20149@moon>
In-Reply-To: <20090910134139.GA20149@moon>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Aleksandr V. Piskunov wrote:
> On Thu, Sep 10, 2009 at 04:12:15PM +0300, Antti Palosaari wrote:
>> Aleksandr V. Piskunov wrote:
>>>> Here is a test case:
>>>> Two DVB-T USB adapters, dvb_usb_af9015 and dvb_usb_af9015. Different tuners,
>>> Err, make it: dvb_usb_af9015 and dvb_usb_ce6230
>> Those both uses currently too small bulk urbs, only 512 bytes. I have  
>> asked suitable bulk urb size for ~20mbit/sec usb2.0 stream, but no-one  
>> have answered yet (search ml back week or two). I think will increase  
>> those to the 8k to reduce load.
>>
> 
> Nice, I'm ready to test if such change helps.

OK, I will make test version in couple of hours.

> Does USB subsystem provide any way to monitor current raw USB data transfer rate?

I don't if there is tool for raw data analysis, but for DVB devices you 
can use dvbtraffic tool.

Antti
-- 
http://palosaari.fi/
