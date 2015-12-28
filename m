Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp2-g21.free.fr ([212.27.42.2]:5268 "EHLO smtp2-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752131AbbL1MVL (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 28 Dec 2015 07:21:11 -0500
Subject: Re: Automatic device driver back-porting with media_build
To: linux-media <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
References: <5672A6F0.6070003@free.fr> <20151217105543.13599560@recife.lan>
 <56811270.7070907@free.fr>
From: Mason <slash.tmp@free.fr>
Message-ID: <5681292F.3010204@free.fr>
Date: Mon, 28 Dec 2015 13:21:03 +0100
MIME-Version: 1.0
In-Reply-To: <56811270.7070907@free.fr>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 28/12/2015 11:44, Mason wrote:

> Hello Mauro,
> 
> Haven't heard back from you in a while. Maybe someone else can point
> out what I'm doing wrong?
> 
> On 17/12/2015 13:55, Mauro Carvalho Chehab wrote:
> 
>> Mason wrote:
>>
>>> I have a TechnoTrend TT-TVStick CT2-4400v2 USB tuner, as described here:
>>> http://linuxtv.org/wiki/index.php/TechnoTrend_TT-TVStick_CT2-4400
>>>
>>> According to the article, the device is supported since kernel 3.19
>>> and indeed, if I use a 4.1 kernel, I can pick CONFIG_DVB_USB_DVBSKY
>>> and everything seems to work.
>>>
>>> Unfortunately (for me), I've been asked to make this driver work on
>>> an ancient 3.4 kernel.
>>
>> The goal is to allow compilation since 2.6.32, but please notice that
>> not all drivers will go that far. Basically, when the backport seems too
>> complex, we just remove the driver from the list of drivers that are
>> compiled for a given legacy version.
>>
>> See the file v4l/versions.txt to double-check if the drivers you need
>> have such restrictions. I suspect that, in the specific case of
>> DVB_USB_DVBSKY, it should compile.
> 
> Whatever options I pick for my 3.4 config, CONFIG_DVB_USB_DVBSKY remains
> unset in v4l/.config
> 
> $ grep -r DVB_USB_DVBSKY media_build/v4l/
> media_build/v4l/Kconfig:config DVB_USB_DVBSKY
> media_build/v4l/Kconfig.kern: [snip config USB]
> media_build/v4l/Kconfig.kern: [snip config I2C]
> media_build/v4l/.myconfig:CONFIG_DVB_USB_DVBSKY                        := n
> media_build/v4l/Makefile.media:obj-$(CONFIG_DVB_USB_DVBSKY) += dvb-usb-dvbsky.o
> media_build/v4l/.config:# CONFIG_DVB_USB_DVBSKY is not set
> 
> I suppose some prerequisite is missing?
> Does anything obvious come to mind?
> 
> I've resorted to interrupting the build and changing v4l/.config to
> CONFIG_DVB_USB_DVBSKY=m (and the module is correctly built) but this
> feels like an unnecessary hack.

/tmp/sandbox/media_build$ make allmodconfig

didn't add anything on top of what the vanilla 'make' did.

$ make menuconfig
make -C /tmp/sandbox/media_build/v4l menuconfig
make[1]: Entering directory `/tmp/sandbox/media_build/v4l'
/tmp/buildroot-2014.05-13/output/build/linux-custom/scripts/kconfig/mconf ./Kconfig
./Kconfig:519: syntax error
./Kconfig:518: unknown option "Say"
./Kconfig:519: unknown option "To"
./Kconfig:520: unknown option "called"
./Kconfig:523: syntax error
./Kconfig:522:warning: multi-line strings not supported
./Kconfig:522: unknown option "If"
make[1]: *** [menuconfig] Error 1
make[1]: Leaving directory `/tmp/sandbox/media_build/v4l'
make: *** [menuconfig] Error 2

I'll keep poking random knobs.

Regards.

