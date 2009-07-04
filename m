Return-path: <linux-media-owner@vger.kernel.org>
Received: from psmtp04.wxs.nl ([195.121.247.13]:55513 "EHLO psmtp04.wxs.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752684AbZGDHoH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 4 Jul 2009 03:44:07 -0400
Received: from localhost (ip545779c6.direct-adsl.nl [84.87.121.198])
 by psmtp04.wxs.nl
 (iPlanet Messaging Server 5.2 HotFix 2.15 (built Nov 14 2006))
 with ESMTP id <0KM800C82YT46X@psmtp04.wxs.nl> for linux-media@vger.kernel.org;
 Sat, 04 Jul 2009 09:44:09 +0200 (MEST)
Date: Sat, 04 Jul 2009 09:43:41 +0200
From: Jan Hoogenraad <jan-conceptronic@hoogenraad.net>
Subject: Re: Ralink RTL2831U
In-reply-to: <4A4E9A12.9080802@iki.fi>
To: Antti Palosaari <crope@iki.fi>
Cc: Jelle de Jong <jelledejong@powercraft.nl>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Message-id: <4A4F082D.7010909@hoogenraad.net>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7BIT
References: <4A448634.7000209@powercraft.nl> <4A4E9A12.9080802@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Please note that the current (not split-up) driver was developed by the 
maker of the hardware.
It is the same code that is used in the Windows driver.

As far as I have seen, there is only ONE callback from the tuner code to 
the demodulator.
I forgot the name of the routine.

Cheers,
		Jan

Antti Palosaari wrote:
> Moi Jelle,
> 
> On 06/26/2009 11:26 AM, Jelle de Jong wrote:
>> Question for Antti if he had any luck with the devices (rtl2831-r2) I 
>> send?
> 
> I have been busy with other drivers, but now I have time for this.
> 
> It was a little bit tricky to take sniffs from Windows because sniffer 
> crashed very easily with this device :o But after testing about all 
> drivers I found and after countless blue-screens I finally got one good 
> sniff. From sniff I see this device is rather simple to program. And 
> device you send have MT2060 tuner.
> 
> With a any luck and without other summer activities (I am still hoping 
> warm weather and beach activities :) it will not take many days to get 
> picture. After that I will move relevant parts from the current Ralink 
> driver to the new driver... I will keep informed about driver status.
> 
> regards
> Antti


-- 
Jan Hoogenraad
Hoogenraad Interface Services
Postbus 2717
3500 GS Utrecht
