Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:58927 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751441Ab3BOLjd (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Feb 2013 06:39:33 -0500
Message-ID: <511E1E4E.7050005@iki.fi>
Date: Fri, 15 Feb 2013 13:38:54 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Alexander List <alex@list.priv.at>
CC: linux-media@vger.kernel.org
Subject: Re: DMB-H USB Sticks: MagicPro ProHDTV Mini 2 USB
References: <511D8DF9.7060508@list.priv.at> <511E0200.6080508@iki.fi> <511E16FF.4050602@list.priv.at>
In-Reply-To: <511E16FF.4050602@list.priv.at>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/15/2013 01:07 PM, Alexander List wrote:
> On 02/15/2013 05:38 PM, Antti Palosaari wrote:
>
> Terve!

=)

>
>> First thing to do is identify used chips. Open the box and find out 3
>> biggest chip. There may be 1, 2 or 3 big chips depending on
>> integration level.
>
> OK, my Nikon's charger is somewhere, so I have to transcribe what I see ...
>
> On the back of the PCB we have a package with 8 pins, labeled C02H
> P26XOD - looks like an EEPROM, Google says. [1]
> On the front we have one big RTL2836BU C2K84A1 GC10 [2], and one smaller
> FC0013 C1236 0035L. There are two packages with metal enclosure saying
> NTK 27.000F, I guess XTALs.
>
> Hope this helps ...

Yeah, that quite enough.

RTL2836BU is USB interface and demod integrated to one package
FC0013 is RF tuner

Xtal freq sounds a little bit unusual compared to those used for DVB-T 
sticks.

Biggest challenge is to make driver for the demod. USB interface could 
be just same which is used for RTL2831U/RTL2832U even lsusb looks 
different. If it is different then new USB interface driver is also 
needed. FC0013 driver exists. I am not going to work that one device!

>
> Alex
>
> [1] http://www.datasheetarchive.com/24C02H-datasheet.html
> [2] http://detail.china.alibaba.com/offer/1144172336.html
> [3] http://www.rtlsdr.org/ - Fitipower Tuner 50-1700 MHz

regards
Antti


-- 
http://palosaari.fi/
