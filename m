Return-path: <linux-media-owner@vger.kernel.org>
Received: from vader.hardeman.nu ([95.142.160.32]:50807 "EHLO hardeman.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751587AbbESWGp (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 19 May 2015 18:06:45 -0400
Date: Tue, 19 May 2015 22:38:51 +0200
From: David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
To: Antti =?iso-8859-1?Q?Sepp=E4l=E4?= <a.seppala@gmail.com>
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	James Hogan <james@albanarts.com>
Subject: Re: [PATCH v3 1/7] rc: rc-ir-raw: Add scancode encoder callback
Message-ID: <20150519203851.GC18036@hardeman.nu>
References: <1427824092-23163-1-git-send-email-a.seppala@gmail.com>
 <1427824092-23163-2-git-send-email-a.seppala@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1427824092-23163-2-git-send-email-a.seppala@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Mar 31, 2015 at 08:48:06PM +0300, Antti Seppälä wrote:
>From: James Hogan <james@albanarts.com>
>
>Add a callback to raw ir handlers for encoding and modulating a scancode
>to a set of raw events. This could be used for transmit, or for
>converting a wakeup scancode filter to a form that is more suitable for
>raw hardware wake up filters.
>
>Signed-off-by: James Hogan <james@albanarts.com>
>Signed-off-by: Antti Seppälä <a.seppala@gmail.com>
>Cc: David Härdeman <david@hardeman.nu>
>---
>
>Notes:
>    Changes in v3:
>     - Ported to apply against latest media-tree
>    
>    Changes in v2:
>     - Alter encode API to return -ENOBUFS when there isn't enough buffer
>       space. When this occurs all buffer contents must have been written
>       with the partial encoding of the scancode. This is to allow drivers
>       such as nuvoton-cir to provide a shorter buffer and still get a
>       useful partial encoding for the wakeup pattern.
>
> drivers/media/rc/rc-core-priv.h |  2 ++
> drivers/media/rc/rc-ir-raw.c    | 37 +++++++++++++++++++++++++++++++++++++
> include/media/rc-core.h         |  3 +++
> 3 files changed, 42 insertions(+)
>
>diff --git a/drivers/media/rc/rc-core-priv.h b/drivers/media/rc/rc-core-priv.h
>index b68d4f76..122c25f 100644
>--- a/drivers/media/rc/rc-core-priv.h
>+++ b/drivers/media/rc/rc-core-priv.h
>@@ -25,6 +25,8 @@ struct ir_raw_handler {
> 
> 	u64 protocols; /* which are handled by this handler */
> 	int (*decode)(struct rc_dev *dev, struct ir_raw_event event);
>+	int (*encode)(u64 protocols, const struct rc_scancode_filter *scancode,
>+		      struct ir_raw_event *events, unsigned int max);
> 
> 	/* These two should only be used by the lirc decoder */
> 	int (*raw_register)(struct rc_dev *dev);
>diff --git a/drivers/media/rc/rc-ir-raw.c b/drivers/media/rc/rc-ir-raw.c
>index b732ac6..dd47fe5 100644
>--- a/drivers/media/rc/rc-ir-raw.c
>+++ b/drivers/media/rc/rc-ir-raw.c
>@@ -246,6 +246,43 @@ static int change_protocol(struct rc_dev *dev, u64 *rc_type)
> 	return 0;
> }
> 
>+/**
>+ * ir_raw_encode_scancode() - Encode a scancode as raw events
>+ *
>+ * @protocols:		permitted protocols
>+ * @scancode:		scancode filter describing a single scancode
>+ * @events:		array of raw events to write into
>+ * @max:		max number of raw events
>+ *
>+ * Attempts to encode the scancode as raw events.
>+ *
>+ * Returns:	The number of events written.
>+ *		-ENOBUFS if there isn't enough space in the array to fit the
>+ *		encoding. In this case all @max events will have been written.
>+ *		-EINVAL if the scancode is ambiguous or invalid, or if no
>+ *		compatible encoder was found.
>+ */
>+int ir_raw_encode_scancode(u64 protocols,

Why a bitmask of protocols and not a single protocol enum? What's the
use case for encoding a given scancode according to one out of a number
of protocols (and not even knowing which one)??

>+			   const struct rc_scancode_filter *scancode,
>+			   struct ir_raw_event *events, unsigned int max)
>+{
>+	struct ir_raw_handler *handler;
>+	int ret = -EINVAL;
>+
>+	mutex_lock(&ir_raw_handler_lock);
>+	list_for_each_entry(handler, &ir_raw_handler_list, list) {
>+		if (handler->protocols & protocols && handler->encode) {
>+			ret = handler->encode(protocols, scancode, events, max);
>+			if (ret >= 0 || ret == -ENOBUFS)
>+				break;
>+		}
>+	}
>+	mutex_unlock(&ir_raw_handler_lock);
>+
>+	return ret;
>+}
>+EXPORT_SYMBOL(ir_raw_encode_scancode);
>+
> /*
>  * Used to (un)register raw event clients
>  */
>diff --git a/include/media/rc-core.h b/include/media/rc-core.h
>index 2c7fbca..5703c08 100644
>--- a/include/media/rc-core.h
>+++ b/include/media/rc-core.h
>@@ -250,6 +250,9 @@ int ir_raw_event_store_edge(struct rc_dev *dev, enum raw_event_type type);
> int ir_raw_event_store_with_filter(struct rc_dev *dev,
> 				struct ir_raw_event *ev);
> void ir_raw_event_set_idle(struct rc_dev *dev, bool idle);
>+int ir_raw_encode_scancode(u64 protocols,
>+			   const struct rc_scancode_filter *scancode,
>+			   struct ir_raw_event *events, unsigned int max);
> 
> static inline void ir_raw_event_reset(struct rc_dev *dev)
> {
>-- 
>2.0.5
>

-- 
David Härdeman
