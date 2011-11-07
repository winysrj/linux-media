Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:59660 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932094Ab1KGN0h (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 7 Nov 2011 08:26:37 -0500
From: =?iso-8859-1?Q?S=E9bastien_RAILLARD_=28COEXSI=29?= <sr@coexsi.fr>
To: "Ralph Metzler" <rjkm@metzlerbros.de>,
	"Linux Media Mailing List" <linux-media@vger.kernel.org>
Subject: [DVB] ddbridge driver oops
Date: Mon, 7 Nov 2011 14:26:35 +0100
Message-ID: <008901cc9d50$dff1c4d0$9fd54e70$@coexsi.fr>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Language: fr
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Dear Ralph,

I had a crash when testing the latest ddbridge driver.
I didn't manage to get all the call trace, but I manage to get some
information where the crash is coming from.
It seems to be related with a irq processing problem or scheduling/power
management.

Using gdb and the call trace address, it shows me an origin in line 2021
from this code "tasklet_schedule(&dev->dma[0].tasklet);" :

2016                    if (s & 0x00000004)
2017                            irq_handle_i2c(dev, 2);
2018                    if (s & 0x00000008)
2019                            irq_handle_i2c(dev, 3);
2020
2021                    if (s & 0x00000100)
2022                            tasklet_schedule(&dev->dma[0].tasklet);
2023                    if (s & 0x00000200)
2024                            tasklet_schedule(&dev->dma[1].tasklet);
2025                    if (s & 0x00000400)

Here is a part of the call trace I managed to get:

error_code
init_sched_groups_power
get_signal_to_deliver
wake_up_common
spin_lock_irqsave
wake_up
irq_handler+0x2a5/0x490 [ddbridge] => this translate to the code above

Sebastien

