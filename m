Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:58907 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754846Ab0J0Mbf (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Oct 2010 08:31:35 -0400
From: Hans de Goede <hdegoede@redhat.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Lee Jones <lee.jones@canonical.com>,
	Jean-Francois Moine <moinejf@free.fr>,
	Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 1/7] gspca: submit interrupt urbs *after* isoc urbs
Date: Wed, 27 Oct 2010 14:35:20 +0200
Message-Id: <1288182926-25400-2-git-send-email-hdegoede@redhat.com>
In-Reply-To: <1288182926-25400-1-git-send-email-hdegoede@redhat.com>
References: <1288182926-25400-1-git-send-email-hdegoede@redhat.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Currently gspca supported usb-1.1 webcams for which we support the input
button through an interrupt endpoint won't stream (not enough bandwidth
error) when used through an USB-2.0 hub.

After much debugging I've found out that the cause for this is that the
ehci-sched.c schedeling code does not like it when there are already urb's
scheduled when (large) isoc urbs are queued. By moving the submission
of the interrupt urbs to after submitting the isoc urbs the camera
starts working again through usb-2.0 hubs.

Note that this does not fix isoc. streaming through a usb-hub while another
1.1 usb device (like the microphone of the same cam) is also active
at the same time :(

I've spend a long time analyzing the linux kernel ehci scheduler code,
resulting in this (long) mail:
http://www.spinics.net/lists/linux-usb/msg37982.html

The conclusion of the following mail thread is that yes there are several
issues when using usb-1.1 devices through a usb-2.0 hub, but these are not
easily fixable in the current code. Fixing this in ehci-sched.c requires
an almost full rewrite, which is not bound to happen anytime soon.

So with this patch gspca driven usb-1.1 webcams will atleast work when
connected through an usb-2.0 hub when the microphone is not used.

As an added bonus this patch avoids extra destroy/create input urb cycles
when we end up falling back to a lower speed alt setting because of bandwidth
limitations.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 drivers/media/video/gspca/gspca.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/media/video/gspca/gspca.c b/drivers/media/video/gspca/gspca.c
index 8fe8fb4..dbd63c5 100644
--- a/drivers/media/video/gspca/gspca.c
+++ b/drivers/media/video/gspca/gspca.c
@@ -676,13 +676,11 @@ static struct usb_host_endpoint *get_ep(struct gspca_dev *gspca_dev)
 			i, ep->desc.bEndpointAddress);
 	gspca_dev->alt = i;		/* memorize the current alt setting */
 	if (gspca_dev->nbalt > 1) {
-		gspca_input_destroy_urb(gspca_dev);
 		ret = usb_set_interface(gspca_dev->dev, gspca_dev->iface, i);
 		if (ret < 0) {
 			err("set alt %d err %d", i, ret);
 			ep = NULL;
 		}
-		gspca_input_create_urb(gspca_dev);
 	}
 	return ep;
 }
@@ -781,7 +779,7 @@ static int gspca_init_transfer(struct gspca_dev *gspca_dev)
 
 	if (!gspca_dev->present) {
 		ret = -ENODEV;
-		goto out;
+		goto unlock;
 	}
 
 	/* reset the streaming variables */
@@ -802,8 +800,10 @@ static int gspca_init_transfer(struct gspca_dev *gspca_dev)
 	if (gspca_dev->sd_desc->isoc_init) {
 		ret = gspca_dev->sd_desc->isoc_init(gspca_dev);
 		if (ret < 0)
-			goto out;
+			goto unlock;
 	}
+
+	gspca_input_destroy_urb(gspca_dev);
 	ep = get_ep(gspca_dev);
 	if (ep == NULL) {
 		ret = -EIO;
@@ -873,6 +873,8 @@ static int gspca_init_transfer(struct gspca_dev *gspca_dev)
 		}
 	}
 out:
+	gspca_input_create_urb(gspca_dev);
+unlock:
 	mutex_unlock(&gspca_dev->usb_lock);
 	return ret;
 }
-- 
1.7.3.1

