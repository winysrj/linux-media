Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:2745 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751655Ab3KMH0d (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 13 Nov 2013 02:26:33 -0500
Received: from tschai.lan (209.80-203-20.nextgentel.com [80.203.20.209])
	(authenticated bits=0)
	by smtp-vbr2.xs4all.nl (8.13.8/8.13.8) with ESMTP id rAD7QTgg043384
	for <linux-media@vger.kernel.org>; Wed, 13 Nov 2013 08:26:32 +0100 (CET)
	(envelope-from hverkuil@xs4all.nl)
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id 8D3202A1F80
	for <linux-media@vger.kernel.org>; Wed, 13 Nov 2013 08:26:23 +0100 (CET)
Message-ID: <5283299F.5050008@xs4all.nl>
Date: Wed, 13 Nov 2013 08:26:23 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: cron job: media_tree daily build: ABI WARNING
References: <20131113033210.940D72A1F80@tschai.lan>
In-Reply-To: <20131113033210.940D72A1F80@tschai.lan>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/13/2013 04:32 AM, Hans Verkuil wrote:
> This message is generated daily by a cron job that builds media_tree for
> the kernels and architectures in the list below.
> 
> Results of the daily build of media_tree:
> 
> date:		Wed Nov 13 04:00:21 CET 2013
> git branch:	test
> git hash:	80f93c7b0f4599ffbdac8d964ecd1162b8b618b9
> gcc version:	i686-linux-gcc (GCC) 4.8.1
> sparse version:	0.4.5-rc1
> host hardware:	x86_64
> host os:	3.12-0.slh.1-amd64
> 
> linux-git-arm-at91: OK
> linux-git-arm-davinci: OK
> linux-git-arm-exynos: OK
> linux-git-arm-mx: OK
> linux-git-arm-omap: OK
> linux-git-arm-omap1: OK
> linux-git-arm-pxa: OK
> linux-git-blackfin: OK
> linux-git-i686: OK
> linux-git-m32r: OK
> linux-git-mips: OK
> linux-git-powerpc64: OK
> linux-git-sh: OK
> linux-git-x86_64: OK
> linux-2.6.31.14-i686: OK
> linux-2.6.32.27-i686: OK
> linux-2.6.33.7-i686: OK
> linux-2.6.34.7-i686: OK
> linux-2.6.35.9-i686: OK
> linux-2.6.36.4-i686: OK
> linux-2.6.37.6-i686: OK
> linux-2.6.38.8-i686: OK
> linux-2.6.39.4-i686: OK
> linux-3.0.60-i686: OK
> linux-3.1.10-i686: OK
> linux-3.2.37-i686: OK
> linux-3.3.8-i686: OK
> linux-3.4.27-i686: OK
> linux-3.5.7-i686: OK
> linux-3.6.11-i686: OK
> linux-3.7.4-i686: OK
> linux-3.8-i686: OK
> linux-3.9.2-i686: OK
> linux-3.10.1-i686: OK
> linux-3.11.1-i686: OK
> linux-3.12-i686: OK
> linux-2.6.31.14-x86_64: OK
> linux-2.6.32.27-x86_64: OK
> linux-2.6.33.7-x86_64: OK
> linux-2.6.34.7-x86_64: OK
> linux-2.6.35.9-x86_64: OK
> linux-2.6.36.4-x86_64: OK
> linux-2.6.37.6-x86_64: OK
> linux-2.6.38.8-x86_64: OK
> linux-2.6.39.4-x86_64: OK
> linux-3.0.60-x86_64: OK
> linux-3.1.10-x86_64: OK
> linux-3.2.37-x86_64: OK
> linux-3.3.8-x86_64: OK
> linux-3.4.27-x86_64: OK
> linux-3.5.7-x86_64: OK
> linux-3.6.11-x86_64: OK
> linux-3.7.4-x86_64: OK
> linux-3.8-x86_64: OK
> linux-3.9.2-x86_64: OK
> linux-3.10.1-x86_64: OK
> linux-3.11.1-x86_64: OK
> linux-3.12-x86_64: OK
> apps: WARNINGS
> spec-git: OK
> ABI WARNING: change for arm-at91
> ABI WARNING: change for arm-davinci
> ABI WARNING: change for arm-exynos
> ABI WARNING: change for arm-mx
> ABI WARNING: change for arm-omap
> ABI WARNING: change for arm-omap1
> ABI WARNING: change for arm-pxa
> ABI WARNING: change for blackfin
> ABI WARNING: change for i686
> ABI WARNING: change for m32r
> ABI WARNING: change for mips
> ABI WARNING: change for powerpc64
> ABI WARNING: change for sh
> ABI WARNING: change for x86_64

Ignore these warnings, they are caused by problems with 'sort'. Depending on
whether I ran the build manually or from cron the LANG setting was different,
leading to different sort results. I now set LANG explicitly in my build
script, so hopefully these false warnings will disappear during the next build.

For the longest time I couldn't understand why sort would give different results
until I had an early morning eureka moment today :-)

Regards,

	Hans

> sparse version:	0.4.5-rc1
> sparse: ERRORS
> 
> Detailed results are available here:
> 
> http://www.xs4all.nl/~hverkuil/logs/Wednesday.log
> 
> Full logs are available here:
> 
> http://www.xs4all.nl/~hverkuil/logs/Wednesday.tar.bz2
> 
> The Media Infrastructure API from this daily build is here:
> 
> http://www.xs4all.nl/~hverkuil/spec/media.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

