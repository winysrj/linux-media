Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mB2KQpSX005419
	for <video4linux-list@redhat.com>; Tue, 2 Dec 2008 15:26:51 -0500
Received: from smtp1-g19.free.fr (smtp1-g19.free.fr [212.27.42.27])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mB2KQ1Yr024217
	for <video4linux-list@redhat.com>; Tue, 2 Dec 2008 15:26:02 -0500
Message-ID: <493599E3.1040806@free.fr>
Date: Tue, 02 Dec 2008 21:26:11 +0100
From: Thierry Merle <thierry.merle@free.fr>
MIME-Version: 1.0
To: Chris Grove <dj_gerbil@tiscali.co.uk>
References: <002901c95150$44c16b90$ce4442b0$@co.uk>
	<4931ADCD.2000407@free.fr>	<011901c952f4$a02d9710$e088c530$@co.uk>
	<4932ACE9.7030309@free.fr> <012301c95302$6eed5f60$4cc81e20$@co.uk>
	<013f01c9532a$8dcbdf10$a9639d30$@co.uk> <493301D5.5050001@free.fr>
	<000301c95341$504c5810$f0e50830$@co.uk> <493451C5.9010406@free.fr>
	<00bf01c95402$ae3c6070$0ab52150$@co.uk>
In-Reply-To: <00bf01c95402$ae3c6070$0ab52150$@co.uk>
Content-Type: multipart/mixed; boundary="------------010804020805070807090600"
Cc: video4linux-list@redhat.com
Subject: Re: Hauppauge WinTV USB Model 566 PAL-I
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

This is a multi-part message in MIME format.
--------------010804020805070807090600
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit

Chris Grove a écrit :
> -----Original Message-----
> From: Thierry Merle [mailto:thierry.merle@free.fr] 
> Sent: 01 December 2008 21:06
> To: Chris Grove
> Subject: Re: Hauppauge WinTV USB Model 566 PAL-I
> 
> Chris Grove wrote:
>> -----Original Message-----
>> From: Thierry Merle [mailto:thierry.merle@free.fr]
>> Sent: 30 November 2008 21:13
>> To: Chris Grove
>> Cc: video4linux-list@redhat.com
>> Subject: Re: Hauppauge WinTV USB Model 566 PAL-I
>>
>> Chris Grove wrote:
>>> A further, slightly interesting development is that the s-video input 
>>> works fine with no interference at all, also the TV picture in fine 
>>> in
>> windows.
>>> Just thought that might help with a solution.
>>>
>> Right, this helps. We can deduce this does not come from the 
>> decompression algorithm since it is the same whether the TV input or 
>> the s-video input is selected.
>> I suspect a tda9887/saa7113 interface problem but just my intuition.
>> As it works under windows, can you do an usbsnoop
>> (http://www.linuxtv.org/v4lwiki/index.php/Usbsnoop)
>> Just open the TV application, let it tune the channel and stop the 
>> application immediately in order to have a minimal capture file.
>>
>> For the audio over USB, in the ancient times I developed a audio 
>> extension for usbvision. I don't even know what I did from it. I can 
>> look for it if you want. I will need to sweep the dust (compilation 
>> errors and so on) but should work.
>>
>> P.S.: this thread is really hard to follow now... please reply under 
>> my answer so that we will be able to read that again :)
>>
>> Hi, yea sorry about that, Outlook always starts at the top of the message.
>> Anyway, I've used USB Snoop and ended up with a 45Mb file. Now I'm 
>> guessing you don't need all of it so there is a portion of it below my 
>> answer. As for the audio-over-usb, yes please, I wouldn't mind a look 
>> at the code if you can find it. Anyway here's that sample, Thanks for the
> help.
> I found the audio-over-usb code (see attached). The code may need some
> cleanups and can cause kernel oops.
> The USB snoops need to be analyzed. Can you put it on a site so that I can
> download it?
> Nevertheless you can read what I wrote when I was programming the
> audio-over-usb driver here:
> http://thierry.merle.free.fr/articles.php?lng=en&pg=82
> The page was translated to English using google translate so there may be
> some problems of understanding :) For some more information about the
> usbvision chip, I wrote a page here:
> http://thierry.merle.free.fr/articles.php?lng=en&pg=68
> 
> As a first step, I will look at the register accesses. They begin with a
> line like this:
> 00000000: 00000000: 42 33 00 00
> With the datasheet I can understand what the windows driver is setting.
> 
> [SNIP]
> 
>> -- URB_FUNCTION_CONTROL_TRANSFER:
>>   PipeHandle           = 8ac23cfc [endpoint 0x00000001]
>>   TransferFlags        = 00000000 (USBD_TRANSFER_DIRECTION_OUT,
>> ~USBD_SHORT_TRANSFER_OK)
>>   TransferBufferLength = 00000001
>>   TransferBuffer       = a1745938
>>   TransferBufferMDL    = 00000000
>>     00000000: 30
>>   UrbLink              = 00000000
>>   SetupPacket          =
>>     00000000: 42 33 00 00 07 00 01 00
> For example here you have a register programming #07 (SER_MODE from the
> NT1004 datasheet).
> Value is 0x30 (TransferBufferMDL line). Means MODE=3.
> This is just for the example, this one is not interesting.
> There are other registers more interesting but I should have the complete
> log to find out.
> 
> You may have sent me the sufficient data to investigate but in doubt give me
> the complete logs.
> Of course you can look at the problem if you are interested.
> 
> Thanks
> Thierry
> 
> Hi Thierry, Thanks for the links to you code, I'll download it and have a
> look. Here's hoping I can work out what's going on in it. I've uploaded the
> whole of the log to my skydrive, the link is below. 
> http://cid-19380f9184511dde.skydrive.live.com/browse.aspx/Public
> To be honest I'm only a learner when it comes to linux and c++ programming,
> I'm more of a basic programmer so I need all the help I can get my hands on.
> Thanks in advance for all your help. Chris. 
> 
> 
Sorry I forgot to attach the patch of audio-over-usb :)
It applies on the v4l-dvb tree and creates an optional module for audio.
Thierry

