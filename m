Return-path: <linux-media-owner@vger.kernel.org>
Received: from netrider.rowland.org ([192.131.102.5]:42937 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754585Ab0AECpq (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Jan 2010 21:45:46 -0500
Date: Mon, 4 Jan 2010 21:45:45 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
To: Sean <knife@toaster.net>
cc: bugzilla-daemon@bugzilla.kernel.org, <moinejf@free.fr>,
	<linux-media@vger.kernel.org>, USB list <linux-usb@vger.kernel.org>
Subject: Re: [Bug 14564] capture-example sleeping function called from invalid
 context at arch/x86/mm/fault.c
In-Reply-To: <4B42A498.10801@toaster.net>
Message-ID: <Pine.LNX.4.44L0.1001042141560.26506-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 4 Jan 2010, Sean wrote:

> Jef,
> 
> I upgraded to the latest v4l-dvb from http://linuxtv.org/hg/v4l-dvb, 
> made the kernel modules, made the v4l libraries, and recompiled 
> capture-example.c. Gspca now shows 2.8.0. The error still persists. Alan 
> Stern's latest patch to ohci-q.c traps the error. I think it is an issue 
> with the cpu or usb controller on the Vortex86SX SoC.

The CPU is more likely than the USB controller.  The erroneous pointer 
values we see are virtual addresses, whereas the USB controller would 
probably write a physical (or DMA) address if it was malfunctioning.

Or it could be some bizarre timing problem with the memory bus, or 
something else equally obscure.  You didn't mention before that this 
was a SoC rather than an ordinary PC.

Alan Stern

