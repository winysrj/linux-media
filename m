Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-2.cisco.com ([144.254.224.141]:50614 "EHLO
	ams-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751069Ab3GXMqd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Jul 2013 08:46:33 -0400
Received: from cobaltpc1.localnet (dhcp-10-54-92-107.cisco.com [10.54.92.107])
	by ams-core-3.cisco.com (8.14.5/8.14.5) with ESMTP id r6OCk7XE032013
	for <linux-media@vger.kernel.org>; Wed, 24 Jul 2013 12:46:07 GMT
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: Re: cron job: media_tree daily build: ERRORS
Date: Wed, 24 Jul 2013 14:46:06 +0200
References: <20130723172748.0E6DE35E0395@alastor.dyndns.org>
In-Reply-To: <20130723172748.0E6DE35E0395@alastor.dyndns.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201307241446.06927.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue 23 July 2013 19:27:47 Hans Verkuil wrote:
> This message is generated daily by a cron job that builds media_tree for
> the kernels and architectures in the list below.

I've fixed the build issues after the 3.11 merge. So hopefully today's daily build
will be back to 'WARNINGS'.

Regards,

	Hans

> 
> Results of the daily build of media_tree:
> 
> date:		Tue Jul 23 19:00:18 CEST 2013
> git branch:	test
> git hash:	c859e6ef33ac0c9a5e9e934fe11a2232752b4e96
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
> linux-git-mips: OK
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
> linux-2.6.39.4-i686: ERRORS
> linux-3.0.60-i686: ERRORS
> linux-3.10-i686: ERRORS
> linux-3.1.10-i686: ERRORS
> linux-3.2.37-i686: ERRORS
> linux-3.3.8-i686: ERRORS
> linux-3.4.27-i686: ERRORS
> linux-3.5.7-i686: ERRORS
> linux-3.6.11-i686: ERRORS
> linux-3.7.4-i686: ERRORS
> linux-3.8-i686: ERRORS
> linux-3.9.2-i686: ERRORS
> linux-2.6.31.14-x86_64: ERRORS
> linux-2.6.32.27-x86_64: ERRORS
> linux-2.6.33.7-x86_64: ERRORS
> linux-2.6.34.7-x86_64: ERRORS
> linux-2.6.35.9-x86_64: ERRORS
> linux-2.6.36.4-x86_64: ERRORS
> linux-2.6.37.6-x86_64: ERRORS
> linux-2.6.38.8-x86_64: ERRORS
> linux-2.6.39.4-x86_64: ERRORS
> linux-3.0.60-x86_64: ERRORS
> linux-3.10-x86_64: ERRORS
> linux-3.1.10-x86_64: ERRORS
> linux-3.2.37-x86_64: ERRORS
> linux-3.3.8-x86_64: ERRORS
> linux-3.4.27-x86_64: ERRORS
> linux-3.5.7-x86_64: ERRORS
> linux-3.6.11-x86_64: ERRORS
> linux-3.7.4-x86_64: ERRORS
> linux-3.8-x86_64: ERRORS
> linux-3.9.2-x86_64: ERRORS
> apps: WARNINGS
> spec-git: OK
> sparse version:	v0.4.5-rc1
> sparse: ERRORS
> 
> Detailed results are available here:
> 
> http://www.xs4all.nl/~hverkuil/logs/Tuesday.log
> 
> Full logs are available here:
> 
> http://www.xs4all.nl/~hverkuil/logs/Tuesday.tar.bz2
> 
> The Media Infrastructure API from this daily build is here:
> 
> http://www.xs4all.nl/~hverkuil/spec/media.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
