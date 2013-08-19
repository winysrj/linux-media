Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:47847 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750775Ab3HSPTd (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Aug 2013 11:19:33 -0400
Message-ID: <52123758.4090007@iki.fi>
Date: Mon, 19 Aug 2013 18:18:48 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: remi <remi@remis.cc>
CC: linux-media@vger.kernel.org
Subject: Re: avermedia A306 / PCIe-minicard (laptop)
References: <641271032.80124.1376921926586.open-xchange@email.1and1.fr>
In-Reply-To: <641271032.80124.1376921926586.open-xchange@email.1and1.fr>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/19/2013 05:18 PM, remi wrote:
> Hello
>
> I have this card since months,
>
> http://www.avermedia.com/avertv/Product/ProductDetail.aspx?Id=376&SI=true
>
> I have finally retested it with the cx23885 driver : card=39
>
>
>
> If I could do anything to identify : [    2.414734] cx23885[0]: i2c scan: found
> device @ 0x66  [???]
>
> Or "hookup" the xc5000 etc
>
> I'll be more than glad .
>


>
> ps: i opened it up a while ago,i saw an af9013 chip ? dvb-tuner looks like
> maybe the "device @ 0x66 i2c"
>
> I will double check , and re-write-down all the chips , i think 3 .

You have to identify all the chips, for DVB-T there is tuner missing.

USB-interface: cx23885
DVB-T demodulator: AF9013
RF-tuner: ?

If there is existing driver for used RF-tuner it comes nice hacking 
project for some newcomer.

It is just tweaking and hacking to find out all settings. AF9013 driver 
also needs likely some changes, currently it is used only for devices 
having AF9015 with integrated AF9013, or AF9015 dual devices having 
AF9015 + external AF9013 providing second tuner.

I have bought quite similar AverMedia A301 ages back as I was looking 
for that AF9013 model, but maybe I have bought just wrong one... :)


regards
Antti


-- 
http://palosaari.fi/
