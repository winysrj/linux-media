Return-path: <linux-media-owner@vger.kernel.org>
Received: from e6.ny.us.ibm.com ([32.97.182.146]:45644 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757936AbZDNS1d (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Apr 2009 14:27:33 -0400
Subject: [BUILD FAILURE 02/04] Next April 14 : x86 randconfig
	[drivers/built-in.o cx231xx-audio.c]
From: Subrata Modak <subrata@linux.vnet.ibm.com>
Reply-To: subrata@linux.vnet.ibm.com
To: Ingo Molnar <mingo@elte.hu>, srinivasa.deevi@conexant.com,
	Greg KH <greg@kroah.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
	linux-next <linux-next@vger.kernel.org>,
	sachinp <sachinp@linux.vnet.ibm.com>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Alexander Beregalov <a.beregalov@gmail.com>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org
Content-Type: text/plain
Date: Tue, 14 Apr 2009 23:57:21 +0530
Message-Id: <1239733641.5344.70.camel@subratamodak.linux.ibm.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Observed the following build error:
---
LD      .tmp_vmlinux1
drivers/built-in.o: In function `cx231xx_audio_fini':
cx231xx-audio.c:(.text+0x1eec59): undefined reference to `snd_card_free'
drivers/built-in.o: In function `cx231xx_audio_isocirq':
cx231xx-audio.c:(.text+0x1eeecc): undefined reference to
`snd_pcm_link_rwlock'
cx231xx-audio.c:(.text+0x1eef59): undefined reference to
`snd_pcm_link_rwlock'
cx231xx-audio.c:(.text+0x1eef8e): undefined reference to
`snd_pcm_period_elapsed'
drivers/built-in.o: In function `snd_cx231xx_capture_open':
cx231xx-audio.c:(.text+0x1ef338): undefined reference to
`snd_pcm_hw_constraint_integer'
drivers/built-in.o: In function `cx231xx_audio_init':
cx231xx-audio.c:(.text+0x1ef476): undefined reference to
`snd_card_create'
cx231xx-audio.c:(.text+0x1ef4c3): undefined reference to `snd_pcm_new'
cx231xx-audio.c:(.text+0x1ef4fa): undefined reference to
`snd_pcm_set_ops'
cx231xx-audio.c:(.text+0x1ef555): undefined reference to
`snd_card_register'
cx231xx-audio.c:(.text+0x1ef577): undefined reference to `snd_card_free'
drivers/built-in.o:(.data+0x24354): undefined reference to
`snd_pcm_lib_ioctl'
make: *** [.tmp_vmlinux1] Error 1
---

Patch was already provided. Still to get into this tree:
http://lkml.org/lkml/2009/4/7/400,

Regards--
Subrata


