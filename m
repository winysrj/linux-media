Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:3416 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754311Ab3A1LMa (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 28 Jan 2013 06:12:30 -0500
Received: from alastor.dyndns.org (166.80-203-20.nextgentel.com [80.203.20.166] (may be forged))
	(authenticated bits=0)
	by smtp-vbr13.xs4all.nl (8.13.8/8.13.8) with ESMTP id r0SBCRva072467
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-media@vger.kernel.org>; Mon, 28 Jan 2013 12:12:29 +0100 (CET)
	(envelope-from hverkuil@xs4all.nl)
Received: from tschai.localnet (tschai.lan [192.168.1.10])
	(Authenticated sender: hans)
	by alastor.dyndns.org (Postfix) with ESMTPSA id 43AAA11E00B4
	for <linux-media@vger.kernel.org>; Mon, 28 Jan 2013 12:12:22 +0100 (CET)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: Re: cron job: media_tree daily build: WARNINGS
Date: Mon, 28 Jan 2013 12:12:21 +0100
References: <20130128110050.41A4011E00AE@alastor.dyndns.org>
In-Reply-To: <20130128110050.41A4011E00AE@alastor.dyndns.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201301281212.21189.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon January 28 2013 12:00:50 Hans Verkuil wrote:
> This message is generated daily by a cron job that builds media_tree for
> the kernels and architectures in the list below.

OK, the daily build is back in business! I've improved my scripts substantially.
In particular, if you download the scripts archive found here:

http://hverkuil.home.xs4all.nl/logs/scripts.tar.bz2

and then follow the instructions in the README file you can setup your
own daily build. Just note that for a full daily build you need 25 GB of
harddisk space... Actually, I highly recommend putting it on an SSD instead.

I also discovered that errors due to backport patches no longer applying
cleanly didn't end up in the summary log due to a regex bug, so that should
be easier to notice as well.

Regards,

	Hans

> 
> Results of the daily build of media_tree:
> 
> date:		Mon Jan 28 08:49:09 CET 2013
> git branch:	for_v3.9
> git hash:	a32f7d1ad3744914273c6907204c2ab3b5d496a0
> gcc version:	i686-linux-gcc (GCC) 4.7.2
> host hardware:	x86_64
> host os:	3.4.07-marune
> 
> linux-git-arm-davinci: WARNINGS
> linux-git-arm-exynos: WARNINGS
> linux-git-arm-omap: WARNINGS
> linux-git-i686: OK
> linux-git-m32r: OK
> linux-git-mips: WARNINGS
> linux-git-powerpc64: OK
> linux-git-sh: OK
> linux-git-x86_64: OK
> linux-2.6.31.14-i686: WARNINGS
> linux-2.6.32.27-i686: WARNINGS
> linux-2.6.33.7-i686: WARNINGS
> linux-2.6.34.7-i686: WARNINGS
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
> linux-3.8-rc4-i686: OK
> linux-2.6.31.14-x86_64: WARNINGS
> linux-2.6.32.27-x86_64: WARNINGS
> linux-2.6.33.7-x86_64: WARNINGS
> linux-2.6.34.7-x86_64: WARNINGS
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
> linux-3.8-rc4-x86_64: OK
> apps: WARNINGS
> spec-git: OK
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
