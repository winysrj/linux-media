Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:9161 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753194Ab0IIRxJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 9 Sep 2010 13:53:09 -0400
Message-ID: <4C891F0D.2060103@redhat.com>
Date: Thu, 09 Sep 2010 14:53:17 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Pawel Osciak <p.osciak@samsung.com>
CC: linux-media@vger.kernel.org, kyungmin.park@samsung.com,
	m.szyprowski@samsung.com, t.fujak@samsung.com
Subject: Re: [PATCH/RFC v1 0/7] Videobuf2 framework
References: <1284023988-23351-1-git-send-email-p.osciak@samsung.com>
In-Reply-To: <1284023988-23351-1-git-send-email-p.osciak@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

Em 09-09-2010 06:19, Pawel Osciak escreveu:
> Hello,
> 
> These patches add a new driver framework for Video for Linux 2 driver
> - Videobuf2.

I didn't test the patches, but, from a source code review, they seem
on a good shape. I did a few comments on some patches. There are a few
missing features for them to be used with real drivers:

1) it lacks implementation of read() method. This means that vivi driver
has a regression, as it currently supports it.

2) it lacks OVERLAY mode. We can probably mark this feature as deprecated,
avoiding the need of implementing it on videobuf2, but we need a patch
for Documentation/feature-removal-schedule.txt,  in order to allow the
migration of the existing drivers like bttv and saa7134, where this feature
is implemented, of course if people agree that this is the better way;

3) it lacks the implementation of videobuf-dvb;

4) it lacks an implementation for DMA S/G.

We need to address all the above issues, in order to use it, otherwise the
migration of existing drivers would cause regressions, as features will be
missing.

Cheers,
Mauro.
