Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:40949 "EHLO
	lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932223AbcECG3U (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 3 May 2016 02:29:20 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id 108E4180487
	for <linux-media@vger.kernel.org>; Tue,  3 May 2016 08:29:05 +0200 (CEST)
Subject: Re: cron job: media_tree daily build: ERRORS
To: linux-media@vger.kernel.org
References: <20160503030513.28EDE1800C7@tschai.lan>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <57284530.7060609@xs4all.nl>
Date: Tue, 3 May 2016 08:29:04 +0200
MIME-Version: 1.0
In-Reply-To: <20160503030513.28EDE1800C7@tschai.lan>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/03/2016 05:05 AM, Hans Verkuil wrote:
> This message is generated daily by a cron job that builds media_tree for
> the kernels and architectures in the list below.
> 
> Results of the daily build of media_tree:
> 
> date:		Tue May  3 04:00:18 CEST 2016
> git branch:	test
> git hash:	68af062b5f38510dc96635314461c6bbe1dbf2fe
> gcc version:	i686-linux-gcc (GCC) 5.3.0
> sparse version:	v0.5.0-56-g7647c77
> smatch version:	v0.5.0-3413-g618cd5c
> host hardware:	x86_64
> host os:	4.5.0-164
> 
> linux-git-arm-at91: ERRORS
> linux-git-arm-davinci: ERRORS
> linux-git-arm-exynos: ERRORS
> linux-git-arm-mx: ERRORS
> linux-git-arm-omap: ERRORS
> linux-git-arm-omap1: ERRORS
> linux-git-arm-pxa: ERRORS
> linux-git-blackfin-bf561: OK
> linux-git-i686: OK
> linux-git-m32r: OK
> linux-git-mips: OK
> linux-git-powerpc64: OK
> linux-git-sh: ERRORS
> linux-git-x86_64: OK

These errors are because 'make oldconfig' fails. I corrected this, but also
did some tests to see whether there isn't a better alternative and I discovered
'make olddefconfig' which will do the same things that 'make menuconfig' does:
it picks the default value for new config options.

This should prevent this from happening again in the future.

Regards,

	Hans
