Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bl2nam02on0068.outbound.protection.outlook.com ([104.47.38.68]:26575
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750742AbdBRGuz (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 18 Feb 2017 01:50:55 -0500
From: Anurag Kumar Vulisha <anurag.kumar.vulisha@xilinx.com>
To: Anurag Kumar Vulisha <anuragku@xilinx.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
CC: Punnaiah Choudary Kalluri <punnaia@xilinx.com>,
        Anirudha Sarangi <anirudh@xilinx.com>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] media: uvcvideo: Add support for changing
 UVC_URBS/UVC_MAX_PACKETS from sysfs
Date: Sat, 18 Feb 2017 06:35:18 +0000
Message-ID: <3802E9A6666DF54886E2B9CBF743BA9827BDDF21@XAP-PVEXMBX02.xlnx.xilinx.com>
References: <1486140008-21892-1-git-send-email-anuragku@xilinx.com>
In-Reply-To: <1486140008-21892-1-git-send-email-anuragku@xilinx.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Ping !

>-----Original Message-----
>From: Anurag Kumar Vulisha [mailto:anurag.kumar.vulisha@xilinx.com]
>Sent: Friday, February 03, 2017 10:10 PM
>To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>; Mauro Carvalho
>Chehab <mchehab@kernel.org>
>Cc: Punnaiah Choudary Kalluri <punnaia@xilinx.com>; Anirudha Sarangi
><anirudh@xilinx.com>; linux-media@vger.kernel.org; linux-
>kernel@vger.kernel.org; Anurag Kumar Vulisha <anuragku@xilinx.com>
>Subject: [PATCH] media: uvcvideo: Add support for changing
>UVC_URBS/UVC_MAX_PACKETS from sysfs
>
>The uvc_video.c driver currently has fixed the maximum UVC_URBS queued to =
5
>and max UVC_MAX_PACKETS per URB to 32K. This configuration works fine with
>USB 2.0 and some USB 3.0 cameras on embedded platforms(like Zynq Ultrascal=
e).
>Since embedded platforms has slow processing speed as compared to
>servers/x86 machines, we may need to increase the number of URBs(UVC_URBS)
>queued. Also some next generation USB 3.0 cameras (like ZED stereo camera)
>splits each frame into multiple chunks of 48K bytes (which is greater than=
 the size
>of UVC_MAX_PACKETS per URB), so we may need to increase
>UVC_MAX_PACKETS also at runtime instead of #define it.
>
>This patch adds the solution to change UVC_URBS and UVC_MAX_PACKETS at
>runtime using sysfs layer before starting the video application.
>
>Signed-off-by: Anurag Kumar Vulisha <anuragku@xilinx.com>
>---
> drivers/media/usb/uvc/uvc_driver.c | 89
>++++++++++++++++++++++++++++++++++++++
> drivers/media/usb/uvc/uvc_video.c  | 39 ++++++++++++-----
> drivers/media/usb/uvc/uvcvideo.h   | 12 +++--
> 3 files changed, 126 insertions(+), 14 deletions(-)
>
>diff --git a/drivers/media/usb/uvc/uvc_driver.c
>b/drivers/media/usb/uvc/uvc_driver.c
>index 04bf350..51c8058 100644
>--- a/drivers/media/usb/uvc/uvc_driver.c
>+++ b/drivers/media/usb/uvc/uvc_driver.c
>@@ -190,6 +190,89 @@ static struct uvc_format_desc uvc_fmts[] =3D {
>       },
> };
>
>+/* Sysfs attributes for show and store max_urbs/max_packets per URB */
>+
>+static ssize_t get_max_urbs_show(struct device *dev,
>+      struct device_attribute *attr, char *buf) {
>+
>+      struct uvc_streaming *stream =3D NULL;
>+      struct usb_interface *intf =3D to_usb_interface(dev);
>+      struct uvc_device *udev =3D usb_get_intfdata(intf);
>+      u32 ret_len =3D 0;
>+      u32 stream_num =3D 0;
>+
>+      list_for_each_entry(stream, &udev->streams, list) {
>+              ret_len +=3D scnprintf((char *)(buf + ret_len), PAGE_SIZE,
>+                              "stream[%d] =3D %d\n", stream_num++,
>+                                              stream->max_urbs);
>+      }
>+
>+      return ret_len;
>+}
>+static DEVICE_ATTR_RO(get_max_urbs);
>+
>+static ssize_t set_max_urbs_store(struct device *dev,
>+      struct device_attribute *attr, const char *buf, size_t count) {
>+
>+      struct uvc_streaming *stream;
>+      struct usb_interface *intf =3D to_usb_interface(dev);
>+      struct uvc_device *udev =3D usb_get_intfdata(intf);
>+
>+      list_for_each_entry(stream, &udev->streams, list) {
>+              sscanf(buf, "%d", &stream->max_urbs);
>+      }
>+
>+      return count;
>+}
>+static DEVICE_ATTR_WO(set_max_urbs);
>+
>+static ssize_t get_max_packets_show(struct device *dev,
>+      struct device_attribute *attr, char *buf) {
>+
>+      struct uvc_streaming *stream =3D NULL;
>+      struct usb_interface *intf =3D to_usb_interface(dev);
>+      struct uvc_device *udev =3D usb_get_intfdata(intf);
>+      u32 ret_len =3D 0;
>+      u32 stream_num =3D 0;
>+
>+      list_for_each_entry(stream, &udev->streams, list) {
>+              ret_len +=3D scnprintf((char *)(buf + ret_len), PAGE_SIZE,
>+                              "stream[%d] =3D %d\n", stream_num++,
>+                                              stream->max_packets);
>+      }
>+
>+      return ret_len;
>+}
>+static DEVICE_ATTR_RO(get_max_packets);
>+
>+static ssize_t set_max_packets_store(struct device *dev,
>+      struct device_attribute *attr, const char *buf, size_t count) {
>+
>+      struct uvc_streaming *stream;
>+      struct usb_interface *intf =3D to_usb_interface(dev);
>+      struct uvc_device *udev =3D usb_get_intfdata(intf);
>+
>+      list_for_each_entry(stream, &udev->streams, list) {
>+              sscanf(buf, "%d", &stream->max_packets);
>+      }
>+
>+      return count;
>+}
>+static DEVICE_ATTR_WO(set_max_packets);
>+
>+static struct attribute *uvc_attributes[] =3D {
>+      &dev_attr_get_max_urbs.attr,
>+      &dev_attr_set_max_urbs.attr,
>+      &dev_attr_get_max_packets.attr,
>+      &dev_attr_set_max_packets.attr,
>+      NULL
>+};
>+
>+static const struct attribute_group uvc_attr_group =3D {
>+      .attrs =3D uvc_attributes,
>+};
>+
>+
> /* ----------------------------------------------------------------------=
--
>  * Utility functions
>  */
>@@ -2097,6 +2180,12 @@ static int uvc_probe(struct usb_interface *intf,
>                       "supported.\n", ret);
>       }
>
>+      ret =3D sysfs_create_group(&dev->intf->dev.kobj, &uvc_attr_group);
>+      if (ret < 0) {
>+              uvc_printk(KERN_ERR, "Failed to create sysfs node %d\n", re=
t);
>+              return ret;
>+      }
>+
>       uvc_trace(UVC_TRACE_PROBE, "UVC device initialized.\n");
>       usb_enable_autosuspend(udev);
>       return 0;
>diff --git a/drivers/media/usb/uvc/uvc_video.c
>b/drivers/media/usb/uvc/uvc_video.c
>index f3c1c85..18efd03 100644
>--- a/drivers/media/usb/uvc/uvc_video.c
>+++ b/drivers/media/usb/uvc/uvc_video.c
>@@ -1362,7 +1362,7 @@ static void uvc_free_urb_buffers(struct uvc_streamin=
g
>*stream)  {
>       unsigned int i;
>
>-      for (i =3D 0; i < UVC_URBS; ++i) {
>+      for (i =3D 0; i < stream->max_urbs; ++i) {
>               if (stream->urb_buffer[i]) {
> #ifndef CONFIG_DMA_NONCOHERENT
>                       usb_free_coherent(stream->dev->udev, stream-
>>urb_size, @@ -1374,6 +1374,11 @@ static void uvc_free_urb_buffers(struct
>uvc_streaming *stream)
>               }
>       }
>
>+      /* Free memory used for storing URB pointers */
>+      kfree(stream->urb);
>+      kfree(stream->urb_buffer);
>+      kfree(stream->urb_dma);
>+
>       stream->urb_size =3D 0;
> }
>
>@@ -1382,7 +1387,7 @@ static void uvc_free_urb_buffers(struct uvc_streamin=
g
>*stream)
>  * already allocated when resuming from suspend, in which case it will
>  * return without touching the buffers.
>  *
>- * Limit the buffer size to UVC_MAX_PACKETS bulk/isochronous packets. If =
the
>+ * Limit the buffer size to stream->max_packets bulk/isochronous
>+ packets. If the
>  * system is too low on memory try successively smaller numbers of packet=
s
>  * until allocation succeeds.
>  *
>@@ -1398,16 +1403,24 @@ static int uvc_alloc_urb_buffers(struct
>uvc_streaming *stream,
>       if (stream->urb_size)
>               return stream->urb_size / psize;
>
>+      /* Allocate memory for storing URB pointers */
>+      stream->urb =3D (struct urb **)kcalloc(stream->max_urbs,
>+                      sizeof(struct urb *), gfp_flags | __GFP_NOWARN);
>+      stream->urb_buffer =3D (char **)kcalloc(stream->max_urbs,
>+                              sizeof(char *), gfp_flags | __GFP_NOWARN);
>+      stream->urb_dma =3D (dma_addr_t *)kcalloc(stream->max_urbs,
>+                              sizeof(dma_addr_t), gfp_flags |
>__GFP_NOWARN);
>+
>       /* Compute the number of packets. Bulk endpoints might transfer UVC
>        * payloads across multiple URBs.
>        */
>       npackets =3D DIV_ROUND_UP(size, psize);
>-      if (npackets > UVC_MAX_PACKETS)
>-              npackets =3D UVC_MAX_PACKETS;
>+      if (npackets > stream->max_packets)
>+              npackets =3D stream->max_packets;
>
>       /* Retry allocations until one succeed. */
>       for (; npackets > 1; npackets /=3D 2) {
>-              for (i =3D 0; i < UVC_URBS; ++i) {
>+              for (i =3D 0; i < stream->max_urbs; ++i) {
>                       stream->urb_size =3D psize * npackets;  #ifndef
>CONFIG_DMA_NONCOHERENT
>                       stream->urb_buffer[i] =3D usb_alloc_coherent( @@ -
>1423,9 +1436,9 @@ static int uvc_alloc_urb_buffers(struct uvc_streaming
>*stream,
>                       }
>               }
>
>-              if (i =3D=3D UVC_URBS) {
>+              if (i =3D=3D stream->max_urbs) {
>                       uvc_trace(UVC_TRACE_VIDEO, "Allocated %u URB
>buffers "
>-                              "of %ux%u bytes each.\n", UVC_URBS,
>npackets,
>+                              "of %ux%u bytes each.\n", stream->max_urbs,
>npackets,
>                               psize);
>                       return npackets;
>               }
>@@ -1446,7 +1459,7 @@ static void uvc_uninit_video(struct uvc_streaming
>*stream, int free_buffers)
>
>       uvc_video_stats_stop(stream);
>
>-      for (i =3D 0; i < UVC_URBS; ++i) {
>+      for (i =3D 0; i < stream->max_urbs; ++i) {
>               urb =3D stream->urb[i];
>               if (urb =3D=3D NULL)
>                       continue;
>@@ -1507,7 +1520,7 @@ static int uvc_init_video_isoc(struct uvc_streaming
>*stream,
>
>       size =3D npackets * psize;
>
>-      for (i =3D 0; i < UVC_URBS; ++i) {
>+      for (i =3D 0; i < stream->max_urbs; ++i) {
>               urb =3D usb_alloc_urb(npackets, gfp_flags);
>               if (urb =3D=3D NULL) {
>                       uvc_uninit_video(stream, 1);
>@@ -1573,7 +1586,7 @@ static int uvc_init_video_bulk(struct uvc_streaming
>*stream,
>       if (stream->type =3D=3D V4L2_BUF_TYPE_VIDEO_OUTPUT)
>               size =3D 0;
>
>-      for (i =3D 0; i < UVC_URBS; ++i) {
>+      for (i =3D 0; i < stream->max_urbs; ++i) {
>               urb =3D usb_alloc_urb(0, gfp_flags);
>               if (urb =3D=3D NULL) {
>                       uvc_uninit_video(stream, 1);
>@@ -1678,7 +1691,7 @@ static int uvc_init_video(struct uvc_streaming *stre=
am,
>gfp_t gfp_flags)
>               return ret;
>
>       /* Submit the URBs. */
>-      for (i =3D 0; i < UVC_URBS; ++i) {
>+      for (i =3D 0; i < stream->max_urbs; ++i) {
>               ret =3D usb_submit_urb(stream->urb[i], gfp_flags);
>               if (ret < 0) {
>                       uvc_printk(KERN_ERR, "Failed to submit URB %u "
>@@ -1839,6 +1852,10 @@ int uvc_video_init(struct uvc_streaming *stream)
>       stream->cur_format =3D format;
>       stream->cur_frame =3D frame;
>
>+      /* Set max URB numbers & max packets per URB to default */
>+      stream->max_urbs =3D UVC_URBS;
>+      stream->max_packets =3D UVC_MAX_PACKETS;
>+
>       /* Select the video decoding function */
>       if (stream->type =3D=3D V4L2_BUF_TYPE_VIDEO_CAPTURE) {
>               if (stream->dev->quirks & UVC_QUIRK_BUILTIN_ISIGHT) diff --=
git
>a/drivers/media/usb/uvc/uvcvideo.h b/drivers/media/usb/uvc/uvcvideo.h
>index 3d6cc62..250cf89 100644
>--- a/drivers/media/usb/uvc/uvcvideo.h
>+++ b/drivers/media/usb/uvc/uvcvideo.h
>@@ -506,9 +506,15 @@ struct uvc_streaming {
>               __u32 max_payload_size;
>       } bulk;
>
>-      struct urb *urb[UVC_URBS];
>-      char *urb_buffer[UVC_URBS];
>-      dma_addr_t urb_dma[UVC_URBS];
>+      /* Maximum number of URBs that can be submitted */
>+      u32 max_urbs;
>+
>+      /* Maximum number of packets per URB */
>+      u32 max_packets;
>+
>+      struct urb **urb;
>+      char **urb_buffer;
>+      dma_addr_t *urb_dma;
>       unsigned int urb_size;
>
>       __u32 sequence;
>--
>2.1.1



This email and any attachments are intended for the sole use of the named r=
ecipient(s) and contain(s) confidential information that may be proprietary=
, privileged or copyrighted under applicable law. If you are not the intend=
ed recipient, do not read, copy, or forward this email message or any attac=
hments. Delete this email message and any attachments immediately.
