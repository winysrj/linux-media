Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:59037 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757264Ab2AEAah (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 Jan 2012 19:30:37 -0500
Received: by werm1 with SMTP id m1so1632wer.19
        for <linux-media@vger.kernel.org>; Wed, 04 Jan 2012 16:30:36 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4F04DAD1.5030104@redhat.com>
References: <CALzAhNUHJiwv5PmDPZyaxofA+1vBUw7WBV2EoT4VQNZZn--6fg@mail.gmail.com>
	<4F04D657.7050402@infradead.org>
	<4F04DAD1.5030104@redhat.com>
Date: Wed, 4 Jan 2012 19:30:35 -0500
Message-ID: <CALzAhNWZ5y6SzitO=__e72+y8KO4FSYLXFBOf-iSKaYhFgyJtg@mail.gmail.com>
Subject: Re: [PULL] git://git.kernellabs.com/stoth/cx23885-hvr1850.git
 media-master branch
From: Steven Toth <stoth@kernellabs.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux-Media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> There's something wrong on this patch. It breaks compilation:

Mauro,

My mistake, I've corrected the issue:

The following changes since commit 9c9c3d078b0dd81a74e5f531aa1efa30add5b419:

 [media] cx23885: Configure the MPEG encoder early to avoid jerky
video (2012-01-04 20:51:18 -0200)

are available in the git repository at:
 git://git.kernellabs.com/stoth/cx23885-hvr1850-fixups.git staging/for_v3.3

Steven Toth (6):
     [media] cx25840: Add a flag to enable the CX23888 DIF to be
enabled or not.
     [media] cx23885: Hauppauge HVR1850 Analog driver support
     [media] cx23885: Control cleanup on the MPEG Encoder
     [media] cx23885: Bugfix /sys/class/video4linux/videoX/name truncation
     [media] cx25840: Hauppauge HVR1850 Analog driver support (patch2)
     [media] cx25840: Added g_std support to the video decoder driver

 drivers/media/video/cx23885/cx23885-417.c   |  105 +-
 drivers/media/video/cx23885/cx23885-cards.c |   28 +-
 drivers/media/video/cx23885/cx23885-core.c  |   24 +-
 drivers/media/video/cx23885/cx23885-dvb.c   |   14 +
 drivers/media/video/cx23885/cx23885-video.c |  157 ++-
 drivers/media/video/cx23885/cx23885.h       |   12 +
 drivers/media/video/cx25840/cx25840-core.c  | 3224 ++++++++++++++++++++++++++-
 include/media/cx25840.h                     |    1 +
 8 files changed, 3454 insertions(+), 111 deletions(-)

Thanks,

- Steve

-- 
Steven Toth - Kernel Labs
http://www.kernellabs.com
+1.646.355.8490
