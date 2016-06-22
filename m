Return-path: <linux-media-owner@vger.kernel.org>
Received: from v-smtpgw2.han.skanova.net ([81.236.60.205]:38543 "EHLO
	v-smtpgw2.han.skanova.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752408AbcFVR5R (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Jun 2016 13:57:17 -0400
Subject: Re: Problems with Si2168 DVB-C card (cx23885)
To: Hurda <hurda@chello.at>, linux-media@vger.kernel.org
References: <10ab0033-763e-94d8-f638-716c5b2507e8@ipvs.uni-stuttgart.de>
 <576A995F.2050505@chello.at>
From: Torbjorn Jansson <torbjorn.jansson@mbox200.swipnet.se>
Message-ID: <a917e696-300b-d2f8-c75f-7dbe45eba51a@mbox200.swipnet.se>
Date: Wed, 22 Jun 2016 19:57:32 +0200
MIME-Version: 1.0
In-Reply-To: <576A995F.2050505@chello.at>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 2016-06-22 15:57, Hurda wrote:
>
>> kernel: si2168 8-0064: found a 'Silicon Labs Si2168-B40'
>> kernel: si2168 8-0064: downloading firmware from file
>> 'dvb-demod-si2168-b40-01.fw'
>> kernel: si2168 8-0064: firmware version: 4.0.19
>>
>>
>> Distribution is Arch. Kernel version is 4.6.2.
>
> IIRC you have to use firmware-version 4.0.11 in pre-4.8-kernels.
> http://palosaari.fi/linux/v4l-dvb/firmware/Si2168/Si2168-B40/4.0.11/
> There was a message on this mailing list a few weeks ago (May 21st,
> regarding DVBSky T330).
>
> Might work with that.

i got a similar card but for dvb-t2 i also found out that one of the 
firmware files must be a specific version.
the one i got from dvbskys firmware package did not work at all except 
with their binary blob driver.

but i'm not yet able to properly test my card since i'm still on 4.4 
kernel (fedora 22) and media_build is broken when modprobing cx23885 
module, dmesg complains about duplicate symbol and modprobe fails with 
exec format error.


