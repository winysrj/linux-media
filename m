Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:53755 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751144Ab0A2JZC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Jan 2010 04:25:02 -0500
Received: by bwz27 with SMTP id 27so1250366bwz.21
        for <linux-media@vger.kernel.org>; Fri, 29 Jan 2010 01:24:59 -0800 (PST)
Message-ID: <4B62A967.3010400@googlemail.com>
Date: Fri, 29 Jan 2010 09:24:55 +0000
From: David Henig <dhhenig@googlemail.com>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>
CC: linux-media@vger.kernel.org
Subject: Re: Make failed - standard ubuntu 9.10
References: <4B62113E.40905@googlemail.com> <4B627EAE.7020303@freemail.hu>
In-Reply-To: <4B627EAE.7020303@freemail.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Thanks, I've been trying to follow the wiki, but getting this error. The 
main kernel packages seem to all be installed, but perhaps something 
less obvious is missing - hard to tell without a definitive list of 
dependencies. Help would be much appreciated!

David

Németh Márton wrote:
> David Henig wrote:
>   
>> Please can someone assist, not sure what the cause of the below is? This 
>> is my second attempt to get linux tv to work, I suspect it's a basic 
>> level error - sorry I'm fairly new to Linux... output below, I'm running 
>> a fairly standard ubuntu 9.10 setup.
>>
>> make[1]: Entering directory `/home/david/v4l-dvb/v4l'
>> Updating/Creating .config
>> Preparing to compile for kernel version 2.6.31
>> File not found: /lib/modules/2.6.31-17-generic/build/.config at 
>> ./scripts/make_kconfig.pl line 32, <IN> line 4.
>> make[1]: *** No rule to make target `.myconfig', needed by 
>> `config-compat.h'. Stop.
>> make[1]: Leaving directory `/home/david/v4l-dvb/v4l'
>> make: *** [all] Error 2
>>     
>
> I think you don't have the kernel development files installed.
>
> The recommended reading would be:
> http://linuxtv.org/wiki/index.php/How_to_Obtain,_Build_and_Install_V4L-DVB_Device_Drivers
>
> Regards,
>
> 	Márton Németh
>   
