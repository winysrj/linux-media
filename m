Return-path: <mchehab@pedra>
Received: from mail.kapsi.fi ([217.30.184.167]:41337 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933140Ab0JFV3i (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 6 Oct 2010 17:29:38 -0400
Message-ID: <4CACEA3F.8020503@iki.fi>
Date: Thu, 07 Oct 2010 00:29:35 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: dave cunningham <news004@upsilon.org.uk>
CC: linux-media@vger.kernel.org
Subject: Re: [linux-dvb] [bug] AF9015 message "WARNING: >>> tuning failed!!!"
References: <201010061456.19573.pmw.gover@yahoo.co.uk> <4CACD0F3.6030203@iki.fi> <vQlRLYBT3NrMFwnE@echelon.upsilon.org.uk>
In-Reply-To: <vQlRLYBT3NrMFwnE@echelon.upsilon.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On 10/06/2010 11:36 PM, dave cunningham wrote:
> In message <4CACD0F3.6030203@iki.fi>, Antti Palosaari wrote
>
>> It is QT1010 tuner driver issue. None is working for that currently or
>> in near future. Feel free to fix :]
>>
>
> The wiki appears to show this stick as working.
> <http://linuxtv.org/wiki/index.php/Afatech_AF9015>.
>
> Is this information incorrect or is it hit and miss depending on the
> host system?

It "works" but performance is poor. Usually it locks when RF signal is 
weak. If you fix bug around line 381 in qt1010.c it will work much 
better. But if you fix that it will break devices zl10353+qt1010 since 
zl10353 driver misses AGC configuration.

Antti
-- 
http://palosaari.fi/
