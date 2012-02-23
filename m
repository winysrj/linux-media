Return-path: <linux-media-owner@vger.kernel.org>
Received: from jaguar.purple-paw.com ([79.99.64.40]:41457 "EHLO
	jaguar.purple-paw.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752002Ab2BWLnt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 23 Feb 2012 06:43:49 -0500
Message-ID: <4F462670.7060707@rker.me.uk>
Date: Thu, 23 Feb 2012 11:43:44 +0000
From: Edd Barker <eddb@rker.me.uk>
MIME-Version: 1.0
To: Lars Hanisch <dvb@cinnamon-sage.de>
CC: linux-media@vger.kernel.org
Subject: Re: Cine CT v6
References: <4F44E821.2010804@rker.me.uk> <4F45280D.1000304@cinnamon-sage.de>
In-Reply-To: <4F45280D.1000304@cinnamon-sage.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Thanks Lars,

dvb-fe-tool worked great, appreciate the help.

Regards
Edd

On 22/02/2012 17:38, Lars Hanisch wrote:
> Hi,
>
> Am 22.02.2012 14:05, schrieb Edd Barker:
>> Hi Members
>>
>> I've just got a Cine CT v6 card and have having a bit of trouble. I
>> want to use dvb-t only, I've followed the
>> instructions here...
>>
>> http://linuxtv.org/wiki/index.php/Digital_Devices_DuoFlex_C%26T
>>
>> The card is now appearing in /dev/dvb/adapter0 & /dev/dvb/adapter1.
>> However only one frontend is showing up and if I try
>> to scan dvb-t I get an error that I'm sure means I'm trying to use
>> dvb-c tuner.
>>
>> WARNING: frontend type (QAM) is not compatible with requested tuning
>> type (OFDM)
>>
>> I'm running on Ubuntu 11.10, 3.0.0-16 kernal. Is this something anyone
>> else has come across or knows what I can do to
>> use the dvb-t frontend?
>
> You can use dvb-fe-tool to switch the type of delivery system used as a
> default for old applications.
> In the near past the drivers of hybrid cards were changed so there's
> only one frontend for all delivery systems, since they can only be
> opened mutually exclusive.
>
> There should be an PPA at Launchpad with a recent version of the
> tools/utils, but I don't have the URL at the moment.
>
> Regards,
> Lars.
>
>>
>> Thanks
>> Edd
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at http://vger.kernel.org/majordomo-info.html
>>
