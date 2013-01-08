Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-1.cisco.com ([144.254.224.140]:43533 "EHLO
	ams-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755236Ab3AHJ6O (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 8 Jan 2013 04:58:14 -0500
Received: from cobaltpc1.localnet (dhcp-10-54-92-107.cisco.com [10.54.92.107])
	by ams-core-3.cisco.com (8.14.5/8.14.5) with ESMTP id r089wBUx003675
	for <linux-media@vger.kernel.org>; Tue, 8 Jan 2013 09:58:11 GMT
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: Re: cron job: media_tree daily build: ERRORS
Date: Tue, 8 Jan 2013 10:58:11 +0100
References: <20130107213823.ED56311E00F1@alastor.dyndns.org>
In-Reply-To: <20130107213823.ED56311E00F1@alastor.dyndns.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201301081058.11297.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon 7 January 2013 22:38:23 Hans Verkuil wrote:
> This message is generated daily by a cron job that builds media_tree for
> the kernels and architectures in the list below.
> 
> Results of the daily build of media_tree:
> 
> date:        Mon Jan  7 19:00:18 CET 2013
> git hash:    73ec66c000e9816806c7380ca3420f4e0638c40e
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
> linux-2.6.39.1-i686: WARNINGS
> linux-3.0-i686: WARNINGS
> linux-3.1-i686: WARNINGS
> linux-3.2.1-i686: WARNINGS
> linux-3.3-i686: WARNINGS
> linux-3.4-i686: WARNINGS
> linux-3.5-i686: WARNINGS
> linux-3.6-i686: WARNINGS
> linux-3.7-i686: WARNINGS
> linux-3.8-rc1-i686: WARNINGS
> linux-2.6.31.12-x86_64: WARNINGS
> linux-2.6.32.6-x86_64: WARNINGS
> linux-2.6.33-x86_64: WARNINGS
> linux-2.6.34-x86_64: WARNINGS
> linux-2.6.35.3-x86_64: WARNINGS
> linux-2.6.36-x86_64: WARNINGS
> linux-2.6.37-x86_64: WARNINGS
> linux-2.6.38.2-x86_64: WARNINGS
> linux-2.6.39.1-x86_64: WARNINGS
> linux-3.0-x86_64: WARNINGS
> linux-3.1-x86_64: WARNINGS
> linux-3.2.1-x86_64: WARNINGS
> linux-3.3-x86_64: WARNINGS
> linux-3.4-x86_64: WARNINGS
> linux-3.5-x86_64: WARNINGS
> linux-3.6-x86_64: WARNINGS
> linux-3.7-x86_64: WARNINGS
> linux-3.8-rc1-x86_64: WARNINGS
> apps: WARNINGS
> spec-git: OK
> sparse: ERRORS
> 
> Detailed results are available here:
> 
> http://www.xs4all.nl/~hverkuil/logs/Monday.log

There were a lot of new 'redefined' warnings that I have fixed.

In addition, it turned out that any driver using vb2 wasn't compiled for
kernels <3.2 due to the fact that DMA_SHARED_BUFFER wasn't set. That's fixed
as well, so drivers like em28xx and vivi will now compile on those older
kernels. This also was the reason I never saw that the usb_translate_error
function needed to be added to compat.h: it's used in em28xx but that driver
was never compiled on kernels without usb_translate_error.

Hopefully everything works now.

Regards,

	Hans
