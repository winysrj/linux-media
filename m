Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-3.cisco.com ([144.254.224.146]:18899 "EHLO
	ams-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751701Ab3HFHul (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 6 Aug 2013 03:50:41 -0400
Received: from cobaltpc1.localnet (dhcp-10-54-92-107.cisco.com [10.54.92.107])
	by ams-core-3.cisco.com (8.14.5/8.14.5) with ESMTP id r767obgJ012343
	for <linux-media@vger.kernel.org>; Tue, 6 Aug 2013 07:50:37 GMT
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: Re: cron job: media_tree daily build: ERRORS
Date: Tue, 6 Aug 2013 09:50:16 +0200
References: <20130802181203.76D4635E0045@alastor.dyndns.org>
In-Reply-To: <20130802181203.76D4635E0045@alastor.dyndns.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201308060950.16114.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri 2 August 2013 20:12:03 Hans Verkuil wrote:
> This message is generated daily by a cron job that builds media_tree for
> the kernels and architectures in the list below.

Hard-core mailinglist readers will have noticed that the daily build email
was missing for a few days. That was due to the fact that I moved my mailserver
to another host and I missed one single configuration line preventing
remote smtp logins.

I fixed it this morning, and todays daily build should be able to post its
results again.

I also fixed the errors for kernels <2.6.38 yesterday, so hopefully everything
should compile again.

	Hans

> 
> Results of the daily build of media_tree:
> 
> date:		Fri Aug  2 19:00:23 CEST 2013
> git branch:	test
> git hash:	dfb9f94e8e5e7f73c8e2bcb7d4fb1de57e7c333d
> gcc version:	i686-linux-gcc (GCC) 4.8.1
> sparse version:	v0.4.5-rc1
> host hardware:	x86_64
> host os:	3.9-7.slh.1-amd64
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
> linux-git-mips: ERRORS
> linux-git-powerpc64: OK
> linux-git-sh: OK
> linux-git-x86_64: OK
> linux-2.6.31.14-i686: ERRORS
> linux-2.6.32.27-i686: ERRORS
> linux-2.6.33.7-i686: ERRORS
> linux-2.6.34.7-i686: ERRORS
> linux-2.6.35.9-i686: ERRORS
> linux-2.6.36.4-i686: ERRORS
> linux-2.6.37.6-i686: ERRORS
> linux-2.6.38.8-i686: ERRORS
> linux-2.6.39.4-i686: WARNINGS
> linux-3.0.60-i686: OK
> linux-3.10-i686: OK
> linux-3.1.10-i686: OK
> linux-3.2.37-i686: OK
> linux-3.3.8-i686: OK
> linux-3.4.27-i686: WARNINGS
> linux-3.5.7-i686: WARNINGS
> linux-3.6.11-i686: WARNINGS
> linux-3.7.4-i686: WARNINGS
> linux-3.8-i686: WARNINGS
> linux-3.9.2-i686: WARNINGS
> linux-2.6.31.14-x86_64: ERRORS
> linux-2.6.32.27-x86_64: ERRORS
> linux-2.6.33.7-x86_64: ERRORS
> linux-2.6.34.7-x86_64: ERRORS
> linux-2.6.35.9-x86_64: ERRORS
> linux-2.6.36.4-x86_64: ERRORS
> linux-2.6.37.6-x86_64: ERRORS
> linux-2.6.38.8-x86_64: ERRORS
> linux-2.6.39.4-x86_64: WARNINGS
> linux-3.0.60-x86_64: OK
> linux-3.10-x86_64: OK
> linux-3.1.10-x86_64: OK
> linux-3.2.37-x86_64: OK
> linux-3.3.8-x86_64: OK
> linux-3.4.27-x86_64: WARNINGS
> linux-3.5.7-x86_64: WARNINGS
> linux-3.6.11-x86_64: WARNINGS
> linux-3.7.4-x86_64: WARNINGS
> linux-3.8-x86_64: WARNINGS
> linux-3.9.2-x86_64: WARNINGS
> apps: WARNINGS
> spec-git: OK
> sparse version:	v0.4.5-rc1
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