--------------010804020805070807090600
Content-Type: text/plain;
 name="audio-over-usb.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="audio-over-usb.patch"

# HG changeset patch
# User tmerle@lugdush.houroukhai.org
# Date 1187638538 -7200
# Node ID 543ee2df05e084be0142b9b290807a4d6c1eba59
# Parent  b2e361a866a551424a7a71772347f2c1ca9990bd
usbvision: audio over USB

From: Thierry Merle <thierry.merle@free.fr>

This enables the audio over USB for usbvision that are capable to transmit
the audio data over the USB cable, to get rid of the line-in audio cable.
The quality is poor (16KHz stereo) compared to the line-in audio (44KHz stereo).

Signed-off-by: Thierry Merle <thierry.merle@free.fr>

diff -r b2e361a866a5 -r 543ee2df05e0 linux/drivers/media/video/usbvision/Kconfig
--- a/linux/drivers/media/video/usbvision/Kconfig	Mon Jun 18 22:09:25 2007 +0200
+++ b/linux/drivers/media/video/usbvision/Kconfig	Mon Aug 20 21:35:38 2007 +0200
@@ -10,3 +10,13 @@ config VIDEO_USBVISION
 
 	  To compile this driver as a module, choose M here: the
 	  module will be called usbvision.
+
+config VIDEO_USBVISION_AUDIO
+	tristate "Audio support for USB video devices based on Nogatech NT1003/1004/1005"
+	depends on USB && I2C
+	select VIDEO_USBVISION
+	---help---
+	  This is an audio driver for usbvision based usb video devices.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called usbvision-audio.
diff -r b2e361a866a5 -r 543ee2df05e0 linux/drivers/media/video/usbvision/Makefile
--- a/linux/drivers/media/video/usbvision/Makefile	Mon Jun 18 22:09:25 2007 +0200
+++ b/linux/drivers/media/video/usbvision/Makefile	Mon Aug 20 21:35:38 2007 +0200
@@ -1,5 +1,6 @@ usbvision-objs  := usbvision-core.o usbv
 usbvision-objs  := usbvision-core.o usbvision-video.o usbvision-i2c.o usbvision-cards.o
 
 obj-$(CONFIG_VIDEO_USBVISION) += usbvision.o
+obj-$(CONFIG_VIDEO_USBVISION_AUDIO) += usbvision-audio.o
 
 EXTRA_CFLAGS += -Idrivers/media/video
