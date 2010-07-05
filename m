Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:4373 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751473Ab0GEGTy (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 5 Jul 2010 02:19:54 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: pavan_savoy@ti.com
Subject: Re: V4L2 radio drivers for TI-WL7
Date: Mon, 5 Jul 2010 08:21:53 +0200
Cc: linux-media@vger.kernel.org, matti.j.aaltonen@nokia.com,
	mchehab@infradead.org, pavan savoy <pavan_savoy@yahoo.co.in>,
	eduardo.valentin@nokia.com
References: <31718.25391.qm@web94912.mail.in2.yahoo.com>
In-Reply-To: <31718.25391.qm@web94912.mail.in2.yahoo.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201007050821.53313.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Friday 02 July 2010 09:01:34 Pavan Savoy wrote:
> Hi,
> 
> We have/in process of developing a V4L2 driver for the FM Radio on the Texas Instruments WiLink 7 module.
> 
> For transport/communication with the chip, we intend to use the shared transport driver currently staged in mainline at drivers/staging/ti-st/.
> 
> To which tree should I generate patches against? is the tree
> git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git
> fine ? to be used with the v4l_for_2.6.35 branch ?

You patch against git://git.linuxtv.org/v4l-dvb.git.

> 
> Also, this is over the UART/TTY unlike the WL1273 i2c mfd driver...

Is the WiLink 7 a platform device (i.e. an integral part of the CPU) or a separate
chip that can be used with any hardware?

Will the FM Radio always be controlled over a UART/TTY bus or is that specific
to your development platform?

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG, part of Cisco
