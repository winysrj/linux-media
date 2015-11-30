Return-path: <linux-media-owner@vger.kernel.org>
Received: from zeniv.linux.org.uk ([195.92.253.2]:51399 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751675AbbK3DEd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 29 Nov 2015 22:04:33 -0500
Date: Mon, 30 Nov 2015 03:04:28 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Kukjin Kim <kgene@kernel.org>,
	Krzysztof Kozlowski <k.kozlowski@samsung.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: ->poll() instances shouldn't be indefinitely blocking
Message-ID: <20151130030427.GY22011@ZenIV.linux.org.uk>
References: <20151127050026.GX22011@ZenIV.linux.org.uk>
 <20151127131843.0416fe2b@recife.lan>
 <CA+55aFw-9Y6c-wgiXkyFuce7bqA-RQsRUuW6wC42ayoN4nVo6g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFw-9Y6c-wgiXkyFuce7bqA-RQsRUuW6wC42ayoN4nVo6g@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Nov 27, 2015 at 09:49:11AM -0800, Linus Torvalds wrote:

> Al, what do you think? The whole "generic code should be robust wrt
> drivers making silly mistakes" just sounds like a good idea. Finding
> these things through code inspection is all well and good, but having
> a nice warning report from users might be even better.

FWIW, sparse catches them just fine here.  I don't mind using the MSB
as a canary, but AFAICS that code tends to be rarely hit, so this
kind of runtime warning isn't going to be all that useful.

The current list is:

drivers/media/platform/exynos-gsc/gsc-m2m.c:707:24:    expected restricted __poll_t
drivers/media/platform/exynos-gsc/gsc-m2m.c:707:24:    got int
drivers/media/platform/exynos-gsc/gsc-m2m.c:707:24: warning: incorrect type in return expression (different base types)
--- this one
drivers/media/platform/s3c-camif/camif-capture.c:615:21:    expected restricted __poll_t [usertype] ret
drivers/media/platform/s3c-camif/camif-capture.c:615:21:    got int
drivers/media/platform/s3c-camif/camif-capture.c:615:21: warning: incorrect type in assignment (different base types)
        mutex_lock(&camif->lock);
        if (vp->owner && vp->owner != file->private_data)
                ret = -EBUSY;
        else   
                ret = vb2_poll(&vp->vb_queue, file, wait);
--- not nice
drivers/media/radio/radio-wl1273.c:1092:24:    expected restricted __poll_t
drivers/media/radio/radio-wl1273.c:1092:24:    got int
drivers/media/radio/radio-wl1273.c:1092:24: warning: incorrect type in return expression (different base types)
        struct wl1273_device *radio = video_get_drvdata(video_devdata(file));
        struct wl1273_core *core = radio->core;

        if (radio->owner && radio->owner != file)
                return -EBUSY;

        radio->owner = file;
--- obviously racy, not to mention anything else (that's the very beginning of
->poll() instance)
drivers/staging/rdma/hfi1/diag.c:798:24:    expected restricted __poll_t
drivers/staging/rdma/hfi1/diag.c:798:24:    got int
drivers/staging/rdma/hfi1/diag.c:798:24: warning: incorrect type in return expression (different base types)
        dd = hfi1_dd_from_sc_inode(fp->f_inode);
        if (dd == NULL)
                return -ENODEV;
--- hadn't looked yet
drivers/misc/mei/main.c:668:24:    expected int
drivers/misc/mei/main.c:668:24:    got restricted __poll_t [usertype] <noident>
drivers/misc/mei/main.c:668:24: warning: incorrect type in return expression (different base types)
--- this one is other way round - it's ->fasync() returning POLLERR; the
author told of that one, says it's a cut'n'paste bug.  Hopefully will get
fixed...
drivers/tty/n_r3964.c:1241:24:    expected restricted __poll_t [assigned] [usertype] result
drivers/tty/n_r3964.c:1241:24:    got int
drivers/tty/n_r3964.c:1241:24: warning: incorrect type in assignment (different base types)
        pClient = findClient(pInfo, task_pid(current));
        if (pClient) {
...
        } else {
                result = -EINVAL;
--- maybe it's just me, but this looks utterly bogus.  task_pid(current)?
Really?
drivers/uio/uio.c:497:24:    expected restricted __poll_t
drivers/uio/uio.c:497:24:    got int
drivers/uio/uio.c:497:24: warning: incorrect type in return expression (different base types)
        if (!idev->info->irq)
                return -EIO;
--- bogosity aside, I really don't like the look of the lifetime
rules for the thing idev->info points to in that one.  Looks like
unregistration *can* happen while the sucker's open, and it won't
wait for anything to run down.
kernel/time/posix-clock.c:75:24:    expected restricted __poll_t
kernel/time/posix-clock.c:75:24:    got int
--- that one does deal with unregistration, but (a) returns a bogus
value and (b) does down_read(&clk->rwsem), which might be not nice
in ->poll() instance.
kernel/trace/ring_buffer.c:640:32:    expected restricted __poll_t
kernel/trace/ring_buffer.c:640:32:    got int
kernel/trace/ring_buffer.c:640:32: warning: incorrect type in return expression (different base types)
--- might be racy, in any case the return value is bogus
sound/core/compress_offload.c:381:24:    expected restricted __poll_t
sound/core/compress_offload.c:381:24:    got int
sound/core/compress_offload.c:381:24: warning: incorrect type in return expression (different base types)
sound/core/compress_offload.c:384:24:    expected restricted __poll_t
sound/core/compress_offload.c:384:24:    got int
sound/core/compress_offload.c:384:24: warning: incorrect type in return expression (different base types)
--- a couple of "what do we return after struct file being
stomped upon, because it can't happen in any other way"
sound/core/compress_offload.c:388:24:    expected restricted __poll_t [usertype] retval
sound/core/compress_offload.c:388:24:    got int
sound/core/compress_offload.c:388:24: warning: incorrect type in assignment (different base types)
sound/core/pcm_native.c:3152:24:    expected restricted __poll_t
sound/core/pcm_native.c:3152:24:    got int
sound/core/pcm_native.c:3152:24: warning: incorrect type in return expression (different base types)
sound/core/pcm_native.c:3191:24:    expected restricted __poll_t
sound/core/pcm_native.c:3191:24:    got int
sound/core/pcm_native.c:3191:24: warning: incorrect type in return expression (different base types)
--- not sure, hadn't looked in detail.
sound/core/seq/oss/seq_oss.c:203:24:    expected restricted __poll_t
sound/core/seq/oss/seq_oss.c:203:24:    got int
sound/core/seq/oss/seq_oss.c:203:24: warning: incorrect type in return expression (different base types)
--- impossible to hit without struct file being corrupted
sound/core/seq/seq_clientmgr.c:1102:24:    expected restricted __poll_t
sound/core/seq/seq_clientmgr.c:1102:24:    got int
sound/core/seq/seq_clientmgr.c:1102:24: warning: incorrect type in return expression (different base types)
--- ditto
drivers/gpu/vga/vgaarb.c:1169:24: warning: incorrect type in return expression (different base types)
drivers/gpu/vga/vgaarb.c:1169:24:    expected restricted __poll_t
drivers/gpu/vga/vgaarb.c:1169:24:    got int
--- ditto

That's on amd64/allmodconfig build with the annotations I'd done for
->poll().  They also have caught a couple of dubious places in net/9p,
still looking in there.  FWIW, the typical impact of annotations on a
driver is something like
@@ -2155,11 +2155,11 @@ pmu_write(struct file *file, const char __user *buf,
        return 0;
 }
 
-static unsigned int
+static __poll_t
 pmu_fpoll(struct file *filp, poll_table *wait)
 {
        struct pmu_private *pp = filp->private_data;
-       unsigned int mask = 0;
+       __poll_t mask = 0;
        unsigned long flags;
        
        if (pp == 0)

IOW, not really intrusive.  make C=2 CF="-D__CHECK_ENDIAN -D__CHECK_POLL__"
right now, might as well make poll annotations trigger on __CHECK_ENDIAN__
alone - there's not much noise left.  Again, I have no problem with
adding "if the MSB is set, it's probably a broken driver returning -E...
instead of the valid bitmap, let's warn about it", but IMO it's better
dealt with by sparse at build time; bogus values are not returned on
common paths, so the runtime test coverage won't be good.

See vfs.git#work.poll-annotations for the current state of that queue.  The
last commit needs to be split and folded back into the relevant commits
before - the queue was originally done back in March and last week I'd
ported it to current mainline, the last commit being the annotations
in the code that had been added since then.

The current summary follows:
Shortlog:
Al Viro (20):
      switch poll.h to generic-y where possible
      annotate POLL... constants and ->poll() return value
      annotate poll_table_struct->_key and poll_table_entry->key
      annotate wake_..._poll() last argument
      fs: annotate ->poll() instances
      annotate proto_ops ->poll()
      annotate proto_ops ->poll() instances
      net: annotate file_operations ->poll() instances
      kernel: annotate ->poll() instances
      annotate posix clock
      annotate security/
      annotate mm/
      annotate ipc/
      annotate drivers/media and its users
      annotate sound/
      annotate tty
      annotate assorted drivers
      VFS annotations
      annotations around wakeup callbacks
      missing ->poll() annotations [splitme]

Diffstat:
 arch/alpha/include/asm/Kbuild                      |  1 +
 arch/alpha/include/uapi/asm/poll.h                 |  1 -
 arch/blackfin/include/uapi/asm/poll.h              |  4 +--
 arch/cris/arch-v10/drivers/gpio.c                  |  6 ++--
 arch/cris/arch-v10/drivers/sync_serial.c           |  8 ++---
 arch/cris/arch-v32/drivers/sync_serial.c           |  8 ++---
 arch/frv/include/uapi/asm/poll.h                   |  2 +-
 arch/ia64/include/asm/Kbuild                       |  1 +
 arch/ia64/include/uapi/asm/poll.h                  |  1 -
 arch/ia64/kernel/perfmon.c                         |  4 +--
 arch/m32r/include/asm/Kbuild                       |  1 +
 arch/m32r/include/uapi/asm/poll.h                  |  1 -
 arch/m68k/include/uapi/asm/poll.h                  |  2 +-
 arch/microblaze/include/asm/Kbuild                 |  1 +
 arch/microblaze/include/uapi/asm/poll.h            |  1 -
 arch/mips/include/uapi/asm/poll.h                  |  2 +-
 arch/mips/kernel/rtlx.c                            |  4 +--
 arch/mn10300/include/asm/Kbuild                    |  1 +
 arch/mn10300/include/uapi/asm/poll.h               |  1 -
 arch/powerpc/include/asm/Kbuild                    |  1 +
 arch/powerpc/include/uapi/asm/poll.h               |  1 -
 arch/powerpc/kernel/rtasd.c                        |  2 +-
 arch/powerpc/platforms/cell/spufs/file.c           | 16 +++++-----
 arch/powerpc/platforms/powernv/opal-prd.c          |  2 +-
 arch/s390/include/asm/Kbuild                       |  1 +
 arch/s390/include/uapi/asm/poll.h                  |  1 -
 arch/score/include/asm/Kbuild                      |  1 +
 arch/score/include/uapi/asm/poll.h                 |  6 ----
 arch/sparc/include/uapi/asm/poll.h                 |  8 ++---
 arch/um/drivers/hostaudio_kern.c                   |  4 +--
 arch/um/include/asm/Kbuild                         |  1 +
 arch/x86/include/asm/Kbuild                        |  1 +
 arch/x86/include/uapi/asm/poll.h                   |  1 -
 arch/x86/kernel/apm_32.c                           |  2 +-
 arch/x86/kernel/cpu/mcheck/mce.c                   |  2 +-
 arch/xtensa/include/uapi/asm/poll.h                |  4 +--
 block/bsg.c                                        |  4 +--
 crypto/algif_aead.c                                |  4 +--
 crypto/algif_skcipher.c                            |  6 ++--
 drivers/android/binder.c                           |  2 +-
 drivers/bluetooth/hci_ldisc.c                      |  2 +-
 drivers/bluetooth/hci_vhci.c                       |  2 +-
 drivers/char/apm-emulation.c                       |  2 +-
 drivers/char/dtlk.c                                |  6 ++--
 drivers/char/genrtc.c                              |  2 +-
 drivers/char/hpet.c                                |  2 +-
 drivers/char/ipmi/ipmi_devintf.c                   |  4 +--
 drivers/char/ipmi/ipmi_watchdog.c                  |  4 +--
 drivers/char/pcmcia/cm4040_cs.c                    |  4 +--
 drivers/char/ppdev.c                               |  4 +--
 drivers/char/random.c                              |  4 +--
 drivers/char/rtc.c                                 |  4 +--
 drivers/char/snsc.c                                |  4 +--
 drivers/char/sonypi.c                              |  2 +-
 drivers/char/virtio_console.c                      |  4 +--
 drivers/char/xillybus/xillybus_core.c              |  4 +--
 drivers/dma-buf/dma-buf.c                          |  6 ++--
 drivers/firewire/core-cdev.c                       |  4 +--
 drivers/firewire/nosy.c                            |  4 +--
 drivers/gpu/drm/drm_fops.c                         |  4 +--
 drivers/gpu/drm/vmwgfx/vmwgfx_drv.h                |  2 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_ioctl.c              |  2 +-
 drivers/gpu/vga/vgaarb.c                           |  2 +-
 drivers/hid/hid-debug.c                            |  2 +-
 drivers/hid/hid-roccat.c                           |  2 +-
 drivers/hid/hid-sensor-custom.c                    |  4 +--
 drivers/hid/hidraw.c                               |  2 +-
 drivers/hid/uhid.c                                 |  2 +-
 drivers/hid/usbhid/hiddev.c                        |  2 +-
 drivers/hsi/clients/cmt_speech.c                   |  4 +--
 drivers/hv/hv_utils_transport.c                    |  2 +-
 drivers/iio/iio_core.h                             |  2 +-
 drivers/iio/industrialio-buffer.c                  |  2 +-
 drivers/iio/industrialio-event.c                   |  4 +--
 drivers/infiniband/core/ucm.c                      |  4 +--
 drivers/infiniband/core/ucma.c                     |  4 +--
 drivers/infiniband/core/user_mad.c                 |  4 +--
 drivers/infiniband/core/uverbs_main.c              |  4 +--
 drivers/infiniband/hw/qib/qib_file_ops.c           | 14 ++++-----
 drivers/input/evdev.c                              |  4 +--
 drivers/input/input.c                              |  2 +-
 drivers/input/joydev.c                             |  2 +-
 drivers/input/misc/hp_sdc_rtc.c                    |  4 +--
 drivers/input/misc/uinput.c                        |  2 +-
 drivers/input/mousedev.c                           |  4 +--
 drivers/input/serio/serio_raw.c                    |  4 +--
 drivers/input/serio/userio.c                       |  2 +-
 drivers/isdn/capi/capi.c                           |  4 +--
 drivers/isdn/divert/divert_procfs.c                |  4 +--
 drivers/isdn/hardware/eicon/divamnt.c              |  4 +--
 drivers/isdn/hardware/eicon/divasi.c               |  4 +--
 drivers/isdn/hardware/eicon/divasmain.c            |  2 +-
 drivers/isdn/hardware/eicon/divasproc.c            |  2 +-
 drivers/isdn/hysdn/hysdn_proclog.c                 |  4 +--
 drivers/isdn/i4l/isdn_common.c                     |  4 +--
 drivers/isdn/i4l/isdn_ppp.c                        |  4 +--
 drivers/isdn/i4l/isdn_ppp.h                        |  2 +-
 drivers/isdn/mISDN/timerdev.c                      |  4 +--
 drivers/macintosh/smu.c                            |  4 +--
 drivers/macintosh/via-pmu.c                        |  4 +--
 drivers/md/md.c                                    |  4 +--
 drivers/media/common/saa7146/saa7146_fops.c        |  8 ++---
 drivers/media/common/siano/smsdvb-debugfs.c        |  7 ++---
 drivers/media/dvb-core/dmxdev.c                    |  8 ++---
 drivers/media/dvb-core/dvb_ca_en50221.c            |  4 +--
 drivers/media/dvb-core/dvb_frontend.c              |  2 +-
 drivers/media/firewire/firedtv-ci.c                |  2 +-
 drivers/media/media-devnode.c                      |  2 +-
 drivers/media/pci/bt8xx/bttv-driver.c              | 12 ++++----
 drivers/media/pci/cx18/cx18-fileops.c              |  8 ++---
 drivers/media/pci/cx18/cx18-fileops.h              |  2 +-
 drivers/media/pci/ddbridge/ddbridge-core.c         |  4 +--
 drivers/media/pci/ivtv/ivtv-fileops.c              | 10 +++---
 drivers/media/pci/ivtv/ivtv-fileops.h              |  4 +--
 drivers/media/pci/meye/meye.c                      |  4 +--
 drivers/media/pci/saa7134/saa7134-video.c          |  4 +--
 drivers/media/pci/saa7164/saa7164-encoder.c        |  6 ++--
 drivers/media/pci/saa7164/saa7164-vbi.c            |  4 +--
 drivers/media/pci/ttpci/av7110_av.c                |  8 ++---
 drivers/media/pci/ttpci/av7110_ca.c                |  4 +--
 drivers/media/pci/zoran/zoran_driver.c             |  4 +--
 drivers/media/platform/davinci/vpfe_capture.c      |  2 +-
 drivers/media/platform/exynos-gsc/gsc-m2m.c        |  4 +--
 drivers/media/platform/fsl-viu.c                   |  6 ++--
 drivers/media/platform/m2m-deinterlace.c           |  4 +--
 drivers/media/platform/mx2_emmaprp.c               |  4 +--
 drivers/media/platform/omap/omap_vout.c            |  2 +-
 drivers/media/platform/omap3isp/ispvideo.c         |  4 +--
 drivers/media/platform/s3c-camif/camif-capture.c   |  4 +--
 drivers/media/platform/s5p-mfc/s5p_mfc.c           |  4 +--
 drivers/media/platform/s5p-tv/mixer_video.c        |  4 +--
 drivers/media/platform/sh_veu.c                    |  2 +-
 drivers/media/platform/soc_camera/atmel-isi.c      |  2 +-
 drivers/media/platform/soc_camera/mx2_camera.c     |  2 +-
 drivers/media/platform/soc_camera/mx3_camera.c     |  2 +-
 drivers/media/platform/soc_camera/omap1_camera.c   |  2 +-
 drivers/media/platform/soc_camera/pxa_camera.c     |  2 +-
 drivers/media/platform/soc_camera/rcar_vin.c       |  2 +-
 .../platform/soc_camera/sh_mobile_ceu_camera.c     |  2 +-
 drivers/media/platform/soc_camera/soc_camera.c     |  4 +--
 drivers/media/platform/timblogiw.c                 |  2 +-
 drivers/media/platform/via-camera.c                |  2 +-
 drivers/media/platform/vivid/vivid-core.c          |  2 +-
 drivers/media/platform/vivid/vivid-radio-rx.c      |  2 +-
 drivers/media/platform/vivid/vivid-radio-rx.h      |  2 +-
 drivers/media/platform/vivid/vivid-radio-tx.c      |  2 +-
 drivers/media/platform/vivid/vivid-radio-tx.h      |  2 +-
 drivers/media/radio/radio-cadet.c                  |  6 ++--
 drivers/media/radio/radio-si476x.c                 |  6 ++--
 drivers/media/radio/radio-wl1273.c                 |  2 +-
 drivers/media/radio/si470x/radio-si470x-common.c   |  6 ++--
 drivers/media/radio/wl128x/fmdrv_v4l2.c            |  2 +-
 drivers/media/rc/lirc_dev.c                        |  4 +--
 drivers/media/usb/cpia2/cpia2.h                    |  4 +--
 drivers/media/usb/cpia2/cpia2_core.c               |  4 +--
 drivers/media/usb/cpia2/cpia2_v4l.c                |  4 +--
 drivers/media/usb/cx231xx/cx231xx-417.c            |  6 ++--
 drivers/media/usb/cx231xx/cx231xx-video.c          |  6 ++--
 drivers/media/usb/gspca/gspca.c                    |  6 ++--
 drivers/media/usb/hdpvr/hdpvr-video.c              |  6 ++--
 drivers/media/usb/pvrusb2/pvrusb2-v4l2.c           |  4 +--
 drivers/media/usb/stkwebcam/stk-webcam.c           |  4 +--
 drivers/media/usb/tm6000/tm6000-video.c            | 10 +++---
 drivers/media/usb/uvc/uvc_queue.c                  |  4 +--
 drivers/media/usb/uvc/uvc_v4l2.c                   |  2 +-
 drivers/media/usb/uvc/uvcvideo.h                   |  2 +-
 drivers/media/usb/zr364xx/zr364xx.c                |  4 +--
 drivers/media/v4l2-core/v4l2-ctrls.c               |  2 +-
 drivers/media/v4l2-core/v4l2-dev.c                 |  4 +--
 drivers/media/v4l2-core/v4l2-mem2mem.c             | 10 +++---
 drivers/media/v4l2-core/v4l2-subdev.c              |  2 +-
 drivers/media/v4l2-core/videobuf-core.c            | 10 +++---
 drivers/media/v4l2-core/videobuf2-v4l2.c           | 10 +++---
 drivers/misc/cxl/api.c                             |  2 +-
 drivers/misc/cxl/cxl.h                             |  2 +-
 drivers/misc/cxl/file.c                            |  4 +--
 drivers/misc/hpilo.c                               |  2 +-
 drivers/misc/lis3lv02d/lis3lv02d.c                 |  2 +-
 drivers/misc/mei/amthif.c                          |  4 +--
 drivers/misc/mei/main.c                            |  6 ++--
 drivers/misc/mei/mei_dev.h                         |  2 +-
 drivers/misc/mic/host/mic_fops.c                   |  4 +--
 drivers/misc/mic/host/mic_fops.h                   |  2 +-
 drivers/misc/mic/scif/scif_api.c                   |  7 +++--
 drivers/misc/mic/scif/scif_epd.h                   |  2 +-
 drivers/misc/mic/scif/scif_fd.c                    |  2 +-
 drivers/misc/phantom.c                             |  4 +--
 drivers/misc/vmw_vmci/vmci_host.c                  |  4 +--
 drivers/net/macvtap.c                              |  4 +--
 drivers/net/ppp/ppp_async.c                        |  2 +-
 drivers/net/ppp/ppp_generic.c                      |  4 +--
 drivers/net/ppp/ppp_synctty.c                      |  2 +-
 drivers/net/tun.c                                  |  4 +--
 drivers/net/wan/cosa.c                             |  4 +--
 drivers/net/wireless/rt2x00/rt2x00debug.c          |  2 +-
 drivers/platform/goldfish/goldfish_pipe.c          |  4 +--
 drivers/platform/x86/sony-laptop.c                 |  2 +-
 drivers/pps/pps.c                                  |  2 +-
 drivers/ptp/ptp_chardev.c                          |  2 +-
 drivers/ptp/ptp_private.h                          |  2 +-
 drivers/rtc/rtc-dev.c                              |  2 +-
 drivers/s390/block/dasd_eer.c                      |  4 +--
 drivers/s390/char/monreader.c                      |  2 +-
 drivers/scsi/megaraid/megaraid_sas_base.c          |  4 +--
 drivers/scsi/mpt3sas/mpt3sas_ctl.c                 |  2 +-
 drivers/scsi/sg.c                                  |  4 +--
 drivers/staging/android/sync.c                     |  2 +-
 drivers/staging/comedi/comedi_fops.c               |  4 +--
 drivers/staging/comedi/drivers/serial2002.c        |  2 +-
 drivers/staging/media/bcm2048/radio-bcm2048.c      |  4 +--
 drivers/staging/media/davinci_vpfe/vpfe_video.c    |  2 +-
 drivers/staging/media/lirc/lirc_parallel.c         |  2 +-
 drivers/staging/media/lirc/lirc_sir.c              |  4 +--
 drivers/staging/media/lirc/lirc_zilog.c            |  4 +--
 drivers/staging/media/omap4iss/iss_video.c         |  2 +-
 drivers/staging/most/aim-cdev/cdev.c               |  4 +--
 drivers/staging/most/aim-v4l2/video.c              |  4 +--
 drivers/staging/rdma/hfi1/diag.c                   |  6 ++--
 drivers/staging/rdma/hfi1/file_ops.c               | 18 +++++------
 drivers/staging/rdma/ipath/ipath_file_ops.c        | 18 +++++------
 drivers/staging/speakup/speakup_soft.c             |  4 +--
 drivers/tty/n_gsm.c                                |  4 +--
 drivers/tty/n_hdlc.c                               |  6 ++--
 drivers/tty/n_r3964.c                              |  6 ++--
 drivers/tty/n_tty.c                                |  4 +--
 drivers/tty/tty_io.c                               |  8 ++---
 drivers/tty/vt/vc_screen.c                         |  4 +--
 drivers/uio/uio.c                                  |  2 +-
 drivers/usb/class/cdc-wdm.c                        |  4 +--
 drivers/usb/class/usblp.c                          |  4 +--
 drivers/usb/core/devices.c                         |  2 +-
 drivers/usb/core/devio.c                           |  4 +--
 drivers/usb/gadget/function/f_fs.c                 |  4 +--
 drivers/usb/gadget/function/f_hid.c                |  4 +--
 drivers/usb/gadget/function/f_printer.c            |  4 +--
 drivers/usb/gadget/function/uvc_queue.c            |  2 +-
 drivers/usb/gadget/function/uvc_queue.h            |  2 +-
 drivers/usb/gadget/function/uvc_v4l2.c             |  2 +-
 drivers/usb/gadget/legacy/inode.c                  |  4 +--
 drivers/usb/misc/iowarrior.c                       |  4 +--
 drivers/usb/misc/ldusb.c                           |  4 +--
 drivers/usb/misc/legousbtower.c                    |  6 ++--
 drivers/usb/mon/mon_bin.c                          |  4 +--
 drivers/vfio/virqfd.c                              |  4 +--
 drivers/vhost/vhost.c                              |  8 ++---
 drivers/vhost/vhost.h                              |  4 +--
 drivers/virt/fsl_hypervisor.c                      |  4 +--
 drivers/xen/evtchn.c                               |  4 +--
 drivers/xen/mcelog.c                               |  2 +-
 drivers/xen/xenbus/xenbus_dev_frontend.c           |  2 +-
 fs/cachefiles/daemon.c                             | 10 +++---
 fs/coda/psdev.c                                    |  4 +--
 fs/dlm/plock.c                                     |  4 +--
 fs/dlm/user.c                                      |  2 +-
 fs/ecryptfs/miscdev.c                              |  4 +--
 fs/eventfd.c                                       |  4 +--
 fs/eventpoll.c                                     |  6 ++--
 fs/fcntl.c                                         |  4 +--
 fs/fuse/dev.c                                      |  4 +--
 fs/fuse/file.c                                     |  2 +-
 fs/fuse/fuse_i.h                                   |  2 +-
 fs/kernfs/file.c                                   |  2 +-
 fs/notify/fanotify/fanotify_user.c                 |  4 +--
 fs/notify/inotify/inotify_user.c                   |  4 +--
 fs/ocfs2/dlmfs/dlmfs.c                             |  4 +--
 fs/pipe.c                                          |  4 +--
 fs/proc/inode.c                                    |  6 ++--
 fs/proc/kmsg.c                                     |  2 +-
 fs/proc/proc_sysctl.c                              |  4 +--
 fs/proc_namespace.c                                |  4 +--
 fs/select.c                                        | 23 ++++++--------
 fs/signalfd.c                                      |  4 +--
 fs/timerfd.c                                       |  4 +--
 fs/userfaultfd.c                                   |  4 +--
 include/drm/drmP.h                                 |  2 +-
 include/linux/dma-buf.h                            |  2 +-
 include/linux/fs.h                                 |  2 +-
 include/linux/net.h                                |  2 +-
 include/linux/poll.h                               | 10 +++---
 include/linux/posix-clock.h                        |  2 +-
 include/linux/ring_buffer.h                        |  2 +-
 include/linux/scif.h                               |  4 +--
 include/linux/skbuff.h                             |  4 +--
 include/linux/tty_ldisc.h                          |  2 +-
 include/linux/wait.h                               | 10 +++---
 include/media/lirc_dev.h                           |  2 +-
 include/media/media-devnode.h                      |  2 +-
 include/media/soc_camera.h                         |  2 +-
 include/media/v4l2-ctrls.h                         |  2 +-
 include/media/v4l2-dev.h                           |  2 +-
 include/media/v4l2-mem2mem.h                       |  4 +--
 include/media/videobuf-core.h                      |  2 +-
 include/media/videobuf2-v4l2.h                     |  4 +--
 include/net/bluetooth/bluetooth.h                  |  2 +-
 include/net/inet_connection_sock.h                 |  2 +-
 include/net/iucv/af_iucv.h                         |  4 +--
 include/net/sctp/sctp.h                            |  3 +-
 include/net/sock.h                                 |  4 +--
 include/net/tcp.h                                  |  4 +--
 include/net/udp.h                                  |  2 +-
 include/sound/hwdep.h                              |  2 +-
 include/sound/info.h                               |  2 +-
 include/uapi/asm-generic/poll.h                    | 36 +++++++++++++---------
 include/uapi/linux/types.h                         |  6 ++++
 ipc/mqueue.c                                       |  4 +--
 kernel/events/core.c                               |  4 +--
 kernel/printk/printk.c                             |  4 +--
 kernel/relay.c                                     |  4 +--
 kernel/time/posix-clock.c                          |  4 +--
 kernel/trace/ring_buffer.c                         |  2 +-
 kernel/trace/trace.c                               |  6 ++--
 mm/memcontrol.c                                    |  2 +-
 mm/swapfile.c                                      |  2 +-
 net/atm/common.c                                   |  4 +--
 net/atm/common.h                                   |  2 +-
 net/batman-adv/debugfs.c                           |  2 +-
 net/batman-adv/icmp_socket.c                       |  2 +-
 net/bluetooth/af_bluetooth.c                       |  7 ++---
 net/caif/caif_socket.c                             |  6 ++--
 net/core/datagram.c                                |  7 ++---
 net/core/sock.c                                    |  2 +-
 net/dccp/dccp.h                                    |  3 +-
 net/dccp/proto.c                                   |  5 ++-
 net/decnet/af_decnet.c                             |  4 +--
 net/ipv4/tcp.c                                     |  4 +--
 net/ipv4/udp.c                                     |  4 +--
 net/irda/af_irda.c                                 |  6 ++--
 net/irda/irnet/irnet_ppp.c                         |  8 ++---
 net/irda/irnet/irnet_ppp.h                         |  2 +-
 net/iucv/af_iucv.c                                 |  8 ++---
 net/netlink/af_netlink.c                           |  6 ++--
 net/nfc/llcp_sock.c                                |  8 ++---
 net/nfc/nci/uart.c                                 |  2 +-
 net/packet/af_packet.c                             |  6 ++--
 net/phonet/socket.c                                |  6 ++--
 net/rds/af_rds.c                                   |  6 ++--
 net/rfkill/core.c                                  |  4 +--
 net/rxrpc/af_rxrpc.c                               |  6 ++--
 net/sctp/socket.c                                  |  4 +--
 net/socket.c                                       |  7 ++---
 net/sunrpc/cache.c                                 | 10 +++---
 net/sunrpc/rpc_pipe.c                              |  4 +--
 net/tipc/socket.c                                  |  6 ++--
 net/unix/af_unix.c                                 | 15 ++++-----
 net/vmw_vsock/af_vsock.c                           |  6 ++--
 security/tomoyo/audit.c                            |  2 +-
 security/tomoyo/common.c                           |  4 +--
 security/tomoyo/common.h                           |  6 ++--
 security/tomoyo/securityfs_if.c                    |  2 +-
 sound/core/compress_offload.c                      |  6 ++--
 sound/core/control.c                               |  4 +--
 sound/core/hwdep.c                                 |  2 +-
 sound/core/info.c                                  |  4 +--
 sound/core/init.c                                  |  2 +-
 sound/core/oss/pcm_oss.c                           |  4 +--
 sound/core/pcm_native.c                            |  8 ++---
 sound/core/rawmidi.c                               |  4 +--
 sound/core/seq/oss/seq_oss.c                       |  4 +--
 sound/core/seq/oss/seq_oss_device.h                |  2 +-
 sound/core/seq/oss/seq_oss_rw.c                    |  4 +--
 sound/core/seq/seq_clientmgr.c                     |  4 +--
 sound/core/timer.c                                 |  4 +--
 sound/firewire/bebob/bebob_hwdep.c                 |  4 +--
 sound/firewire/dice/dice-hwdep.c                   |  4 +--
 sound/firewire/digi00x/digi00x-hwdep.c             |  4 +--
 sound/firewire/fireworks/fireworks_hwdep.c         |  4 +--
 sound/firewire/oxfw/oxfw-hwdep.c                   |  4 +--
 sound/firewire/tascam/tascam-hwdep.c               |  4 +--
 sound/oss/dmabuf.c                                 |  6 ++--
 sound/oss/dmasound/dmasound_core.c                 |  4 +--
 sound/oss/midibuf.c                                |  4 +--
 sound/oss/sequencer.c                              |  4 +--
 sound/oss/sound_calls.h                            |  6 ++--
 sound/oss/soundcard.c                              |  2 +-
 sound/oss/swarm_cs4297a.c                          |  4 +--
 sound/usb/mixer_quirks.c                           |  2 +-
 sound/usb/usx2y/us122l.c                           |  4 +--
 sound/usb/usx2y/usX2Yhwdep.c                       |  4 +--
 virt/kvm/eventfd.c                                 |  4 +--
 379 files changed, 760 insertions(+), 758 deletions(-)
 delete mode 100644 arch/alpha/include/uapi/asm/poll.h
 delete mode 100644 arch/ia64/include/uapi/asm/poll.h
 delete mode 100644 arch/m32r/include/uapi/asm/poll.h
 delete mode 100644 arch/microblaze/include/uapi/asm/poll.h
 delete mode 100644 arch/mn10300/include/uapi/asm/poll.h
 delete mode 100644 arch/powerpc/include/uapi/asm/poll.h
 delete mode 100644 arch/s390/include/uapi/asm/poll.h
 delete mode 100644 arch/score/include/uapi/asm/poll.h
 delete mode 100644 arch/x86/include/uapi/asm/poll.h
