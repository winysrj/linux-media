Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:52967 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753559AbaBKUlz (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Feb 2014 15:41:55 -0500
Message-ID: <52FA8B10.9060009@iki.fi>
Date: Tue, 11 Feb 2014 22:41:52 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Malcolm Priestley <tvboxspy@gmail.com>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH 2/2] af9035: Add remaining it913x dual ids to af9035.
References: <1391951046.13992.15.camel@canaries32-MCP7A>	 <52FA6113.300@iki.fi> <1392150757.3378.14.camel@canaries32-MCP7A>
In-Reply-To: <1392150757.3378.14.camel@canaries32-MCP7A>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11.02.2014 22:32, Malcolm Priestley wrote:
> On Tue, 2014-02-11 at 19:42 +0200, Antti Palosaari wrote:
>> Moikka Malcolm!
>> Thanks for the patch serie.
>>
>> You removed all IDs from it913x driver. There is possibility to just
>> remove / comment out:
>> 	MODULE_DEVICE_TABLE(usb, it913x_id_table);
>> which prevents loading that driver automatically, but leaves possibility
>> to load it manually if user wants to fallback. I am fine either way you
>> decide to do it, just a propose.
> Hi Antti
>
> I am going post a patches to remove it.
>
> The only reason why an user would want to fall back is
> the use dvb-usb-it9137-01.fw firmware with USB_VID_KWORLD_2.
>
> I left the USB_VID_KWORLD_2 ids in the driver.
>
> I haven't found any issues with dvb-usb-it9135-01.fw
>
> USB_VID_KWORLD_2 users could have trouble updating older kernels via
> media_build.
>
> Perhaps there should be a warning message in af9035 that users need to
> change firmware.

Is that KẂorld device dual model (I guess yes, because of it9137)? Is it 
version 1 (AX) or version 2 (BX) chip?

If it is dual with version 1 chips, it is similar than that:
http://blog.palosaari.fi/2013/06/naked-hardware-9-terratec-cinergy-t.html

I suspect firmware is same for both it9135 or it9137 and only difference 
between chips is pins to connect slave demodulator.

Maybe difference is just firmware version and it is likely older (as I 
extracted one it9135 ver. 1 fw from latest windows driver). Have to 
check that.

regards
Antti

-- 
http://palosaari.fi/
