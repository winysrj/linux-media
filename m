Return-path: <linux-media-owner@vger.kernel.org>
Received: from Galois.linutronix.de ([146.0.238.70]:38752 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726081AbeIJONL (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 10 Sep 2018 10:13:11 -0400
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: linux-media@vger.kernel.org, linux-usb@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        tglx@linutronix.de
Subject: [PATCH 0/3] media: use irqsave() in USB's complete callback + remove local_irq_save
Date: Mon, 10 Sep 2018 11:19:57 +0200
Message-Id: <20180910092000.14693-1-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I've been looking at my queue and compared to v4.19-rc3. As it turns
out, everything was merged except for

	media: em28xx-audio: use irqsave() in USB's complete
	media: tm6000: use irqsave() in USB's complete callback

I haven't seen any reply to those two patches (like asking for changes)
so I assume that those two just fell through the cracks.

The last one is the final removal of the local_irq_save() statement once
all drivers were audited & fixed.

Sebastian
