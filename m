Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nexicom.net ([216.168.96.13]:47855 "EHLO smtp.nexicom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751185Ab1JZTcR (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 26 Oct 2011 15:32:17 -0400
Received: from mail.lockie.ca (dyn-dsl-mb-216-168-118-207.nexicom.net [216.168.118.207])
	by smtp.nexicom.net (8.13.6/8.13.4) with ESMTP id p9QJQQOQ019669
	for <linux-media@vger.kernel.org>; Wed, 26 Oct 2011 15:26:26 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by mail.lockie.ca (Postfix) with ESMTP id 72E0E1E01A6
	for <linux-media@vger.kernel.org>; Wed, 26 Oct 2011 15:26:25 -0400 (EDT)
Message-ID: <4EA85EE1.7080807@lockie.ca>
Date: Wed, 26 Oct 2011 15:26:25 -0400
From: James <rjl@lockie.ca>
MIME-Version: 1.0
To: linux-media Mailing List <linux-media@vger.kernel.org>
Subject: cx23885[0]: videobuf_dvb_register_frontend failed (errno = -12)
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

*I compiled kernel-3.1 and now my tuner card fails:

> $ dmesg | grep cx
> cx23885 driver version 0.0.3 loaded
> cx23885 0000:03:00.0: PCI INT A -> Link[LNEA] -> GSI 16 (level, low) 
> -> IRQ 16
> CORE cx23885[0]: subsystem: 0070:7911, board: Hauppauge WinTV-HVR1250 
> [card=3,autodetected]
> cx23885[0]: hauppauge eeprom: model=79571
> cx23885_dvb_register() allocating 1 frontend(s)
> cx23885[0]: cx23885 based dvb card
> DVB: registering new adapter (cx23885[0])
> cx23885[0]: videobuf_dvb_register_frontend failed (errno = -12)
> cx23885_dvb_register() dvb_register failed err = -22
> cx23885_dev_setup() Failed to register dvb on VID_C
> cx23885_dev_checkrevision() Hardware revision = 0xb0
> cx23885[0]/0: found at 0000:03:00.0, rev: 2, irq: 16, latency: 0, 
> mmio: 0xf9e00000
> cx23885 0000:03:00.0: setting latency timer to 64

**cx23885[0]: videobuf_dvb_register_frontend failed (errno = -12)
**Where can I look up what errno  -12 is?

*
