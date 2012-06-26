Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:50800 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750809Ab2FZTrn (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Jun 2012 15:47:43 -0400
Message-ID: <4FEA11D7.3040306@iki.fi>
Date: Tue, 26 Jun 2012 22:47:35 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: cedric.dewijs@telfort.nl
CC: mchehab@infradead.org, linux-media@vger.kernel.org
Subject: Re: Betr: Re: DiB0700 rc submit urb failed after reboot, ok after
 replug
References: <4FC4F2690000C052@mta-nl-9.mail.tiscali.sys>
In-Reply-To: <4FC4F2690000C052@mta-nl-9.mail.tiscali.sys>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/26/2012 10:43 PM, cedric.dewijs@telfort.nl wrote:
>
>>> [    6.517631] rc0: IR-receiver inside an USB DVB receiver as /devices/pci0000:00/0000:00:1d.7/usb2/2-4/rc/rc0
>>> [    6.517821] dvb-usb: schedule remote query interval to 50 msecs.
>>> [    6.517825] dvb-usb: Pinnacle PCTV 73e SE successfully initialized
> and
>>> connected.
>>> [    6.517951] dib0700: rc submit urb failed
>>
>> I am almost sure it is that issue I fixed:
>>
>> http://git.linuxtv.org/anttip/media_tree.git/commit/36bd9e4ba1de78bfb9f3bcf8b07c63a157da6499
>>
>>
>> Antti
>>
>> --
> Hi Antti,
>
> I have tried to test your fix, but I fail to build your kernel. Here's what
> I've done:
> $ git clone git://linuxtv.org/anttip/media_tree.git
> $ cd media_tree/
> $ cp /proc/config.gz .
> $ gunzip config.gz
> $ mv config .config
> $ make Xconfig
>    CHECK   qt
> sed < scripts/kconfig/lkc_proto.h > scripts/kconfig/lkc_defs.h 's/P(\([^,]*\),.*/#define
> \1 (\*\1_p)/'
>    HOSTCC  scripts/kconfig/kconfig_load.o
> /usr/bin/moc -i scripts/kconfig/qconf.h -o scripts/kconfig/qconf.moc
>    HOSTCXX scripts/kconfig/qconf.o
>    HOSTLD  scripts/kconfig/qconf
> scripts/kconfig/qconf Kconfig
> drivers/media/Kconfig:102: can't open file "drivers/media/IR/Kconfig"
> make[1]: *** [xconfig] Error 1
> make: *** [xconfig] Error 2
>
> I have googled for the error, but i could only find this site wich is not
> in a language I understand.
> http://www.linuxtv.fi/viewtopic.php?f=15&t=4560
>
> What have I missed?
> Best regards,
> Cedric

It does not resolve DiB0700 driver issue even you get it compile as 
there is no that driver. You can still copy paste changes and test if 
you wish.

regards
Antti


-- 
http://palosaari.fi/


