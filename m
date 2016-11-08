Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:37044
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753152AbcKHRzu (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 8 Nov 2016 12:55:50 -0500
Date: Tue, 8 Nov 2016 15:55:20 -0200
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: VDR User <user.vdr@gmail.com>
Cc: linux-media@vger.kernel.org
Subject: Re: Question about 2 gp8psk patches I noticed, and possible bug.
Message-ID: <20161108155520.224229d5@vento.lan>
In-Reply-To: <CAA7C2qjXSkmmCB=zc7Y-Btpwzm_B=_ok0t6qMRuCy+gfrEhcMw@mail.gmail.com>
References: <CAA7C2qjXSkmmCB=zc7Y-Btpwzm_B=_ok0t6qMRuCy+gfrEhcMw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sat, 5 Nov 2016 19:24:58 -0700
VDR User <user.vdr@gmail.com> escreveu:

> I have
> several different Genpix devices that use the gp8psk driver and in all
> cases the following happens when I unload it:
> 
> [494896.234616] usbcore: deregistering interface driver dvb_usb_gp8psk
> [494896.234712] ------------[ cut here ]------------
> [494896.234719] WARNING: CPU: 1 PID: 28102 at kernel/module.c:1108
> module_put+0x57/0x70
> [494896.234720] Modules linked in: dvb_usb_gp8psk(-) dvb_usb dvb_core
> nvidia_drm(PO) nvidia_modeset(PO) snd_hda_codec_hdmi snd_hda_intel
> snd_hda_codec snd_hwdep snd_hda_core snd_pcm snd_timer snd soundcore
> nvidia(PO) [last unloaded: rc_core]
> [494896.234732] CPU: 1 PID: 28102 Comm: rmmod Tainted: P        WC O
>  4.8.4-build.1 #1
> [494896.234733] Hardware name: MSI MS-7309/MS-7309, BIOS V1.12 02/23/2009
> [494896.234735]  00000000 c12ba080 00000000 00000000 c103ed6a c1616014
> 00000001 00006dc6
> [494896.234739]  c1615862 00000454 c109e8a7 c109e8a7 00000009 ffffffff
> 00000000 f13f6a10
> [494896.234743]  f5f5a600 c103ee33 00000009 00000000 00000000 c109e8a7
> f80ca4d0 c109f617
> [494896.234746] Call Trace:
> [494896.234753]  [<c12ba080>] ? dump_stack+0x44/0x64
> [494896.234756]  [<c103ed6a>] ? __warn+0xfa/0x120
> [494896.234758]  [<c109e8a7>] ? module_put+0x57/0x70
> [494896.234760]  [<c109e8a7>] ? module_put+0x57/0x70
> [494896.234762]  [<c103ee33>] ? warn_slowpath_null+0x23/0x30
> [494896.234763]  [<c109e8a7>] ? module_put+0x57/0x70
> [494896.234766]  [<f80ca4d0>] ? gp8psk_fe_set_frontend+0x460/0x460
> [dvb_usb_gp8psk]
> [494896.234769]  [<c109f617>] ? symbol_put_addr+0x27/0x50
> [494896.234771]  [<f80bc9ca>] ?
> dvb_usb_adapter_frontend_exit+0x3a/0x70 [dvb_usb]
> [494896.234773]  [<f80bb3bf>] ? dvb_usb_exit+0x2f/0xd0 [dvb_usb]
> [494896.234776]  [<c13d03bc>] ? usb_disable_endpoint+0x7c/0xb0
> [494896.234778]  [<f80bb48a>] ? dvb_usb_device_exit+0x2a/0x50 [dvb_usb]
> [494896.234780]  [<c13d2882>] ? usb_unbind_interface+0x62/0x250
> [494896.234782]  [<c136b514>] ? __pm_runtime_idle+0x44/0x70
> [494896.234785]  [<c13620d8>] ? __device_release_driver+0x78/0x120
> [494896.234787]  [<c1362907>] ? driver_detach+0x87/0x90
> [494896.234789]  [<c1361c48>] ? bus_remove_driver+0x38/0x90
> [494896.234791]  [<c13d1c18>] ? usb_deregister+0x58/0xb0
> [494896.234793]  [<c109fbb0>] ? SyS_delete_module+0x130/0x1f0
> [494896.234796]  [<c1055654>] ? task_work_run+0x64/0x80
> [494896.234798]  [<c1000fa5>] ? exit_to_usermode_loop+0x85/0x90
> [494896.234800]  [<c10013f0>] ? do_fast_syscall_32+0x80/0x130
> [494896.234803]  [<c1549f43>] ? sysenter_past_esp+0x40/0x6a
> [494896.234805] ---[ end trace 6ebc60ef3981792f ]---
> [494896.235890] dvb-usb: Genpix SkyWalker-2 DVB-S receiver
> successfully deinitialized and disconnected.

I suspect that this is due to a race condition at device unregister.
could you please try the enclosed patch?

gp8psk: unregister gp8psk-fe early

Letting gp8psk-fe to unregister late can cause race issues.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>


diff --git a/drivers/media/usb/dvb-usb/gp8psk.c b/drivers/media/usb/dvb-usb/gp8psk.c
index 2829e3082d15..04ea2bbbe5ae 100644
--- a/drivers/media/usb/dvb-usb/gp8psk.c
+++ b/drivers/media/usb/dvb-usb/gp8psk.c
@@ -270,6 +270,32 @@ static int gp8psk_usb_probe(struct usb_interface *intf,
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
+				dvb_unregister_frontend(adap->fe_adap[i].fe);
+				dvb_frontend_detach(adap->fe_adap[i].fe);
+			}
+		}
+		adap->num_frontends_initialized = 0;
+	}
+
+	dvb_usb_device_exit(intf);
+}
+
 static struct usb_device_id gp8psk_usb_table [] = {
 	    { USB_DEVICE(USB_VID_GENPIX, USB_PID_GENPIX_8PSK_REV_1_COLD) },
 	    { USB_DEVICE(USB_VID_GENPIX, USB_PID_GENPIX_8PSK_REV_1_WARM) },
@@ -338,7 +364,7 @@ static struct dvb_usb_device_properties gp8psk_properties = {
 static struct usb_driver gp8psk_usb_driver = {
 	.name		= "dvb_usb_gp8psk",
 	.probe		= gp8psk_usb_probe,
-	.disconnect = dvb_usb_device_exit,
+	.disconnect	= gp8psk_usb_disconnect,
 	.id_table	= gp8psk_usb_table,
 };
 
