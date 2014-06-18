Return-path: <linux-media-owner@vger.kernel.org>
Received: from dehamd003.servertools24.de ([31.47.254.18]:60938 "EHLO
	dehamd003.servertools24.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933705AbaFRIVD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Jun 2014 04:21:03 -0400
Message-ID: <53A14BEB.1060403@ladisch.de>
Date: Wed, 18 Jun 2014 10:20:59 +0200
From: Clemens Ladisch <clemens@ladisch.de>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Devin Heitmueller <dheitmueller@kernellabs.com>
CC: Takashi Iwai <tiwai@suse.de>, alsa-devel@alsa-project.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [alsa-devel] [PATCH 1/3] sound: Add a quirk to enforce period_bytes
References: <1402762571-6316-1-git-send-email-m.chehab@samsung.com> <1402762571-6316-2-git-send-email-m.chehab@samsung.com> <539E9F25.7030504@ladisch.de> <CAGoCfiw3du9rXFvDfsUYLu4Ru6mbdWa+LtAyYupXosM0n-71NA@mail.gmail.com> <20140616120544.10ef75f4.m.chehab@samsung.com>
In-Reply-To: <20140616120544.10ef75f4.m.chehab@samsung.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro Carvalho Chehab wrote:
> Let's see the au0828 case:
> 	48 kHz, 2 bytes/sample, 2 channels, 256 maxpacksize, 1 ms URB
> interval (bInterval = 1).
>
> In this case, there is 192 bytes per 1ms period.

The device's clock and the bus clock are not synchronized, so there will
be _approximately_ 192 bytes per USB frame.

> Let's assume that the period was set to 3456, with corresponds to
> a latency of 18 ms.
>
> In this case, as NUM_URBS = 12,

There is no symbol named NUM_URBS.

> it means that the transfer buffer will be set to its maximum value of
> 3072 bytes per URB pack (12 * 256)

The number of URBs is not the same as the number of packets per URB.

> and the URB transfer_callback will be called on every 16 ms.

It will be called once per millisecond.

> So, what

... definitely not ...

> happens is:
>
> 	- after 16 ms, the first 3072 bytes arrive. The next
> 	  packet will take another 16ms to arrive;
> 	- after 2 ms, underrun, as the period_size was not
> 	  filled yet.


Regards,
Clemens
