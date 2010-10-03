Return-path: <mchehab@pedra>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:4321 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752182Ab0JCSGJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 3 Oct 2010 14:06:09 -0400
Received: from tschai.localnet (186.84-48-119.nextgentel.com [84.48.119.186])
	(authenticated bits=0)
	by smtp-vbr13.xs4all.nl (8.13.8/8.13.8) with ESMTP id o93I650n089285
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Sun, 3 Oct 2010 20:06:08 +0200 (CEST)
	(envelope-from hverkuil@xs4all.nl)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: Re: [cron job] v4l-dvb daily build 2.6.26 and up: ERRORS
Date: Sun, 3 Oct 2010 20:06:00 +0200
References: <201010021915.o92JF4vl003186@smtp-vbr12.xs4all.nl>
In-Reply-To: <201010021915.o92JF4vl003186@smtp-vbr12.xs4all.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201010032006.00190.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi all,

On Saturday, October 02, 2010 21:15:04 Hans Verkuil wrote:
> This message is generated daily by a cron job that builds v4l-dvb for
> the kernels and architectures in the list below.
> 
> Results of the daily build of v4l-dvb:
> 
> date:        Sat Oct  2 19:00:05 CEST 2010
> path:        http://www.linuxtv.org/hg/v4l-dvb
> changeset:   15164:1da5fed5c8b2
> git master:       3e6dce76d99b328716b43929b9195adfee1de00c
> git media-master: c8dd732fd119ce6d562d5fa82a10bbe75a376575
> gcc version:      i686-linux-gcc (GCC) 4.5.1

I've updated the compiler to the latest 4.5.1 release.

> host hardware:    x86_64
> host os:          2.6.32.5
> 
> linux-git-armv5: WARNINGS
> linux-git-armv5-davinci: WARNINGS
> linux-git-armv5-ixp: WARNINGS
> linux-git-armv5-omap2: WARNINGS
> linux-git-i686: WARNINGS
> linux-git-m32r: WARNINGS
> linux-git-mips: WARNINGS
> linux-git-powerpc64: WARNINGS
> linux-git-x86_64: WARNINGS

The git compiles were broken, particularly for the arm. They are now fixed.
But note that there are *many* warnings being generated, mostly to do with
signedness issues. Probably as a consequence of the compiler upgrade.

Anyone interested in a janitorial job?

Regards,

	Hans

> linux-2.6.32.6-armv5: WARNINGS
> linux-2.6.33-armv5: WARNINGS
> linux-2.6.34-armv5: WARNINGS
> linux-2.6.35.3-armv5: WARNINGS
> linux-2.6.36-rc2-armv5: ERRORS
> linux-2.6.32.6-armv5-davinci: ERRORS
> linux-2.6.33-armv5-davinci: ERRORS
> linux-2.6.34-armv5-davinci: ERRORS
> linux-2.6.35.3-armv5-davinci: ERRORS
> linux-2.6.36-rc2-armv5-davinci: ERRORS
> linux-2.6.32.6-armv5-ixp: ERRORS
> linux-2.6.33-armv5-ixp: ERRORS
> linux-2.6.34-armv5-ixp: ERRORS
> linux-2.6.35.3-armv5-ixp: ERRORS
> linux-2.6.36-rc2-armv5-ixp: ERRORS
> linux-2.6.32.6-armv5-omap2: ERRORS
> linux-2.6.33-armv5-omap2: ERRORS
> linux-2.6.34-armv5-omap2: ERRORS
> linux-2.6.35.3-armv5-omap2: ERRORS
> linux-2.6.36-rc2-armv5-omap2: ERRORS
> linux-2.6.26.8-i686: WARNINGS
> linux-2.6.27.44-i686: WARNINGS
> linux-2.6.28.10-i686: WARNINGS
> linux-2.6.29.1-i686: WARNINGS
> linux-2.6.30.10-i686: WARNINGS
> linux-2.6.31.12-i686: WARNINGS
> linux-2.6.32.6-i686: WARNINGS
> linux-2.6.33-i686: WARNINGS
> linux-2.6.34-i686: WARNINGS
> linux-2.6.35.3-i686: WARNINGS
> linux-2.6.36-rc2-i686: ERRORS
> linux-2.6.32.6-m32r: WARNINGS
> linux-2.6.33-m32r: WARNINGS
> linux-2.6.34-m32r: WARNINGS
> linux-2.6.35.3-m32r: WARNINGS
> linux-2.6.36-rc2-m32r: ERRORS
> linux-2.6.32.6-mips: WARNINGS
> linux-2.6.33-mips: WARNINGS
> linux-2.6.34-mips: WARNINGS
> linux-2.6.35.3-mips: WARNINGS
> linux-2.6.36-rc2-mips: ERRORS
> linux-2.6.32.6-powerpc64: WARNINGS
> linux-2.6.33-powerpc64: WARNINGS
> linux-2.6.34-powerpc64: WARNINGS
> linux-2.6.35.3-powerpc64: WARNINGS
> linux-2.6.36-rc2-powerpc64: ERRORS
> linux-2.6.26.8-x86_64: WARNINGS
> linux-2.6.27.44-x86_64: WARNINGS
> linux-2.6.28.10-x86_64: WARNINGS
> linux-2.6.29.1-x86_64: WARNINGS
> linux-2.6.30.10-x86_64: WARNINGS
> linux-2.6.31.12-x86_64: WARNINGS
> linux-2.6.32.6-x86_64: WARNINGS
> linux-2.6.33-x86_64: WARNINGS
> linux-2.6.34-x86_64: WARNINGS
> linux-2.6.35.3-x86_64: WARNINGS
> linux-2.6.36-rc2-x86_64: ERRORS
> spec-git: OK
> sparse: ERRORS
> 
> Detailed results are available here:
> 
> http://www.xs4all.nl/~hverkuil/logs/Saturday.log
> 
> Full logs are available here:
> 
> http://www.xs4all.nl/~hverkuil/logs/Saturday.tar.bz2
> 
> The V4L-DVB specification from this daily build is here:
> 
> http://www.xs4all.nl/~hverkuil/spec/media.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG, part of Cisco
