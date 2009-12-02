Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:25374 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755184AbZLBUsh (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 2 Dec 2009 15:48:37 -0500
Message-ID: <4B16D26E.9010200@redhat.com>
Date: Wed, 02 Dec 2009 18:47:42 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Jon Smirl <jonsmirl@gmail.com>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	Maxim Levitsky <maximlevitsky@gmail.com>, awalls@radix.net,
	j@jannau.net, jarod@redhat.com, jarod@wilsonet.com, khc@pm.waw.pl,
	linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org, lirc-list@lists.sourceforge.net,
	superm1@ubuntu.com, Christoph Bartelmus <lirc@bartelmus.de>
Subject: Re: [RFC v2] Another approach to IR
References: <9e4733910912010816q32e829a2uce180bfda69ef86d@mail.gmail.com>	 <4B155288.1060509@redhat.com>	 <20091201175400.GA19259@core.coreip.homeip.net>	 <4B1567D8.7080007@redhat.com>	 <20091201201158.GA20335@core.coreip.homeip.net>	 <4B15852D.4050505@redhat.com>	 <20091202093803.GA8656@core.coreip.homeip.net>	 <4B16614A.3000208@redhat.com>	 <20091202171059.GC17839@core.coreip.homeip.net>	 <4B16C10E.6040907@redhat.com> <9e4733910912021150k33446d3aybf0634fa0007ca1d@mail.gmail.com>
In-Reply-To: <9e4733910912021150k33446d3aybf0634fa0007ca1d@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Jon Smirl wrote:

> IR devices transmit vendor/device/command triplets. They are easy to
> tell apart and create an evdev device corresponding to each
> vendor/device pair or something else along those lines.

What they transmit depend on the used protocol. With NEC and RC5 (currently, the
most common protocols), they transmit only address (TV, VCR, SAT) and command.

If you have two IR's that not fully follow RC5 standard, they may use distinct
addresses. So, if you're lucky enough, you'll be able to guess the IR vendor,
based on the 8 bit address code.

I think that you can get the vendor only with RC6 IR's on some modes. 
In the case of RC6, as pointed by Andy, there are some patents envolved, 
meaning that we probably will need to decode it on userspace, except if 
someone can get the proper patent rights for its used on Linux.

Cheers,
Mauro.

