Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:1563 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750775AbaJOHCI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 15 Oct 2014 03:02:08 -0400
Message-ID: <543E1BCB.2070209@xs4all.nl>
Date: Wed, 15 Oct 2014 09:01:31 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: kbuild test robot <fengguang.wu@intel.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
CC: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	kbuild-all@01.org
Subject: Re: ERROR: "cfb_fillrect" [drivers/media/platform/vivid/vivid.ko]
 undefined!
References: <543df6ac./nmR186XoMwlH656%fengguang.wu@intel.com>
In-Reply-To: <543df6ac./nmR186XoMwlH656%fengguang.wu@intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

A patch for this is already in my pull request I posted last week.

	Hans

On 10/15/2014 06:23 AM, kbuild test robot wrote:
> tree:   git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
> head:   2d65a9f48fcdf7866aab6457bc707ca233e0c791
> commit: e75420dd25bc9d7b6f4e3b4c4f6c778b610c8cda [media] vivid: enable the vivid driver
> date:   6 weeks ago
> config: i386-randconfig-ib0-10151216 (attached as .config)
> reproduce:
>   git checkout e75420dd25bc9d7b6f4e3b4c4f6c778b610c8cda
>   # save the attached .config to linux build tree
>   make ARCH=i386 
> 
> All error/warnings:
> 
>>> ERROR: "cfb_fillrect" [drivers/media/platform/vivid/vivid.ko] undefined!
>>> ERROR: "cfb_imageblit" [drivers/media/platform/vivid/vivid.ko] undefined!
>>> ERROR: "cfb_copyarea" [drivers/media/platform/vivid/vivid.ko] undefined!
> 
> ---
> 0-DAY kernel build testing backend              Open Source Technology Center
> http://lists.01.org/mailman/listinfo/kbuild                 Intel Corporation
> 
