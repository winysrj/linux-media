Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:56226 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753359Ab2HPNqE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Aug 2012 09:46:04 -0400
Received: by lagy9 with SMTP id y9so1464692lag.19
        for <linux-media@vger.kernel.org>; Thu, 16 Aug 2012 06:46:03 -0700 (PDT)
Message-ID: <502CF98B.1060700@iki.fi>
Date: Thu, 16 Aug 2012 16:45:47 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-media <linux-media@vger.kernel.org>
Subject: Re: dvb-usb-v2 change broke s2250-loader compilation
References: <201208161233.43618.hverkuil@xs4all.nl> <502CE527.2070006@iki.fi>
In-Reply-To: <502CE527.2070006@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/16/2012 03:18 PM, Antti Palosaari wrote:
> On 08/16/2012 01:33 PM, Hans Verkuil wrote:
>> Building the kernel with the Sensoray 2250/2251 staging go7007 driver
>> enabled
>> fails with this link error:
>>
>> ERROR: "usb_cypress_load_firmware"
>> [drivers/staging/media/go7007/s2250-loader.ko] undefined!
>>
>> As far as I can tell this is related to the dvb-usb-v2 changes.
>>
>> Can someone take a look at this?
>>
>> Thanks!
>>
>>     Hans
>
> Yes it is dvb usb v2 related. I wasn't even aware that someone took that
> module use in few days after it was added for the dvb-usb-v2.
>
> Maybe it is worth to make it even more common and move out of dvb-usb-v2...
>
> regards
> Antti

And after looking it twice I cannot see the reason. I split that Cypress 
firmware download to own module called dvb_usb_cypress_firmware which 
offer routine usbv2_cypress_load_firmware(). Old DVB USB is left 
untouched. I can confirm it fails to compile for s2250, but there is 
still old dvb_usb_cxusb that is compiling without a error.

Makefile paths seems to be correct also, no idea whats wrong....


regards
Antti


-- 
http://palosaari.fi/
