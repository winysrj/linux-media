Return-path: <mchehab@pedra>
Received: from mail.kapsi.fi ([217.30.184.167]:56057 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751648Ab1FRM4f (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 18 Jun 2011 08:56:35 -0400
Message-ID: <4DFCA07D.5030404@iki.fi>
Date: Sat, 18 Jun 2011 15:56:29 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Thomas Holzeisen <thomas@holzeisen.de>
CC: =?UTF-8?B?U2FzY2hhIFfDvHN0ZW1hbm4=?= <sascha@killerhippy.de>,
	linux-media@vger.kernel.org,
	Jan Hoogenraad <jan-conceptronic@hoogenraad.net>
Subject: Re: RTL2831U wont compile against 2.6.38
References: <4DF9BCAA.3030301@holzeisen.de> <4DF9EA62.2040008@killerhippy.de> <4DFB2EE4.2030400@holzeisen.de> <4DFBAAE7.9070204@killerhippy.de> <4DFC9DB5.104@holzeisen.de>
In-Reply-To: <4DFC9DB5.104@holzeisen.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On 06/18/2011 03:44 PM, Thomas Holzeisen wrote:
> I already resolved the symbol thing. Your lsusb explains a lot, you have a RTl2832, while I have
> the RTL2831 which seem to be Revision 4 of the RTL2830.
>
> However, there seem to be big similarities between all those chips. It might be not that hard for
> the contributors of this driver to add support for the early chips as well. Maybe Jan can shade
> some light on it, since he wrote the initial RTL2831 driver. In any case I may help with testing it.

I think there is no such revision 4 RTL2830 which is RTL2831. I think 
you misunderstand. There is DVB-T demods RTL2830 and RTL2832. Then there 
is USB-bridge let's call it RTL28xxU. When you put USB-bridge and demod 
together you get chips called RTL2831U (USB-bridge + RTL2830 demod) and 
RTL2832U (USB-bridge + RTL2832 demod).

Also many other Realtek demods exits which uses same USB-bridge.


regards
Antti



-- 
http://palosaari.fi/
