Return-path: <linux-media-owner@vger.kernel.org>
Received: from Galois.linutronix.de ([146.0.238.70]:35868 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752231AbeGAPjc (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sun, 1 Jul 2018 11:39:32 -0400
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: linux-media@vger.kernel.org
Cc: tglx@linutronix.de, Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-usb@vger.kernel.org
Subject: [PATCH REPOST 0/5] media: use irqsave() in USB's complete callback
Date: Sun,  1 Jul 2018 17:39:16 +0200
Message-Id: <20180701153921.13129-1-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This series is about using _irqsave() primitives in the completion
callback in order to get rid of local_irq_save() in
__usb_hcd_giveback_urb().

Sebastian
