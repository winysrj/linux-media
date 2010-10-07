Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:4605 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751529Ab0JGVsV (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 7 Oct 2010 17:48:21 -0400
Message-ID: <4CAE4020.4000209@redhat.com>
Date: Thu, 07 Oct 2010 18:48:16 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: dheitmueller@kernellabs.com
CC: Srinivasa.Deevi@conexant.com, Palash.Bandyopadhyay@conexant.com,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 01/10] V4L/DVB: cx231xx: remove a printk warning at -avcore
 and at -417
References: <cover.1285699057.git.mchehab@redhat.com> <20100928154653.785c1f3f@pedra>
In-Reply-To: <20100928154653.785c1f3f@pedra>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 28-09-2010 15:46, Mauro Carvalho Chehab escreveu:
> drivers/media/video/cx231xx/cx231xx-avcore.c:1608: warning: format ‘%d’ expects type ‘int’, but argument 3 has type ‘long unsigned int’
> drivers/media/video/cx231xx/cx231xx-417.c:1047: warning: format ‘%d’ expects type ‘int’, but argument 3 has type ‘size_t’
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

OK, I just updated my tree with the patches that Mkrufky acked.
It basically contains the same patches from my previous post, plus
the patches that Palash sent, and Devin/Mkrufky patches from polaris4
tree, rebased over the top of kernel v2.6.36-rc7 (this makes easier
for me to test and to merge).

The patches are at:
	http://git.linuxtv.org/mchehab/cx231xx.git

Sri already sent his ack for the first series of the patches.

The tree contains two extra patches:

1) a cx231xx large CodingStyle fix patch:
	http://git.linuxtv.org/mchehab/cx231xx.git?a=commit;h=eacd1a7749ae45d1f2f5782c013b863ff480746d

It basically solves the issues that checkpatch.pl complained on this series of patches;

2) a cx231xx-417 gcc warning fix:
	http://git.linuxtv.org/mchehab/cx231xx.git?a=commit;h=ca3a6a8c2a4819702e93b9612c4a6d90474ea9b5

Devin,

Would it be ok for you if I merge them on my main tree? They're needed for one
board I'm working with (a Pixelview SBTVD Hybrid - that supports both analog
and full-seg ISDB-T).

Thanks,
Mauro.
