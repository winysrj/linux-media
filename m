Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:45976 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750731Ab0EMV2o (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 13 May 2010 17:28:44 -0400
Message-ID: <4BEC6F03.4000403@iki.fi>
Date: Fri, 14 May 2010 00:28:35 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: matthieu castet <castet.matthieu@free.fr>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH] af9015 : more robust eeprom parsing
References: <4BA5FFA5.7030800@free.fr>
In-Reply-To: <4BA5FFA5.7030800@free.fr>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Terve!
And sorry I have been "out of the office" for few months... Now I am 
back and I think I have again time for this project...

On 03/21/2010 01:14 PM, matthieu castet wrote:
> the af9015 eeprom parsing accept 0x38 as 2nd demodulator. But this is
> impossible because the
> first one is already hardcoded to 0x38.
> This remove a special case for AverMedia AVerTV Volar Black HD.

I don't like this. It adds one more rather unnecessary if(). Of course 
we can validity check many kind of values from eeprom but I think it is 
not rather wise. Just trust eeprom and if there is device which does 
have garbage content in eeprom then add special case for that broken 
device. Currently AverMedia AVerTV Volar Black HD (A850) is only device 
I know which does have bad eeprom content.

> Also in af9015_copy_firmware don't hardcode the 2nd demodulator address
> to 0x3a.

This one looks good.

>
>
> Signed-off-by: Matthieu CASTET <castet.matthieu@free.fr>

regards
Antti
-- 
http://palosaari.fi/
