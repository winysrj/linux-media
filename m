Return-path: <mchehab@pedra>
Received: from psmtp30.wxs.nl ([195.121.247.32]:44755 "EHLO psmtp30.wxs.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753009Ab0HYLLn (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 25 Aug 2010 07:11:43 -0400
Received: from localhost (ip545779c6.direct-adsl.nl [84.87.121.198])
 by psmtp30.wxs.nl
 (iPlanet Messaging Server 5.2 HotFix 2.15 (built Nov 14 2006))
 with ESMTP id <0L7P004DGGFFWI@psmtp30.wxs.nl> for linux-media@vger.kernel.org;
 Wed, 25 Aug 2010 13:11:42 +0200 (MEST)
Date: Wed, 25 Aug 2010 13:11:13 +0200
From: Jan Hoogenraad <jan-conceptronic@hoogenraad.net>
Subject: Failure of v4l-dvb daily build against kernel 2.6.28 and others
In-reply-to: <201008241840.o7OIeiF9051544@smtp-vbr2.xs4all.nl>
To: Douglas Schilling Landgraf <dougsland@gmail.com>
Cc: linux-media@vger.kernel.org
Message-id: <4C74FA51.8040805@hoogenraad.net>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7BIT
References: <201008241840.o7OIeiF9051544@smtp-vbr2.xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

Douglas:

I now see that some more versions have several build errors and/or warnings.

Could you, in the process of backporting, try to reduce this as well ?

Hans Verkuil wrote:
> This message is generated daily by a cron job that builds v4l-dvb for
> the kernels and architectures in the list below.
> 
> Results of the daily build of v4l-dvb:
> 
> date:        Tue Aug 24 19:00:24 CEST 2010
> path:        http://www.linuxtv.org/hg/v4l-dvb
> changeset:   15131:2ceef3d75547
> git master:       f6760aa024199cfbce564311dc4bc4d47b6fb349
> git media-master: 1c1371c2fe53ded8ede3a0404c9415fbf3321328
> gcc version:      i686-linux-gcc (GCC) 4.4.3
> host hardware:    x86_64
> host os:          2.6.32.5
> 
> linux-2.6.32.6-armv5: ERRORS
> linux-2.6.33-armv5: WARNINGS
> linux-2.6.34-armv5: WARNINGS
> linux-2.6.35-rc1-armv5: WARNINGS
> linux-2.6.32.6-armv5-davinci: ERRORS
> linux-2.6.33-armv5-davinci: ERRORS
> linux-2.6.34-armv5-davinci: ERRORS
> linux-2.6.35-rc1-armv5-davinci: ERRORS
> linux-2.6.32.6-armv5-ixp: ERRORS
> linux-2.6.33-armv5-ixp: ERRORS
> linux-2.6.34-armv5-ixp: ERRORS
> linux-2.6.35-rc1-armv5-ixp: ERRORS
> linux-2.6.32.6-armv5-omap2: ERRORS
> linux-2.6.33-armv5-omap2: ERRORS
> linux-2.6.34-armv5-omap2: ERRORS
> linux-2.6.35-rc1-armv5-omap2: ERRORS
> linux-2.6.22.19-i686: ERRORS
> linux-2.6.23.17-i686: ERRORS
> linux-2.6.24.7-i686: ERRORS
> linux-2.6.25.20-i686: ERRORS
> linux-2.6.26.8-i686: ERRORS
> linux-2.6.27.44-i686: ERRORS
> linux-2.6.28.10-i686: ERRORS
> linux-2.6.29.1-i686: ERRORS
> linux-2.6.30.10-i686: ERRORS
> linux-2.6.31.12-i686: ERRORS
> linux-2.6.32.6-i686: ERRORS
> linux-2.6.33-i686: ERRORS
> linux-2.6.34-i686: ERRORS
> linux-2.6.35-rc1-i686: ERRORS
> linux-2.6.32.6-m32r: ERRORS
> linux-2.6.33-m32r: WARNINGS
> linux-2.6.34-m32r: WARNINGS
> linux-2.6.35-rc1-m32r: WARNINGS
> linux-2.6.32.6-mips: ERRORS
> linux-2.6.33-mips: WARNINGS
> linux-2.6.34-mips: WARNINGS
> linux-2.6.35-rc1-mips: WARNINGS
> linux-2.6.32.6-powerpc64: ERRORS
> linux-2.6.33-powerpc64: ERRORS
> linux-2.6.34-powerpc64: ERRORS
> linux-2.6.35-rc1-powerpc64: ERRORS
> linux-2.6.22.19-x86_64: ERRORS
> linux-2.6.23.17-x86_64: ERRORS
> linux-2.6.24.7-x86_64: ERRORS
> linux-2.6.25.20-x86_64: ERRORS
> linux-2.6.26.8-x86_64: ERRORS
> linux-2.6.27.44-x86_64: ERRORS
> linux-2.6.28.10-x86_64: ERRORS
> linux-2.6.29.1-x86_64: ERRORS
> linux-2.6.30.10-x86_64: ERRORS
> linux-2.6.31.12-x86_64: ERRORS
> linux-2.6.32.6-x86_64: ERRORS
> linux-2.6.33-x86_64: WARNINGS
> linux-2.6.34-x86_64: WARNINGS
> linux-2.6.35-rc1-x86_64: WARNINGS
> linux-git-armv5: WARNINGS
> linux-git-armv5-davinci: WARNINGS
> linux-git-armv5-ixp: WARNINGS
> linux-git-armv5-omap2: WARNINGS
> linux-git-i686: WARNINGS
> linux-git-m32r: OK
> linux-git-mips: OK
> linux-git-powerpc64: OK
> linux-git-x86_64: WARNINGS
> spec: ERRORS
> spec-git: OK
> sparse: ERRORS
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
> http://www.xs4all.nl/~hverkuil/logs/Tuesday.log
> 
> Full logs are available here:
> 
> http://www.xs4all.nl/~hverkuil/logs/Tuesday.tar.bz2
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
Jan Hoogenraad
Hoogenraad Interface Services
Postbus 2717
3500 GS Utrecht
