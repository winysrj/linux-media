Return-path: <linux-media-owner@vger.kernel.org>
Received: from lider.pardus.org.tr ([193.140.100.216]:42027 "EHLO
	lider.pardus.org.tr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754595Ab0BGOyX (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 7 Feb 2010 09:54:23 -0500
Message-ID: <4B6ED423.3090700@pardus.org.tr>
Date: Sun, 07 Feb 2010 16:54:27 +0200
From: =?UTF-8?B?T3phbiDDh2HEn2xheWFu?= <ozan@pardus.org.tr>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [GIT PATCHES for 2.6.33] DVB Mantis driver
References: <4B531CDC.8020400@redhat.com>
In-Reply-To: <4B531CDC.8020400@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro Carvalho Chehab wrote:
> Linus,
> 
> Please pull from:
>         ssh://master.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git mantis
> 
> For the DVB mantis driver. This is a new driver that add support for the DVB devices
> based on ST mantis chips. This design is becoming very popular and the driver were
> already out of the kernel tree for some time.
> 
> As this driver doesn't touch on the existing code, were already confirmed to work
> by several people, and is being on linux-next since December, I'm hoping that you'll
> accept its late submission for 2.6.33.
> 

Hi,

I don't know it it was intentional but those mantis and hopper drivers doesn't call MODULE_DEVICE_TABLE
macro which makes them aliasless and hence not auto-loadable.

Regards,
Ozan Caglayan
