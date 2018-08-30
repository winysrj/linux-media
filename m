Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:38062 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727233AbeH3VYT (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 30 Aug 2018 17:24:19 -0400
From: Ezequiel Garcia <ezequiel@collabora.com>
To: linux-media@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Tomasz Figa <tfiga@chromium.org>,
        "Matwey V . Kornilov" <matwey@sai.msu.ru>,
        Alan Stern <stern@rowland.harvard.edu>, kernel@collabora.com,
        Keiichi Watanabe <keiichiw@chromium.org>,
        Ezequiel Garcia <ezequiel@collabora.com>
Subject: [RFC 2/3] USB: core: Add non-coherent buffer allocation helpers
Date: Thu, 30 Aug 2018 14:20:29 -0300
Message-Id: <20180830172030.23344-3-ezequiel@collabora.com>
In-Reply-To: <20180830172030.23344-1-ezequiel@collabora.com>
References: <20180830172030.23344-1-ezequiel@collabora.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As noted recently by Matwey V. Kornilov, using coherent
buffers on platforms _without_ hardware coherency results in
some devices being completely unusable, due to transfers
being too slow.

Moreover, using non-coherent buffers on platforms _with_ hardware
coherency, do not show a significant impact. This has been tested
by Matwey on PWC USB cameras on x86_64 and ARM platforms.
Quoting [1] (where kmalloc-ed buffers use streaming mappings):

"""
[..] average memcpy() data transfer rate (rate) and handler
completion time (time) have been measured when running video stream at
640x480 resolution at 10fps.

x86_64 based system (Intel Core i5-3470). This platform has hardware
coherent DMA support and proposed change doesn't make big difference here.

 * kmalloc:            rate = (2.0 +- 0.4) GBps
                       time = (5.0 +- 3.0) usec
 * usb_alloc_coherent: rate = (3.4 +- 1.2) GBps
                       time = (3.5 +- 3.0) usec

armv7l based system (TI AM335x BeagleBone Black @ 300MHz). This platform
has no hardware coherent DMA support. DMA coherence is implemented via
disabled page caching that slows down memcpy() due to memory controller
behaviour.

 * kmalloc:            rate =  (114 +- 5) MBps
                       time =   (84 +- 4) usec
 * usb_alloc_coherent: rate = (28.1 +- 0.1) MBps
                       time =  (341 +- 2) usec
""

Introduce a pair of usb_{alloc,free}_noncoherent helper functions,
for drivers that want to use non-coherent transfer buffers.

[1]: https://lkml.org/lkml/2018/8/9/734

Signed-off-by: Ezequiel Garcia <ezequiel@collabora.com>
---
 drivers/usb/core/buffer.c | 29 ++++++++++++--------
 drivers/usb/core/hcd.c    |  5 ++--
 drivers/usb/core/usb.c    | 56 +++++++++++++++++++++++++++++++++++++--
 include/linux/usb.h       |  5 ++++
 include/linux/usb/hcd.h   |  4 +--
 5 files changed, 82 insertions(+), 17 deletions(-)

diff --git a/drivers/usb/core/buffer.c b/drivers/usb/core/buffer.c
index 77eef8acff94..1bc9df883337 100644
--- a/drivers/usb/core/buffer.c
+++ b/drivers/usb/core/buffer.c
@@ -119,7 +119,8 @@ void *hcd_buffer_alloc(
 	struct usb_bus		*bus,
 	size_t			size,
 	gfp_t			mem_flags,
-	dma_addr_t		*dma
+	dma_addr_t		*dma,
+	unsigned long		attrs
 )
 {
 	struct usb_hcd		*hcd = bus_to_hcd(bus);
@@ -136,18 +137,22 @@ void *hcd_buffer_alloc(
 		return kmalloc(size, mem_flags);
 	}
 
-	for (i = 0; i < HCD_BUFFER_POOLS; i++) {
-		if (size <= pool_max[i])
-			return dma_pool_alloc(hcd->pool[i], mem_flags, dma);
+	/* Only use pools for coherent buffer requests */
+	if (!attrs) {
+		for (i = 0; i < HCD_BUFFER_POOLS; i++)
+			if (size <= pool_max[i])
+				return dma_pool_alloc(hcd->pool[i],
+						mem_flags, dma);
 	}
-	return dma_alloc_coherent(hcd->self.sysdev, size, dma, mem_flags);
+	return dma_alloc_attrs(hcd->self.sysdev, size, dma, mem_flags, attrs);
 }
 
 void hcd_buffer_free(
 	struct usb_bus		*bus,
 	size_t			size,
 	void			*addr,
-	dma_addr_t		dma
+	dma_addr_t		dma,
+	unsigned long		attrs
 )
 {
 	struct usb_hcd		*hcd = bus_to_hcd(bus);
@@ -163,11 +168,13 @@ void hcd_buffer_free(
 		return;
 	}
 
-	for (i = 0; i < HCD_BUFFER_POOLS; i++) {
-		if (size <= pool_max[i]) {
-			dma_pool_free(hcd->pool[i], addr, dma);
-			return;
+	if (!attrs) {
+		for (i = 0; i < HCD_BUFFER_POOLS; i++) {
+			if (size <= pool_max[i]) {
+				dma_pool_free(hcd->pool[i], addr, dma);
+				return;
+			}
 		}
 	}
-	dma_free_coherent(hcd->self.sysdev, size, addr, dma);
+	dma_free_attrs(hcd->self.sysdev, size, addr, dma, attrs);
 }
diff --git a/drivers/usb/core/hcd.c b/drivers/usb/core/hcd.c
index 1c21955fe7c0..25303738eb28 100644
--- a/drivers/usb/core/hcd.c
+++ b/drivers/usb/core/hcd.c
@@ -1383,7 +1383,7 @@ static int hcd_alloc_coherent(struct usb_bus *bus,
 	}
 
 	vaddr = hcd_buffer_alloc(bus, size + sizeof(vaddr),
-				 mem_flags, dma_handle);
+				 mem_flags, dma_handle, 0);
 	if (!vaddr)
 		return -ENOMEM;
 
@@ -1416,7 +1416,8 @@ static void hcd_free_coherent(struct usb_bus *bus, dma_addr_t *dma_handle,
 	if (dir == DMA_FROM_DEVICE)
 		memcpy(vaddr, *vaddr_handle, size);
 
-	hcd_buffer_free(bus, size + sizeof(vaddr), *vaddr_handle, *dma_handle);
+	hcd_buffer_free(bus, size + sizeof(vaddr),
+			*vaddr_handle, *dma_handle, 0);
 
 	*vaddr_handle = vaddr;
 	*dma_handle = 0;
diff --git a/drivers/usb/core/usb.c b/drivers/usb/core/usb.c
index 623be3174fb3..234ea5ab4bb7 100644
--- a/drivers/usb/core/usb.c
+++ b/drivers/usb/core/usb.c
@@ -858,6 +858,58 @@ int __usb_get_extra_descriptor(char *buffer, unsigned size,
 }
 EXPORT_SYMBOL_GPL(__usb_get_extra_descriptor);
 
+/**
+ * usb_alloc_noncoherent - allocate dma-non-coherent buffer
+ * @dev: device the buffer will be used with
+ * @size: requested buffer size
+ * @mem_flags: affect whether allocation may block
+ * @dma: used to return DMA address of buffer
+ *
+ * Return: Either null (indicating no buffer could be allocated), or the
+ * cpu-space pointer to a non-coherent buffer that may be used to perform
+ * DMA to the specified device. Such cpu-space buffers are returned along
+ * with the DMA address (through the pointer provided).
+ *
+ * Note:
+ * These non-conherent buffers are used with URB_NO_xxx_DMA_MAP set in
+ * urb->transfer_flags to avoid using "DMA bounce buffers". When using
+ * this API, you must have the necessary syncs points. If you are unsure
+ * about this, you should be using coherent buffers via usb_alloc_coherent.
+ *
+ * When the buffer is no longer used, free it with usb_free_noncoherent().
+ */
+void *usb_alloc_noncoherent(struct usb_device *dev, size_t size, gfp_t mem_flags,
+			 dma_addr_t *dma)
+{
+	if (!dev || !dev->bus)
+		return NULL;
+	return hcd_buffer_alloc(dev->bus, size,
+			mem_flags, dma, DMA_ATTR_NON_CONSISTENT);
+}
+EXPORT_SYMBOL_GPL(usb_alloc_noncoherent);
+
+/**
+ * usb_free_noncoherent - free memory allocated with usb_alloc_noncoherent()
+ * @dev: device the buffer was used with
+ * @size: requested buffer size
+ * @addr: CPU address of buffer
+ * @dma: DMA address of buffer
+ *
+ * This reclaims an I/O buffer, letting it be reused.  The memory must have
+ * been allocated using usb_alloc_noncoherent(), and the parameters must match
+ * those provided in that allocation request.
+ */
+void usb_free_noncoherent(struct usb_device *dev, size_t size, void *addr,
+		       dma_addr_t dma)
+{
+	if (!dev || !dev->bus)
+		return;
+	if (!addr)
+		return;
+	hcd_buffer_free(dev->bus, size, addr, dma, DMA_ATTR_NON_CONSISTENT);
+}
+EXPORT_SYMBOL_GPL(usb_free_noncoherent);
+
 /**
  * usb_alloc_coherent - allocate dma-consistent buffer for URB_NO_xxx_DMA_MAP
  * @dev: device the buffer will be used with
@@ -886,7 +938,7 @@ void *usb_alloc_coherent(struct usb_device *dev, size_t size, gfp_t mem_flags,
 {
 	if (!dev || !dev->bus)
 		return NULL;
-	return hcd_buffer_alloc(dev->bus, size, mem_flags, dma);
+	return hcd_buffer_alloc(dev->bus, size, mem_flags, dma, 0);
 }
 EXPORT_SYMBOL_GPL(usb_alloc_coherent);
 
@@ -908,7 +960,7 @@ void usb_free_coherent(struct usb_device *dev, size_t size, void *addr,
 		return;
 	if (!addr)
 		return;
-	hcd_buffer_free(dev->bus, size, addr, dma);
+	hcd_buffer_free(dev->bus, size, addr, dma, 0);
 }
 EXPORT_SYMBOL_GPL(usb_free_coherent);
 
diff --git a/include/linux/usb.h b/include/linux/usb.h
index 4cdd515a4385..7fddd6c2a61e 100644
--- a/include/linux/usb.h
+++ b/include/linux/usb.h
@@ -1750,6 +1750,11 @@ static inline int usb_urb_dir_out(struct urb *urb)
 
 int usb_urb_ep_type_check(const struct urb *urb);
 
+void *usb_alloc_noncoherent(struct usb_device *dev, size_t size,
+	gfp_t mem_flags, dma_addr_t *dma);
+void usb_free_noncoherent(struct usb_device *dev, size_t size,
+	void *addr, dma_addr_t dma);
+
 void *usb_alloc_coherent(struct usb_device *dev, size_t size,
 	gfp_t mem_flags, dma_addr_t *dma);
 void usb_free_coherent(struct usb_device *dev, size_t size,
diff --git a/include/linux/usb/hcd.h b/include/linux/usb/hcd.h
index 97e2ddec18b1..41dd5f0acaad 100644
--- a/include/linux/usb/hcd.h
+++ b/include/linux/usb/hcd.h
@@ -486,9 +486,9 @@ int hcd_buffer_create(struct usb_hcd *hcd);
 void hcd_buffer_destroy(struct usb_hcd *hcd);
 
 void *hcd_buffer_alloc(struct usb_bus *bus, size_t size,
-	gfp_t mem_flags, dma_addr_t *dma);
+	gfp_t mem_flags, dma_addr_t *dma, unsigned long attrs);
 void hcd_buffer_free(struct usb_bus *bus, size_t size,
-	void *addr, dma_addr_t dma);
+	void *addr, dma_addr_t dma, unsigned long attrs);
 
 /* generic bus glue, needed for host controllers that don't use PCI */
 extern irqreturn_t usb_hcd_irq(int irq, void *__hcd);
-- 
2.18.0
