Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:1276 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932493AbZHUUpG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 21 Aug 2009 16:45:06 -0400
Received: from durdane.lan (marune.xs4all.nl [82.95.89.49])
	by smtp-vbr4.xs4all.nl (8.13.8/8.13.8) with ESMTP id n7LKj65F031183
	for <linux-media@vger.kernel.org>; Fri, 21 Aug 2009 22:45:06 +0200 (CEST)
	(envelope-from hverkuil@xs4all.nl)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: Re: [cron job] v4l-dvb daily build 2.6.22 and up: ERRORS, 2.6.16-2.6.21: ERRORS
Date: Fri, 21 Aug 2009 22:45:05 +0200
References: <200908211817.n7LIHIqA054646@smtp-vbr4.xs4all.nl>
In-Reply-To: <200908211817.n7LIHIqA054646@smtp-vbr4.xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908212245.05796.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Friday 21 August 2009 20:17:18 Hans Verkuil wrote:
> This message is generated daily by a cron job that builds v4l-dvb for
> the kernels and architectures in the list below.

Guys, I'm providing this service for a reason: please take a look at the 
detailed log when you see errors or warnings.

This time round we have a compat error with DIV_ROUND_CLOSEST:

v4l/stb6100.c: In function 'stb6100_set_frequency':
v4l/stb6100.c:377: error: implicit declaration of 
function 'DIV_ROUND_CLOSEST'

Should be simple to fix. This macro appeared in 2.6.29 and so should be made 
available in compat.h.

I also get a large amount of errors on smssdio.c for kernels pre-2.6.24:

v4l/smssdio.c:39:33: error: linux/mmc/sdio_func.h: No such file or directory
v4l/smssdio.c:51: error: array type has incomplete element type
v4l/smssdio.c:52: warning: implicit declaration of function 'SDIO_DEVICE'
v4l/smssdio.c:53: error: field name not in record or union initializer
v4l/smssdio.c:53: error: (near initialization for 'smssdio_ids')

This header appeared in 2.6.24 for the first time, so this driver shouldn't 
be build on older kernel versions.

There is also a warning here:

v4l/smssdio.c: In function 'smssdio_sendrequest':
v4l/smssdio.c:81: warning: 'ret' may be used uninitialized in this function

The bttv driver has been broken for a loooong time for kernels <= 2.6.19:

v4l/bttv-driver.c:4635: warning: implicit declaration of 
function 'PCI_VDEVICE'
v4l/bttv-driver.c:4635: error: 'BROOKTREE' undeclared here (not in a 
function)

I don't care about anything pre-2.6.22, but since some people wanted it I've 
kept compiling against these old kernels. But if nobody fixes this soon, 
then I'm going to kill that off since I have better uses for those CPU 
cycles.

Bottom line: if you know that a change of yours was merged in v4l-dvb, and 
you see errors or warnings appearing in the daily build, then take a look 
if your change caused it, and if so, then please fix it asap.

Regards,

	Hans

>
> Results of the daily build of v4l-dvb:
>
> date:        Fri Aug 21 19:00:07 CEST 2009
> path:        http://www.linuxtv.org/hg/v4l-dvb
> changeset:   12492:d0ec20a376fe
> gcc version: gcc (GCC) 4.3.1
> hardware:    x86_64
> host os:     2.6.26
>
> linux-2.6.22.19-armv5: OK
> linux-2.6.23.12-armv5: OK
> linux-2.6.24.7-armv5: OK
> linux-2.6.25.11-armv5: OK
> linux-2.6.26-armv5: OK
> linux-2.6.27-armv5: OK
> linux-2.6.28-armv5: OK
> linux-2.6.29.1-armv5: OK
> linux-2.6.30-armv5: OK
> linux-2.6.31-rc5-armv5: OK
> linux-2.6.27-armv5-ixp: ERRORS
> linux-2.6.28-armv5-ixp: ERRORS
> linux-2.6.29.1-armv5-ixp: OK
> linux-2.6.30-armv5-ixp: OK
> linux-2.6.31-rc5-armv5-ixp: OK
> linux-2.6.28-armv5-omap2: ERRORS
> linux-2.6.29.1-armv5-omap2: OK
> linux-2.6.30-armv5-omap2: OK
> linux-2.6.31-rc5-armv5-omap2: OK
> linux-2.6.22.19-i686: ERRORS
> linux-2.6.23.12-i686: ERRORS
> linux-2.6.24.7-i686: ERRORS
> linux-2.6.25.11-i686: ERRORS
> linux-2.6.26-i686: ERRORS
> linux-2.6.27-i686: ERRORS
> linux-2.6.28-i686: ERRORS
> linux-2.6.29.1-i686: WARNINGS
> linux-2.6.30-i686: WARNINGS
> linux-2.6.31-rc5-i686: OK
> linux-2.6.23.12-m32r: ERRORS
> linux-2.6.24.7-m32r: OK
> linux-2.6.25.11-m32r: OK
> linux-2.6.26-m32r: OK
> linux-2.6.27-m32r: OK
> linux-2.6.28-m32r: OK
> linux-2.6.29.1-m32r: OK
> linux-2.6.30-m32r: OK
> linux-2.6.31-rc5-m32r: OK
> linux-2.6.30-mips: WARNINGS
> linux-2.6.31-rc5-mips: OK
> linux-2.6.27-powerpc64: ERRORS
> linux-2.6.28-powerpc64: ERRORS
> linux-2.6.29.1-powerpc64: WARNINGS
> linux-2.6.30-powerpc64: WARNINGS
> linux-2.6.31-rc5-powerpc64: OK
> linux-2.6.22.19-x86_64: ERRORS
> linux-2.6.23.12-x86_64: ERRORS
> linux-2.6.24.7-x86_64: ERRORS
> linux-2.6.25.11-x86_64: ERRORS
> linux-2.6.26-x86_64: ERRORS
> linux-2.6.27-x86_64: ERRORS
> linux-2.6.28-x86_64: ERRORS
> linux-2.6.29.1-x86_64: WARNINGS
> linux-2.6.30-x86_64: WARNINGS
> linux-2.6.31-rc5-x86_64: OK
> sparse (linux-2.6.30): OK
> sparse (linux-2.6.31-rc5): OK
> linux-2.6.16.61-i686: ERRORS
> linux-2.6.17.14-i686: ERRORS
> linux-2.6.18.8-i686: ERRORS
> linux-2.6.19.5-i686: ERRORS
> linux-2.6.20.21-i686: ERRORS
> linux-2.6.21.7-i686: ERRORS
> linux-2.6.16.61-x86_64: ERRORS
> linux-2.6.17.14-x86_64: ERRORS
> linux-2.6.18.8-x86_64: ERRORS
> linux-2.6.19.5-x86_64: ERRORS
> linux-2.6.20.21-x86_64: ERRORS
> linux-2.6.21.7-x86_64: ERRORS
>
> Detailed results are available here:
>
> http://www.xs4all.nl/~hverkuil/logs/Friday.log
>
> Full logs are available here:
>
> http://www.xs4all.nl/~hverkuil/logs/Friday.tar.bz2
>
> The V4L2 specification from this daily build is here:
>
> http://www.xs4all.nl/~hverkuil/spec/v4l2.html
>
> The DVB API specification from this daily build is here:
>
> http://www.xs4all.nl/~hverkuil/spec/dvbapi.pdf
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
