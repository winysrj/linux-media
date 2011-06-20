Return-path: <mchehab@pedra>
Received: from mail.kapsi.fi ([217.30.184.167]:41951 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752901Ab1FTWWi (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Jun 2011 18:22:38 -0400
Message-ID: <4DFFC82B.10402@iki.fi>
Date: Tue, 21 Jun 2011 01:22:35 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Jan Hoogenraad <jan-conceptronic@hoogenraad.net>
CC: =?UTF-8?B?U2FzY2hhIFfDvHN0ZW1hbm4=?= <sascha@killerhippy.de>,
	linux-media@vger.kernel.org,
	Thomas Holzeisen <thomas@holzeisen.de>, stybla@turnovfree.net,
	Maxim Levitsky <maximlevitsky@gmail.com>
Subject: Re: RTL2831U driver updates
References: <4DF9BCAA.3030301@holzeisen.de> <4DF9EA62.2040008@killerhippy.de> <4DFA7748.6000704@hoogenraad.net>
In-Reply-To: <4DFA7748.6000704@hoogenraad.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

It is Maxim who have been hacking with RTL2832/RTL2832U lately. But I 
think he have given up since no noise anymore.

I have taken now it again up to my desk and have been hacking two days 
now. Currently I am working with RTL2830 demod driver, I started it from 
scratch. Take sniffs, make scripts to generate code from USB traffic, 
copy pasted that to driver skeleton and now I have picture. Just 
implement all one-by-one until ready :-) I think I will implement it as 
minimum possible, no any signal statistic counters - lets add those 
later if someone wants to do that.

USB-bridge part is rather OK as I did earlier and it is working with 
RTL2831U and RTL2832U at least. No remote support yet.

I hope someone else would make missing driver for RTL2832U demod still...


Antti


-- 
http://palosaari.fi/
