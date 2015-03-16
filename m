Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:50032 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751345AbbCPVEI (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Mar 2015 17:04:08 -0400
Message-ID: <55074543.4060303@iki.fi>
Date: Mon, 16 Mar 2015 23:04:03 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Benjamin Larsson <benjamin@southpole.se>, mchehab@osg.samsung.com
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 04/10] rtl28xxu: swap frontend order for slave demods
References: <1426460275-3766-1-git-send-email-benjamin@southpole.se> <1426460275-3766-4-git-send-email-benjamin@southpole.se> <550740A7.2080809@southpole.se>
In-Reply-To: <550740A7.2080809@southpole.se>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/16/2015 10:44 PM, Benjamin Larsson wrote:
> On 03/15/2015 11:57 PM, Benjamin Larsson wrote:
>> Some devices have 2 demodulators, when this is the case
>> make the slave demod be listed first. Enumerating the slave
>> first will help legacy applications to use the hardware.
>>
>
> Ignore this patch for now. Stuff gets broken if applied.

I will not apply it even you fix it. I don't like idea adding such hack 
to kernel in order to workaround buggy applications. There is many older 
devices having similar situation, having 2 demods - one for DVB-T and 
one for DVB-C. So there has been surely enough time for app developers 
to add support for multiple frontends... laziness.

Quite same happened for DVB-T2 support. I added initially hack for 
CXD2820R driver in order to support DVB-T2 even applications are not 
supporting it. That was implemented using trick driver did DVB-T2 tune 
when DVB-T tune fails. After many years I did another DVB-T2 driver 
Si2168 and didn't add such hack anymore. And what was result; almost all 
applications were still lacking proper DVB-T2 support, after many many 
years...

So I will never ever add any hacks to driver to workaround application 
support as application developers are so lazy to add support or new 
things if there is some workaround available.

regards
Antti

-- 
http://palosaari.fi/
