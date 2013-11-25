Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:3618 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752717Ab3KYIU5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Nov 2013 03:20:57 -0500
Received: from tschai.lan (209.80-203-20.nextgentel.com [80.203.20.209] (may be forged))
	(authenticated bits=0)
	by smtp-vbr9.xs4all.nl (8.13.8/8.13.8) with ESMTP id rAP8Kssq066123
	for <linux-media@vger.kernel.org>; Mon, 25 Nov 2013 09:20:56 +0100 (CET)
	(envelope-from hverkuil@xs4all.nl)
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id 4B3612A2220
	for <linux-media@vger.kernel.org>; Mon, 25 Nov 2013 09:20:41 +0100 (CET)
Message-ID: <52930859.9060908@xs4all.nl>
Date: Mon, 25 Nov 2013 09:20:41 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: cron job: media_tree daily build: OK
References: <20131125033237.936AF2A221F@tschai.lan>
In-Reply-To: <20131125033237.936AF2A221F@tschai.lan>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Finally! It's producing an OK result. It's been a long, long time since we
managed that.

Next step: continue whittling away at the sparse warnings/errors.

Regards,

	Hans

On 11/25/2013 04:32 AM, Hans Verkuil wrote:
> This message is generated daily by a cron job that builds media_tree for
> the kernels and architectures in the list below.
> 
> Results of the daily build of media_tree:
> 
> date:		Mon Nov 25 04:00:27 CET 2013
> git branch:	test
> git hash:	80f93c7b0f4599ffbdac8d964ecd1162b8b618b9
> gcc version:	i686-linux-gcc (GCC) 4.8.1
> sparse version:	0.4.5-rc1
> host hardware:	x86_64
> host os:	3.12-0.slh.2-amd64
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
> apps: OK
> spec-git: OK
> sparse version:	0.4.5-rc1
> sparse: ERRORS
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

