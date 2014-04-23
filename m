Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:53645 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755549AbaDWPy6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Apr 2014 11:54:58 -0400
Message-ID: <5357E24F.70701@iki.fi>
Date: Wed, 23 Apr 2014 18:54:55 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
CC: LMML <linux-media@vger.kernel.org>
Subject: Re: [GIT PULL 3.16] 2013:025f PCTV tripleStick (292e)
References: <535721C7.7030807@iki.fi> <20140423101103.534da391@samsung.com>
In-Reply-To: <20140423101103.534da391@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 23.04.2014 16:11, Mauro Carvalho Chehab wrote:
> Em Wed, 23 Apr 2014 05:13:27 +0300
> Antti Palosaari <crope@iki.fi> escreveu:
>
>> Hardware is Empia EM28178, Silicon Labs Si2168, Silicon Labs Si2157.
>> There is on/off external LNA too. Two new drivers for Silicon Labs DTV
>> chipset.
>>
>> Demod needs firmware, which could be found from driver CD version 6.4.8.984.
>> /TVC 6.4.8/Driver/PCTV Empia/emOEM.sys
>> dd if=emOEM.sys ibs=1 skip=1089416 count=2720 of=dvb-demod-si2168-01.fw
>> md5sum dvb-demod-si2168-01.fw
>> 87c317e0b75ad49c2f2cbf35572a8093  dvb-demod-si2168-01.fw
>
> Not sure if you did it already, but could you please put the above
> instructions on our Wiki page?

Will do.

> It would be better to add it at the DVB get firmware script, but it seems
> that PCTV didn't put the driver yet on their website.

There is driver updates , but not that as it is very new device and no 
updates available. I will add it after driver is available online.

regards
Antti
-- 
http://palosaari.fi/
