Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io0-f178.google.com ([209.85.223.178]:35817 "EHLO
	mail-io0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751912AbbKUWUO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 21 Nov 2015 17:20:14 -0500
Received: by ioc74 with SMTP id 74so155864526ioc.2
        for <linux-media@vger.kernel.org>; Sat, 21 Nov 2015 14:20:13 -0800 (PST)
MIME-Version: 1.0
Date: Sun, 22 Nov 2015 00:20:13 +0200
Message-ID: <CAJ2oMhL93kMM8i9Mc9ayRmtAkCyN1Stq2SRsjNpeLrVvR5DWNw@mail.gmail.com>
Subject: Interrupt handler responsibility
From: Ran Shalit <ranshalit@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

I am trying to understand the interrupt handler responsibility in
v4l2, also with respect to dma usage. I see that it is not defined as
part of the videobuf2 API.

This is what I understand this far:
1. start_streaming is responsible for getting into "streaming" state.
dma start should be trigggered at this point.
2. interrupt handler: is responsible for passing back the buffer to
user using vb2_buffer_done() call.

But what is the exact reponsibility of interrupt handler with respect
to dma usage  ?
In some of the drivers I see that the interrupt start/stop dma, but in
 v4l2-pci-skeleton.c I don't see any usage of dma in the interrupt
handler, so I'm not sure.

Best Regards,
Ran
