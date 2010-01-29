Return-path: <linux-media-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.26]:29232 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753515Ab0A2MaU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Jan 2010 07:30:20 -0500
Received: by ey-out-2122.google.com with SMTP id 22so147664eye.5
        for <linux-media@vger.kernel.org>; Fri, 29 Jan 2010 04:30:18 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4B62A967.3010400@googlemail.com>
References: <4B62113E.40905@googlemail.com> <4B627EAE.7020303@freemail.hu>
	 <4B62A967.3010400@googlemail.com>
Date: Fri, 29 Jan 2010 07:30:18 -0500
Message-ID: <c2fe070d1001290430v472c8040r2a61c7904ef7234d@mail.gmail.com>
Subject: Re: Make failed - standard ubuntu 9.10
From: leandro Costantino <lcostantino@gmail.com>
To: David Henig <dhhenig@googlemail.com>
Cc: =?ISO-8859-1?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Its looking for .config file inside the kernel source.

/lib/modules/2.6.31-17-generic/build/.config
  1) check that /build is a symlink to /usr/src/kernel-path-source
  2) IF there is something like /proc/config  , copy it to
/usr/src/kernel-path-source/.config
      IF NOT, then you could try doing a make oldconfig ....

I really dont know that the ubuntu packages includes inside, so, those
are my 2 cents...

2010/1/29 David Henig <dhhenig@googlemail.com>:
> Thanks, I've been trying to follow the wiki, but getting this error. The
> main kernel packages seem to all be installed, but perhaps something less
> obvious is missing - hard to tell without a definitive list of dependencies.
> Help would be much appreciated!
>
> David
>
> Németh Márton wrote:
>>
>> David Henig wrote:
>>
>>>
>>> Please can someone assist, not sure what the cause of the below is? This
>>> is my second attempt to get linux tv to work, I suspect it's a basic level
>>> error - sorry I'm fairly new to Linux... output below, I'm running a fairly
>>> standard ubuntu 9.10 setup.
>>>
>>> make[1]: Entering directory `/home/david/v4l-dvb/v4l'
>>> Updating/Creating .config
>>> Preparing to compile for kernel version 2.6.31
>>> File not found: /lib/modules/2.6.31-17-generic/build/.config at
>>> ./scripts/make_kconfig.pl line 32, <IN> line 4.
>>> make[1]: *** No rule to make target `.myconfig', needed by
>>> `config-compat.h'. Stop.
>>> make[1]: Leaving directory `/home/david/v4l-dvb/v4l'
>>> make: *** [all] Error 2
>>>
>>
>> I think you don't have the kernel development files installed.
>>
>> The recommended reading would be:
>>
>> http://linuxtv.org/wiki/index.php/How_to_Obtain,_Build_and_Install_V4L-DVB_Device_Drivers
>>
>> Regards,
>>
>>        Márton Németh
>>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
