Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:46141 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754121Ab1KFSHd (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 6 Nov 2011 13:07:33 -0500
Message-ID: <4EB6CCE3.4020809@iki.fi>
Date: Sun, 06 Nov 2011 20:07:31 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Patrick Boettcher <pboettcher@kernellabs.com>
CC: linux-media <linux-media@vger.kernel.org>
Subject: Re: FX2 FW: conversion from Intel HEX to DVB USB "hexline"
References: <4EB6990C.8000904@iki.fi> <201111061858.00709.pboettcher@kernellabs.com>
In-Reply-To: <201111061858.00709.pboettcher@kernellabs.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Many thanks!

Actually, I was just started to write similar Python script! You got 
maybe 15min late but still 15min before mine was ready :)

Format was nothing more than convert ASCII hex values to binary bytes 
and stripping out all white spaces and Intel HEX start code ":".

Why it was initially converted to binary and not used Intel HEX as it 
is? I think you know, as a original author, history about that decision?

regards
Antti

On 11/06/2011 07:58 PM, Patrick Boettcher wrote:
> Hi Antti,
>
> On Sunday, November 06, 2011 03:26:20 PM Antti Palosaari wrote:
>> Is there any simple tool (or one liner script :) to convert normal Intel
>> HEX firmware to format used by DVB USB Cypress firmware loader?
>>
>> Or is there some other way those are created?
>>
>> Loader is here:
>> dvb-usb-firmware.c
>> int usb_cypress_load_firmware()
>
> I'm sure that you have found something yourself in the meantime, but I used
> the attached script to convert .hex to binaries.
>
> HTH,
>
> --
> Patrick Boettcher - KernelLabs
> http://www.kernellabs.com/


-- 
http://palosaari.fi/
