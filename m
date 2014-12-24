Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:55545 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751872AbaLXLDd (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Dec 2014 06:03:33 -0500
Message-ID: <549A9D83.8050106@iki.fi>
Date: Wed, 24 Dec 2014 13:03:31 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Benjamin Larsson <benjamin@southpole.se>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH 48/66] rtl28xxu: use master I2C adapter for slave demods
References: <1419367799-14263-1-git-send-email-crope@iki.fi> <1419367799-14263-48-git-send-email-crope@iki.fi> <549A0CA9.6050401@southpole.se>
In-Reply-To: <549A0CA9.6050401@southpole.se>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/24/2014 02:45 AM, Benjamin Larsson wrote:
> On 12/23/2014 09:49 PM, Antti Palosaari wrote:
>> Both mn88472 and mn88473 slave demods are connected to master I2C
>> bus, not the bus behind master demod I2C gate like tuners. Use
>> correct bus.
>>
>
> Hello Antti, in my work tree I am still getting i2c errors even with the
> ir poll workaround (it takes really long time to get them). If I reload
> the rtl28xxu driver 2 times it starts working again. Could this change
> be related to such errors ?

Moikka
It could be related. I didn't take many tests, just tested both of my 
sticks continues working so it is obvious slave demod is not connected 
to master demod adapter.

Tree is here if you wish to test.
http://git.linuxtv.org/cgit.cgi/anttip/media_tree.git/log/?h=rtl28xx

regards
Antti

-- 
http://palosaari.fi/
