Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-05.arcor-online.net ([151.189.21.45]:47098 "EHLO
	mail-in-05.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750772Ab0BLFWg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Feb 2010 00:22:36 -0500
Subject: Re: [cron job] v4l-dvb daily build 2.6.22 and up: ERRORS,
 2.6.16-2.6.21: ERRORS
From: hermann pitton <hermann-pitton@arcor.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org
In-Reply-To: <201002111918.o1BJIKH9044660@smtp-vbr13.xs4all.nl>
References: <201002111918.o1BJIKH9044660@smtp-vbr13.xs4all.nl>
Content-Type: text/plain
Date: Fri, 12 Feb 2010 06:22:19 +0100
Message-Id: <1265952139.2533.2.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am Donnerstag, den 11.02.2010, 20:18 +0100 schrieb Hans Verkuil:
> This message is generated daily by a cron job that builds v4l-dvb for
> the kernels and architectures in the list below.
> 
> Results of the daily build of v4l-dvb:
> 
> date:        Thu Feb 11 19:01:22 CET 2010
> path:        http://www.linuxtv.org/hg/v4l-dvb
> changeset:   14197:095b1aec2354
> gcc version: i686-linux-gcc (GCC) 4.4.3
> host hardware:    x86_64
> host os:     2.6.32.5
> 
> linux-2.6.32.6-armv5: OK
> linux-2.6.33-rc5-armv5: OK
> linux-2.6.32.6-armv5-davinci: ERRORS
> linux-2.6.33-rc5-armv5-davinci: ERRORS
> linux-2.6.32.6-armv5-dm365: ERRORS
> linux-2.6.33-rc5-armv5-dm365: ERRORS
> linux-2.6.32.6-armv5-ixp: OK
> linux-2.6.33-rc5-armv5-ixp: OK
> linux-2.6.32.6-armv5-omap2: OK
> linux-2.6.33-rc5-armv5-omap2: OK
> linux-2.6.22.19-i686: ERRORS
> linux-2.6.23.17-i686: ERRORS
> linux-2.6.24.7-i686: ERRORS
> linux-2.6.25.20-i686: ERRORS
> linux-2.6.26.8-i686: ERRORS
> linux-2.6.27.44-i686: ERRORS
> linux-2.6.28.10-i686: ERRORS
> linux-2.6.29.1-i686: ERRORS
> linux-2.6.30.10-i686: ERRORS
> linux-2.6.31.12-i686: WARNINGS
> linux-2.6.32.6-i686: OK
> linux-2.6.33-rc5-i686: OK
> linux-2.6.32.6-m32r: OK
> linux-2.6.33-rc5-m32r: OK
> linux-2.6.32.6-mips: OK
> linux-2.6.33-rc5-mips: OK
> linux-2.6.32.6-powerpc64: OK
> linux-2.6.33-rc5-powerpc64: OK
> linux-2.6.22.19-x86_64: ERRORS
> linux-2.6.23.17-x86_64: ERRORS
> linux-2.6.24.7-x86_64: ERRORS
> linux-2.6.25.20-x86_64: ERRORS
> linux-2.6.26.8-x86_64: ERRORS
> linux-2.6.27.44-x86_64: ERRORS
> linux-2.6.28.10-x86_64: ERRORS
> linux-2.6.29.1-x86_64: ERRORS
> linux-2.6.30.10-x86_64: ERRORS
> linux-2.6.31.12-x86_64: WARNINGS
> linux-2.6.32.6-x86_64: OK
> linux-2.6.33-rc5-x86_64: OK
> spec: OK
> sparse (v4l-dvb-git): ERRORS
> sparse (linux-2.6.33-rc5): ERRORS
> linux-2.6.16.62-i686: ERRORS
> linux-2.6.17.14-i686: ERRORS
> linux-2.6.18.8-i686: ERRORS
> linux-2.6.19.7-i686: ERRORS
> linux-2.6.20.21-i686: ERRORS
> linux-2.6.21.7-i686: ERRORS
> linux-2.6.16.62-x86_64: ERRORS
> linux-2.6.17.14-x86_64: ERRORS
> linux-2.6.18.8-x86_64: ERRORS
> linux-2.6.19.7-x86_64: ERRORS
> linux-2.6.20.21-x86_64: ERRORS
> linux-2.6.21.7-x86_64: ERRORS
> 
> Detailed results are available here:
> 
> http://www.xs4all.nl/~hverkuil/logs/Thursday.log
> 
> Full logs are available here:
> 
> http://www.xs4all.nl/~hverkuil/logs/Thursday.tar.bz2
> 
> The V4L-DVB specification from this daily build is here:
> 
> http://www.xs4all.nl/~hverkuil/spec/media.html



Douglas did fix it on current hg.

Cheers,
Hermann


