Return-path: <linux-media-owner@vger.kernel.org>
Received: from cpsmtpb-ews08.kpnxchange.com ([213.75.39.13]:4236 "EHLO
	cpsmtpb-ews08.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750760Ab2FZTnl convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Jun 2012 15:43:41 -0400
Date: Tue, 26 Jun 2012 21:43:37 +0200
Message-ID: <4FC4F2690000C052@mta-nl-9.mail.tiscali.sys>
In-Reply-To: <4FE8D35E.7080802@iki.fi>
From: cedric.dewijs@telfort.nl
Subject: Betr: Re: DiB0700 rc submit urb failed after reboot, ok after replug
To: "Antti Palosaari" <crope@iki.fi>
Cc: mchehab@infradead.org, linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


>> [    6.517631] rc0: IR-receiver inside an USB DVB receiver as /devices/pci0000:00/0000:00:1d.7/usb2/2-4/rc/rc0
>> [    6.517821] dvb-usb: schedule remote query interval to 50 msecs.
>> [    6.517825] dvb-usb: Pinnacle PCTV 73e SE successfully initialized
and
>> connected.
>> [    6.517951] dib0700: rc submit urb failed
>
>I am almost sure it is that issue I fixed:
>
>http://git.linuxtv.org/anttip/media_tree.git/commit/36bd9e4ba1de78bfb9f3bcf8b07c63a157da6499
>
>
>Antti
>
>-- 
Hi Antti,

I have tried to test your fix, but I fail to build your kernel. Here's what
I've done:
$ git clone git://linuxtv.org/anttip/media_tree.git
$ cd media_tree/
$ cp /proc/config.gz .
$ gunzip config.gz
$ mv config .config
$ make Xconfig
  CHECK   qt
sed < scripts/kconfig/lkc_proto.h > scripts/kconfig/lkc_defs.h 's/P(\([^,]*\),.*/#define
\1 (\*\1_p)/'
  HOSTCC  scripts/kconfig/kconfig_load.o
/usr/bin/moc -i scripts/kconfig/qconf.h -o scripts/kconfig/qconf.moc
  HOSTCXX scripts/kconfig/qconf.o
  HOSTLD  scripts/kconfig/qconf
scripts/kconfig/qconf Kconfig
drivers/media/Kconfig:102: can't open file "drivers/media/IR/Kconfig"
make[1]: *** [xconfig] Error 1
make: *** [xconfig] Error 2

I have googled for the error, but i could only find this site wich is not
in a language I understand.
http://www.linuxtv.fi/viewtopic.php?f=15&t=4560

What have I missed?
Best regards,
Cedric




       



