Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:32265 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754978AbZCOTy5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 15 Mar 2009 15:54:57 -0400
Message-ID: <49BD5D0E.3090304@iki.fi>
Date: Sun, 15 Mar 2009 21:54:54 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: pureherz@gmail.com
CC: linux-media@vger.kernel.org, linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] EC168 and MT2060
References: <1237129041.7993.38.camel@0ri0n>  <49BD3B31.8030308@iki.fi> <1237146464.7993.94.camel@0ri0n>
In-Reply-To: <1237146464.7993.94.camel@0ri0n>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

t.Hgch wrote:
>> Partially received? If there is really MT2060 tuner then channels should 
>>   not be received at all.
> 
> I checked again and i am getting a couple of dtv channels and some more
> radio channels, and they display/sound pretty well.

Then the tuner must be MXL5003S because it is only tuner ec168 Linux 
driver supports currently.

> I'm sure that the card model is the one I previously mentioned, the
> output from lsusb is:
> 
> Bus 001 Device 002: ID 18b4:1001  
> 
>> I can look usb-sniffs if you will take.
>> http://www.pcausa.com/Utilities/UsbSnoop/default.htm
> 
> I didn't find  usbsnoop for linux, so I used usbmon. Here is a sample:

Linux usb-sniff is useless. But no need for Windows sniffs because your 
device is not mt2060 one. If someone have ec168 with mt2060 tuner then 
Windows sniffs are welcome.

regards
Antti
-- 
http://palosaari.fi/