diff -r b2e361a866a5 -r 543ee2df05e0 linux/drivers/media/video/usbvision/usbvision-audio.c
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/linux/drivers/media/video/usbvision/usbvision-audio.c	Mon Aug 20 21:35:38 2007 +0200
@@ -0,0 +1,450 @@
+/*
+ *  Nogatech usbvision NT100x audio extension
+ *
+ *  Copyright (c) 2007 Thierry Merle <thierry.merle@free.fr>
+ *           parameters taken from a patch from Hal Finkel.
+ *
+ *  This driver is based on Markus Rechberger's em28xx-audio driver
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; either version 2 of the License, or
+ *  (at your option) any later version.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; if not, write to the Free Software
+ *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+
+#include <linux/kernel.h>
+#include <linux/usb.h>
+#include <linux/init.h>
+#include <linux/sound.h>
+#include <linux/spinlock.h>
+#include <linux/soundcard.h>
+#include <linux/slab.h>
+#include <linux/vmalloc.h>
+#include <linux/proc_fs.h>
+#include <linux/moduleparam.h>
+
+#include <sound/driver.h>
+#include <sound/core.h>
+#include <sound/pcm.h>
+#include <sound/pcm_params.h>
+#include <sound/info.h>
+#include <sound/initval.h>
+#include <sound/control.h>
+#include "usbvision.h"
+
+static int index[SNDRV_CARDS] = SNDRV_DEFAULT_IDX;
+static int usbvision_cmd(struct usb_usbvision *dev, int cmd,int arg);
+
+#if LINUX_VERSION_CODE <= KERNEL_VERSION(2,6,16)
+static int snd_pcm_alloc_vmalloc_buffer(snd_pcm_substream_t *subs, size_t size)
+#else
+static int snd_pcm_alloc_vmalloc_buffer(struct snd_pcm_substream *subs, size_t size)
+#endif
+{
+#if LINUX_VERSION_CODE <= KERNEL_VERSION(2,6,16)
+	snd_pcm_runtime_t *runtime = subs->runtime;
+#else
+	struct snd_pcm_runtime *runtime = subs->runtime;
+#endif
+	if(runtime->dma_area){
+		if(runtime->dma_bytes > size)
+			return 0;
+		vfree(runtime->dma_area);
+	}
+	runtime->dma_area = vmalloc(size);
+	if(!runtime ->dma_area)
+		return -ENOMEM;
+	runtime->dma_bytes = size;
+	return 0;
+}
+
+#if LINUX_VERSION_CODE <= KERNEL_VERSION(2,6,16)
+static snd_pcm_hardware_t snd_usbvision_hw_capture = {
+#else
+static struct snd_pcm_hardware snd_usbvision_hw_capture = {
+#endif
+	.info = SNDRV_PCM_INFO_BLOCK_TRANSFER | SNDRV_PCM_INFO_MMAP | SNDRV_PCM_INFO_INTERLEAVED  | SNDRV_PCM_INFO_MMAP_VALID,
+	.formats = SNDRV_PCM_FMTBIT_U8|SNDRV_PCM_FMTBIT_U16_LE,
+	.rates = SNDRV_PCM_RATE_8000 | SNDRV_PCM_RATE_16000,
+	.rate_min = 8000,
+	.rate_max = 16000,
+	.channels_min = 1,
+	.channels_max = 2,
+	.buffer_bytes_max = 62720,
+	.period_bytes_min = 12544,
+	.period_bytes_max = 12544,
+	.periods_min = 2,
+	.periods_max = 12544,
+};
+
+
+#if LINUX_VERSION_CODE <= KERNEL_VERSION(2,6,16)
+static int snd_usbvision_capture_open(snd_pcm_substream_t *substream)
+#else
+static int snd_usbvision_capture_open(struct snd_pcm_substream *substream)
+#endif
+{
+	struct usb_usbvision *dev = snd_pcm_substream_chip(substream);
+#if LINUX_VERSION_CODE <= KERNEL_VERSION(2,6,16)
+	snd_pcm_runtime_t *runtime = substream->runtime;
+#else
+	struct snd_pcm_runtime *runtime = substream->runtime;
+#endif
+	runtime->hw = snd_usbvision_hw_capture;
+	snd_pcm_hw_constraint_integer(runtime, SNDRV_PCM_HW_PARAM_PERIODS);
+	dev->adev->capture_pcm_substream = substream;
+	runtime->private_data = dev;
+	return 0;
+}
+
+#if LINUX_VERSION_CODE <= KERNEL_VERSION(2,6,16)
+static int snd_usbvision_pcm_close(snd_pcm_substream_t *substream)
+#else
+static int snd_usbvision_pcm_close(struct snd_pcm_substream *substream)
+#endif
+{
+	return 0;
+}
+
+#if LINUX_VERSION_CODE <= KERNEL_VERSION(2,6,16)
+static int snd_usbvision_hw_capture_params(snd_pcm_substream_t *substream, snd_pcm_hw_params_t *hw_params)
+#else
+static int snd_usbvision_hw_capture_params(struct snd_pcm_substream *substream, struct snd_pcm_hw_params *hw_params)
+#endif
+{
+	unsigned int channels, rate, format;
+	int ret;
+	ret = snd_pcm_alloc_vmalloc_buffer(substream, params_buffer_bytes(hw_params));
+	format = params_format(hw_params);
+	rate = params_rate(hw_params);
+	channels = params_channels(hw_params);
+	/* TODO: set up usbvision audio chip to deliver the correct audio format, current default is 48000hz multiplexed => 96000hz mono
+	   which shouldn't matter since analogue TV only supports mono*/
+	return 0;
+}
+
+#if LINUX_VERSION_CODE <= KERNEL_VERSION(2,6,16)
+static int snd_usbvision_hw_capture_free(snd_pcm_substream_t *substream)
+#else
+static int snd_usbvision_hw_capture_free(struct snd_pcm_substream *substream)
+#endif
+{
+	struct usb_usbvision *dev = snd_pcm_substream_chip(substream);
+	if(dev->adev->capture_stream==Stream_On){
+		dev->adev->users--;
+		usbvision_cmd(dev,USBVISION_CAPTURE_STREAM_EN,0);
+	}
+	return 0;
+}
+
+#if LINUX_VERSION_CODE <= KERNEL_VERSION(2,6,16)
+static int snd_usbvision_prepare(snd_pcm_substream_t *substream)
+#else
+static int snd_usbvision_prepare(struct snd_pcm_substream *substream)
+#endif
+{
+	return 0;
+}
+
+#if LINUX_VERSION_CODE <= KERNEL_VERSION(2,6,16)
+static int snd_usbvision_capture_trigger(snd_pcm_substream_t *substream, int cmd)
+#else
+static int snd_usbvision_capture_trigger(struct snd_pcm_substream *substream, int cmd)
+#endif
+{
+	struct usb_usbvision *dev = snd_pcm_substream_chip(substream);
+	switch(cmd){
+		case SNDRV_PCM_TRIGGER_START:
+			usbvision_cmd(dev,USBVISION_CAPTURE_STREAM_EN,1);
+			return 0;
+		case SNDRV_PCM_TRIGGER_STOP:
+			return 0;
+		default:
+			return -EINVAL;
+	}
+}
+
+#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,0) || LINUX_VERSION_CODE > KERNEL_VERSION(2,6,18)
+static void usbvision_audio_isocirq(struct urb *urb)
+{
+#else
+static void usbvision_audio_isocirq(struct urb *urb, struct pt_regs *regs)
+{
+#endif
+	struct usb_usbvision *dev=urb->context;
+	int i;
+	unsigned int oldptr;
+	unsigned long flags;
+	int period_elapsed = 0;
+	int status;
+	unsigned char *cp;
+	unsigned int stride;
+#if LINUX_VERSION_CODE <= KERNEL_VERSION(2,6,16)
+	snd_pcm_substream_t *substream;
+	snd_pcm_runtime_t *runtime;
+#else
+	struct snd_pcm_substream *substream;
+	struct snd_pcm_runtime *runtime;
+#endif
+	if(dev->adev->capture_pcm_substream){
+		substream=dev->adev->capture_pcm_substream;
+		runtime=substream->runtime;
+
+		stride = runtime->frame_bits >> 3;
+		for(i=0;i<urb->number_of_packets;i++){
+			int length=urb->iso_frame_desc[i].actual_length/stride;
+			cp=(unsigned char *) urb->transfer_buffer + urb->iso_frame_desc[i].offset;
+
+			if(!length)
+				continue;
+
+			spin_lock_irqsave(&dev->adev->slock, flags);
+			oldptr = dev->adev->hwptr_done_capture;
+			dev->adev->hwptr_done_capture +=length;
+			if(dev->adev->hwptr_done_capture >= runtime->buffer_size)
+				dev->adev->hwptr_done_capture -= runtime->buffer_size;
+
+			dev->adev->capture_transfer_done += length;
+			if(dev->adev->capture_transfer_done >= runtime->period_size){
+				dev->adev->capture_transfer_done -= runtime->period_size;
+				period_elapsed=1;
+			}
+			spin_unlock_irqrestore(&dev->adev->slock, flags);
+
+			if(oldptr + length >= runtime->buffer_size){
+				unsigned int cnt = runtime->buffer_size-oldptr-1;
+				memcpy(runtime->dma_area+oldptr*stride, cp , cnt*stride);
+				memcpy(runtime->dma_area, cp + cnt, length*stride - cnt*stride);
+			} else {
+				memcpy(runtime->dma_area+oldptr*stride, cp, length*stride);
+			}
+		}
+		if(period_elapsed){
+			snd_pcm_period_elapsed(substream);
+		}
+	}
+	urb->status = 0;
+	if((status = usb_submit_urb(urb, GFP_ATOMIC))){
+		err("%s: resubmit of audio urb failed (error=%i)\n", __FUNCTION__, status);
+	}
+	return;
+}
+
+static int usbvision_isoc_audio_deinit(struct usb_usbvision *dev)
+{
+	int i;
+	for(i=0;i<USBVISION_AUDIO_BUFS;i++){
+		usb_kill_urb(dev->adev->urb[i]);
+		usb_free_urb(dev->adev->urb[i]);
+		dev->adev->urb[i]=NULL;
+	}
+	return 0;
+}
+
+static int usbvision_init_audio_isoc(struct usb_usbvision *dev){
+	int i;
+	int errCode;
+	const int sb_size=USBVISION_NUM_AUDIO_PACKETS * USBVISION_AUDIO_MAX_PACKET_SIZE;
+	for(i=0;i<USBVISION_AUDIO_BUFS;i++){
+		struct urb *urb;
+		int j,k;
+		dev->adev->transfer_buffer[i]=kmalloc(sb_size,GFP_ATOMIC);
+		if(!dev->adev->transfer_buffer[i]){
+			return -ENOMEM;
+		}
+		memset(dev->adev->transfer_buffer[i],0x80,sb_size);
+		urb = usb_alloc_urb(USBVISION_NUM_AUDIO_PACKETS,GFP_ATOMIC);
+		if(urb){
+			urb->dev=dev->dev;
+			urb->context=dev;
+			urb->pipe=usb_rcvisocpipe(dev->dev,0x83);
+			urb->transfer_flags = URB_ISO_ASAP;
+			urb->transfer_buffer = dev->adev->transfer_buffer[i];
+			urb->interval=1;
+			urb->complete = usbvision_audio_isocirq;
+			urb->number_of_packets = USBVISION_NUM_AUDIO_PACKETS;
+			urb->transfer_buffer_length = sb_size;
+			for(j=k=0; j<USBVISION_NUM_AUDIO_PACKETS;j++,k+=USBVISION_AUDIO_MAX_PACKET_SIZE){
+				urb->iso_frame_desc[j].offset = k;
+				urb->iso_frame_desc[j].length=USBVISION_AUDIO_MAX_PACKET_SIZE;
+			}
+			dev->adev->urb[i]=urb;
+		} else {
+			return -ENOMEM;
+		}
+	}
+	for(i=0;i<USBVISION_AUDIO_BUFS;i++){
+		errCode = usb_submit_urb(dev->adev->urb[i], GFP_ATOMIC);
+		if (errCode){
+			usbvision_isoc_audio_deinit(dev);
+			return errCode;
+		}
+	}
+	return 0;
+}
+
+
+static int usbvision_cmd(struct usb_usbvision *dev, int cmd,int arg){
+	switch(cmd){
+		case USBVISION_CAPTURE_STREAM_EN:
+			if(dev->adev->capture_stream == Stream_Off && arg==1){
+				dev->adev->users++;
+				dev->adev->capture_stream=Stream_On;
+				usbvision_init_audio_isoc(dev);
+			} else if (dev->adev->capture_stream==Stream_On && arg==0){
+				dev->adev->capture_stream=Stream_Off;
+				usbvision_isoc_audio_deinit(dev);
+			} else {
+				printk("An underrun occured very likely... ignoring it\n");
+			}
+			return 0;
+		default:
+			return -EINVAL;
+	}
+}
+
+
+#if LINUX_VERSION_CODE <= KERNEL_VERSION(2,6,16)
+static snd_pcm_uframes_t snd_usbvision_capture_pointer(snd_pcm_substream_t *substream)
+#else
+static snd_pcm_uframes_t snd_usbvision_capture_pointer(struct snd_pcm_substream *substream)
+#endif
+{
+	struct usb_usbvision *dev;
+	snd_pcm_uframes_t hwptr_done;
+	dev = snd_pcm_substream_chip(substream);
+	hwptr_done = dev->adev->hwptr_done_capture;
+	return hwptr_done;
+}
+
+#if LINUX_VERSION_CODE <= KERNEL_VERSION(2,6,16)
+static struct page *snd_pcm_get_vmalloc_page(snd_pcm_substream_t *subs,
+					     unsigned long offset)
+#else
+static struct page *snd_pcm_get_vmalloc_page(struct snd_pcm_substream *subs,
+					     unsigned long offset)
+#endif
+{
+	void *pageptr = subs->runtime->dma_area + offset;
+	return vmalloc_to_page(pageptr);
+}
+
+
+#if LINUX_VERSION_CODE <= KERNEL_VERSION(2,6,16)
+static snd_pcm_ops_t snd_usbvision_pcm_capture = {
+#else
+static struct snd_pcm_ops snd_usbvision_pcm_capture = {
+#endif
+	.open = snd_usbvision_capture_open,
+	.close = snd_usbvision_pcm_close,
+	.ioctl = snd_pcm_lib_ioctl,
+	.hw_params = snd_usbvision_hw_capture_params,
+	.hw_free = snd_usbvision_hw_capture_free,
+	.prepare = snd_usbvision_prepare,
+	.trigger = snd_usbvision_capture_trigger,
+	.pointer = snd_usbvision_capture_pointer,
+	.page = snd_pcm_get_vmalloc_page,
+};
+
+
+static int usbvision_audio_init(struct usb_usbvision *dev){
+	struct usbvision_audio *adev;
+#if LINUX_VERSION_CODE <= KERNEL_VERSION(2,6,16)
+	snd_pcm_t *pcm;
+	snd_card_t *card;
+#else
+	struct snd_pcm *pcm;
+	struct snd_card *card;
+#endif
+	static int devnr;
+	int ret;
+	int err;
+	printk("usbvision-audio.c: probing for usbvision audio for usb\n");
+	printk("usbvision-audio.c: Copyright (C) 2006 Markus Rechberger\n");
+	adev=kzalloc(sizeof(*adev),GFP_KERNEL);
+	if(!adev){
+		printk("usbvision-audio.c: out of memory\n");
+		return -1;
+	}
+	card = snd_card_new(index[devnr], "Usbvision Audio", THIS_MODULE,0);
+	if(card==NULL){
+		kfree(adev);
+		return -ENOMEM;
+	}
+
+	spin_lock_init(&adev->slock);
+	ret=snd_pcm_new(card, "Usbvision Audio", 0, 0, 1, &pcm);
+	snd_pcm_set_ops(pcm, SNDRV_PCM_STREAM_CAPTURE, &snd_usbvision_pcm_capture);
+	pcm->info_flags = 0;
+	pcm->private_data = dev;
+	strcpy(pcm->name,"Usbvision Capture");
+	strcpy(card->driver, "Nogatech Usbvision Audio");
+	strcpy(card->shortname, "Usbvision Audio");
+	strcpy(card->longname,"Nogatech Usbvision Audio");
+
+	if((err = snd_card_register(card))<0){
+		snd_card_free(card);
+		return -ENOMEM;
+	}
+	adev->sndcard=card;
+	adev->udev=dev->dev;
+	dev->adev=adev;
+	return 0;
+}
+
+static int usbvision_audio_fini(struct usb_usbvision *dev){
+	if(dev==NULL)
+		return 0;
+	if(dev->adev){
+		snd_card_free(dev->adev->sndcard);
+		kfree(dev->adev);
+		dev->adev=NULL;
+	}
+	return 0;
+}
+
+static struct usbvision_ops audio_ops = {
+	.id	= USBVISION_AUDIO,
+	.name	= "Usbvision Audio Extension",
+	.init	= usbvision_audio_init,
+	.fini	= usbvision_audio_fini,
+};
+
+static int __init usbvision_alsa_register(void)
+{
+	request_module("usbvision");
+	request_module("tuner");
+	return usbvision_register_extension(&audio_ops);
+}
+
+static void __exit usbvision_alsa_unregister(void)
+{
+	usbvision_unregister_extension(&audio_ops);
+}
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Thierry Merle <thierry.merle@free.fr>");
+MODULE_DESCRIPTION("Usbvision Audio driver");
+
+module_init(usbvision_alsa_register);
+module_exit(usbvision_alsa_unregister);
+
+/*
+ * Overrides for Emacs so that we follow Linus's tabbing style.
+ * ---------------------------------------------------------------------------
+ * Local variables:
+ * c-basic-offset: 8
+ * End:
+ */
diff -r b2e361a866a5 -r 543ee2df05e0 linux/drivers/media/video/usbvision/usbvision-core.c
--- a/linux/drivers/media/video/usbvision/usbvision-core.c	Mon Jun 18 22:09:25 2007 +0200
+++ b/linux/drivers/media/video/usbvision/usbvision-core.c	Mon Aug 20 21:35:38 2007 +0200
@@ -2706,6 +2706,9 @@ int usbvision_muxsel(struct usb_usbvisio
 	return 0;
 }
 
+
+EXPORT_SYMBOL(usbvision_write_reg);
+
 /*
  * Overrides for Emacs so that we follow Linus's tabbing style.
  * ---------------------------------------------------------------------------
diff -r b2e361a866a5 -r 543ee2df05e0 linux/drivers/media/video/usbvision/usbvision-video.c
--- a/linux/drivers/media/video/usbvision/usbvision-video.c	Mon Jun 18 22:09:25 2007 +0200
+++ b/linux/drivers/media/video/usbvision/usbvision-video.c	Mon Aug 20 21:35:38 2007 +0200
@@ -101,6 +101,11 @@ USBVISION_DRIVER_VERSION_PATCHLEVEL)
  "." __stringify(USBVISION_DRIVER_VERSION_MINOR)\
  "." __stringify(USBVISION_DRIVER_VERSION_PATCHLEVEL)
 
+/* Extension management stuff */
+static LIST_HEAD(usbvision_extension_devlist);
+static DEFINE_MUTEX(usbvision_extension_devlist_lock);
+static struct usb_usbvision *usbvisionDevice = NULL;
+
 #define	ENABLE_HEXDUMP	0	/* Enable if you need it */
 
 
@@ -138,6 +143,8 @@ static struct usbvision_v4l2_format_st u
 
 /* Function prototypes */
 static void usbvision_release(struct usb_usbvision *usbvision);
+static void usbvision_init_extensions(struct usb_usbvision *usbvision);
+static void usbvision_fini_extensions(struct usb_usbvision *usbvision);
 
 /* Default initalization of device driver parameters */
 /* Set the default format for ISOC endpoint */
@@ -1789,6 +1796,7 @@ static struct usb_usbvision *usbvision_a
 	}
 #endif
 
+	usbvisionDevice = usbvision;
 	usbvision->dev = dev;
 
 	init_MUTEX(&usbvision->lock);	/* to 1 == available */
@@ -1846,6 +1854,7 @@ static void usbvision_release(struct usb
 	}
 
 	kfree(usbvision);
+	usbvisionDevice = NULL;
 
 	PDEBUG(DBG_PROBE, "success");
 }
