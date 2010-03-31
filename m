Return-path: <linux-media-owner@vger.kernel.org>
Received: from poutre.nerim.net ([62.4.16.124]:49219 "EHLO poutre.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757642Ab0CaSJm (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 31 Mar 2010 14:09:42 -0400
Date: Wed, 31 Mar 2010 20:09:38 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Andrzej Hajda <andrzej.hajda@wp.pl>,
	LMML <linux-media@vger.kernel.org>
Subject: Re: cx88 remote control event device
Message-ID: <20100331200938.7bd49eee@hyperion.delvare>
In-Reply-To: <4BB38A7D.7080702@redhat.com>
References: <20100331130042.276d7ef7@hyperion.delvare>
	<4BB38A7D.7080702@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On Wed, 31 Mar 2010 14:46:37 -0300, Mauro Carvalho Chehab wrote:
> Hi Jean,
> 
> Jean Delvare wrote:
> > Hi Andrzej,
> > 
> > Last year, you submitted a fix for the cx88 remote control not behaving
> > properly on some cards. The fix works fine for me and lets me use my
> > remote control, and I am very grateful for this.
> > 
> > However, I have noticed (using powertop) that the cx88 driver is waking
> > up the kernel 1250 times per second to handle the remote control. I
> > understand that it is needed for proper operation when the remote
> > control is in use. What I do not understand is why it still happens
> > when nobody uses the remote control. Even when no application has the
> > event device node opened, polling still happens.
> > 
> > Can't we have the cx88 driver poll the remote control only when the
> > device node is opened? I believe this would save some power by allowing
> > the CPU to stay in higher C states.
> 
> The IR can be used even when nobody is opening the /dev/video device, as
> it is an input device that can be used to control other things, including
> the start of the video application.
> 
> That's said, it makes sense to only enable the polling when the /dev/input/event 
> device is opened. 

Sorry for not being clear originally; this is exactly what I meant.

> Btw, the same polling logic is also present on bttv and saa7134 drivers.
> 
> As I'm doing a large IR rework, with the addition of the IR core subsystem,
> and the patch for handing the open/close is very simple, I've already wrote
> a patch for saa7134, on my IR tree:
> 	http://git.linuxtv.org/mchehab/ir.git?a=commitdiff;h=2b1d3acdb48266f05b82923b8db06e6c7ada0c72
> 
> The change itself is very simple, although I've added some additional checks
> to avoid the risk of having an IRQ while IR is disabled.

Looks very good, nice to see someone is already working on the problem.

> I have one cx88 board on my IR test machine (although I need to find the IR sensor for the
> board I'm using there). If I find one that works, I'll try later to write a similar 
> code to cx88.

Thanks,
-- 
Jean Delvare
