Return-path: <linux-media-owner@vger.kernel.org>
Received: from ironport2-out.teksavvy.com ([206.248.154.181]:61550 "EHLO
	ironport2-out.pppoe.ca" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753907Ab0CBPAY (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 2 Mar 2010 10:00:24 -0500
Message-ID: <4B8D2805.4030808@teksavvy.com>
Date: Tue, 02 Mar 2010 10:00:21 -0500
From: Mark Lord <kernel@teksavvy.com>
MIME-Version: 1.0
To: Andy Walls <awalls@radix.net>
CC: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	ivtv-devel@ivtvdriver.org
Subject: Re: cx18: Unable to find blank work order form to schedule incoming
 mailbox ...
References: <4B8BE647.7070709@teksavvy.com>	 <1267493641.4035.17.camel@palomino.walls.org>	 <4B8CA8DD.5030605@teksavvy.com> <1267533630.3123.17.camel@palomino.walls.org>
In-Reply-To: <1267533630.3123.17.camel@palomino.walls.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/02/10 07:40, Andy Walls wrote:
..
>>> 3. The work handler kernel thread, cx18-0-in, got killed, if that's
>>> possible, or the processor it was running on got really bogged down.
>> ..
..

One thing from the /var/log/messages output:

    12:55:59 duke kernel: IRQ 18/cx18-0: IRQF_DISABLED is not guaranteed on shared IRQs

Which is a result of the code doing this:

             retval = request_irq(cx->pci_dev->irq, cx18_irq_handler,
                              IRQF_SHARED | IRQF_DISABLED,
                              cx->v4l2_dev.name, (void *)cx);

I'm not at the MythTV box right now, but it is likely that this IRQ
really is shared with other devices.

Does the driver *really* rely upon IRQF_DISABLED (to avoid races in the handler)?
If so, then this could be a good clue.
If not, then that IRQF_DISABLED should get nuked.

Cheers
