Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w2.samsung.com ([211.189.100.13]:24259 "EHLO
	usmailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753947AbaHNLyy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Aug 2014 07:54:54 -0400
Received: from uscpsbgm2.samsung.com
 (u115.gpu85.samsung.co.kr [203.254.195.115]) by usmailout3.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0NAA00BBVP3HZT20@usmailout3.samsung.com> for
 linux-media@vger.kernel.org; Thu, 14 Aug 2014 07:54:53 -0400 (EDT)
Date: Thu, 14 Aug 2014 08:54:49 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Hans Verkuil <hansverk@cisco.com>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [GIT PULL FOR v3.18] tw68: add new driver for tw68xx grabber cards
Message-id: <20140814085449.46224641.m.chehab@samsung.com>
In-reply-to: <53EC8240.5080801@cisco.com>
References: <53EC8240.5080801@cisco.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 14 Aug 2014 11:32:48 +0200
Hans Verkuil <hansverk@cisco.com> escreveu:

> The following changes since commit 0f3bf3dc1ca394a8385079a5653088672b65c5c4:
>                                                                                                                                        
>    [media] cx23885: fix UNSET/TUNER_ABSENT confusion (2014-08-01 15:30:59 -0300)
>                                                                                                                                        
> are available in the git repository at:
>                                                                                                                                        
>    git://linuxtv.org/hverkuil/media_tree.git tw68
>                                                                                                                                        
> for you to fetch changes up to 64889b98f7ed20ab630a47eff4a5847c3aa0555e:
>                                                                                                                                        
>    MAINTAINERS: add tw68 entry (2014-08-10 10:36:10 +0200)
>                                                                                                                                        
> ----------------------------------------------------------------
> Hans Verkuil (2):
>        tw68: add support for Techwell tw68xx PCI grabber boards

NACK. This patch breaks compilation with allyesconfig:

drivers/media/pci/tw68/tw68-video.c: In function 'tw68_s_input':
drivers/media/pci/tw68/tw68-video.c:751:2: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
  if (i < 0 || i >= TW68_INPUT_MAX)
  ^
drivers/media/pci/tw68/built-in.o:(.bss+0x568): multiple definition of `video_debug'
drivers/media/pci/saa7134/built-in.o:(.bss+0x3b08): first defined here
make[2]: *** [drivers/media/pci/built-in.o] Error 1
make[1]: *** [drivers/media/pci] Error 2
make: *** [_module_drivers/media] Error 2

PS.: It likely makes sense to also rename video_debug at saa7134, or
to get rid of both, in favor of using dynamic debug printks.

Regards,
Mauro
