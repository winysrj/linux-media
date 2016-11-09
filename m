Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:40093
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753528AbcKIJdj (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 9 Nov 2016 04:33:39 -0500
Date: Wed, 9 Nov 2016 07:33:31 -0200
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: VDR User <user.vdr@gmail.com>
Cc: "mailing list: linux-media" <linux-media@vger.kernel.org>
Subject: Re: Question about 2 gp8psk patches I noticed, and possible bug.
Message-ID: <20161109073331.204b53c4@vento.lan>
In-Reply-To: <CAA7C2qiY5MddsP4Ghky1PAhYuvTbBUR5QwejM=z8wCMJCwRw7g@mail.gmail.com>
References: <CAA7C2qjXSkmmCB=zc7Y-Btpwzm_B=_ok0t6qMRuCy+gfrEhcMw@mail.gmail.com>
        <20161108155520.224229d5@vento.lan>
        <CAA7C2qiY5MddsP4Ghky1PAhYuvTbBUR5QwejM=z8wCMJCwRw7g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 8 Nov 2016 22:00:41 -0800
VDR User <user.vdr@gmail.com> escreveu:

> Hi Mauro,
> 
> Unfortunately the patch doesn't seem to have solved the problem. I do
> have the kernel recompiled with debug enabled though per your irc msg.
> dmesg gives me:
> 
> [   70.741073] usbcore: deregistering interface driver dvb_usb_gp8psk
> [   70.741165] ------------[ cut here ]------------
> [   70.741172] WARNING: CPU: 1 PID: 2119 at kernel/module.c:1108
> module_put+0x67/0x80
> [   70.741174] Modules linked in: dvb_usb_gp8psk(-) dvb_usb dvb_core
> nvidia_drm(PO) nvidia_modeset(PO) snd_hda_codec_hdmi snd_hda_intel
> snd_hda_codec snd_hwdep snd_hda_core snd_pcm snd_timer snd soundcore
> nvidia(PO)
> [   70.741186] CPU: 1 PID: 2119 Comm: rmmod Tainted: P           O
> 4.8.4-build.2 #1
> [   70.741187] Hardware name: MSI MS-7309/MS-7309, BIOS V1.12 02/23/2009
> [   70.741189]  00000000 c12c15f0 00000000 00000000 c103fc7a c161ecc0
> 00000001 00000847
> [   70.741194]  c161e50f 00000454 c10a4b87 c10a4b87 00000009 fb090cc0
> 00000000 00000000
> [   70.741197]  f4e72000 c103fd43 00000009 00000000 00000000 c10a4b87
> fb08f6a0 c10a58fa
> [   70.741202] Call Trace:
> [   70.741206]  [<c12c15f0>] ? dump_stack+0x44/0x64
> [   70.741209]  [<c103fc7a>] ? __warn+0xfa/0x120
> [   70.741211]  [<c10a4b87>] ? module_put+0x67/0x80
> [   70.741213]  [<c10a4b87>] ? module_put+0x67/0x80
> [   70.741215]  [<c103fd43>] ? warn_slowpath_null+0x23/0x30
> [   70.741217]  [<c10a4b87>] ? module_put+0x67/0x80
> [   70.741221]  [<fb08f6a0>] ? gp8psk_fe_set_frontend+0x460/0x460
> [dvb_usb_gp8psk]
> [   70.741223]  [<c10a58fa>] ? symbol_put_addr+0x2a/0x50
> [   70.741225]  [<fb08e04e>] ? gp8psk_usb_disconnect+0x4e/0x90 [dvb_usb_gp8psk]

Ok, it is running your new driver.

> [   70.741229]  [<c13da272>] ? usb_unbind_interface+0x62/0x250
> [   70.741233]  [<c1551f3f>] ? _raw_spin_unlock_irqrestore+0xf/0x30
> [   70.741235]  [<c1372ea4>] ? __pm_runtime_idle+0x44/0x70
> [   70.741239]  [<c1369a68>] ? __device_release_driver+0x78/0x120
> [   70.741241]  [<c136a297>] ? driver_detach+0x87/0x90
> [   70.741243]  [<c13695d8>] ? bus_remove_driver+0x38/0x90
> [   70.741245]  [<c13d9608>] ? usb_deregister+0x58/0xb0
> [   70.741248]  [<c10a5eb0>] ? SyS_delete_module+0x130/0x1f0
> [   70.741251]  [<c1036200>] ? __do_page_fault+0x1a0/0x440
> [   70.741253]  [<c1000fa5>] ? exit_to_usermode_loop+0x85/0x90
> [   70.741254]  [<c10013f0>] ? do_fast_syscall_32+0x80/0x130
> [   70.741257]  [<c1552403>] ? sysenter_past_esp+0x40/0x6a
> [   70.741259] ---[ end trace a387b7eddb538bfb ]---
> [   70.743654] dvb-usb: Genpix SkyWalker-2 DVB-S receiver successfully
> deinitialized and disconnected.
> 
> 
> I read the Bug Hunting url but it's still not clear to me which line
> from that dmesg text I should be focused on. It would suggest the
> first line (dump_stack+0x44/0x64) but you pointed to
> gp8psk_fe_set_frontend so I'm not sure what to do next. 

I wrote some patches a few days ago improving bug hunting. Just updated
it at fedorapeople:
	https://mchehab.fedorapeople.org/kernel_docs/admin-guide/bug-hunting.html

Basically, each line on the above is a function. dump_stack() is the one
that generates the above dump. So, not useful. Assuming that the driver
core at the Kernel is ok (with is usually a good assumption), we can
exclude __warn() and module_put(), warn_slowpath_null() and other similar
functions, focusing on the ones inside gp8psk module.

> When I go into
> gdb I see:
> 
> gdb $(find /lib/modules/$(uname -r) -name dvb-usb-gp8psk.ko)
> ...
> Reading symbols from
> /lib/modules/4.8.4-build.2/kernel/drivers/media/usb/dvb-usb/dvb-usb-gp8psk.ko...(no
> debugging symbols found)...done.
> (gdb)
> 
> gdb /usr/src/linux/vmlinux
> ...
> Reading symbols from /usr/src/linux/vmlinux...done.
> (gdb)
> (gdb)
> 
> "No debugging symbols found" doesn't sound good,

Yes. Clearly, it was unable to read the symbols. Depending on the
way you built the Kernel, though, the symbols may have been
stripped at the install dirs (using the strip command). Fedora builds do
that, placing the symbols on a separate package, that can be installed in
separate (kernel-debug).

The safest way to get the symbols is by loading 
dvb-usb-gp8psk.ko from the directory where you compiled the
Kernel, instead of from /lib/modules/.



> but DEBUG is enabled:
> 
> $ grep "^CONFIG_DEBUG" /usr/src/linux/.config
> CONFIG_DEBUG_RODATA=y
> CONFIG_DEBUG_INFO=y
> CONFIG_DEBUG_FS=y
> CONFIG_DEBUG_KERNEL=y
> CONFIG_DEBUG_MEMORY_INIT=y
> CONFIG_DEBUG_PREEMPT=y
> CONFIG_DEBUG_BUGVERBOSE=y

Yes, you should have symbols there.

What disturbs me is why gp8psk_fe_set_frontend() is on that stack trace.
It doesn't make much sense, except if you're trying to open the frontend
while removing the module. Anyway, I added a few printks and changed
something at the dvb_frontend core to test some things.

Please test the enclosed patch. It replaces the one I sent you before.

Thanks,
Mauro

diff --git a/drivers/media/dvb-core/dvb_frontend.c b/drivers/media/dvb-core/dvb_frontend.c
index 98edf46b22d0..a43ac8f36895 100644
--- a/drivers/media/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb-core/dvb_frontend.c
@@ -2726,6 +2726,9 @@ int dvb_unregister_frontend(struct dvb_frontend* fe)
 	dev_dbg(fe->dvb->device, "%s:\n", __func__);
 
 	mutex_lock(&frontend_mutex);
+
+	/* We should not accept open() anymore for the frontend */
+	fe->exit = DVB_FE_DEVICE_REMOVED;
 	dvb_frontend_stop (fe);
 	dvb_unregister_device (fepriv->dvbdev);
 
diff --git a/drivers/media/usb/dvb-usb/gp8psk.c b/drivers/media/usb/dvb-usb/gp8psk.c
index cede0d8b0f8a..bb01f1dc8ed0 100644
--- a/drivers/media/usb/dvb-usb/gp8psk.c
+++ b/drivers/media/usb/dvb-usb/gp8psk.c
@@ -270,6 +270,35 @@ static int gp8psk_usb_probe(struct usb_interface *intf,
 	return ret;
 }
 
+static void gp8psk_usb_disconnect(struct usb_interface *intf)
+{
+	struct dvb_usb_device *d = usb_get_intfdata(intf);
+	struct dvb_usb_adapter *adap;
+	int i, n;
+
+	/*
+	 * As gsp8psk-fe can call back this driver, in order to do URB
+	 * transfers, we need to manually exit the frontend earlier.
+	 */
+	for (n = 0; n < d->num_adapters_initialized; n++) {
+		adap = &d->adapter[n];
+		i = adap->num_frontends_initialized - 1;
+
+		for (; i >= 0; i--) {
+			if (adap->fe_adap[i].fe != NULL) {
+				printk("gp8psk: unregistering fe%d\n", i);
+				dvb_unregister_frontend(adap->fe_adap[i].fe);
+				printk("gp8psk: detaching fe%d\n", i);
+				dvb_frontend_detach(adap->fe_adap[i].fe);
+			}
+		}
+		adap->num_frontends_initialized = 0;
+	}
+
+	printk("gp8psk: calling dvb_usb_device_exit\n");
+	dvb_usb_device_exit(intf);
+}
+
 static struct usb_device_id gp8psk_usb_table [] = {
 	    { USB_DEVICE(USB_VID_GENPIX, USB_PID_GENPIX_8PSK_REV_1_COLD) },
 	    { USB_DEVICE(USB_VID_GENPIX, USB_PID_GENPIX_8PSK_REV_1_WARM) },
@@ -338,7 +367,7 @@ static struct dvb_usb_device_properties gp8psk_properties = {
 static struct usb_driver gp8psk_usb_driver = {
 	.name		= "dvb_usb_gp8psk",
 	.probe		= gp8psk_usb_probe,
-	.disconnect = dvb_usb_device_exit,
+	.disconnect	= gp8psk_usb_disconnect,
 	.id_table	= gp8psk_usb_table,
 };
 

