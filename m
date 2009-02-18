Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.sea5.speakeasy.net ([69.17.117.3]:50397 "EHLO
	mail1.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752046AbZBRDW1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Feb 2009 22:22:27 -0500
Received: from shell2.sea5.speakeasy.net ([69.17.116.3])
          (envelope-sender <xyzzy@speakeasy.org>)
          by mail1.sea5.speakeasy.net (qmail-ldap-1.03) with AES256-SHA encrypted SMTP
          for <linux-media@vger.kernel.org>; 18 Feb 2009 03:22:23 -0000
Date: Tue, 17 Feb 2009 19:22:23 -0800 (PST)
From: Trent Piepho <xyzzy@speakeasy.org>
To: linux-media@vger.kernel.org
cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] [BUG] changeset 9029 (http://linuxtv.org/hg/v4l-dvb/rev/aa3e5cc1d833)
In-Reply-To: <200902180304.28615@orion.escape-edv.de>
Message-ID: <Pine.LNX.4.58.0902171911060.24268@shell2.speakeasy.net>
References: <4986507C.1050609@googlemail.com> <200902170140.53617@orion.escape-edv.de>
 <499A36CD.4070209@linuxtv.org> <200902180304.28615@orion.escape-edv.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 18 Feb 2009, Oliver Endriss wrote:
> [1] If you want to lock a process against an interrupt handler,
> - the process must use spin_lock_irq()
> - the interrupt can use spin_lock()
>
> A routine has to use spin_lock_irqsave if (and only if) process and irq
> call the routine concurrently. I do not see yet how this might happen.

Some code calls the swfilter functions from process context and some
drivers call them from interrupt context.
