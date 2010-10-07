Return-path: <mchehab@pedra>
Received: from cnxtsmtp1.conexant.com ([198.62.9.252]:47845 "EHLO
	Cnxtsmtp1.conexant.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752131Ab0JGT05 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 7 Oct 2010 15:26:57 -0400
Received: from cps (nbwsmx1.bbnet.ad [157.152.183.211]) (using TLSv1 with cipher RC4-MD5 (128/128
 bits)) (No client certificate requested) by Cnxtsmtp1.conexant.com (Tumbleweed MailGate 3.7.1) with
 ESMTP id 2E18C12264E for <linux-media@vger.kernel.org>; Thu, 7 Oct 2010 12:09:15 -0700 (PDT)
From: "Palash Bandyopadhyay" <Palash.Bandyopadhyay@conexant.com>
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"linuxtv-commits@linuxtv.org" <linuxtv-commits@linuxtv.org>
cc: "Ruslan Pisarev" <ruslan@rpisarev.org.ua>
Date: Thu, 7 Oct 2010 12:09:16 -0700
Subject: RE: [git:v4l-dvb/v2.6.37] V4L/DVB: Staging: cx25821: fix braces and space coding style
 issues
Message-ID: <34B38BE41EDBA046A4AFBB591FA311320247613CA1@NBMBX01.bbnet.ad>
References: <E1P3vN0-0002Qf-9Z@www.linuxtv.org>
In-Reply-To: <E1P3vN0-0002Qf-9Z@www.linuxtv.org>
Content-Language: en-US
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Thanks.

Looks ok.

Signed off by Palash Bandyopadhyay

-----Original Message-----
From: Mauro Carvalho Chehab [mailto:mchehab@redhat.com]
Sent: Thursday, October 07, 2010 11:37 AM
To: linuxtv-commits@linuxtv.org
Cc: Ruslan Pisarev; Palash Bandyopadhyay
Subject: [git:v4l-dvb/v2.6.37] V4L/DVB: Staging: cx25821: fix braces and space coding style issues

This is an automatic generated email to let you know that the following patch were queued at the
http://git.linuxtv.org/media-tree.git tree:

Subject: V4L/DVB: Staging: cx25821: fix braces and space coding style issues
Author:  Ruslan Pisarev <ruslanpisarev@gmail.com>
Date:    Mon Sep 27 10:01:36 2010 -0300

Errors found by the checkpatch.pl tool.

[mchehab@redhat.com: merged a series of CodingStyle cleanup patches for cx25851. They're all from the same author, and patches the same driver]
Signed-off-by: Ruslan Pisarev <ruslan@rpisarev.org.ua>
Cc: Palash Bandyopadhyay <Palash.Bandyopadhyay@conexant.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

 drivers/staging/cx25821/cx25821-audio-upstream.c   |   13 +-
 drivers/staging/cx25821/cx25821-audio.h            |   10 +-
 drivers/staging/cx25821/cx25821-core.c             |   62 +++++-----
 drivers/staging/cx25821/cx25821-i2c.c              |    2 +-
 drivers/staging/cx25821/cx25821-medusa-reg.h       |   10 +-
 drivers/staging/cx25821/cx25821-medusa-video.c     |    8 +-
 drivers/staging/cx25821/cx25821-reg.h              |    4 +-
 .../staging/cx25821/cx25821-video-upstream-ch2.c   |  135 +++++++++-----------
 .../staging/cx25821/cx25821-video-upstream-ch2.h   |   14 +-
 drivers/staging/cx25821/cx25821-video-upstream.c   |   28 ++--
 drivers/staging/cx25821/cx25821-video-upstream.h   |   10 +-
 drivers/staging/cx25821/cx25821.h                  |   51 ++++----
 12 files changed, 168 insertions(+), 179 deletions(-)

---

http://git.linuxtv.org/media-tree.git?a=commitdiff;h=b9a1211dff08aa73fc26db66980ec0710a6c7134

diff --git a/drivers/staging/cx25821/cx25821-audio-upstream.c b/drivers/staging/cx25821/cx25821-audio-upstream.c
index cdff49f..6f32006 100644
--- a/drivers/staging/cx25821/cx25821-audio-upstream.c
+++ b/drivers/staging/cx25821/cx25821-audio-upstream.c
@@ -40,8 +40,8 @@ MODULE_AUTHOR("Hiep Huynh <hiep.huynh@conexant.com>");
 MODULE_LICENSE("GPL");

 static int _intr_msk =
-    FLD_AUD_SRC_RISCI1 | FLD_AUD_SRC_OF | FLD_AUD_SRC_SYNC |
-    FLD_AUD_SRC_OPC_ERR;
+       FLD_AUD_SRC_RISCI1 | FLD_AUD_SRC_OF | FLD_AUD_SRC_SYNC |
+       FLD_AUD_SRC_OPC_ERR;

 int cx25821_sram_channel_setup_upstream_audio(struct cx25821_dev *dev,
                                              struct sram_channel *ch,
@@ -506,7 +506,7 @@ int cx25821_audio_upstream_irq(struct cx25821_dev *dev, int chan_num,
 {
        int i = 0;
        u32 int_msk_tmp;
-       struct sram_channel *channel = dev->channels[chan_num].sram_channels;
+       struct sram_channel *channel = dev->channels[chan_num].sram_channels;
        dma_addr_t risc_phys_jump_addr;
        __le32 *rp;

@@ -608,7 +608,7 @@ static irqreturn_t cx25821_upstream_irq_audio(int irq, void *dev_id)
        if (!dev)
                return -1;

-       sram_ch = dev->channels[dev->_audio_upstream_channel_select].
+       sram_ch = dev->channels[dev->_audio_upstream_channel_select].
                                       sram_channels;

        msk_stat = cx_read(sram_ch->int_mstat);
@@ -733,7 +733,7 @@ int cx25821_audio_upstream_init(struct cx25821_dev *dev, int channel_select)
        }

        dev->_audio_upstream_channel_select = channel_select;
-       sram_ch = dev->channels[channel_select].sram_channels;
+       sram_ch = dev->channels[channel_select].sram_channels;

        /* Work queue */
        INIT_WORK(&dev->_audio_work_entry, cx25821_audioups_handler);
@@ -764,9 +764,8 @@ int cx25821_audio_upstream_init(struct cx25821_dev *dev, int channel_select)
                       str_length + 1);

                /* Default if filename is empty string */
-               if (strcmp(dev->input_audiofilename, "") == 0) {
+               if (strcmp(dev->input_audiofilename, "") == 0)
                        dev->_audiofilename = "/root/audioGOOD.wav";
-               }
        } else {
                str_length = strlen(_defaultAudioName);
                dev->_audiofilename = kmalloc(str_length + 1, GFP_KERNEL);
diff --git a/drivers/staging/cx25821/cx25821-audio.h b/drivers/staging/cx25821/cx25821-audio.h
index 434b2a3..a702a0d 100644
--- a/drivers/staging/cx25821/cx25821-audio.h
+++ b/drivers/staging/cx25821/cx25821-audio.h
@@ -31,18 +31,18 @@
 #define NUMBER_OF_PROGRAMS  8

 /*
-  Max size of the RISC program for a buffer. - worst case is 2 writes per line
-  Space is also added for the 4 no-op instructions added on the end.
-*/
+ * Max size of the RISC program for a buffer. - worst case is 2 writes per line
+ * Space is also added for the 4 no-op instructions added on the end.
+ */
 #ifndef USE_RISC_NOOP
 #define MAX_BUFFER_PROGRAM_SIZE     \
-    (2*LINES_PER_BUFFER*RISC_WRITE_INSTRUCTION_SIZE + RISC_WRITECR_INSTRUCTION_SIZE*4)
+       (2*LINES_PER_BUFFER*RISC_WRITE_INSTRUCTION_SIZE + RISC_WRITECR_INSTRUCTION_SIZE*4)
 #endif

 /* MAE 12 July 2005 Try to use NOOP RISC instruction instead */
 #ifdef USE_RISC_NOOP
 #define MAX_BUFFER_PROGRAM_SIZE     \
-    (2*LINES_PER_BUFFER*RISC_WRITE_INSTRUCTION_SIZE + RISC_NOOP_INSTRUCTION_SIZE*4)
+       (2*LINES_PER_BUFFER*RISC_WRITE_INSTRUCTION_SIZE + RISC_NOOP_INSTRUCTION_SIZE*4)
 #endif

 /* Sizes of various instructions in bytes.  Used when adding instructions. */
diff --git a/drivers/staging/cx25821/cx25821-core.c b/drivers/staging/cx25821/cx25821-core.c
index 03391f4..ca1eece 100644
--- a/drivers/staging/cx25821/cx25821-core.c
+++ b/drivers/staging/cx25821/cx25821-core.c
@@ -42,7 +42,7 @@ static unsigned int card[] = {[0 ... (CX25821_MAXBOARDS - 1)] = UNSET };
 module_param_array(card, int, NULL, 0444);
 MODULE_PARM_DESC(card, "card type");

-static unsigned int cx25821_devcount = 0;
+static unsigned int cx25821_devcount;

 static DEFINE_MUTEX(devlist);
 LIST_HEAD(cx25821_devlist);
@@ -781,14 +781,14 @@ static void cx25821_shutdown(struct cx25821_dev *dev)

        /* Disable Video A/B activity */
        for (i = 0; i < VID_CHANNEL_NUM; i++) {
-              cx_write(dev->channels[i].sram_channels->dma_ctl, 0);
-              cx_write(dev->channels[i].sram_channels->int_msk, 0);
+               cx_write(dev->channels[i].sram_channels->dma_ctl, 0);
+               cx_write(dev->channels[i].sram_channels->int_msk, 0);
        }

-       for (i = VID_UPSTREAM_SRAM_CHANNEL_I; i <= VID_UPSTREAM_SRAM_CHANNEL_J;
-            i++) {
-              cx_write(dev->channels[i].sram_channels->dma_ctl, 0);
-              cx_write(dev->channels[i].sram_channels->int_msk, 0);
+       for (i = VID_UPSTREAM_SRAM_CHANNEL_I;
+               i <= VID_UPSTREAM_SRAM_CHANNEL_J; i++) {
+               cx_write(dev->channels[i].sram_channels->dma_ctl, 0);
+               cx_write(dev->channels[i].sram_channels->int_msk, 0);
        }

        /* Disable Audio activity */
@@ -806,9 +806,9 @@ void cx25821_set_pixel_format(struct cx25821_dev *dev, int channel_select,
                              u32 format)
 {
        if (channel_select <= 7 && channel_select >= 0) {
-              cx_write(dev->channels[channel_select].
-                              sram_channels->pix_frmt, format);
-              dev->channels[channel_select].pixel_formats = format;
+               cx_write(dev->channels[channel_select].
+                       sram_channels->pix_frmt, format);
+               dev->channels[channel_select].pixel_formats = format;
        }
 }

@@ -829,7 +829,7 @@ static void cx25821_initialize(struct cx25821_dev *dev)
        cx_write(PCI_INT_STAT, 0xffffffff);

        for (i = 0; i < VID_CHANNEL_NUM; i++)
-              cx_write(dev->channels[i].sram_channels->int_stat, 0xffffffff);
+               cx_write(dev->channels[i].sram_channels->int_stat, 0xffffffff);

        cx_write(AUD_A_INT_STAT, 0xffffffff);
        cx_write(AUD_B_INT_STAT, 0xffffffff);
@@ -843,22 +843,22 @@ static void cx25821_initialize(struct cx25821_dev *dev)
        mdelay(100);

        for (i = 0; i < VID_CHANNEL_NUM; i++) {
-              cx25821_set_vip_mode(dev, dev->channels[i].sram_channels);
-              cx25821_sram_channel_setup(dev, dev->channels[i].sram_channels,
-                                              1440, 0);
-              dev->channels[i].pixel_formats = PIXEL_FRMT_422;
-              dev->channels[i].use_cif_resolution = FALSE;
+               cx25821_set_vip_mode(dev, dev->channels[i].sram_channels);
+               cx25821_sram_channel_setup(dev, dev->channels[i].sram_channels,
+                                               1440, 0);
+               dev->channels[i].pixel_formats = PIXEL_FRMT_422;
+               dev->channels[i].use_cif_resolution = FALSE;
        }

        /* Probably only affect Downstream */
-       for (i = VID_UPSTREAM_SRAM_CHANNEL_I; i <= VID_UPSTREAM_SRAM_CHANNEL_J;
-            i++) {
-              cx25821_set_vip_mode(dev, dev->channels[i].sram_channels);
+       for (i = VID_UPSTREAM_SRAM_CHANNEL_I;
+               i <= VID_UPSTREAM_SRAM_CHANNEL_J; i++) {
+               cx25821_set_vip_mode(dev, dev->channels[i].sram_channels);
        }

-       cx25821_sram_channel_setup_audio(dev,
-                              dev->channels[SRAM_CH08].sram_channels,
-                              128, 0);
+       cx25821_sram_channel_setup_audio(dev,
+                               dev->channels[SRAM_CH08].sram_channels,
+                               128, 0);

        cx25821_gpio_init(dev);
 }
@@ -931,8 +931,8 @@ static int cx25821_dev_setup(struct cx25821_dev *dev)

        /* Apply a sensible clock frequency for the PCIe bridge */
        dev->clk_freq = 28000000;
-       for (i = 0; i < MAX_VID_CHANNEL_NUM; i++)
-              dev->channels[i].sram_channels = &cx25821_sram_channels[i];
+       for (i = 0; i < MAX_VID_CHANNEL_NUM; i++)
+               dev->channels[i].sram_channels = &cx25821_sram_channels[i];

        if (dev->nr > 1)
                CX25821_INFO("dev->nr > 1!");
@@ -1003,11 +1003,11 @@ static int cx25821_dev_setup(struct cx25821_dev *dev)

        cx25821_card_setup(dev);

-       if (medusa_video_init(dev) < 0)
-              CX25821_ERR("%s() Failed to initialize medusa!\n"
-              , __func__);
+       if (medusa_video_init(dev) < 0)
+               CX25821_ERR("%s() Failed to initialize medusa!\n"
+               , __func__);

-       cx25821_video_register(dev);
+       cx25821_video_register(dev);

        /* register IOCTL device */
        dev->ioctl_dev =
@@ -1342,12 +1342,12 @@ static irqreturn_t cx25821_irq(int irq, void *dev_id)

        for (i = 0; i < VID_CHANNEL_NUM; i++) {
                if (pci_status & mask[i]) {
-                      vid_status = cx_read(dev->channels[i].
-                              sram_channels->int_stat);
+                       vid_status = cx_read(dev->channels[i].
+                               sram_channels->int_stat);

                        if (vid_status)
                                handled +=
-                                   cx25821_video_irq(dev, i, vid_status);
+                               cx25821_video_irq(dev, i, vid_status);

                        cx_write(PCI_INT_STAT, mask[i]);
                }
diff --git a/drivers/staging/cx25821/cx25821-i2c.c b/drivers/staging/cx25821/cx25821-i2c.c
index e43572e..2b14bcc 100644
--- a/drivers/staging/cx25821/cx25821-i2c.c
+++ b/drivers/staging/cx25821/cx25821-i2c.c
@@ -283,7 +283,7 @@ static struct i2c_algorithm cx25821_i2c_algo_template = {
        .master_xfer = i2c_xfer,
        .functionality = cx25821_functionality,
 #ifdef NEED_ALGO_CONTROL
-       .algo_control = dummy_algo_control,
+       .algo_control = dummy_algo_control,
 #endif
 };

diff --git a/drivers/staging/cx25821/cx25821-medusa-reg.h b/drivers/staging/cx25821/cx25821-medusa-reg.h
index f7f33b3..1c1c228 100644
--- a/drivers/staging/cx25821/cx25821-medusa-reg.h
+++ b/drivers/staging/cx25821/cx25821-medusa-reg.h
@@ -443,13 +443,13 @@
 /*****************************************************************************/
 /* LUMA_CTRL register fields */
 #define VDEC_A_BRITE_CTRL                              0x1014
-#define VDEC_A_CNTRST_CTRL                     0x1015
-#define VDEC_A_PEAK_SEL                        0x1016
+#define VDEC_A_CNTRST_CTRL                     0x1015
+#define VDEC_A_PEAK_SEL                                0x1016

 /*****************************************************************************/
 /* CHROMA_CTRL register fields */
-#define VDEC_A_USAT_CTRL                       0x1018
-#define VDEC_A_VSAT_CTRL                       0x1019
-#define VDEC_A_HUE_CTRL                        0x101A
+#define VDEC_A_USAT_CTRL                       0x1018
+#define VDEC_A_VSAT_CTRL                       0x1019
+#define VDEC_A_HUE_CTRL                                0x101A

 #endif
diff --git a/drivers/staging/cx25821/cx25821-medusa-video.c b/drivers/staging/cx25821/cx25821-medusa-video.c
index ef9f2b8..1e11e0c 100644
--- a/drivers/staging/cx25821/cx25821-medusa-video.c
+++ b/drivers/staging/cx25821/cx25821-medusa-video.c
@@ -778,9 +778,9 @@ int medusa_set_saturation(struct cx25821_dev *dev, int saturation, int decoder)

 int medusa_video_init(struct cx25821_dev *dev)
 {
-       u32 value = 0, tmp = 0;
-       int ret_val = 0;
-       int i = 0;
+       u32 value = 0, tmp = 0;
+       int ret_val = 0;
+       int i = 0;

        mutex_lock(&dev->lock);

@@ -829,7 +829,7 @@ int medusa_video_init(struct cx25821_dev *dev)
        /* select AFE clock to output mode */
        value = cx25821_i2c_read(&dev->i2c_bus[0], AFE_AB_DIAG_CTRL, &tmp);
        value &= 0x83FFFFFF;
-       ret_val =
+       ret_val =
           cx25821_i2c_write(&dev->i2c_bus[0], AFE_AB_DIAG_CTRL,
                             value | 0x10000000);

diff --git a/drivers/staging/cx25821/cx25821-reg.h b/drivers/staging/cx25821/cx25821-reg.h
index cfe0f32..a3fc25a 100644
--- a/drivers/staging/cx25821/cx25821-reg.h
+++ b/drivers/staging/cx25821/cx25821-reg.h
@@ -163,8 +163,8 @@
 #define  FLD_VID_DST_RISC2         0x00000010
 #define  FLD_VID_SRC_RISC1         0x00000002
 #define  FLD_VID_DST_RISC1         0x00000001
-#define  FLD_VID_SRC_ERRORS            FLD_VID_SRC_OPC_ERR | FLD_VID_SRC_SYNC | FLD_VID_SRC_UF
-#define  FLD_VID_DST_ERRORS            FLD_VID_DST_OPC_ERR | FLD_VID_DST_SYNC | FLD_VID_DST_OF
+#define  FLD_VID_SRC_ERRORS            (FLD_VID_SRC_OPC_ERR | FLD_VID_SRC_SYNC | FLD_VID_SRC_UF)
+#define  FLD_VID_DST_ERRORS            (FLD_VID_DST_OPC_ERR | FLD_VID_DST_SYNC | FLD_VID_DST_OF)

 /* ***************************************************************************** */
 #define  AUD_A_INT_MSK             0x0400C0    /* Audio Int interrupt mask */
diff --git a/drivers/staging/cx25821/cx25821-video-upstream-ch2.c b/drivers/staging/cx25821/cx25821-video-upstream-ch2.c
index d12dbb5..405e2db 100644
--- a/drivers/staging/cx25821/cx25821-video-upstream-ch2.c
+++ b/drivers/staging/cx25821/cx25821-video-upstream-ch2.c
@@ -32,17 +32,17 @@
 #include <linux/file.h>
 #include <linux/fcntl.h>
 #include <linux/slab.h>
-#include <asm/uaccess.h>
+#include <linux/uaccess.h>

 MODULE_DESCRIPTION("v4l2 driver module for cx25821 based TV cards");
 MODULE_AUTHOR("Hiep Huynh <hiep.huynh@conexant.com>");
 MODULE_LICENSE("GPL");

 static int _intr_msk =
-    FLD_VID_SRC_RISC1 | FLD_VID_SRC_UF | FLD_VID_SRC_SYNC | FLD_VID_SRC_OPC_ERR;
+       FLD_VID_SRC_RISC1 | FLD_VID_SRC_UF | FLD_VID_SRC_SYNC | FLD_VID_SRC_OPC_ERR;

 static __le32 *cx25821_update_riscprogram_ch2(struct cx25821_dev *dev,
-                                             __le32 * rp, unsigned int offset,
+                                             __le32 *rp, unsigned int offset,
                                              unsigned int bpl, u32 sync_line,
                                              unsigned int lines,
                                              int fifo_enable, int field_type)
@@ -53,9 +53,8 @@ static __le32 *cx25821_update_riscprogram_ch2(struct cx25821_dev *dev,
        *(rp++) = cpu_to_le32(RISC_RESYNC | sync_line);

        if (USE_RISC_NOOP_VIDEO) {
-               for (i = 0; i < NUM_NO_OPS; i++) {
+               for (i = 0; i < NUM_NO_OPS; i++)
                        *(rp++) = cpu_to_le32(RISC_NOOP);
-               }
        }

        /* scan lines */
@@ -75,7 +74,7 @@ static __le32 *cx25821_update_riscprogram_ch2(struct cx25821_dev *dev,
 }

 static __le32 *cx25821_risc_field_upstream_ch2(struct cx25821_dev *dev,
-                                              __le32 * rp,
+                                              __le32 *rp,
                                               dma_addr_t databuf_phys_addr,
                                               unsigned int offset,
                                               u32 sync_line, unsigned int bpl,
@@ -88,14 +87,12 @@ static __le32 *cx25821_risc_field_upstream_ch2(struct cx25821_dev *dev,
        int dist_betwn_starts = bpl * 2;

        /* sync instruction */
-       if (sync_line != NO_SYNC_LINE) {
+       if (sync_line != NO_SYNC_LINE)
                *(rp++) = cpu_to_le32(RISC_RESYNC | sync_line);
-       }

        if (USE_RISC_NOOP_VIDEO) {
-               for (i = 0; i < NUM_NO_OPS; i++) {
+               for (i = 0; i < NUM_NO_OPS; i++)
                        *(rp++) = cpu_to_le32(RISC_NOOP);
-               }
        }

        /* scan lines */
@@ -133,7 +130,7 @@ int cx25821_risc_buffer_upstream_ch2(struct cx25821_dev *dev,
 {
        __le32 *rp;
        int fifo_enable = 0;
-       int singlefield_lines = lines >> 1; /*get line count for single field */
+       int singlefield_lines = lines >> 1; /*get line count for single field */
        int odd_num_lines = singlefield_lines;
        int frame = 0;
        int frame_size = 0;
@@ -218,15 +215,15 @@ void cx25821_stop_upstream_video_ch2(struct cx25821_dev *dev)
                    ("cx25821: No video file is currently running so return!\n");
                return;
        }
-       /* Disable RISC interrupts */
+       /* Disable RISC interrupts */
        tmp = cx_read(sram_ch->int_msk);
        cx_write(sram_ch->int_msk, tmp & ~_intr_msk);

-       /* Turn OFF risc and fifo */
+       /* Turn OFF risc and fifo */
        tmp = cx_read(sram_ch->dma_ctl);
        cx_write(sram_ch->dma_ctl, tmp & ~(FLD_VID_FIFO_EN | FLD_VID_RISC_EN));

-       /* Clear data buffer memory */
+       /* Clear data buffer memory */
        if (dev->_data_buf_virt_addr_ch2)
                memset(dev->_data_buf_virt_addr_ch2, 0,
                       dev->_data_buf_size_ch2);
@@ -250,9 +247,8 @@ void cx25821_stop_upstream_video_ch2(struct cx25821_dev *dev)

 void cx25821_free_mem_upstream_ch2(struct cx25821_dev *dev)
 {
-       if (dev->_is_running_ch2) {
+       if (dev->_is_running_ch2)
                cx25821_stop_upstream_video_ch2(dev);
-       }

        if (dev->_dma_virt_addr_ch2) {
                pci_free_consistent(dev->pci, dev->_risc_size_ch2,
@@ -303,11 +299,10 @@ int cx25821_get_frame_ch2(struct cx25821_dev *dev, struct sram_channel *sram_ch)
        file_offset = dev->_frame_count_ch2 * frame_size;

        myfile = filp_open(dev->_filename_ch2, O_RDONLY | O_LARGEFILE, 0);
-
        if (IS_ERR(myfile)) {
                const int open_errno = -PTR_ERR(myfile);
-               printk("%s(): ERROR opening file(%s) with errno = %d! \n",
-                      __func__, dev->_filename_ch2, open_errno);
+               printk("%s(): ERROR opening file(%s) with errno = %d!\n",
+                       __func__, dev->_filename_ch2, open_errno);
                return PTR_ERR(myfile);
        } else {
                if (!(myfile->f_op)) {
@@ -371,8 +366,8 @@ static void cx25821_vidups_handler_ch2(struct work_struct *work)
            container_of(work, struct cx25821_dev, _irq_work_entry_ch2);

        if (!dev) {
-               printk("ERROR %s(): since container_of(work_struct) FAILED! \n",
-                      __func__);
+               printk("ERROR %s(): since container_of(work_struct) FAILED!\n",
+                       __func__);
                return;
        }

@@ -398,8 +393,8 @@ int cx25821_openfile_ch2(struct cx25821_dev *dev, struct sram_channel *sram_ch)

        if (IS_ERR(myfile)) {
                const int open_errno = -PTR_ERR(myfile);
-               printk("%s(): ERROR opening file(%s) with errno = %d! \n",
-                      __func__, dev->_filename_ch2, open_errno);
+               printk("%s(): ERROR opening file(%s) with errno = %d!\n",
+                       __func__, dev->_filename_ch2, open_errno);
                return PTR_ERR(myfile);
        } else {
                if (!(myfile->f_op)) {
@@ -450,9 +445,8 @@ int cx25821_openfile_ch2(struct cx25821_dev *dev, struct sram_channel *sram_ch)
                        if (i > 0)
                                dev->_frame_count_ch2++;

-                       if (vfs_read_retval < line_size) {
+                       if (vfs_read_retval < line_size)
                                break;
-                       }
                }

                dev->_file_status_ch2 =
@@ -494,7 +488,7 @@ static int cx25821_upstream_buffer_prepare_ch2(struct cx25821_dev *dev,
                return -ENOMEM;
        }

-       /* Iniitize at this address until n bytes to 0 */
+       /* Iniitize at this address until n bytes to 0 */
        memset(dev->_dma_virt_addr_ch2, 0, dev->_risc_size_ch2);

        if (dev->_data_buf_virt_addr_ch2 != NULL) {
@@ -502,7 +496,7 @@ static int cx25821_upstream_buffer_prepare_ch2(struct cx25821_dev *dev,
                                    dev->_data_buf_virt_addr_ch2,
                                    dev->_data_buf_phys_addr_ch2);
        }
-       /* For Video Data buffer allocation */
+       /* For Video Data buffer allocation */
        dev->_data_buf_virt_addr_ch2 =
            pci_alloc_consistent(dev->pci, dev->upstream_databuf_size_ch2,
                                 &data_dma_addr);
@@ -515,26 +509,26 @@ static int cx25821_upstream_buffer_prepare_ch2(struct cx25821_dev *dev,
                return -ENOMEM;
        }

-       /* Initialize at this address until n bytes to 0 */
+       /* Initialize at this address until n bytes to 0 */
        memset(dev->_data_buf_virt_addr_ch2, 0, dev->_data_buf_size_ch2);

        ret = cx25821_openfile_ch2(dev, sram_ch);
        if (ret < 0)
                return ret;

-       /* Creating RISC programs */
+       /* Creating RISC programs */
        ret =
            cx25821_risc_buffer_upstream_ch2(dev, dev->pci, 0, bpl,
                                             dev->_lines_count_ch2);
        if (ret < 0) {
                printk(KERN_INFO
-                      "cx25821: Failed creating Video Upstream Risc programs! \n");
+                       "cx25821: Failed creating Video Upstream Risc programs!\n");
                goto error;
        }

        return 0;

-      error:
+       error:
        return ret;
 }

@@ -542,7 +536,7 @@ int cx25821_video_upstream_irq_ch2(struct cx25821_dev *dev, int chan_num,
                                   u32 status)
 {
        u32 int_msk_tmp;
-       struct sram_channel *channel = dev->channels[chan_num].sram_channels;
+       struct sram_channel *channel = dev->channels[chan_num].sram_channels;
        int singlefield_lines = NTSC_FIELD_HEIGHT;
        int line_size_in_bytes = Y422_LINE_SZ;
        int odd_risc_prog_size = 0;
@@ -550,13 +544,13 @@ int cx25821_video_upstream_irq_ch2(struct cx25821_dev *dev, int chan_num,
        __le32 *rp;

        if (status & FLD_VID_SRC_RISC1) {
-              /* We should only process one program per call */
+               /* We should only process one program per call */
                u32 prog_cnt = cx_read(channel->gpcnt);

-              /*
-                 Since we've identified our IRQ, clear our bits from the
-                 interrupt mask and interrupt status registers
-              */
+               /*
+                *  Since we've identified our IRQ, clear our bits from the
+                *  interrupt mask and interrupt status registers
+                */
                int_msk_tmp = cx_read(channel->int_msk);
                cx_write(channel->int_msk, int_msk_tmp & ~_intr_msk);
                cx_write(channel->int_stat, _intr_msk);
@@ -612,7 +606,7 @@ int cx25821_video_upstream_irq_ch2(struct cx25821_dev *dev, int chan_num,
                       dev->_frame_count_ch2);
                return -1;
        }
-       /* ElSE, set the interrupt mask register, re-enable irq. */
+       /* ElSE, set the interrupt mask register, re-enable irq. */
        int_msk_tmp = cx_read(channel->int_msk);
        cx_write(channel->int_msk, int_msk_tmp |= _intr_msk);

@@ -631,24 +625,22 @@ static irqreturn_t cx25821_upstream_irq_ch2(int irq, void *dev_id)
                return -1;

        channel_num = VID_UPSTREAM_SRAM_CHANNEL_J;
-
-       sram_ch = dev->channels[channel_num].sram_channels;
+       sram_ch = dev->channels[channel_num].sram_channels;

        msk_stat = cx_read(sram_ch->int_mstat);
        vid_status = cx_read(sram_ch->int_stat);

-       /* Only deal with our interrupt */
+       /* Only deal with our interrupt */
        if (vid_status) {
                handled =
                    cx25821_video_upstream_irq_ch2(dev, channel_num,
                                                   vid_status);
        }

-       if (handled < 0) {
+       if (handled < 0)
                cx25821_stop_upstream_video_ch2(dev);
-       } else {
+       else
                handled += handled;
-       }

        return IRQ_RETVAL(handled);
 }
@@ -667,22 +659,21 @@ static void cx25821_set_pixelengine_ch2(struct cx25821_dev *dev,
        value |= dev->_isNTSC_ch2 ? 0 : 0x10;
        cx_write(ch->vid_fmt_ctl, value);

-       /*
-         set number of active pixels in each line. Default is 720
-         pixels in both NTSC and PAL format
-       */
+       /*
+        *  set number of active pixels in each line. Default is 720
+        * pixels in both NTSC and PAL format
+        */
        cx_write(ch->vid_active_ctl1, width);

        num_lines = (height / 2) & 0x3FF;
        odd_num_lines = num_lines;

-       if (dev->_isNTSC_ch2) {
+       if (dev->_isNTSC_ch2)
                odd_num_lines += 1;
-       }

        value = (num_lines << 16) | odd_num_lines;

-       /* set number of active lines in field 0 (top) and field 1 (bottom) */
+       /* set number of active lines in field 0 (top) and field 1 (bottom) */
        cx_write(ch->vid_active_ctl2, value);

        cx_write(ch->vid_cdt_size, VID_CDT_SIZE >> 3);
@@ -694,27 +685,27 @@ int cx25821_start_video_dma_upstream_ch2(struct cx25821_dev *dev,
        u32 tmp = 0;
        int err = 0;

-       /*
-         656/VIP SRC Upstream Channel I & J and 7 - Host Bus Interface
-         for channel A-C
-       */
+       /*
+        *  656/VIP SRC Upstream Channel I & J and 7 - Host Bus Interface
+        * for channel A-C
+        */
        tmp = cx_read(VID_CH_MODE_SEL);
        cx_write(VID_CH_MODE_SEL, tmp | 0x1B0001FF);

-       /*
-         Set the physical start address of the RISC program in the initial
-         program counter(IPC) member of the cmds.
-       */
+       /*
+        *  Set the physical start address of the RISC program in the initial
+        *  program counter(IPC) member of the cmds.
+        */
        cx_write(sram_ch->cmds_start + 0, dev->_dma_phys_addr_ch2);
-       cx_write(sram_ch->cmds_start + 4, 0); /* Risc IPC High 64 bits 63-32 */
+       cx_write(sram_ch->cmds_start + 4, 0); /* Risc IPC High 64 bits 63-32 */

        /* reset counter */
        cx_write(sram_ch->gpcnt_ctl, 3);

-       /* Clear our bits from the interrupt status register. */
+       /* Clear our bits from the interrupt status register. */
        cx_write(sram_ch->int_stat, _intr_msk);

-       /* Set the interrupt mask register, enable irq. */
+       /* Set the interrupt mask register, enable irq. */
        cx_set(PCI_INT_MSK, cx_read(PCI_INT_MSK) | (1 << sram_ch->irq_bit));
        tmp = cx_read(sram_ch->int_msk);
        cx_write(sram_ch->int_msk, tmp |= _intr_msk);
@@ -727,7 +718,7 @@ int cx25821_start_video_dma_upstream_ch2(struct cx25821_dev *dev,
                       dev->pci->irq);
                goto fail_irq;
        }
-       /* Start the DMA  engine */
+       /* Start the DMA  engine */
        tmp = cx_read(sram_ch->dma_ctl);
        cx_set(sram_ch->dma_ctl, tmp | FLD_VID_RISC_EN);

@@ -736,7 +727,7 @@ int cx25821_start_video_dma_upstream_ch2(struct cx25821_dev *dev,

        return 0;

-      fail_irq:
+       fail_irq:
        cx25821_dev_unregister(dev);
        return err;
 }
@@ -758,7 +749,7 @@ int cx25821_vidupstream_init_ch2(struct cx25821_dev *dev, int channel_select,
        }

        dev->_channel2_upstream_select = channel_select;
-       sram_ch = dev->channels[channel_select].sram_channels;
+       sram_ch = dev->channels[channel_select].sram_channels;

        INIT_WORK(&dev->_irq_work_entry_ch2, cx25821_vidups_handler_ch2);
        dev->_irq_queues_ch2 =
@@ -769,10 +760,10 @@ int cx25821_vidupstream_init_ch2(struct cx25821_dev *dev, int channel_select,
                    ("cx25821: create_singlethread_workqueue() for Video FAILED!\n");
                return -ENOMEM;
        }
-       /*
-         656/VIP SRC Upstream Channel I & J and 7 -
-         Host Bus Interface for channel A-C
-       */
+       /*
+        * 656/VIP SRC Upstream Channel I & J and 7 -
+        * Host Bus Interface for channel A-C
+        */
        tmp = cx_read(VID_CH_MODE_SEL);
        cx_write(VID_CH_MODE_SEL, tmp | 0x1B0001FF);

@@ -808,7 +799,7 @@ int cx25821_vidupstream_init_ch2(struct cx25821_dev *dev, int channel_select,
                       str_length + 1);
        }

-       /* Default if filename is empty string */
+       /* Default if filename is empty string */
        if (strcmp(dev->input_filename_ch2, "") == 0) {
                if (dev->_isNTSC_ch2) {
                        dev->_filename_ch2 =
@@ -833,7 +824,7 @@ int cx25821_vidupstream_init_ch2(struct cx25821_dev *dev, int channel_select,
        dev->upstream_riscbuf_size_ch2 = risc_buffer_size * 2;
        dev->upstream_databuf_size_ch2 = data_frame_size * 2;

-       /* Allocating buffers and prepare RISC program */
+       /* Allocating buffers and prepare RISC program */
        retval =
            cx25821_upstream_buffer_prepare_ch2(dev, sram_ch,
                                                dev->_line_size_ch2);
@@ -848,7 +839,7 @@ int cx25821_vidupstream_init_ch2(struct cx25821_dev *dev, int channel_select,

        return 0;

-      error:
+       error:
        cx25821_dev_unregister(dev);

        return err;
diff --git a/drivers/staging/cx25821/cx25821-video-upstream-ch2.h b/drivers/staging/cx25821/cx25821-video-upstream-ch2.h
index 6234063..029e830 100644
--- a/drivers/staging/cx25821/cx25821-video-upstream-ch2.h
+++ b/drivers/staging/cx25821/cx25821-video-upstream-ch2.h
@@ -88,14 +88,14 @@
 #endif

 #ifndef USE_RISC_NOOP_VIDEO
-#define PAL_US_VID_PROG_SIZE      ((PAL_FIELD_HEIGHT + 1) * 3 * DWORD_SIZE + RISC_WRITECR_INSTRUCTION_SIZE )
-#define PAL_RISC_BUF_SIZE         ( 2 * (RISC_SYNC_INSTRUCTION_SIZE + PAL_US_VID_PROG_SIZE) )
+#define PAL_US_VID_PROG_SIZE      ((PAL_FIELD_HEIGHT + 1) * 3 * DWORD_SIZE + RISC_WRITECR_INSTRUCTION_SIZE)
+#define PAL_RISC_BUF_SIZE         (2 * (RISC_SYNC_INSTRUCTION_SIZE + PAL_US_VID_PROG_SIZE))
 #define PAL_VID_PROG_SIZE         ((PAL_FIELD_HEIGHT*2) * 3 * DWORD_SIZE + 2*RISC_SYNC_INSTRUCTION_SIZE + \
-                                   RISC_WRITECR_INSTRUCTION_SIZE + JUMP_INSTRUCTION_SIZE )
-#define ODD_FLD_PAL_PROG_SIZE     ((PAL_FIELD_HEIGHT) * 3 * DWORD_SIZE + RISC_SYNC_INSTRUCTION_SIZE + RISC_WRITECR_INSTRUCTION_SIZE )
-#define ODD_FLD_NTSC_PROG_SIZE    ((NTSC_ODD_FLD_LINES) * 3 * DWORD_SIZE + RISC_SYNC_INSTRUCTION_SIZE + RISC_WRITECR_INSTRUCTION_SIZE )
+                                   RISC_WRITECR_INSTRUCTION_SIZE + JUMP_INSTRUCTION_SIZE)
+#define ODD_FLD_PAL_PROG_SIZE     ((PAL_FIELD_HEIGHT) * 3 * DWORD_SIZE + RISC_SYNC_INSTRUCTION_SIZE + RISC_WRITECR_INSTRUCTION_SIZE)
+#define ODD_FLD_NTSC_PROG_SIZE    ((NTSC_ODD_FLD_LINES) * 3 * DWORD_SIZE + RISC_SYNC_INSTRUCTION_SIZE + RISC_WRITECR_INSTRUCTION_SIZE)
 #define NTSC_US_VID_PROG_SIZE     ((NTSC_ODD_FLD_LINES + 1) * 3 * DWORD_SIZE + RISC_WRITECR_INSTRUCTION_SIZE + JUMP_INSTRUCTION_SIZE)
-#define NTSC_RISC_BUF_SIZE        (2 * (RISC_SYNC_INSTRUCTION_SIZE + NTSC_US_VID_PROG_SIZE) )
+#define NTSC_RISC_BUF_SIZE        (2 * (RISC_SYNC_INSTRUCTION_SIZE + NTSC_US_VID_PROG_SIZE))
 #define FRAME1_VID_PROG_SIZE      ((NTSC_ODD_FLD_LINES + NTSC_FIELD_HEIGHT) * 3 * DWORD_SIZE + 2*RISC_SYNC_INSTRUCTION_SIZE + \
-                                   RISC_WRITECR_INSTRUCTION_SIZE + JUMP_INSTRUCTION_SIZE )
+                                   RISC_WRITECR_INSTRUCTION_SIZE + JUMP_INSTRUCTION_SIZE)
 #endif
diff --git a/drivers/staging/cx25821/cx25821-video-upstream.c b/drivers/staging/cx25821/cx25821-video-upstream.c
index 756a820..16bf74d 100644
--- a/drivers/staging/cx25821/cx25821-video-upstream.c
+++ b/drivers/staging/cx25821/cx25821-video-upstream.c
@@ -39,7 +39,7 @@ MODULE_AUTHOR("Hiep Huynh <hiep.huynh@conexant.com>");
 MODULE_LICENSE("GPL");

 static int _intr_msk =
-    FLD_VID_SRC_RISC1 | FLD_VID_SRC_UF | FLD_VID_SRC_SYNC | FLD_VID_SRC_OPC_ERR;
+       FLD_VID_SRC_RISC1 | FLD_VID_SRC_UF | FLD_VID_SRC_SYNC | FLD_VID_SRC_OPC_ERR;

 int cx25821_sram_channel_setup_upstream(struct cx25821_dev *dev,
                                        struct sram_channel *ch,
@@ -346,13 +346,13 @@ int cx25821_get_frame(struct cx25821_dev *dev, struct sram_channel *sram_ch)

        if (IS_ERR(myfile)) {
                const int open_errno = -PTR_ERR(myfile);
-              printk(KERN_ERR
+               printk(KERN_ERR
                   "%s(): ERROR opening file(%s) with errno = %d!\n",
                   __func__, dev->_filename, open_errno);
                return PTR_ERR(myfile);
        } else {
                if (!(myfile->f_op)) {
-                      printk(KERN_ERR
+                       printk(KERN_ERR
                           "%s: File has no file operations registered!",
                           __func__);
                        filp_close(myfile, NULL);
@@ -360,7 +360,7 @@ int cx25821_get_frame(struct cx25821_dev *dev, struct sram_channel *sram_ch)
                }

                if (!myfile->f_op->read) {
-                      printk(KERN_ERR
+                       printk(KERN_ERR
                           "%s: File has no READ operations registered!",
                           __func__);
                        filp_close(myfile, NULL);
@@ -415,7 +415,7 @@ static void cx25821_vidups_handler(struct work_struct *work)
            container_of(work, struct cx25821_dev, _irq_work_entry);

        if (!dev) {
-              printk(KERN_ERR
+               printk(KERN_ERR
                   "ERROR %s(): since container_of(work_struct) FAILED!\n",
                   __func__);
                return;
@@ -448,7 +448,7 @@ int cx25821_openfile(struct cx25821_dev *dev, struct sram_channel *sram_ch)
                return PTR_ERR(myfile);
        } else {
                if (!(myfile->f_op)) {
-                      printk(KERN_ERR
+                       printk(KERN_ERR
                           "%s: File has no file operations registered!",
                           __func__);
                        filp_close(myfile, NULL);
@@ -456,7 +456,7 @@ int cx25821_openfile(struct cx25821_dev *dev, struct sram_channel *sram_ch)
                }

                if (!myfile->f_op->read) {
-                      printk(KERN_ERR
+                       printk(KERN_ERR
                           "%s: File has no READ operations registered!  \
                           Returning.",
                             __func__);
@@ -589,7 +589,7 @@ int cx25821_video_upstream_irq(struct cx25821_dev *dev, int chan_num,
                               u32 status)
 {
        u32 int_msk_tmp;
-       struct sram_channel *channel = dev->channels[chan_num].sram_channels;
+       struct sram_channel *channel = dev->channels[chan_num].sram_channels;
        int singlefield_lines = NTSC_FIELD_HEIGHT;
        int line_size_in_bytes = Y422_LINE_SZ;
        int odd_risc_prog_size = 0;
@@ -657,12 +657,12 @@ int cx25821_video_upstream_irq(struct cx25821_dev *dev, int chan_num,
                           Interrupt!\n", __func__);

                if (status & FLD_VID_SRC_SYNC)
-                      printk(KERN_ERR "%s: Video Received Sync Error \
-                      Interrupt!\n", __func__);
+                       printk(KERN_ERR "%s: Video Received Sync Error \
+                               Interrupt!\n", __func__);

                if (status & FLD_VID_SRC_OPC_ERR)
-                      printk(KERN_ERR "%s: Video Received OpCode Error \
-                      Interrupt!\n", __func__);
+                       printk(KERN_ERR "%s: Video Received OpCode Error \
+                               Interrupt!\n", __func__);
        }

        if (dev->_file_status == END_OF_FILE) {
@@ -690,7 +690,7 @@ static irqreturn_t cx25821_upstream_irq(int irq, void *dev_id)

        channel_num = VID_UPSTREAM_SRAM_CHANNEL_I;

-       sram_ch = dev->channels[channel_num].sram_channels;
+       sram_ch = dev->channels[channel_num].sram_channels;

        msk_stat = cx_read(sram_ch->int_mstat);
        vid_status = cx_read(sram_ch->int_stat);
@@ -811,7 +811,7 @@ int cx25821_vidupstream_init_ch1(struct cx25821_dev *dev, int channel_select,
        }

        dev->_channel_upstream_select = channel_select;
-       sram_ch = dev->channels[channel_select].sram_channels;
+       sram_ch = dev->channels[channel_select].sram_channels;

        INIT_WORK(&dev->_irq_work_entry, cx25821_vidups_handler);
        dev->_irq_queues = create_singlethread_workqueue("cx25821_workqueue");
diff --git a/drivers/staging/cx25821/cx25821-video-upstream.h b/drivers/staging/cx25821/cx25821-video-upstream.h
index 10dee5c..f0b3ac0 100644
--- a/drivers/staging/cx25821/cx25821-video-upstream.h
+++ b/drivers/staging/cx25821/cx25821-video-upstream.h
@@ -97,13 +97,13 @@
 #define PAL_RISC_BUF_SIZE           (2 * PAL_US_VID_PROG_SIZE)

 #define PAL_VID_PROG_SIZE           ((PAL_FIELD_HEIGHT*2) * 3 * DWORD_SIZE + 2*RISC_SYNC_INSTRUCTION_SIZE + \
-                                     RISC_WRITECR_INSTRUCTION_SIZE + JUMP_INSTRUCTION_SIZE )
+                                     RISC_WRITECR_INSTRUCTION_SIZE + JUMP_INSTRUCTION_SIZE)

-#define ODD_FLD_PAL_PROG_SIZE       ((PAL_FIELD_HEIGHT) * 3 * DWORD_SIZE + RISC_SYNC_INSTRUCTION_SIZE + RISC_WRITECR_INSTRUCTION_SIZE )
-#define ODD_FLD_NTSC_PROG_SIZE      ((NTSC_ODD_FLD_LINES) * 3 * DWORD_SIZE + RISC_SYNC_INSTRUCTION_SIZE + RISC_WRITECR_INSTRUCTION_SIZE )
+#define ODD_FLD_PAL_PROG_SIZE       ((PAL_FIELD_HEIGHT) * 3 * DWORD_SIZE + RISC_SYNC_INSTRUCTION_SIZE + RISC_WRITECR_INSTRUCTION_SIZE)
+#define ODD_FLD_NTSC_PROG_SIZE      ((NTSC_ODD_FLD_LINES) * 3 * DWORD_SIZE + RISC_SYNC_INSTRUCTION_SIZE + RISC_WRITECR_INSTRUCTION_SIZE)

 #define NTSC_US_VID_PROG_SIZE       ((NTSC_ODD_FLD_LINES + 1) * 3 * DWORD_SIZE + RISC_WRITECR_INSTRUCTION_SIZE + JUMP_INSTRUCTION_SIZE)
-#define NTSC_RISC_BUF_SIZE          ( 2 * (RISC_SYNC_INSTRUCTION_SIZE + NTSC_US_VID_PROG_SIZE) )
+#define NTSC_RISC_BUF_SIZE          (2 * (RISC_SYNC_INSTRUCTION_SIZE + NTSC_US_VID_PROG_SIZE))
 #define FRAME1_VID_PROG_SIZE        ((NTSC_ODD_FLD_LINES + NTSC_FIELD_HEIGHT) * 3 * DWORD_SIZE + 2*RISC_SYNC_INSTRUCTION_SIZE + \
-                                     RISC_WRITECR_INSTRUCTION_SIZE + JUMP_INSTRUCTION_SIZE )
+                                     RISC_WRITECR_INSTRUCTION_SIZE + JUMP_INSTRUCTION_SIZE)
 #endif
diff --git a/drivers/staging/cx25821/cx25821.h b/drivers/staging/cx25821/cx25821.h
index 1b628f6..c940001 100644
--- a/drivers/staging/cx25821/cx25821.h
+++ b/drivers/staging/cx25821/cx25821.h
@@ -91,10 +91,10 @@

 /* Currently supported by the driver */
 #define CX25821_NORMS (\
-    V4L2_STD_NTSC_M |  V4L2_STD_NTSC_M_JP | V4L2_STD_NTSC_M_KR | \
-    V4L2_STD_PAL_BG |  V4L2_STD_PAL_DK    |  V4L2_STD_PAL_I    | \
-    V4L2_STD_PAL_M  |  V4L2_STD_PAL_N     |  V4L2_STD_PAL_H    | \
-    V4L2_STD_PAL_Nc )
+       V4L2_STD_NTSC_M |  V4L2_STD_NTSC_M_JP | V4L2_STD_NTSC_M_KR | \
+       V4L2_STD_PAL_BG |  V4L2_STD_PAL_DK    |  V4L2_STD_PAL_I    | \
+       V4L2_STD_PAL_M  |  V4L2_STD_PAL_N     |  V4L2_STD_PAL_H    | \
+       V4L2_STD_PAL_Nc)

 #define CX25821_BOARD_CONEXANT_ATHENA10 1
 #define MAX_VID_CHANNEL_NUM     12
@@ -139,7 +139,7 @@ struct cx25821_fh {
        /* video capture */
        struct cx25821_fmt *fmt;
        unsigned int width, height;
-    int channel_id;
+       int channel_id;

        /* vbi capture */
        struct videobuf_queue vidq;
@@ -238,26 +238,25 @@ struct cx25821_data {
 };

 struct cx25821_channel {
-       struct v4l2_prio_state prio;
+       struct v4l2_prio_state prio;

-       int ctl_bright;
-       int ctl_contrast;
-       int ctl_hue;
-       int ctl_saturation;
+       int ctl_bright;
+       int ctl_contrast;
+       int ctl_hue;
+       int ctl_saturation;
+       struct cx25821_data timeout_data;

-       struct cx25821_data timeout_data;
+       struct video_device *video_dev;
+       struct cx25821_dmaqueue vidq;

-       struct video_device *video_dev;
-       struct cx25821_dmaqueue vidq;
+       struct sram_channel *sram_channels;

-       struct sram_channel *sram_channels;
-
-       struct mutex lock;
-       int resources;
+       struct mutex lock;
+       int resources;

-       int pixel_formats;
-       int use_cif_resolution;
-       int cif_width;
+       int pixel_formats;
+       int use_cif_resolution;
+       int cif_width;
 };

 struct cx25821_dev {
@@ -283,7 +282,7 @@ struct cx25821_dev {
        int nr;
        struct mutex lock;

-    struct cx25821_channel channels[MAX_VID_CHANNEL_NUM];
+       struct cx25821_channel channels[MAX_VID_CHANNEL_NUM];

        /* board details */
        unsigned int board;
@@ -311,7 +310,7 @@ struct cx25821_dev {
        int _audio_lines_count;
        int _audioframe_count;
        int _audio_upstream_channel_select;
-       int _last_index_irq;    /* The last interrupt index processed. */
+       int _last_index_irq;    /* The last interrupt index processed. */

        __le32 *_risc_audio_jmp_addr;
        __le32 *_risc_virt_start_addr;
@@ -443,7 +442,7 @@ static inline struct cx25821_dev *get_cx25821(struct v4l2_device *v4l2_dev)
 }

 #define cx25821_call_all(dev, o, f, args...) \
-    v4l2_device_call_all(&dev->v4l2_dev, 0, o, f, ##args)
+       v4l2_device_call_all(&dev->v4l2_dev, 0, o, f, ##args)

 extern struct list_head cx25821_devlist;
 extern struct cx25821_board cx25821_boards[];
@@ -491,7 +490,7 @@ struct sram_channel {
        u32 fld_aud_fifo_en;
        u32 fld_aud_risc_en;

-       /* For Upstream Video */
+       /* For Upstream Video */
        u32 vid_fmt_ctl;
        u32 vid_active_ctl1;
        u32 vid_active_ctl2;
@@ -511,8 +510,8 @@ extern struct sram_channel cx25821_sram_channels[];
 #define cx_write(reg, value)     writel((value), dev->lmmio + ((reg)>>2))

 #define cx_andor(reg, mask, value) \
-  writel((readl(dev->lmmio+((reg)>>2)) & ~(mask)) |\
-  ((value) & (mask)), dev->lmmio+((reg)>>2))
+       writel((readl(dev->lmmio+((reg)>>2)) & ~(mask)) |\
+       ((value) & (mask)), dev->lmmio+((reg)>>2))

 #define cx_set(reg, bit)          cx_andor((reg), (bit), (bit))
 #define cx_clear(reg, bit)        cx_andor((reg), (bit), 0)

Conexant E-mail Firewall (Conexant.Com) made the following annotations
---------------------------------------------------------------------
********************** Legal Disclaimer **************************** 

"This email may contain confidential and privileged material for the sole use of the intended recipient. Any unauthorized review, use or distribution by others is strictly prohibited. If you have received the message in error, please advise the sender by reply email and delete the message. Thank you." 

********************************************************************** 

---------------------------------------------------------------------

