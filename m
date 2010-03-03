Return-path: <linux-media-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.157]:23658 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752323Ab0CCLjg (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 3 Mar 2010 06:39:36 -0500
Received: by fg-out-1718.google.com with SMTP id l26so247448fgb.1
        for <linux-media@vger.kernel.org>; Wed, 03 Mar 2010 03:39:34 -0800 (PST)
Message-ID: <4B8E4A6F.2050809@googlemail.com>
Date: Wed, 03 Mar 2010 12:39:27 +0100
From: e9hack <e9hack@googlemail.com>
MIME-Version: 1.0
To: dougsland@redhat.com
CC: hverkuil@xs4all.nl, Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org
Subject: changeset 14351:2eda2bcc8d6f
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

changeset 14351:2eda2bcc8d6f is incomplete. If the init function is split in two function,
the deinit function shall consider this. The changes shall be apply also to av7110_init_v4l().

diff -r 58ae12f18e80 linux/drivers/media/common/saa7146_fops.c
--- a/linux/drivers/media/common/saa7146_fops.c Tue Mar 02 23:52:36 2010 -0300
+++ b/linux/drivers/media/common/saa7146_fops.c Wed Mar 03 12:15:23 2010 +0100
@@ -481,8 +481,10 @@ int saa7146_vv_release(struct saa7146_de
        DEB_EE(("dev:%p\n",dev));

        v4l2_device_unregister(&dev->v4l2_dev);
-       pci_free_consistent(dev->pci, SAA7146_CLIPPING_MEM, vv->d_clipping.cpu_addr,
vv->d_clipping.dma_handle);
-       kfree(vv);
+       if (vv) {
+               pci_free_consistent(dev->pci, SAA7146_CLIPPING_MEM,
vv->d_clipping.cpu_addr, vv->d_clipping.dma_handle);
+               kfree(vv);
+       }
        dev->vv_data = NULL;
        dev->vv_callback = NULL;

diff -r 58ae12f18e80 linux/drivers/media/dvb/ttpci/av7110_v4l.c
--- a/linux/drivers/media/dvb/ttpci/av7110_v4l.c        Tue Mar 02 23:52:36 2010 -0300
+++ b/linux/drivers/media/dvb/ttpci/av7110_v4l.c        Wed Mar 03 12:15:23 2010 +0100
@@ -790,12 +790,20 @@ int av7110_init_v4l(struct av7110 *av711
                vv_data = &av7110_vv_data_c;
        else
                vv_data = &av7110_vv_data_st;
+       ret = saa7146_vv_devinit(dev);
+
+       if (ret < 0) {
+               ERR(("cannot init device. skipping.\n"));
+               return ret;
+       }
+
        ret = saa7146_vv_init(dev, vv_data);
-
-       if (ret) {
+       if (ret < 0) {
                ERR(("cannot init capture device. skipping.\n"));
+               saa7146_vv_release(dev);
                return ret;
        }
+
        vv_data->ops.vidioc_enum_input = vidioc_enum_input;
        vv_data->ops.vidioc_g_input = vidioc_g_input;
        vv_data->ops.vidioc_s_input = vidioc_s_input;

Regards,
Hartmut
