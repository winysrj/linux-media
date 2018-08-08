Return-path: <linux-media-owner@vger.kernel.org>
Received: from Galois.linutronix.de ([146.0.238.70]:54232 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727706AbeHHXz1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 8 Aug 2018 19:55:27 -0400
Date: Wed, 8 Aug 2018 23:33:49 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-usb@vger.kernel.org, tglx@linutronix.de,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH v2] usb: add usb_fill_iso_urb()
Message-ID: <20180808213348.ipppuapqaasrkhxv@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Provide usb_fill_iso_urb() for the initialisation of isochronous URBs.
We already have one of this helpers for control, bulk and interruptible
URB types. This helps to keep the initialisation of the URB members in
one place.
Update the documentation by adding this to the available init functions
and remove the suggestion to use the `_int_' helper which might provide
wrong encoding for the `interval' member.

This looks like it would cover most users nicely. The sound subsystem
initialises the ->iso_frame_desc[].offset + length member at a different
location and I'm not sure ->interval will work as expected.

Some users also initialise ->iso_frame_desc[].actual_length but I don't
think that this is required since it is the return value.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
RFC … v2:
	- rephrased the interval description as per Alan Stern.
	- packets and packet_size can be 0 so the initialisation of
	  those members will be skipped. Suggested by Alan Stern, came
	  handy while converting drivers.
	- Updated wording as suggested by Laurent Pinchart.

 Documentation/driver-api/usb/URB.rst | 12 +++---
 include/linux/usb.h                  | 60 ++++++++++++++++++++++++++++
 2 files changed, 66 insertions(+), 6 deletions(-)

diff --git a/Documentation/driver-api/usb/URB.rst b/Documentation/driver-api/usb/URB.rst
index 61a54da9fce9..20030b781519 100644
--- a/Documentation/driver-api/usb/URB.rst
+++ b/Documentation/driver-api/usb/URB.rst
@@ -116,11 +116,11 @@ What has to be filled in?
 
 Depending on the type of transaction, there are some inline functions
 defined in ``linux/usb.h`` to simplify the initialization, such as
-:c:func:`usb_fill_control_urb`, :c:func:`usb_fill_bulk_urb` and
-:c:func:`usb_fill_int_urb`.  In general, they need the usb device pointer,
-the pipe (usual format from usb.h), the transfer buffer, the desired transfer
-length, the completion handler, and its context. Take a look at the some
-existing drivers to see how they're used.
+:c:func:`usb_fill_control_urb`, :c:func:`usb_fill_bulk_urb`,
+:c:func:`usb_fill_int_urb` and :c:func:`usb_fill_iso_urb`.  In general, they
+need the usb device pointer, the pipe (usual format from usb.h), the transfer
+buffer, the desired transfer length, the completion handler, and its context.
+Take a look at the some existing drivers to see how they're used.
 
 Flags:
 
@@ -243,7 +243,7 @@ Besides the fields present on a bulk transfer, for ISO, you also
 also have to set ``urb->interval`` to say how often to make transfers; it's
 often one per frame (which is once every microframe for highspeed devices).
 The actual interval used will be a power of two that's no bigger than what
-you specify. You can use the :c:func:`usb_fill_int_urb` macro to fill
+you specify. You can use the :c:func:`usb_fill_iso_urb` macro to fill
 most ISO transfer fields.
 
 For ISO transfers you also have to fill a :c:type:`usb_iso_packet_descriptor`
diff --git a/include/linux/usb.h b/include/linux/usb.h
index 4cdd515a4385..ec1200d53ac5 100644
--- a/include/linux/usb.h
+++ b/include/linux/usb.h
@@ -1697,6 +1697,66 @@ static inline void usb_fill_int_urb(struct urb *urb,
 	urb->start_frame = -1;
 }
 
+/**
+ * usb_fill_iso_urb - initializes an isochronous urb
+ * @urb: pointer to the urb to initialize.
+ * @dev: pointer to the struct usb_device for this urb.
+ * @pipe: the endpoint pipe
+ * @transfer_buffer: pointer to the transfer buffer
+ * @buffer_length: length of the transfer buffer
+ * @complete_fn: pointer to the usb_complete_t function
+ * @context: what to set the urb context to.
+ * @interval: what to set the urb interval to, encoded like
+ *	the endpoint descriptor's bInterval value.
+ * @packets: number of ISO packets.
+ * @packet_size: size of each ISO packet.
+ *
+ * Initializes an isochronous urb with the proper information needed to submit
+ * it to a device.
+ *
+ * Full-speed devices express polling intervals in frames (1 per ms);
+ * high-speed and SuperSpeed devices express polling intervals in
+ * microframes (8 per ms).
+ *
+ * The arguments @packets is to initialize number_of_packets member of struct
+ * usb. If @packets and @packet_size is non zero then the iso_frame_desc array
+ * will be initialized and each packet will have the same size.
+ */
+static inline void usb_fill_iso_urb(struct urb *urb,
+				    struct usb_device *dev,
+				    unsigned int pipe,
+				    void *transfer_buffer,
+				    int buffer_length,
+				    usb_complete_t complete_fn,
+				    void *context,
+				    int interval,
+				    unsigned int packets,
+				    unsigned int packet_size)
+{
+	unsigned int i;
+
+	urb->dev = dev;
+	urb->pipe = pipe;
+	urb->transfer_buffer = transfer_buffer;
+	urb->transfer_buffer_length = buffer_length;
+	urb->complete = complete_fn;
+	urb->context = context;
+
+	interval = clamp(interval, 1, 16);
+	urb->interval = 1 << (interval - 1);
+	urb->start_frame = -1;
+
+	if (packets)
+		urb->number_of_packets = packets;
+
+	if (packet_size) {
+		for (i = 0; i < packets; i++) {
+			urb->iso_frame_desc[i].offset = packet_size * i;
+			urb->iso_frame_desc[i].length = packet_size;
+		}
+	}
+}
+
 extern void usb_init_urb(struct urb *urb);
 extern struct urb *usb_alloc_urb(int iso_packets, gfp_t mem_flags);
 extern void usb_free_urb(struct urb *urb);
-- 
2.18.0
