Return-path: <linux-media-owner@vger.kernel.org>
Received: from Galois.linutronix.de ([146.0.238.70]:36983 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934265AbeGJQSq (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 10 Jul 2018 12:18:46 -0400
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: linux-media@vger.kernel.org
Cc: tglx@linutronix.de, Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-usb@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 2nd REPOST 0/5] media: use irqsave() in USB's complete callback
Date: Tue, 10 Jul 2018 18:18:28 +0200
Message-Id: <20180710161833.2435-1-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is the second repost of the "please use _irqsave() primitives in the
completion callback in order to get rid of local_irq_save() in
__usb_hcd_giveback_urb()" series for the media subsystem. I saw no
feedback from Mauro so far.

The other patches were successfully routed through their subsystems so
far and pop up in linux-next (except for the ath9k but it is merged in
its ath9k tree so it is okay).

Sebastian
