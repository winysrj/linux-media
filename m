Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:44557 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751699AbcEUAQ0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 20 May 2016 20:16:26 -0400
Subject: Re: DVBSky T330 DVB-C regression Linux 4.1.12 to 4.3
To: Rolf Evers-Fischer <embedded24@evers-fischer.de>
References: <1677993131.49456.01924d52-f180-4aca-bc23-42b237aaedb7.open-xchange@email.1und1.de>
Cc: linux-media@vger.kernel.org, olli.salonen@iki.fi
From: Antti Palosaari <crope@iki.fi>
Message-ID: <7a7c5464-f0ba-c6ab-e6a5-d021672762b5@iki.fi>
Date: Sat, 21 May 2016 03:16:22 +0300
MIME-Version: 1.0
In-Reply-To: <1677993131.49456.01924d52-f180-4aca-bc23-42b237aaedb7.open-xchange@email.1und1.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/21/2016 01:47 AM, Rolf Evers-Fischer wrote:
> Dear Antti,
> I apologize for tackling this old problem, but I just ran into the same
> situation with my "DVBSky T330 DVB-C" and found that I'm not the only one.
.....
>> Also, you used 4.0.19 firmware. Could you test that old one:
>> http://palosaari.fi/linux/v4l-dvb/firmware/Si2168/Si2168-B40/4.0.11/
>>
>
> I've just tried the old 4.0.11 firmware - and the error is gone. Now the tuning
> works perfectly!

Reason is that silicon vendor has changed firmware API somewhere between 
4.0.11 and 4.0.19 so that newer firmwares will put device to full sleep 
which causes even device firmware lost.

Fix is here, and I hope I can push it to 4.8 - it will took about half 
year from this day until it is on mainline (it is not regression so I 
cannot send it to older kernels and for 4.7 it is too late). Before that 
just use 4.0.11 firmware.

https://git.linuxtv.org/anttip/media_tree.git/commit/?h=mygica&id=cfd6ab8e840815eb54eb777c9f64807022ba922c

regards
Antti
-- 
http://palosaari.fi/
