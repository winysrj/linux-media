Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:49476 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753248AbbBMOlb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Feb 2015 09:41:31 -0500
Date: Fri, 13 Feb 2015 12:41:25 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: DVB suspend/resume regression on 3.19
Message-ID: <20150213124125.67a67e04@recife.lan>
In-Reply-To: <s5h7fvlaozh.wl-tiwai@suse.de>
References: <s5hvbjbtkp0.wl-tiwai@suse.de>
	<s5h7fvlaozh.wl-tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 13 Feb 2015 15:02:42 +0100
Takashi Iwai <tiwai@suse.de> escreveu:

> At Mon, 09 Feb 2015 11:59:07 +0100,
> Takashi Iwai wrote:
> > 
> > Hi,
> > 
> > we've got a bug report about the suspend/resume regression of DVB
> > device with 3.19.  The symptom is VLC doesn't work after S3 or S4
> > resume.  strace shows that /dev/dvb/adaptor0/dvr returns -ENODEV.
> > 
> > The reporter confirmed that 3.18 works fine, so the regression must be
> > in 3.19.
> > 
> > There is a relevant kernel warning while suspending:
> > 
> >  WARNING: CPU: 1 PID: 3603 at ../kernel/module.c:1001 module_put+0xc7/0xd0()
> >  Workqueue: events_unbound async_run_entry_fn
> >   0000000000000000 ffffffff81a45779 ffffffff81664f12 0000000000000000
> >   ffffffff81062381 0000000000000000 ffffffffa051eea0 ffff8800ca369278
> >   ffffffffa051a068 ffff8800c0a18090 ffffffff810dfb47 0000000000000000
> >  Call Trace:
> >   [<ffffffff810055ac>] dump_trace+0x8c/0x340
> >   [<ffffffff81005903>] show_stack_log_lvl+0xa3/0x190
> >   [<ffffffff81007061>] show_stack+0x21/0x50
> >   [<ffffffff81664f12>] dump_stack+0x47/0x67
> >   [<ffffffff81062381>] warn_slowpath_common+0x81/0xb0
> >   [<ffffffff810dfb47>] module_put+0xc7/0xd0
> >   [<ffffffffa04d98d1>] dvb_usb_adapter_frontend_exit+0x41/0x60 [dvb_usb]
> >   [<ffffffffa04d8451>] dvb_usb_exit+0x31/0xa0 [dvb_usb]
> >   [<ffffffffa04d84fb>] dvb_usb_device_exit+0x3b/0x50 [dvb_usb]
> >   [<ffffffff814cefad>] usb_unbind_interface+0x1ed/0x2c0
> >   [<ffffffff8145ceae>] __device_release_driver+0x7e/0x100
> >   [<ffffffff8145cf52>] device_release_driver+0x22/0x30
> >   [<ffffffff814cf13d>] usb_forced_unbind_intf+0x2d/0x60
> >   [<ffffffff814cf3c3>] usb_suspend+0x73/0x130
> >   [<ffffffff814bd453>] usb_dev_freeze+0x13/0x20
> >   [<ffffffff81468fca>] dpm_run_callback+0x4a/0x150
> >   [<ffffffff81469c81>] __device_suspend+0x121/0x350
> >   [<ffffffff81469ece>] async_suspend+0x1e/0xa0
> >   [<ffffffff81081e63>] async_run_entry_fn+0x43/0x150
> >   [<ffffffff81079e72>] process_one_work+0x142/0x3f0
> >   [<ffffffff8107a234>] worker_thread+0x114/0x460
> >   [<ffffffff8107f3b1>] kthread+0xc1/0xe0
> >   [<ffffffff8166b77c>] ret_from_fork+0x7c/0xb0
> > 
> > So something went wrong in module refcount, which likely leads to
> > disabling the device and returning -ENODEV in the end.
> > 
> > Does this ring a bell to you guys?
> > 
> > The hardware details and logs are found in the URL below:
> >   https://bugzilla.novell.com/show_bug.cgi?id=916577
> 
> I wonder whether no one hits the same problem...?

Hi Takashi,

There were no recent changes at dvb-usb core or at the dtt200u.c driver.
So, I don't think that the regression was caused by a change at the media
subsystem. Yet, we've added some patches to fix suspend/resume at the
DVB core, but they basically add a new set of optional callbacks. So, it
should not cause any regression.

The changeset in question is 59d7889ae49f6e3e9d9cff8c0de7ad95d9ca068b.

>From those messages:

2015-02-06T15:30:47.468258+01:00 linux-z24t kernel: [  150.552119] dvb-usb: downloading firmware from file 'dvb-usb-wt220u-fc03.fw'
2015-02-06T15:30:47.468827+01:00 linux-z24t mtp-probe: checking bus 1, device 5: "/sys/devices/pci0000:00/0000:00:1d.7/usb1/1-4"
2015-02-06T15:30:47.879878+01:00 linux-z24t mtp-probe: bus: 1, device: 5 was not an MTP device
2015-02-06T15:30:47.880192+01:00 linux-z24t kernel: [  151.992993] usb 1-4: USB disconnect, device number 5
2015-02-06T15:30:47.880839+01:00 linux-z24t kernel: [  151.993076] dvb-usb: generic DVB-USB module successfully deinitialized and disconnected.

I _suspect_ that dvb_usb_download_firmware() failed to load the firmware
file.

That problem actually looks like a recently discovered issue:t
request_firmware() fails during resume on some systems. What
seems to happen in this case is that the media drivers are resumed
_before_ mounting the partition where the firmware file is hosted.

Yet, in this case, it should be printing:
	"did not find the firmware file."

I would add a test patch in order to print the return code from
dvb_usb_download_firmware(), in order to see if it succeeds or
not, e. g. something like the patch below, and then try to narrow
down where it is failing, assuming that the new message will be printed.

If nothing gets printed, then I would try to discover why the USB
stack disconnected the device. Perhaps an ehci/xhci bug?

Regards,
Mauro


diff --git a/drivers/media/usb/dvb-usb/dvb-usb-firmware.c b/drivers/media/usb/dvb-usb/dvb-usb-firmware.c
index 733a7ff..184d0290 100644
--- a/drivers/media/usb/dvb-usb/dvb-usb-firmware.c
+++ b/drivers/media/usb/dvb-usb/dvb-usb-firmware.c
@@ -109,6 +109,10 @@ int dvb_usb_download_firmware(struct usb_device *udev, struct dvb_usb_device_pro
 	}
 
 	release_firmware(fw);
+
+	if (ret)
+		err("firmware load failed with %d error code", ret);
+
 	return ret;
 }
 




> 
> 
> Takashi
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
