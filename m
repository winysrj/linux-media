Return-path: <linux-media-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:31981 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751725Ab2BQGo1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Feb 2012 01:44:27 -0500
Date: Fri, 17 Feb 2012 09:44:10 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Dean Anderson <linux-dev@sensoray.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Pete Eberlein <pete@sensoray.com>, linux-media@vger.kernel.org,
	kernel-janitors@vger.kernel.org
Subject: [patch 2/2] [media] s2255drv: fix some endian bugs
Message-ID: <20120217064410.GB3666@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I don't have this hardware and I don't know the subsystem very well.  So
please review this patch carefully.  The original code definitely looks
buggy though.

Sparse complains about some endian bugs where little endian bugs are
treated as cpu endian.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---

diff --git a/drivers/media/video/s2255drv.c b/drivers/media/video/s2255drv.c
index 3505242..4894cbb 100644
--- a/drivers/media/video/s2255drv.c
+++ b/drivers/media/video/s2255drv.c
@@ -134,7 +134,7 @@
 
 /* usb config commands */
 #define IN_DATA_TOKEN	cpu_to_le32(0x2255c0de)
-#define CMD_2255	cpu_to_le32(0xc2255000)
+#define CMD_2255	0xc2255000
 #define CMD_SET_MODE	cpu_to_le32((CMD_2255 | 0x10))
 #define CMD_START	cpu_to_le32((CMD_2255 | 0x20))
 #define CMD_STOP	cpu_to_le32((CMD_2255 | 0x30))
@@ -2025,7 +2025,7 @@ static int save_frame(struct s2255_dev *dev, struct s2255_pipeinfo *pipe_info)
 					pdata[1]);
 				offset = jj + PREFIX_SIZE;
 				bframe = 1;
-				cc = pdword[1];
+				cc = le32_to_cpu(pdword[1]);
 				if (cc >= MAX_CHANNELS) {
 					printk(KERN_ERR
 					       "bad channel\n");
@@ -2034,22 +2034,22 @@ static int save_frame(struct s2255_dev *dev, struct s2255_pipeinfo *pipe_info)
 				/* reverse it */
 				dev->cc = G_chnmap[cc];
 				channel = &dev->channel[dev->cc];
-				payload =  pdword[3];
+				payload =  le32_to_cpu(pdword[3]);
 				if (payload > channel->req_image_size) {
 					channel->bad_payload++;
 					/* discard the bad frame */
 					return -EINVAL;
 				}
 				channel->pkt_size = payload;
-				channel->jpg_size = pdword[4];
+				channel->jpg_size = le32_to_cpu(pdword[4]);
 				break;
 			case S2255_MARKER_RESPONSE:
 
 				pdata += DEF_USB_BLOCK;
 				jj += DEF_USB_BLOCK;
-				if (pdword[1] >= MAX_CHANNELS)
+				if (le32_to_cpu(pdword[1]) >= MAX_CHANNELS)
 					break;
-				cc = G_chnmap[pdword[1]];
+				cc = G_chnmap[le32_to_cpu(pdword[1])];
 				if (cc >= MAX_CHANNELS)
 					break;
 				channel = &dev->channel[cc];
@@ -2072,11 +2072,11 @@ static int save_frame(struct s2255_dev *dev, struct s2255_pipeinfo *pipe_info)
 					wake_up(&dev->fw_data->wait_fw);
 					break;
 				case S2255_RESPONSE_STATUS:
-					channel->vidstatus = pdword[3];
+					channel->vidstatus = le32_to_cpu(pdword[3]);
 					channel->vidstatus_ready = 1;
 					wake_up(&channel->wait_vidstatus);
 					dprintk(5, "got vidstatus %x chan %d\n",
-						pdword[3], cc);
+						le32_to_cpu(pdword[3]), cc);
 					break;
 				default:
 					printk(KERN_INFO "s2255 unknown resp\n");
@@ -2603,10 +2603,11 @@ static int s2255_probe(struct usb_interface *interface,
 		__le32 *pRel;
 		pRel = (__le32 *) &dev->fw_data->fw->data[fw_size - 4];
 		printk(KERN_INFO "s2255 dsp fw version %x\n", *pRel);
-		dev->dsp_fw_ver = *pRel;
-		if (*pRel < S2255_CUR_DSP_FWVER)
+		dev->dsp_fw_ver = le32_to_cpu(*pRel);
+		if (dev->dsp_fw_ver < S2255_CUR_DSP_FWVER)
 			printk(KERN_INFO "s2255: f2255usb.bin out of date.\n");
-		if (dev->pid == 0x2257 && *pRel < S2255_MIN_DSP_COLORFILTER)
+		if (dev->pid == 0x2257 &&
+				dev->dsp_fw_ver < S2255_MIN_DSP_COLORFILTER)
 			printk(KERN_WARNING "s2255: 2257 requires firmware %d"
 			       " or above.\n", S2255_MIN_DSP_COLORFILTER);
 	}
