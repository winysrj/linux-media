Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:60276 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755573Ab2GDTyA (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 4 Jul 2012 15:54:00 -0400
Message-ID: <4FF49F52.2010005@iki.fi>
Date: Wed, 04 Jul 2012 22:53:54 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: pierigno <pierigno@gmail.com>
CC: linux-media@vger.kernel.org
Subject: Re: AF9035 Twinstar has firmware errors
References: <CAN7fRVviA=svPsrHUkXj7B_ZZO02XMAOFyXQz0Sa-DiWvjg1cQ@mail.gmail.com> <4FF494CB.5070001@iki.fi>
In-Reply-To: <4FF494CB.5070001@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/04/2012 10:08 PM, Antti Palosaari wrote:
> Hello and thank you for testing.
>
> On 07/04/2012 09:55 PM, pierigno wrote:
>> hello,
>>
>> I've downloaded and compiled against karnel 3.0.0 and kernel 3.4.3 the
>> latest git tree from antii, branch dvb-usb-pull, and it doesn't
>> recognize my dual tuner Avermedia Twinstar (af9035 + mxl5007t)
>> anymore. Here's the logs from dmesg (the compiled modules do not have
>> any debug parameters to enable):
>
> It is uses new / current dynamic debugs.
>
> modprobe dvb_usbv2; echo -n 'module dvb_usbv2 +p' >
> /sys/kernel/debug/dynamic_debug/control
> echo 'file drivers/media/dvb/dvb-usb/usb_urb.c line 30 -p' >
> /sys/kernel/debug/dynamic_debug/control
> modprobe dvb_usb_af9035; echo -n 'module dvb_usb_af9035 +p' >
> /sys/kernel/debug/dynamic_debug/control
>
>
>> [44919.820892] DVB: registering new adapter (AVerMedia Twinstar (A825))
>> [44919.826864] af9033: firmware version: LINK=11.5.9.0 OFDM=5.17.9.1
>> [44919.826875] DVB: registering adapter 0 frontend 0 (Afatech AF9033
>> (DVB-T))...
>> [44920.166089] mxl5007t 16-0060: creating new instance
>> [44920.166883] mxl5007t_get_chip_id: unknown rev (3f)
>> [44920.166891] mxl5007t_get_chip_id: MxL5007T detected @ 16-0060
>> [44920.178890] usb 2-1.2: dvb_usbv2: 'AVerMedia Twinstar (A825)' error
>> while loading driver (-22)
>
> hmm, -22 == -EINVAL. Should look where this is coming from...

It was coming from the remote controller registration when there is no 
keytable defined :/

Maybe best to load RC_MAP_EMPTY from af9035 in case no remote map defined...
rc->map_name = RC_MAP_EMPTY;

Anyhow, I have to look how to resolve that correctly.

regards
Antti

-- 
http://palosaari.fi/


