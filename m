Return-path: <linux-media-owner@vger.kernel.org>
Received: from Galois.linutronix.de ([146.0.238.70]:60672 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753853AbeFTPUL (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Jun 2018 11:20:11 -0400
Date: Wed, 20 Jun 2018 17:20:07 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-usb@vger.kernel.org, tglx@linutronix.de,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH] USB: note that usb_fill_int_urb() can be used used for ISOC
 urbs.
Message-ID: <20180620152007.xapqkv4ww2hnmvkq@linutronix.de>
References: <20180620110105.19955-1-bigeasy@linutronix.de>
 <3925059.Md1u3KRT1n@avalon>
 <20180620132144.5cdu2ydlqre4ijg6@linutronix.de>
 <18211658.4PQ3SEps0f@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <18211658.4PQ3SEps0f@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Laurent suggested that the kerneldoc documentation could state that
usb_fill_int_urb() can also be used for the initialisation of an
isochronous urb. The USB documentation in
Documentation/driver-api/usb/URB.rst already mentions this, some drivers
do so and there is no explicit usb_fill_iso_urb().

Suggested-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
On 2018-06-20 17:14:53 [+0300], Laurent Pinchart wrote:
> > So you simply asking that the kerneldoc of usb_fill_int_urb() is
> > extended to mention isoc, too?
> 
> That would be nice I think.

here it is.

 include/linux/usb.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/linux/usb.h b/include/linux/usb.h
index 4cdd515a4385..c3a8bd586121 100644
--- a/include/linux/usb.h
+++ b/include/linux/usb.h
@@ -1657,7 +1657,8 @@ static inline void usb_fill_bulk_urb(struct urb *urb,
  *	the endpoint descriptor's bInterval value.
  *
  * Initializes a interrupt urb with the proper information needed to submit
- * it to a device.
+ * it to a device. This function can also be used to initialize an isochronous
+ * urb.
  *
  * Note that High Speed and SuperSpeed(+) interrupt endpoints use a logarithmic
  * encoding of the endpoint interval, and express polling intervals in
-- 
2.17.1
