Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:55731 "EHLO
	lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751924AbbINIuR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Sep 2015 04:50:17 -0400
Received: from [64.103.36.133] (proxy-ams-1.cisco.com [64.103.36.133])
	by tschai.lan (Postfix) with ESMTPSA id 9843D2A0095
	for <linux-media@vger.kernel.org>; Mon, 14 Sep 2015 10:49:01 +0200 (CEST)
Message-ID: <55F68A24.2020002@xs4all.nl>
Date: Mon, 14 Sep 2015 10:49:40 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: cron job: media_tree daily build: ERRORS
References: <20150914023220.19C4C2A009D@tschai.lan>
In-Reply-To: <20150914023220.19C4C2A009D@tschai.lan>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I've fixed the errors reported here (the usual fall-out after a new
rc1 is merged).

However, 4.3-rc1 makes some substantial changes to the memory handling
of vb2 introducing a new file mm/frame_vector.c.

I do have a media_build patch that pulls that in for the compat build, but it
doesn't compile yet. I'll see if I can look at this on Wednesday. This could
turn out to be a major problem when it comes to the compat build.

Regards,

	Hans

On 09/14/15 04:32, Hans Verkuil wrote:
> This message is generated daily by a cron job that builds media_tree for
> the kernels and architectures in the list below.
> 
> Results of the daily build of media_tree:
> 
> date:		Mon Sep 14 04:00:33 CEST 2015
> git branch:	test
> git hash:	9ddf9071ea17b83954358b2dac42b34e5857a9af
> gcc version:	i686-linux-gcc (GCC) 5.1.0
> sparse version:	v0.5.0-51-ga53cea2
> smatch version:	0.4.1-3153-g7d56ab3
> host hardware:	x86_64
> host os:	4.0.0-3.slh.1-amd64
> 
> linux-git-arm-at91: ERRORS
> linux-git-arm-davinci: ERRORS
> linux-git-arm-exynos: ERRORS
> linux-git-arm-mx: ERRORS
> linux-git-arm-omap: ERRORS
> linux-git-arm-omap1: ERRORS
> linux-git-arm-pxa: ERRORS
> linux-git-blackfin-bf561: ERRORS
> linux-git-i686: OK
> linux-git-m32r: OK
> linux-git-mips: ERRORS
> linux-git-powerpc64: OK
> linux-git-sh: ERRORS
> linux-git-x86_64: OK
> linux-2.6.32.27-i686: ERRORS
> linux-2.6.33.7-i686: ERRORS
> linux-2.6.34.7-i686: ERRORS
> linux-2.6.35.9-i686: ERRORS
> linux-2.6.36.4-i686: ERRORS
> linux-2.6.37.6-i686: ERRORS
> linux-2.6.38.8-i686: ERRORS
> linux-2.6.39.4-i686: ERRORS
> linux-3.0.60-i686: ERRORS
> linux-3.1.10-i686: ERRORS
> linux-3.2.37-i686: ERRORS
> linux-3.3.8-i686: ERRORS
> linux-3.4.27-i686: ERRORS
> linux-3.5.7-i686: ERRORS
> linux-3.6.11-i686: ERRORS
> linux-3.7.4-i686: ERRORS
> linux-3.8-i686: ERRORS
> linux-3.9.2-i686: ERRORS
> linux-3.10.1-i686: OK
> linux-3.11.1-i686: OK
> linux-3.12.23-i686: OK
> linux-3.13.11-i686: ERRORS
> linux-3.14.9-i686: ERRORS
> linux-3.15.2-i686: ERRORS
> linux-3.16.7-i686: ERRORS
> linux-3.17.8-i686: OK
> linux-3.18.7-i686: OK
> linux-3.19-i686: OK
> linux-4.0-i686: OK
> linux-4.1.1-i686: OK
> linux-4.2-i686: OK
> linux-4.3-rc1-i686: OK
> linux-2.6.32.27-x86_64: ERRORS
> linux-2.6.33.7-x86_64: ERRORS
> linux-2.6.34.7-x86_64: ERRORS
> linux-2.6.35.9-x86_64: ERRORS
> linux-2.6.36.4-x86_64: ERRORS
> linux-2.6.37.6-x86_64: ERRORS
> linux-2.6.38.8-x86_64: ERRORS
> linux-2.6.39.4-x86_64: ERRORS
> linux-3.0.60-x86_64: ERRORS
> linux-3.1.10-x86_64: ERRORS
> linux-3.2.37-x86_64: ERRORS
> linux-3.3.8-x86_64: ERRORS
> linux-3.4.27-x86_64: ERRORS
> linux-3.5.7-x86_64: ERRORS
> linux-3.6.11-x86_64: ERRORS
> linux-3.7.4-x86_64: ERRORS
> linux-3.8-x86_64: ERRORS
> linux-3.9.2-x86_64: ERRORS
> linux-3.10.1-x86_64: OK
> linux-3.11.1-x86_64: OK
> linux-3.12.23-x86_64: OK
> linux-3.13.11-x86_64: ERRORS
> linux-3.14.9-x86_64: ERRORS
> linux-3.15.2-x86_64: ERRORS
> linux-3.16.7-x86_64: ERRORS
> linux-3.17.8-x86_64: OK
> linux-3.18.7-x86_64: OK
> linux-3.19-x86_64: OK
> linux-4.0-x86_64: OK
> linux-4.1.1-x86_64: OK
> linux-4.2-x86_64: OK
> linux-4.3-rc1-x86_64: OK
> apps: OK
> spec-git: OK
> sparse: ERRORS
> ABI WARNING: change for arm-at91
> ABI WARNING: change for arm-davinci
> ABI WARNING: change for arm-exynos
> ABI WARNING: change for arm-mx
> ABI WARNING: change for arm-omap
> ABI WARNING: change for arm-omap1
> ABI WARNING: change for arm-pxa
> ABI WARNING: change for blackfin-bf561
> ABI WARNING: change for mips
> ABI WARNING: change for sh
> smatch: ERRORS
> 
> Detailed results are available here:
> 
> http://www.xs4all.nl/~hverkuil/logs/Monday.log
> 
> Full logs are available here:
> 
> http://www.xs4all.nl/~hverkuil/logs/Monday.tar.bz2
> 
> The Media Infrastructure API from this daily build is here:
> 
> http://www.xs4all.nl/~hverkuil/spec/media.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
