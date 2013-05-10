Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f175.google.com ([209.85.215.175]:41044 "EHLO
	mail-ea0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753955Ab3EJWDp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 10 May 2013 18:03:45 -0400
Received: by mail-ea0-f175.google.com with SMTP id q10so2411106eaj.6
        for <linux-media@vger.kernel.org>; Fri, 10 May 2013 15:03:43 -0700 (PDT)
Message-ID: <518D6EBC.3010502@gmail.com>
Date: Sat, 11 May 2013 00:03:40 +0200
From: Gianluca Gennari <gennarone@gmail.com>
Reply-To: gennarone@gmail.com
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-media@vger.kernel.org
Subject: Re: cron job: media_tree daily build: ERRORS
References: <20130510181620.2B983130024E@alastor.dyndns.org>
In-Reply-To: <20130510181620.2B983130024E@alastor.dyndns.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Il 10/05/2013 20:16, Hans Verkuil ha scritto:
> This message is generated daily by a cron job that builds media_tree for
> the kernels and architectures in the list below.
> 
> Results of the daily build of media_tree:
> 
> date:		Fri May 10 19:00:23 CEST 2013
> git branch:	test
> git hash:	02615ed5e1b2283db2495af3cf8f4ee172c77d80
> gcc version:	i686-linux-gcc (GCC) 4.7.2
> host hardware:	x86_64
> host os:	3.8-3.slh.2-amd64
> 
> linux-git-arm-davinci: OK
> linux-git-arm-exynos: WARNINGS
> linux-git-arm-omap: WARNINGS
> linux-git-blackfin: WARNINGS
> linux-git-i686: OK
> linux-git-m32r: OK
> linux-git-mips: OK
> linux-git-powerpc64: OK
> linux-git-sh: OK
> linux-git-x86_64: OK
> linux-2.6.31.14-i686: WARNINGS
> linux-2.6.32.27-i686: WARNINGS
> linux-2.6.33.7-i686: ERRORS
> linux-2.6.34.7-i686: ERRORS

Hi Hans,
this breakage is caused by my last patch that you just committed.
I sent a fix for the uvcvideo driver on kernels 2.6.33 and 2.6.34.

Regards,
Gianluca

> linux-2.6.35.9-i686: WARNINGS
> linux-2.6.36.4-i686: WARNINGS
> linux-2.6.37.6-i686: WARNINGS
> linux-2.6.38.8-i686: WARNINGS
> linux-2.6.39.4-i686: WARNINGS
> linux-3.0.60-i686: WARNINGS
> linux-3.1.10-i686: WARNINGS
> linux-3.2.37-i686: WARNINGS
> linux-3.3.8-i686: WARNINGS
> linux-3.4.27-i686: WARNINGS
> linux-3.5.7-i686: WARNINGS
> linux-3.6.11-i686: WARNINGS
> linux-3.7.4-i686: WARNINGS
> linux-3.8-i686: OK
> linux-3.9-rc1-i686: OK
> linux-2.6.31.14-x86_64: WARNINGS
> linux-2.6.32.27-x86_64: WARNINGS
> linux-2.6.33.7-x86_64: ERRORS
> linux-2.6.34.7-x86_64: ERRORS
> linux-2.6.35.9-x86_64: WARNINGS
> linux-2.6.36.4-x86_64: WARNINGS
> linux-2.6.37.6-x86_64: WARNINGS
> linux-2.6.38.8-x86_64: WARNINGS
> linux-2.6.39.4-x86_64: WARNINGS
> linux-3.0.60-x86_64: WARNINGS
> linux-3.1.10-x86_64: WARNINGS
> linux-3.2.37-x86_64: WARNINGS
> linux-3.3.8-x86_64: WARNINGS
> linux-3.4.27-x86_64: WARNINGS
> linux-3.5.7-x86_64: WARNINGS
> linux-3.6.11-x86_64: WARNINGS
> linux-3.7.4-x86_64: WARNINGS
> linux-3.8-x86_64: OK
> linux-3.9-rc1-x86_64: OK
> apps: WARNINGS
> spec-git: OK
> sparse: ERRORS
> 
> Detailed results are available here:
> 
> http://www.xs4all.nl/~hverkuil/logs/Friday.log
> 
> Full logs are available here:
> 
> http://www.xs4all.nl/~hverkuil/logs/Friday.tar.bz2
> 
> The Media Infrastructure API from this daily build is here:
> 
> http://www.xs4all.nl/~hverkuil/spec/media.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

