Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44080 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753138AbaA0O14 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 27 Jan 2014 09:27:56 -0500
Date: Mon, 27 Jan 2014 09:27:43 -0500
From: Jarod Wilson <jarod@redhat.com>
To: Antti =?iso-8859-1?Q?Sepp=E4l=E4?= <a.seppala@gmail.com>
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: Re: [PATCH] nuvoton-cir: Don't touch PS/2 interrupts while
 initializing
Message-ID: <20140127142743.GC22912@redhat.com>
References: <1390643866-10350-1-git-send-email-a.seppala@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1390643866-10350-1-git-send-email-a.seppala@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Jan 25, 2014 at 11:57:46AM +0200, Antti Seppälä wrote:
> There are reports[1] that on some motherboards loading the nuvoton-cir
> disables PS/2 keyboard input. This is caused by an erroneous write of
> CIR_INTR_MOUSE_IRQ_BIT to ACPI control register.
> 
> According to datasheet the write enables mouse power management event
> interrupts which will probably have ill effects if the motherboard has
> only one PS/2 port with keyboard in it.
> 
> The cir hardware does not need mouse interrupts to function and should
> not touch them. This patch removes the illegal writes and registry
> definitions.

Probably a carry-over from the old Nuvoton code, nuking it makes sense to
me, always thought it was a little odd, but it never caused issues on the
system I had (which had no ps2).

Acked-by: Jarod Wilson <jarod@redhat.com>

-- 
Jarod Wilson
jarod@redhat.com

