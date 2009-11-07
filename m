Return-path: <linux-media-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.156]:19515 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751968AbZKGOFC (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 7 Nov 2009 09:05:02 -0500
Received: by fg-out-1718.google.com with SMTP id e12so643243fga.1
        for <linux-media@vger.kernel.org>; Sat, 07 Nov 2009 06:05:06 -0800 (PST)
Message-ID: <4AF57E8E.5070109@googlemail.com>
Date: Sat, 07 Nov 2009 15:05:02 +0100
From: e9hack <e9hack@googlemail.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: linux-media@vger.kernel.org
Subject: Re: bug in changeset 13239:54535665f94b ?
References: <4AEDB05E.1090704@googlemail.com> <20091107104113.0df4593b@pedra.chehab.org>
In-Reply-To: <20091107104113.0df4593b@pedra.chehab.org>
Content-Type: multipart/mixed;
 boundary="------------070509030504010603090000"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------070509030504010603090000
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Mauro Carvalho Chehab schrieb:

> I agree. We need first to stop DMA activity, and then release the page tables.
> 
> Could you please test if the enclosed patch fixes the issue?

Hi Mauro,

your patch doesn't solve the problem, because saa7146_dma_free() doesn't stop a running
dma transfer of the saa7146. Since last weekend, I'm using the attached patch. I'm not
sure, if the functionality of video_end() must be split. Maybe the last part of
video_end() must be execute at the end of vidioc_streamoff().

Regards,
Hartmut





--------------070509030504010603090000
Content-Type: text/x-diff;
 name="saa7146_video.c.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="saa7146_video.c.diff"

vdr:/usr/src/v4l-dvb/linux/drivers/media/common # hg diff saa7146_video.c
diff -r 40705fec2fb2 linux/drivers/media/common/saa7146_video.c
--- a/linux/drivers/media/common/saa7146_video.c        Fri Nov 06 15:54:49 2009 -0200
+++ b/linux/drivers/media/common/saa7146_video.c        Sat Nov 07 15:02:32 2009 +0100
@@ -1093,22 +1093,18 @@ static int vidioc_streamoff(struct file
                return 0;
        }

-       if (vv->video_fh != fh) {
-               DEB_S(("capturing, but in another open.\n"));
-               return -EBUSY;
-       }
+       err = video_end(fh, file);
+       if (err != 0)
+               return err;

        err = -EINVAL;
        if (type == V4L2_BUF_TYPE_VIDEO_CAPTURE)
                err = videobuf_streamoff(&fh->video_q);
        else if (type == V4L2_BUF_TYPE_VBI_CAPTURE)
                err = videobuf_streamoff(&fh->vbi_q);
-       if (0 != err) {
+       if (0 != err)
                DEB_D(("warning: videobuf_streamoff() failed.\n"));
-               video_end(fh, file);
-       } else {
-               err = video_end(fh, file);
-       }
+
        return err;
 }

@@ -1332,7 +1328,44 @@ static void buffer_release(struct videob
        struct saa7146_dev *dev = fh->dev;
        struct saa7146_buf *buf = (struct saa7146_buf *)vb;

+       int i;
+       u32 mc1;
+
        DEB_CAP(("vbuf:%p\n",vb));
+
+       mc1 = saa7146_read(dev, MC1);
+       for(i = 0; i < 3; i++)
+       {
+               u32 base_even;
+               u32 base_odd;
+               u32 prot_addr;
+               u32 base_page;
+               u32 pitch;
+               u32 num;
+               u32 vptr;
+
+               if (buf->pt[i].cpu && buf->pt[i].dma) {
+                       const u32 dma_mask[] = {MASK_06, MASK_05, MASK_04};
+                       vptr = saa7146_read(dev, PCI_VDP1 + i * (PCI_VDP2 - PCI_VDP1));
+                       base_even = saa7146_read(dev, BASE_EVEN1 + i * (BASE_EVEN2 - BASE_EVEN1));
+                       base_odd = saa7146_read(dev, BASE_ODD1 + i * (BASE_ODD2 - BASE_ODD1));
+                       prot_addr = saa7146_read(dev, PROT_ADDR1 + i * (PROT_ADDR2 - PROT_ADDR1));
+                       base_page = saa7146_read(dev, BASE_PAGE1 + i *(BASE_PAGE2 - BASE_PAGE1));
+                       pitch = saa7146_read(dev, PITCH1 + i * (PITCH2 - PITCH1));
+                       num = saa7146_read(dev, NUM_LINE_BYTE1 + i * (NUM_LINE_BYTE2 - NUM_LINE_BYTE1));
+
+                       if ((base_page & (0xfffff000 | ME1)) == (buf->pt[i].dma | ME1) && (mc1 & dma_mask[i])) {
+                               printk("(%s:%d) vdma%d.base_even:     %08x\n", __FILE__, __LINE__, i + 1, base_even);
+                               printk("(%s:%d) vdma%d.base_odd:      %08x\n", __FILE__, __LINE__, i + 1, base_odd);
+                               printk("(%s:%d) vdma%d.prot_addr:     %08x\n", __FILE__, __LINE__, i + 1, prot_addr);
+                               printk("(%s:%d) vdma%d.base_page:     %08x\n", __FILE__, __LINE__, i + 1, base_page);
+                               printk("(%s:%d) vdma%d.pitch:         %08x\n", __FILE__, __LINE__, i + 1, pitch);
+                               printk("(%s:%d) vdma%d.num_line_byte: %08x\n", __FILE__, __LINE__, i + 1, num);
+                               printk("(%s:%d) vdma%d.vptr:          %08x\n", __FILE__, __LINE__, i + 1, vptr);
+                               printk("(%s:%d) MC1:                 %08x\n", __FILE__, __LINE__, mc1);
+                       }
+               }
+       }

        release_all_pagetables(dev, buf);



--------------070509030504010603090000--
