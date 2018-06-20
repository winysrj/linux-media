Return-path: <linux-media-owner@vger.kernel.org>
Received: from Galois.linutronix.de ([146.0.238.70]:59883 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752806AbeFTLBY (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Jun 2018 07:01:24 -0400
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-usb@vger.kernel.org, tglx@linutronix.de
Subject: medial: use irqsave() in URB completion + usb_fill_int_urb
Date: Wed, 20 Jun 2018 13:00:38 +0200
Message-Id: <20180620110105.19955-1-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This series is mostly about using _irqsave() primitives in the
completion callback in order to get rid of local_irq_save() in
__usb_hcd_giveback_urb(). While at it, I also tried to move drivers to
use usb_fill_int_urb() otherwise it is hard find users of a certain API.
=20
Sebastian
