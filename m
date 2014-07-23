Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w2.samsung.com ([211.189.100.12]:23589 "EHLO
	usmailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932943AbaGWTjn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Jul 2014 15:39:43 -0400
Received: from uscpsbgm1.samsung.com
 (u114.gpu85.samsung.co.kr [203.254.195.114]) by mailout2.w2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0N9600LRIJY67D40@mailout2.w2.samsung.com> for
 linux-media@vger.kernel.org; Wed, 23 Jul 2014 15:39:42 -0400 (EDT)
Date: Wed, 23 Jul 2014 16:39:36 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: James Hogan <james@albanarts.com>
Cc: Antti =?UTF-8?B?U2VwcMOkbMOk?= <a.seppala@gmail.com>,
	linux-media@vger.kernel.org,
	David =?UTF-8?B?SMOkcmRlbWFu?= <david@hardeman.nu>,
	Jarod Wilson <jarod@redhat.com>,
	Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCH v2 0/9] rc: Add IR encode based wakeup filtering
Message-id: <20140723163936.164aa577.m.chehab@samsung.com>
In-reply-to: <1394838259-14260-1-git-send-email-james@albanarts.com>
References: <1394838259-14260-1-git-send-email-james@albanarts.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 14 Mar 2014 23:04:10 +0000
James Hogan <james@albanarts.com> escreveu:

> A recent discussion about proposed interfaces for setting up the
> hardware wakeup filter lead to the conclusion that it could help to have
> the generic capability to encode and modulate scancodes into raw IR
> events so that drivers for hardware with a low level wake filter (on the
> level of pulse/space durations) can still easily implement the higher
> level scancode interface that is proposed.
> 
> I posted an RFC patchset showing how this could work, and Antti Seppälä
> posted additional patches to support rc5-sz and nuvoton-cir. This
> patchset improves the original RFC patches and combines & updates
> Antti's patches.
> 
> I'm happy these patches are a good start at tackling the problem, as
> long as Antti is happy with them and they work for him of course.
> 
> Future work could include:
>  - Encoders for more protocols.
>  - Carrier signal events (no use unless a driver makes use of it).
> 
> Patch 1 adds the new encode API.
> Patches 2-3 adds some modulation helpers.
> Patches 4-6 adds some raw encode implementations.
> Patch 7 adds some rc-core support for encode based wakeup filtering.
> Patch 8 adds debug loopback of encoded scancode when filter set.
> Patch 9 (untested) adds encode based wakeup filtering to nuvoton-cir.
> 
> Changes in v2:

Any news about this patch series? There are some comments about them,
so I'll be tagging it as "changes requested" at patchwork, waiting
for a v3 (or is it already there in the middle of the 49 patches from
David?).

Regards,
Mauro