@@ -1898,6 +1907,7 @@ static int __devinit usbvision_probe(str
 	struct usb_device *dev = usb_get_dev(interface_to_usbdev(intf));
 	struct usb_interface *uif;
 	__u8 ifnum = intf->altsetting->desc.bInterfaceNumber;
+	__u8 numEndpoints = intf->altsetting->desc.bNumEndpoints;
 	const struct usb_host_interface *interface;
 	struct usb_usbvision *usbvision = NULL;
 	const struct usb_endpoint_descriptor *endpoint;
@@ -1921,6 +1931,7 @@ static int __devinit usbvision_probe(str
 		interface = &dev->actconfig->interface[ifnum]->altsetting[0];
 	}
 	endpoint = &interface->endpoint[1].desc;
+
 	if ((endpoint->bmAttributes & USB_ENDPOINT_XFERTYPE_MASK) !=
 	    USB_ENDPOINT_XFER_ISOC) {
 		err("%s: interface %d. has non-ISO endpoint!",
@@ -1941,6 +1952,8 @@ static int __devinit usbvision_probe(str
 		return -ENOMEM;
 	}
 
+	usbvision->video_endp = endpoint->bEndpointAddress;
+
 	if (dev->descriptor.bNumConfigurations > 1) {
 		usbvision->bridgeType = BRIDGE_NT1004;
 	} else if (model == DAZZLE_DVC_90_REV_1_SECAM) {
@@ -1987,13 +2000,13 @@ static int __devinit usbvision_probe(str
 	usbvision->remove_pending = 0;
 	usbvision->iface = ifnum;
 	usbvision->ifaceAlt = 0;
-	usbvision->video_endp = endpoint->bEndpointAddress;
 	usbvision->isocPacketSize = 0;
 	usbvision->usb_bandwidth = 0;
 	usbvision->user = 0;
 	usbvision->streaming = Stream_Off;
 	usbvision_register_video(usbvision);
 	usbvision_configure_video(usbvision);
+	usbvision_init_extensions(usbvision);
 	up(&usbvision->lock);
 
 
@@ -2044,6 +2057,8 @@ static void __devexit usbvision_disconne
 
 	// At this time we ask to cancel outstanding URBs
 	usbvision_stop_isoc(usbvision);
+
+	usbvision_fini_extensions(usbvision);
 
 	if (usbvision->power) {
 		usbvision_i2c_unregister(usbvision);
@@ -2074,6 +2089,66 @@ static void __devexit usbvision_disconne
 #endif
 }
 
+static void usbvision_init_extensions(struct usb_usbvision *usbvision)
+{
+	struct list_head *pos=NULL;
+	struct usbvision_ops *ops=NULL;
+
+	PDEBUG(DBG_PROBE, "Initialize extensions");
+
+	mutex_lock(&usbvision_extension_devlist_lock);
+	if(!list_empty(&usbvision_extension_devlist)){
+		list_for_each(pos, &usbvision_extension_devlist){
+			ops=list_entry(pos,struct usbvision_ops, next);
+			ops->init(usbvision);
+		}
+	}
+	mutex_unlock(&usbvision_extension_devlist_lock);
+}
+
+static void usbvision_fini_extensions(struct usb_usbvision *usbvision)
+{
+	struct list_head *pos=NULL;
+	struct usbvision_ops *ops=NULL;
+
+	PDEBUG(DBG_PROBE, "Propagate the uninit to extensions");
+
+	mutex_lock(&usbvision_extension_devlist_lock);
+	if(!list_empty(&usbvision_extension_devlist)){
+		list_for_each(pos, &usbvision_extension_devlist){
+			ops=list_entry(pos,struct usbvision_ops, next);
+			ops->fini(usbvision);
+		}
+	}
+	mutex_unlock(&usbvision_extension_devlist_lock);
+}
+
+int usbvision_register_extension(struct usbvision_ops *ops)
+{
+	mutex_lock(&usbvision_extension_devlist_lock);
+	list_add_tail(&ops->next,&usbvision_extension_devlist);
+	printk("Usbvision: Added (%s) extension\n",ops->name);
+	if(usbvisionDevice) {
+		if(ops->init(usbvisionDevice)<0) {
+			printk("usbvision: error on init of (%s) extension\n",ops->name);
+		}
+		else printk("Usbvision: Initialized (%s) extension\n",ops->name);
+	}
+	mutex_unlock(&usbvision_extension_devlist_lock);
+	return 0;
+}
+
+void usbvision_unregister_extension(struct usbvision_ops *ops)
+{
+	mutex_lock(&usbvision_extension_devlist_lock);
+	printk("Usbvision: Removed (%s) extension\n",ops->name);
+	list_del(&ops->next);
+	if(usbvisionDevice)
+		ops->fini(usbvisionDevice);
+	mutex_unlock(&usbvision_extension_devlist_lock);
+	printk("Usbvision: Removed (%s) extension\n",ops->name);
+}
+
 static struct usb_driver usbvision_driver = {
 #if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,31)) && \
  (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,16))
@@ -2127,6 +2202,8 @@ static void __exit usbvision_exit(void)
 
 module_init(usbvision_init);
 module_exit(usbvision_exit);
+EXPORT_SYMBOL(usbvision_register_extension);
+EXPORT_SYMBOL(usbvision_unregister_extension);
 
 /*
  * Overrides for Emacs so that we follow Linus's tabbing style.
diff -r b2e361a866a5 -r 543ee2df05e0 linux/drivers/media/video/usbvision/usbvision.h
--- a/linux/drivers/media/video/usbvision/usbvision.h	Mon Jun 18 22:09:25 2007 +0200
+++ b/linux/drivers/media/video/usbvision/usbvision.h	Mon Aug 20 21:35:38 2007 +0200
@@ -37,12 +37,22 @@
 #include <media/v4l2-common.h>
 #include <media/tuner.h>
 #include <linux/videodev2.h>
+/* ALSA stuff */
+#include <linux/soundcard.h>
+#include <sound/driver.h>
+#include <sound/core.h>
+#include <sound/pcm.h>
+#include <sound/pcm_params.h>
 
 #define USBVISION_DEBUG		/* Turn on debug messages */
 
 #ifndef VID_HARDWARE_USBVISION
 	#define VID_HARDWARE_USBVISION 34   /* USBVision Video Grabber */
 #endif
+
+#define USBVISION_VIDEO   0x01
+#define USBVISION_VBI     0x02
+#define USBVISION_AUDIO   0x04
 
 #define USBVISION_PWR_REG		0x00
 	#define USBVISION_SSPND_EN		(1 << 1)
@@ -122,6 +132,19 @@
 #define USBVISION_BUF_THR		0x30
 #define USBVISION_DVI_YUV		0x31
 #define USBVISION_AUDIO_CONT		0x32
+	#define USBVISION_AUDIO_EN	(1 << 0)
+	#define USBVISION_BULK_EN	(1 << 1)
+	#define USBVISION_AUDIO_8B	(0 << 2)
+	#define USBVISION_AUDIO_12B	(1 << 2)
+	#define USBVISION_AUDIO_14B	(2 << 2)
+	#define USBVISION_AUDIO_16B	(3 << 2)
+	#define USBVISION_AUDIO_MONO	(0 << 4)
+	#define USBVISION_AUDIO_STEREO	(1 << 4)
+	#define USBVISION_SAMP_8K	(0 << 5)
+	#define USBVISION_SAMP_16K	(1 << 5)
+	#define USBVISION_BITCLOCK_64	(1 << 6)
+	#define USBVISION_BITCLOCK_1644	(2 << 6)
+	#define USBVISION_BITCLOCK_2048	(3 << 6)
 #define USBVISION_AUD_PK_LEN		0x33
 #define USBVISION_BLK_PK_LEN		0x34
 #define USBVISION_PCM_THR1		0x38
@@ -150,6 +173,12 @@
 #define USBVISION_NUM_HEADERMARKER	20
 #define USBVISION_NUMFRAMES		3  /* Maximum number of frames an application can get */
 #define USBVISION_NUMSBUF		2 /* Dimensioning the USB S buffering */
+
+/* usbvision sound stuff */
+#define USBVISION_AUDIO_BUFS 5
+#define USBVISION_NUM_AUDIO_PACKETS 32
+#define USBVISION_AUDIO_MAX_PACKET_SIZE 66 /* static value */
+#define USBVISION_CAPTURE_STREAM_EN 1
 
 #define USBVISION_POWEROFF_TIME		3 * (HZ)		// 3 seconds
 
@@ -355,6 +384,34 @@ struct usbvision_device_data_st {
 	__s16 Y_Offset;
 };
 
+struct usbvision_audio {
+	char name[50];
+	char *transfer_buffer[USBVISION_AUDIO_BUFS];
+	struct urb *urb[USBVISION_AUDIO_BUFS];
+	struct usb_device *udev;
+	unsigned int capture_transfer_done; /* byte amount of acquired data (in bytes) */
+#if LINUX_VERSION_CODE <= KERNEL_VERSION(2,6,16)
+	snd_pcm_substream_t        *capture_pcm_substream;
+#else
+	struct snd_pcm_substream   *capture_pcm_substream;
+#endif
+	unsigned int hwptr_done_capture; /* pointer to the beginning of a new period available (in bytes) */
+#if LINUX_VERSION_CODE <= KERNEL_VERSION(2,6,16)
+	snd_card_t                 *sndcard;
+#else
+	struct snd_card            *sndcard;
+#endif
+	int users;
+	enum StreamState capture_stream;
+	/* low-level register parameters stuff */
+	unsigned char channels;
+	unsigned char samp_rate;
+	unsigned char bits_per_sample;
+	unsigned char bit_clk_freq;
+
+	spinlock_t slock;
+};
+
 /* Declared on usbvision-cards.c */
 extern struct usbvision_device_data_st usbvision_device_data[];
 extern struct usb_device_id usbvision_table[];
@@ -363,6 +420,7 @@ struct usb_usbvision {
 	struct video_device *vdev;         				/* Video Device */
 	struct video_device *rdev;               			/* Radio Device */
 	struct video_device *vbi; 					/* VBI Device   */
+	struct usbvision_audio *adev;					/* Audio over USB */
 
 	/* i2c Declaration Section*/
 	struct i2c_adapter i2c_adap;
@@ -440,6 +498,7 @@ struct usb_usbvision {
 	unsigned int ctl_input;						/* selected input */
 	v4l2_std_id tvnormId;						/* selected tv norm */
 	unsigned char video_endp;					/* 0x82 for USBVISION devices based */
+	unsigned char audio_endp;					/* 0x83 for USBVISION devices based */
 
 	// Decompression stuff:
 	unsigned char *IntraFrameBuffer;				/* Buffer for reference frame */
@@ -472,6 +531,14 @@ struct usb_usbvision {
 	int ComprBlockTypes[4];
 };
 
+/* usbvision extension management part */
+struct usbvision_ops {
+	struct list_head next;
+	char *name;
+	int id;
+	int (*init)(struct usb_usbvision *);
+	int (*fini)(struct usb_usbvision *);
+};
 
 /* --------------------------------------------------------------- */
 /* defined in usbvision-i2c.c                                      */
@@ -519,6 +586,10 @@ void usbvision_reset_powerOffTimer(struc
 void usbvision_reset_powerOffTimer(struct usb_usbvision *usbvision);
 int usbvision_power_off(struct usb_usbvision *usbvision);
 int usbvision_power_on(struct usb_usbvision *usbvision);
+
+/* defined in usbvision-video.c */
+int usbvision_register_extension(struct usbvision_ops *dev);
+void usbvision_unregister_extension(struct usbvision_ops *dev);
 
 #endif									/* __LINUX_USBVISION_H */
 

--------------010804020805070807090600
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
--------------010804020805070807090600--
