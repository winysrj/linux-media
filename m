Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:42401
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751933AbdCHJUb (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 8 Mar 2017 04:20:31 -0500
Date: Wed, 8 Mar 2017 06:10:11 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: <stable@vger.kernel.org>
Cc: linux-media@vger.kernel.org
Subject: [PATCH] [media] dvb-usb: don't use stack for firmware load
Message-ID: <20170308061011.50580267@vento.lan>
In-Reply-To: <1488956197224172@kroah.com>
References: <1488956197224172@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As reported by Marc Duponcheel <marc@offline.be>, firmware load on
dvb-usb is using the stack, with is not allowed anymore on default
Kernel configurations:

[ 1025.958836] dvb-usb: found a 'WideView WT-220U PenType Receiver (based on ZL353)' in cold state, will try to load a firmware
[ 1025.958853] dvb-usb: downloading firmware from file 'dvb-usb-wt220u-zl0353-01.fw'
[ 1025.958855] dvb-usb: could not stop the USB controller CPU.
[ 1025.958856] dvb-usb: error while transferring firmware (transferred size: -11, block size: 3)
[ 1025.958856] dvb-usb: firmware download failed at 8 with -22
[ 1025.958867] usbcore: registered new interface driver dvb_usb_dtt200u

[    2.789902] dvb-usb: downloading firmware from file 'dvb-usb-wt220u-zl0353-01.fw'
[    2.789905] ------------[ cut here ]------------
[    2.789911] WARNING: CPU: 3 PID: 2196 at drivers/usb/core/hcd.c:1584 usb_hcd_map_urb_for_dma+0x430/0x560 [usbcore]
[    2.789912] transfer buffer not dma capable
[    2.789912] Modules linked in: btusb dvb_usb_dtt200u(+) dvb_usb_af9035(+) btrtl btbcm dvb_usb dvb_usb_v2 btintel dvb_core bluetooth rc_core rfkill x86_pkg_temp_thermal intel_powerclamp coretemp crc32_pclmul aesni_intel aes_x86_64 glue_helper lrw gf128mul ablk_helper cryptd drm_kms_helper syscopyarea sysfillrect pcspkr i2c_i801 sysimgblt fb_sys_fops drm i2c_smbus i2c_core r8169 lpc_ich mfd_core mii thermal fan rtc_cmos video button acpi_cpufreq processor snd_hda_codec_realtek snd_hda_codec_generic snd_hda_intel snd_hda_codec snd_hwdep snd_hda_core snd_pcm snd_timer snd crc32c_intel ahci libahci libata xhci_pci ehci_pci xhci_hcd ehci_hcd usbcore usb_common dm_mirror dm_region_hash dm_log dm_mod
[    2.789936] CPU: 3 PID: 2196 Comm: systemd-udevd Not tainted 4.9.0-gentoo #1
[    2.789937] Hardware name: ASUS All Series/H81I-PLUS, BIOS 0401 07/23/2013
[    2.789938]  ffffc9000339b690 ffffffff812bd397 ffffc9000339b6e0 0000000000000000
[    2.789939]  ffffc9000339b6d0 ffffffff81055c86 000006300339b6a0 ffff880116c0c000
[    2.789941]  0000000000000000 0000000000000000 0000000000000001 ffff880116c08000
[    2.789942] Call Trace:
[    2.789945]  [<ffffffff812bd397>] dump_stack+0x4d/0x66
[    2.789947]  [<ffffffff81055c86>] __warn+0xc6/0xe0
[    2.789948]  [<ffffffff81055cea>] warn_slowpath_fmt+0x4a/0x50
[    2.789952]  [<ffffffffa006d460>] usb_hcd_map_urb_for_dma+0x430/0x560 [usbcore]
[    2.789954]  [<ffffffff814ed5a8>] ? io_schedule_timeout+0xd8/0x110
[    2.789956]  [<ffffffffa006e09c>] usb_hcd_submit_urb+0x9c/0x980 [usbcore]
[    2.789958]  [<ffffffff812d0ebf>] ? copy_page_to_iter+0x14f/0x2b0
[    2.789960]  [<ffffffff81126818>] ? pagecache_get_page+0x28/0x240
[    2.789962]  [<ffffffff8118c2a0>] ? touch_atime+0x20/0xa0
[    2.789964]  [<ffffffffa006f7c4>] usb_submit_urb+0x2c4/0x520 [usbcore]
[    2.789967]  [<ffffffffa006feca>] usb_start_wait_urb+0x5a/0xe0 [usbcore]
[    2.789969]  [<ffffffffa007000c>] usb_control_msg+0xbc/0xf0 [usbcore]
[    2.789970]  [<ffffffffa067903d>] usb_cypress_writemem+0x3d/0x40 [dvb_usb]
[    2.789972]  [<ffffffffa06791cf>] usb_cypress_load_firmware+0x4f/0x130 [dvb_usb]
[    2.789973]  [<ffffffff8109dbbe>] ? console_unlock+0x2fe/0x5d0
[    2.789974]  [<ffffffff8109e10c>] ? vprintk_emit+0x27c/0x410
[    2.789975]  [<ffffffff8109e40a>] ? vprintk_default+0x1a/0x20
[    2.789976]  [<ffffffff81124d76>] ? printk+0x43/0x4b
[    2.789977]  [<ffffffffa0679310>] dvb_usb_download_firmware+0x60/0xd0 [dvb_usb]
[    2.789979]  [<ffffffffa0679898>] dvb_usb_device_init+0x3d8/0x610 [dvb_usb]
[    2.789981]  [<ffffffffa069e302>] dtt200u_usb_probe+0x92/0xd0 [dvb_usb_dtt200u]
[    2.789984]  [<ffffffffa007420c>] usb_probe_interface+0xfc/0x270 [usbcore]
[    2.789985]  [<ffffffff8138bf95>] driver_probe_device+0x215/0x2d0
[    2.789986]  [<ffffffff8138c0e6>] __driver_attach+0x96/0xa0
[    2.789987]  [<ffffffff8138c050>] ? driver_probe_device+0x2d0/0x2d0
[    2.789988]  [<ffffffff81389ffb>] bus_for_each_dev+0x5b/0x90
[    2.789989]  [<ffffffff8138b7b9>] driver_attach+0x19/0x20
[    2.789990]  [<ffffffff8138b33c>] bus_add_driver+0x11c/0x220
[    2.789991]  [<ffffffff8138c91b>] driver_register+0x5b/0xd0
[    2.789994]  [<ffffffffa0072f6c>] usb_register_driver+0x7c/0x130 [usbcore]
[    2.789994]  [<ffffffffa06a5000>] ? 0xffffffffa06a5000
[    2.789996]  [<ffffffffa06a501e>] dtt200u_usb_driver_init+0x1e/0x20 [dvb_usb_dtt200u]
[    2.789997]  [<ffffffff81000408>] do_one_initcall+0x38/0x140
[    2.789998]  [<ffffffff8116001c>] ? __vunmap+0x7c/0xc0
[    2.789999]  [<ffffffff81124fb0>] ? do_init_module+0x22/0x1d2
[    2.790000]  [<ffffffff81124fe8>] do_init_module+0x5a/0x1d2
[    2.790002]  [<ffffffff810c96b1>] load_module+0x1e11/0x2580
[    2.790003]  [<ffffffff810c68b0>] ? show_taint+0x30/0x30
[    2.790004]  [<ffffffff81177250>] ? kernel_read_file+0x100/0x190
[    2.790005]  [<ffffffff810c9ffa>] SyS_finit_module+0xba/0xc0
[    2.790007]  [<ffffffff814f13e0>] entry_SYSCALL_64_fastpath+0x13/0x94
[    2.790008] ---[ end trace c78a74e78baec6fc ]---

So, allocate the structure dynamically.

Cc: stable@vger.kernel.org
Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>

---

The original patch failed to apply on Kernel 4.9, due to a trivial change
inside an error message. Original upstream patch:

	43fab9793c1f [media] dvb-usb: don't use stack for firmware load

Greg,

There is one additional fix for dvb-usb-firmware for it to work fine with
non-DMA capable stack. I'm submitting it upstream later today. It should 
apply fine after this one (I tested).

diff --git a/drivers/media/usb/dvb-usb/dvb-usb-firmware.c b/drivers/media/usb/dvb-usb/dvb-usb-firmware.c
index dd048a7c461c..9fc91cd2e029 100644
--- a/drivers/media/usb/dvb-usb/dvb-usb-firmware.c
+++ b/drivers/media/usb/dvb-usb/dvb-usb-firmware.c
@@ -35,29 +35,34 @@ static int usb_cypress_writemem(struct usb_device *udev,u16 addr,u8 *data, u8 le
 
 int usb_cypress_load_firmware(struct usb_device *udev, const struct firmware *fw, int type)
 {
-	struct hexline hx;
+	struct hexline *hx;
 	u8 reset;
 	int ret,pos=0;
 
+	hx = kmalloc(sizeof(*hx), GFP_KERNEL);
+	if (!hx)
+		return -ENOMEM;
+
 	/* stop the CPU */
 	reset = 1;
 	if ((ret = usb_cypress_writemem(udev,cypress[type].cpu_cs_register,&reset,1)) != 1)
 		err("could not stop the USB controller CPU.");
 
-	while ((ret = dvb_usb_get_hexline(fw,&hx,&pos)) > 0) {
-		deb_fw("writing to address 0x%04x (buffer: 0x%02x %02x)\n",hx.addr,hx.len,hx.chk);
-		ret = usb_cypress_writemem(udev,hx.addr,hx.data,hx.len);
+	while ((ret = dvb_usb_get_hexline(fw, hx, &pos)) > 0) {
+		deb_fw("writing to address 0x%04x (buffer: 0x%02x %02x)\n", hx->addr, hx->len, hx->chk);
+		ret = usb_cypress_writemem(udev, hx->addr, hx->data, hx->len);
 
-		if (ret != hx.len) {
+		if (ret != hx->len) {
 			err("error while transferring firmware "
 				"(transferred size: %d, block size: %d)",
-				ret,hx.len);
+				ret, hx->len);
 			ret = -EINVAL;
 			break;
 		}
 	}
 	if (ret < 0) {
 		err("firmware download failed at %d with %d",pos,ret);
+		kfree(hx);
 		return ret;
 	}
 
@@ -71,6 +76,8 @@ int usb_cypress_load_firmware(struct usb_device *udev, const struct firmware *fw
 	} else
 		ret = -EIO;
 
+	kfree(hx);
+
 	return ret;
 }
 EXPORT_SYMBOL(usb_cypress_load_firmware);
