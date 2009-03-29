Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:59614 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751953AbZC2OXf (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 29 Mar 2009 10:23:35 -0400
Message-ID: <49CF845E.1070002@iki.fi>
Date: Sun, 29 Mar 2009 17:23:26 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Olivier MENUEL <olivier.menuel@free.fr>
CC: Laurent Haond <lhaond@bearstech.com>, linux-media@vger.kernel.org
Subject: Re: AverMedia Volar Black HD (A850)
References: <200903291334.00879.olivier.menuel@free.fr> <49CF6157.1050807@iki.fi> <200903291430.22118.olivier.menuel@free.fr>
In-Reply-To: <200903291430.22118.olivier.menuel@free.fr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Olivier MENUEL wrote:
> Thanks for your quick answer !!!
> 
> I don't know much about linux drivers, usb-sniff, etc ... But I tried to make usb-sniff on a windows XP while plugging the device.
> Not sure this is exactly what you were asking and if I did it correctly, but you can find logs in attachment.
> 
> I did it twice just to be sure (it seems some addresses changed the second time, but I guess it's normal).
> Let me know if it's not correct, or if you need something else.
> 
> Again, thanks a lot for your help!

Could you take longer sniff. Probably 2 sniffs.
1) successful tune to channel using 1st tuner
2) successful tune to channel using 2nd tuner

One sec is enough, log increases very fast when streaming picture....

I did look your sniffs and immediately found some bad values :( There is 
byte in eeprom which tells 2nd demodulator i2c address, and guess what 
there was - i2c address of 1st integrated af9015 demodulator :( There 
should be 38 as i2c addr of 1st demod and 3a as 2nd demod.

regards
Antti
-- 
http://palosaari.fi/
