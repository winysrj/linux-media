Return-path: <linux-media-owner@vger.kernel.org>
Received: from proxy.quengel.org ([213.146.113.159]:44086 "EHLO
	gerlin1.hsp-law.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753128AbZCOVcA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 15 Mar 2009 17:32:00 -0400
To: "Matthias Schwarzzot" <zzam@gentoo.org>,
	"Manu Abraham" <manu@linuxtv.org>,
	"Mauro Carvalho Chehab" <mchehab@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
Subject: [Resend][resolved]Twinhan DVB-T card does not tune with 2.6.29
References: <8763ihy4qc.fsf@gerlin1.hsp-law.de>
From: Ralf Gerbig <rge@quengel.org>
Date: Tue, 15 Mar 2009 22:52:43 +0100
Message-ID: <87r60y322c.fsf@gerlin1.hsp-law.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Manu, Matthias, Mauro, everybody else,

this:

commit a00d0bb86b20a86a72f4df9d6e31dda94c02b4fa
Author: Matthias Schwarzzot <zzam@gentoo.org>
Date:   Tue Jan 27 16:29:44 2009 -0300

    V4L/DVB (10978): Report tuning algorith correctly
    
    Signed-off-by: Manu Abraham <manu@linuxtv.org>
    Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

solved the problem.

> Hi Mauro, everybody else,

> it is a Twinhan VisionPlus DVB, works perfectly with 2.6.28 and
> previous.

> I tried rc6, rc7 and current git. The only thing that stands out (to
> my untrained eye) is:

>IRQ 17/bt878: IRQF_DISABLED is not guaranteed on shared IRQs

> messages, /proc/interrupts, modules, lspci included, config.gz
> attached.

I hope this helps,

thanks Ralf

debugging stuff elided
[...]
