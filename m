Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:1340 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752588Ab0A0VxN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Jan 2010 16:53:13 -0500
Received: from durdane.localnet (marune.xs4all.nl [82.95.89.49])
	(authenticated bits=0)
	by smtp-vbr2.xs4all.nl (8.13.8/8.13.8) with ESMTP id o0RLrBlS095694
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Wed, 27 Jan 2010 22:53:12 +0100 (CET)
	(envelope-from hverkuil@xs4all.nl)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: Re: [cron job] v4l-dvb daily build 2.6.22 and up: ERRORS, 2.6.16-2.6.21: ERRORS
Date: Wed, 27 Jan 2010 22:53:10 +0100
References: <201001272148.o0RLmOIv068753@smtp-vbr8.xs4all.nl>
In-Reply-To: <201001272148.o0RLmOIv068753@smtp-vbr8.xs4all.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201001272253.10864.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wednesday 27 January 2010 22:48:24 Hans Verkuil wrote:
> This message is generated daily by a cron job that builds v4l-dvb for
> the kernels and architectures in the list below.

It's up and running again. Note that I upgraded to the latest gcc 4.4.3.
I also updated all the kernels to their latest dot release.

I'm only building the i686 and x86_64 on all kernels from 2.6.16 onwards.
All other architectures are only built for 2.6.32 and 2.6.33. If someone wants
to build one of those for older kernels also, then just let me know.

Regards,

	Hans

> 
> Results of the daily build of v4l-dvb:
> 
> date:        Wed Jan 27 21:00:05 CET 2010
> path:        http://www.linuxtv.org/hg/v4l-dvb
> changeset:   14064:31eaa9423f98
> gcc version: i686-linux-gcc (GCC) 4.4.3
> host hardware:    x86_64
> host os:     2.6.32.5
> 
> linux-2.6.32.6-armv5: OK
> linux-2.6.33-rc5-armv5: OK
> linux-2.6.32.6-armv5-davinci: WARNINGS
> linux-2.6.33-rc5-armv5-davinci: WARNINGS
> linux-2.6.32.6-armv5-dm365: ERRORS
> linux-2.6.33-rc5-armv5-dm365: ERRORS
> linux-2.6.32.6-armv5-ixp: WARNINGS
> linux-2.6.33-rc5-armv5-ixp: WARNINGS
> linux-2.6.32.6-armv5-omap2: WARNINGS
> linux-2.6.33-rc5-armv5-omap2: WARNINGS
> linux-2.6.22.19-i686: WARNINGS
> linux-2.6.23.17-i686: WARNINGS
> linux-2.6.24.7-i686: WARNINGS
> linux-2.6.25.20-i686: WARNINGS
> linux-2.6.26.8-i686: WARNINGS
> linux-2.6.27.44-i686: WARNINGS
> linux-2.6.28.10-i686: WARNINGS
> linux-2.6.29.1-i686: WARNINGS
> linux-2.6.30.10-i686: WARNINGS
> linux-2.6.31.12-i686: WARNINGS
> linux-2.6.32.6-i686: WARNINGS
> linux-2.6.33-rc5-i686: WARNINGS
> linux-2.6.32.6-m32r: OK
> linux-2.6.33-rc5-m32r: OK
> linux-2.6.32.6-mips: WARNINGS
> linux-2.6.33-rc5-mips: WARNINGS
> linux-2.6.32.6-powerpc64: ERRORS
> linux-2.6.33-rc5-powerpc64: ERRORS
> linux-2.6.22.19-x86_64: WARNINGS
> linux-2.6.23.17-x86_64: WARNINGS
> linux-2.6.24.7-x86_64: WARNINGS
> linux-2.6.25.20-x86_64: WARNINGS
> linux-2.6.26.8-x86_64: WARNINGS
> linux-2.6.27.44-x86_64: WARNINGS
> linux-2.6.28.10-x86_64: WARNINGS
> linux-2.6.29.1-x86_64: WARNINGS
> linux-2.6.30.10-x86_64: WARNINGS
> linux-2.6.31.12-x86_64: WARNINGS
> linux-2.6.32.6-x86_64: WARNINGS
> linux-2.6.33-rc5-x86_64: WARNINGS
> spec: OK
> sparse (linux-2.6.32.6): ERRORS
> sparse (linux-2.6.33-rc5): ERRORS
> linux-2.6.16.62-i686: ERRORS
> linux-2.6.17.14-i686: ERRORS
> linux-2.6.18.8-i686: ERRORS
> linux-2.6.19.7-i686: OK
> linux-2.6.20.21-i686: WARNINGS
> linux-2.6.21.7-i686: WARNINGS
> linux-2.6.16.62-x86_64: ERRORS
> linux-2.6.17.14-x86_64: ERRORS
> linux-2.6.18.8-x86_64: ERRORS
> linux-2.6.19.7-x86_64: WARNINGS
> linux-2.6.20.21-x86_64: WARNINGS
> linux-2.6.21.7-x86_64: WARNINGS
> 
> Detailed results are available here:
> 
> http://www.xs4all.nl/~hverkuil/logs/Wednesday.log
> 
> Full logs are available here:
> 
> http://www.xs4all.nl/~hverkuil/logs/Wednesday.tar.bz2
> 
> The V4L-DVB specification from this daily build is here:
> 
> http://www.xs4all.nl/~hverkuil/spec/media.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
