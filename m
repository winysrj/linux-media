Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay01.digicable.hu ([92.249.128.189]:35748 "EHLO
	relay01.digicable.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751382Ab0CGFtc (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 7 Mar 2010 00:49:32 -0500
Message-ID: <4B933E69.8000000@freemail.hu>
Date: Sun, 07 Mar 2010 06:49:29 +0100
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-media@vger.kernel.org
Subject: Re: [cron job] v4l-dvb daily build 2.6.22 and up: ERRORS, 2.6.16-2.6.21:
 OK
References: <201003061952.o26JqdTY011655@smtp-vbr11.xs4all.nl>
In-Reply-To: <201003061952.o26JqdTY011655@smtp-vbr11.xs4all.nl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Hans,

Hans Verkuil wrote:
> This message is generated daily by a cron job that builds v4l-dvb for
> the kernels and architectures in the list below.
> 
> Results of the daily build of v4l-dvb:
> 
> date:        Sat Mar  6 19:00:21 CET 2010
> path:        http://www.linuxtv.org/hg/v4l-dvb
> changeset:   14392:72846c99c0f7
> gcc version: i686-linux-gcc (GCC) 4.4.3
> host hardware:    x86_64
> host os:     2.6.32.5
> 
> [...]
> linux-2.6.32.6-armv5-dm365: ERRORS
> linux-2.6.33-armv5-dm365: ERRORS

I was interested in what these errors could be so I checked the
http://www.xs4all.nl/~hverkuil/logs/Saturday.log file. Unfortunately this log
file does not contain more. So I also checked the detailed log files at
http://www.xs4all.nl/~hverkuil/logs/Saturday.tar.bz2
 * linux-2.6.33-armv5-dm365.log and
 * linux-2.6.32.6-armv5-dm365.log

> Sat Mar  6 19:03:59 CET 2010
> make -C /home/hans/work/build/v4l-dvb-master/v4l
> make[1]: Entering directory `/home/hans/work/build/v4l-dvb-master/v4l'
> scripts/make_makefile.pl
> ./scripts/make_kconfig.pl /home/hans/work/build/trees/armv5-dm365/linux-2.6.32.6 /home/hans/work/build/trees/armv5-dm365/linux-2.6.32.6
> Updating/Creating .config
> File not found: /home/hans/work/build/trees/armv5-dm365/linux-2.6.32.6/.config at ./scripts/make_kconfig.pl line 32, <IN> line 4.
> Preparing to compile for kernel version 2.6.32
> File not found: /home/hans/work/build/trees/armv5-dm365/linux-2.6.32.6/.config at ./scripts/make_kconfig.pl line 32, <IN> line 4.
> Preparing to compile for kernel version 2.6.32
> make[1]: Leaving directory `/home/hans/work/build/v4l-dvb-master/v4l'
> make[1]: Entering directory `/home/hans/work/build/v4l-dvb-master/v4l'
> ./scripts/make_kconfig.pl /home/hans/work/build/trees/armv5-dm365/linux-2.6.32.6 /home/hans/work/build/trees/armv5-dm365/linux-2.6.32.6
> Updating/Creating .config
> File not found: /home/hans/work/build/trees/armv5-dm365/linux-2.6.32.6/.config at ./scripts/make_kconfig.pl line 32, <IN> line 4.
> Preparing to compile for kernel version 2.6.32
> File not found: /home/hans/work/build/trees/armv5-dm365/linux-2.6.32.6/.config at ./scripts/make_kconfig.pl line 32, <IN> line 4.
> Preparing to compile for kernel version 2.6.32
> make[1]: *** No rule to make target `.myconfig', needed by `config-compat.h'.  Stop.
> make[1]: Leaving directory `/home/hans/work/build/v4l-dvb-master/v4l'
> make: *** [all] Error 2
> Sat Mar  6 19:03:59 CET 2010

I recommend to add the lines which contain the message "File not found" to the generated
http://www.xs4all.nl/~hverkuil/logs/Saturday.log log file.

By the way, what could be the problem here?

Regards,

	Márton Németh
