Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:2941 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753685Ab3AWHtH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Jan 2013 02:49:07 -0500
Received: from alastor.dyndns.org (166.80-203-20.nextgentel.com [80.203.20.166])
	(authenticated bits=0)
	by smtp-vbr1.xs4all.nl (8.13.8/8.13.8) with ESMTP id r0N7n2aR014502
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-media@vger.kernel.org>; Wed, 23 Jan 2013 08:49:05 +0100 (CET)
	(envelope-from hverkuil@xs4all.nl)
Received: from tschai.localnet (tschai.lan [192.168.1.10])
	(Authenticated sender: hans)
	by alastor.dyndns.org (Postfix) with ESMTPSA id 5BBD330600A2
	for <linux-media@vger.kernel.org>; Wed, 23 Jan 2013 08:49:02 +0100 (CET)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: Re: cron job: media_tree daily build: ERRORS
Date: Wed, 23 Jan 2013 08:49:02 +0100
References: <20130122210208.576CC3060096@alastor.dyndns.org>
In-Reply-To: <20130122210208.576CC3060096@alastor.dyndns.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201301230849.02139.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue January 22 2013 22:02:08 Hans Verkuil wrote:
> This message is generated daily by a cron job that builds media_tree for
> the kernels and architectures in the list below.
> 
> Results of the daily build of media_tree:
> 
> date:        Tue Jan 22 19:00:19 CET 2013
> git hash:    f66d81b54dac26d4e601d4d7faca53f3bdc98427
> gcc version:      i686-linux-gcc (GCC) 4.7.1
> host hardware:    x86_64
> host os:          3.4.07-marune
> 
> linux-git-arm-eabi-davinci: WARNINGS
> linux-git-arm-eabi-exynos: WARNINGS
> linux-git-arm-eabi-omap: ERRORS
> linux-git-i686: OK
> linux-git-m32r: OK
> linux-git-mips: WARNINGS
> linux-git-powerpc64: OK
> linux-git-sh: OK
> linux-git-x86_64: OK
> linux-2.6.31.12-i686: WARNINGS
> linux-2.6.32.6-i686: WARNINGS
> linux-2.6.33-i686: WARNINGS
> linux-2.6.34-i686: WARNINGS
> linux-2.6.35.3-i686: WARNINGS
> linux-2.6.36-i686: WARNINGS
> linux-2.6.37-i686: WARNINGS
> linux-2.6.38.2-i686: WARNINGS
> linux-2.6.39.1-i686: ERRORS
> linux-3.0-i686: ERRORS
> linux-3.1-i686: ERRORS
> linux-3.2.1-i686: ERRORS
> linux-3.3-i686: ERRORS
> linux-3.4-i686: WARNINGS
> linux-3.5-i686: WARNINGS
> linux-3.6-i686: WARNINGS
> linux-3.7-i686: WARNINGS
> linux-3.8-rc1-i686: OK
> linux-2.6.31.12-x86_64: WARNINGS
> linux-2.6.32.6-x86_64: WARNINGS
> linux-2.6.33-x86_64: WARNINGS
> linux-2.6.34-x86_64: WARNINGS
> linux-2.6.35.3-x86_64: WARNINGS
> linux-2.6.36-x86_64: WARNINGS
> linux-2.6.37-x86_64: WARNINGS
> linux-2.6.38.2-x86_64: WARNINGS
> linux-2.6.39.1-x86_64: ERRORS
> linux-3.0-x86_64: ERRORS
> linux-3.1-x86_64: ERRORS
> linux-3.2.1-x86_64: ERRORS
> linux-3.3-x86_64: ERRORS
> linux-3.4-x86_64: WARNINGS
> linux-3.5-x86_64: WARNINGS
> linux-3.6-x86_64: WARNINGS
> linux-3.7-x86_64: WARNINGS
> linux-3.8-rc1-x86_64: OK
> apps: WARNINGS
> spec-git: OK
> sparse: ERRORS

Please ignore the new ERRORS and the huge amount of warnings yesterday's build
gave. I accidentally messed up my build environment yesterday, causing these
issues.

The main reason is that I apply some patches manually for certain kernels. Of
course, if you then have to recreate your environment those patches need to be
re-applied which I forgot to do. I'm going to automate this process so the
next time I need to do this, it won't be forgotten again.

In addition I discovered that the arm-eabi compiler target is being obsoleted,
instead I should use arm-linux-gnueabi. I want to sort that out as well.

In other words, now is a good time to improve my scripts, ideally to the point
that anyone can take those scripts and set up their own daily build. I'll be
working on that this week, so the build may be unreliable for a few days.
I will let you all know when things are back to normal.

Regards,

	Hans

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
