Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:54524 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752485AbZJTUve (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Oct 2009 16:51:34 -0400
Message-ID: <4ADE22D3.7070701@iki.fi>
Date: Tue, 20 Oct 2009 23:51:31 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: =?UTF-8?B?UGF0cnlrIMWaY2lib3Jlaw==?= <patryk@sciborek.com>
CC: linux-media@vger.kernel.org
Subject: Re: HP/Yuan EC372S DVB-T
References: <1255987185.7941.35.camel@karaluszek.sciborek.com>	 <4ADCF597.4090200@iki.fi> <1256056757.7941.43.camel@karaluszek.sciborek.com>
In-Reply-To: <1256056757.7941.43.camel@karaluszek.sciborek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10/20/2009 07:39 PM, Patryk Ściborek wrote:
> Dnia 2009-10-20, wto o godzinie 02:26 +0300, Antti Palosaari pisze:
>
>> Do you have Windows XP drivers? I think I could fix that device if I get
>> my device working with Windows. And I only have XP...
>
> Hi,
>
> As far as I remember I've just installed (on XP) drivers from CD. It was
> included with the card. I've made a copy:
>
> http://sciborek.com/ec372/windrv.tar.bz2

Thanks. Now I found why I was failing earlier - it was due to USB2.0 
ExpressCard adapter I was using... :-( After I plugged it to Linux 
laptop native ExpressCard slot it attachs demod. Tuning is still always 
failing with filter timeouts. I even opened my box, there is DiBcom 
7700C1-ACXXa-G and Microtune MT2266F. I will hack that more later.

regards
Antti
-- 
http://palosaari.fi/
