Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:42312 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751390AbZBRQsH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Feb 2009 11:48:07 -0500
From: Oliver Endriss <o.endriss@gmx.de>
Reply-To: linux-media@vger.kernel.org
To: Trent Piepho <xyzzy@speakeasy.org>
Subject: Re: [linux-dvb] [BUG] changeset 9029 (http://linuxtv.org/hg/v4l-dvb/rev/aa3e5cc1d833)
Date: Wed, 18 Feb 2009 17:47:07 +0100
Cc: linux-media@vger.kernel.org, linux-dvb@linuxtv.org
References: <4986507C.1050609@googlemail.com> <200902180304.28615@orion.escape-edv.de> <Pine.LNX.4.58.0902171911060.24268@shell2.speakeasy.net>
In-Reply-To: <Pine.LNX.4.58.0902171911060.24268@shell2.speakeasy.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902181747.07804@orion.escape-edv.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Trent Piepho wrote:
> On Wed, 18 Feb 2009, Oliver Endriss wrote:
> > [1] If you want to lock a process against an interrupt handler,
> > - the process must use spin_lock_irq()
> > - the interrupt can use spin_lock()
> >
> > A routine has to use spin_lock_irqsave if (and only if) process and irq
> > call the routine concurrently. I do not see yet how this might happen.
> 
> Some code calls the swfilter functions from process context and some
> drivers call them from interrupt context.

There would be a problem if (and only if) it could happen concurrently
within a given driver. A driver may call the functions either from
process context or from a tasklet/irq.

User space access will occur only if demux_source == DMX_MEMORY_FE.
In this case the driver must not call the routine.

If demux_source == DMX_FRONTEND, the driver may call the routine,
but userspace won't.

Sorry, I need more information to identify the problem.

CU
Oliver

-- 
----------------------------------------------------------------
VDR Remote Plugin 0.4.0: http://www.escape-edv.de/endriss/vdr/
----------------------------------------------------------------
