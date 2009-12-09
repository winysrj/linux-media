Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:1026 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756455AbZLISMa (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 9 Dec 2009 13:12:30 -0500
Message-ID: <4B1FE890.2020201@redhat.com>
Date: Wed, 09 Dec 2009 16:12:32 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Huang Shijie <shijie8@gmail.com>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH 06/11] add the generic file
References: <1258687493-4012-1-git-send-email-shijie8@gmail.com> <1258687493-4012-2-git-send-email-shijie8@gmail.com> <1258687493-4012-3-git-send-email-shijie8@gmail.com> <1258687493-4012-4-git-send-email-shijie8@gmail.com> <1258687493-4012-5-git-send-email-shijie8@gmail.com> <1258687493-4012-6-git-send-email-shijie8@gmail.com> <1258687493-4012-7-git-send-email-shijie8@gmail.com>
In-Reply-To: <1258687493-4012-7-git-send-email-shijie8@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Sorry for not analysing this module earlier.

The way you ordered your patch series is weird and will break git bisect,
if committed on your order. So, I'm starting analizing with this patch.
I'll let the initial ones to the end.

You should send Makefile/Kconfig changes at the end of the patch series, to
avoid breaking compilation in the middle of your patch series.



Cheers,
Mauro.

Huang Shijie wrote:
> pd-main.c contains the ->probe(), it privides the generic
> functions for analog TV,DVB-T and radio.
> 
> Signed-off-by: Huang Shijie <shijie8@gmail.com>
> ---
>  drivers/media/video/tlg2300/pd-main.c |  546 +++++++++++++++++++++++++++++++++
>  1 files changed, 546 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/media/video/tlg2300/pd-main.c
> 
> diff --git a/drivers/media/video/tlg2300/pd-main.c b/drivers/media/video/tlg2300/pd-main.c
> new file mode 100644
> index 0000000..f997e2d
> --- /dev/null
> +++ b/drivers/media/video/tlg2300/pd-main.c
> @@ -0,0 +1,546 @@
> +/*
> + * device driver for Telegent tlg2300 based TV cards
> + *
> + * Author :
> + * 	Kang Yong	<kangyong@telegent.com>
> + * 	Zhang Xiaobing	<xbzhang@telegent.com>
> + * 	Huang Shijie	<zyziii@telegent.com> or <shijie8@hotmail.com>
> + *
> + *	(c) 2009 Telegent Systems
> + *
> + *  This program is free software; you can redistribute it and/or modify
> + *  it under the terms of the GNU General Public License as published by
> + *  the Free Software Foundation; either version 2 of the License, or
> + *  (at your option) any later version.
> + *
> + *  This program is distributed in the hope that it will be useful,
> + *  but WITHOUT ANY WARRANTY; without even the implied warranty of
> + *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + *  GNU General Public License for more details.
> + *
> + *  You should have received a copy of the GNU General Public License
> + *  along with this program; if not, write to the Free Software
> + *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
> + */
> +
> +#include <linux/version.h>
> +#include <linux/kernel.h>
> +#include <linux/errno.h>
> +#include <linux/init.h>
> +#include <linux/slab.h>
> +#include <linux/module.h>
> +#include <linux/kref.h>
> +#include <linux/usb.h>
> +#include <linux/suspend.h>
> +#include <linux/usb/quirks.h>
> +#include <linux/ctype.h>
> +#include <linux/string.h>
> +#include <linux/types.h>
> +#include <linux/firmware.h>
> +#include <linux/smp_lock.h>
> +#include "vendorcmds.h"
> +#include "pd-common.h"
> +
> +#define VENDOR_ID	0x1B24
> +#define PRODUCT_ID	0x4001
> +static struct usb_device_id id_table[] = {
> +	{ USB_DEVICE_AND_INTERFACE_INFO(VENDOR_ID, PRODUCT_ID, 255, 1, 0) },
> +	{ USB_DEVICE_AND_INTERFACE_INFO(VENDOR_ID, PRODUCT_ID, 255, 1, 1) },
> +	{ },
> +};
> +MODULE_DEVICE_TABLE(usb, id_table);
> +
> +int debug_mode;
> +module_param(debug_mode, int, 0644);
> +MODULE_PARM_DESC(debug_mode, "0 = disable, 1 = enable, 2 = verbose");
> +
> +const char *firmware_name = "tlg2300_firmware.bin";
> +struct usb_driver poseidon_driver;
> +LIST_HEAD(pd_device_list); /*should add a lock*/
> +
> +/*
> + * send set request to USB firmware.
> + */
> +s32 send_set_req(struct poseidon *pd, u8 cmdid, s32 param, s32 *cmd_status)
> +{
> +	s32 ret;
> +	s8  data[32] = {};
> +	u16 lower_16, upper_16;
> +
> +	if (pd->state & POSEIDON_STATE_DISCONNECT)
> +		return -ENODEV;
> +
> +	mdelay(30);
> +
> +	if (param == 0) {
> +		upper_16 = lower_16 = 0;
> +	} else {
> +		/* send 32 bit param as  two 16 bit param,little endian */
> +		lower_16 = (unsigned short)(param & 0xffff);
> +		upper_16 = (unsigned short)((param >> 16) & 0xffff);
> +	}
> +	ret = usb_control_msg(pd->udev,
> +			 usb_rcvctrlpipe(pd->udev, 0),
> +			 REQ_SET_CMD | cmdid,
> +			 USB_DIR_IN | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
> +			 lower_16,
> +			 upper_16,
> +			 &data,
> +			 sizeof(*cmd_status),
> +			 USB_CTRL_GET_TIMEOUT);
> +
> +	if (!ret) {
> +		return -ENXIO;
> +	} else {
> +		/*  1st 4 bytes into cmd_status   */
> +		memcpy((char *)cmd_status, &(data[0]), sizeof(*cmd_status));
> +	}
> +	return 0;
> +}
> +
> +/*
> + * send get request to Poseidon firmware.
> + */
> +s32 send_get_req(struct poseidon *pd, u8 cmdid, s32 param,
> +			void *buf, s32 *cmd_status, s32 datalen)
> +{
> +	s32 ret;
> +	s8 data[128] = {};
> +	u16 lower_16, upper_16;
> +
> +	if (pd->state & POSEIDON_STATE_DISCONNECT)
> +		return -ENODEV;
> +
> +	mdelay(30);
> +	if (param == 0) {
> +		upper_16 = lower_16 = 0;
> +	} else {
> +		/*send 32 bit param as two 16 bit param, little endian */
> +		lower_16 = (unsigned short)(param & 0xffff);
> +		upper_16 = (unsigned short)((param >> 16) & 0xffff);
> +	}

You're using host endian here, not little endian. If you want to use little endian,
you should be defining lower_16 and upper_16 as:
	__le16 lower_16, upper_16;

And use the following macros to convert from cpu host endian from/into le16:
	le16_to_cpu()
	cpu_to_le16()

Otherwise, the driver will work only on little endian architectures.

The same comment applies to all other places where you need little endian.

It should be noticed, however, that usb_control_msg already take care of little
endian for you (drivers/usb/core/message.c):
 
        dr->wValue = cpu_to_le16(value);
        dr->wIndex = cpu_to_le16(index);
        dr->wLength = cpu_to_le16(size);

So, in this specific case, just the comments are wrong.

> +	ret = usb_control_msg(pd->udev,
> +			 usb_rcvctrlpipe(pd->udev, 0),
> +			 REQ_GET_CMD | cmdid,
> +			 USB_DIR_IN | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
> +			 lower_16,
> +			 upper_16,
> +			 &data,
> +			 (datalen + sizeof(*cmd_status)),
> +			 USB_CTRL_GET_TIMEOUT);
> +
> +	if (ret < 0) {
> +		return -ENXIO;
> +	} else {
> +		/* 1st 4 bytes into cmd_status, remaining data into cmd_data */
> +		memcpy((char *)cmd_status, &data[0], sizeof(*cmd_status));
> +		memcpy((char *)buf, &data[sizeof(*cmd_status)], datalen);
> +	}
> +	return 0;
> +}
> +
> +static int pm_notifier_block(struct notifier_block *nb,
> +				unsigned long event, void *dummy)
> +{
> +	struct poseidon *pd = NULL;
> +	struct list_head *node, *next;
> +
> +	switch (event) {
> +	case PM_POST_HIBERNATION:
> +		list_for_each_safe(node, next, &pd_device_list) {
> +			struct usb_device *udev;
> +			struct usb_interface *iface;
> +			int rc = 0;
> +
> +			pd = container_of(node, struct poseidon, device_list);
> +			udev = pd->udev;
> +			iface = pd->interface;
> +
> +			rc = usb_lock_device_for_reset(udev, iface);
> +			if (rc >= 0) {
> +				usb_reset_device(udev);
> +				usb_unlock_device(udev);
> +			}
> +		}
> +		break;
> +	case PM_HIBERNATION_PREPARE:
> +		list_for_each_entry(pd, &pd_device_list, device_list) {
> +			if (pd->interface->pm_usage_cnt <= 0) {
> +				pd->state |= POSEIDON_STATE_IDLE_HIBERANTION;
> +				usb_autopm_get_interface(pd->interface);
> +			}
> +			/* for audio */
> +			if (pd->audio.users)
> +				pd->audio.pm_state = 1;
> +		}
> +		break;
> +	default:
> +		log("event :%ld\n", event);
> +	}
> +	return 0;
> +}
> +
> +static struct notifier_block pm_notifer = {
> +	.notifier_call = pm_notifier_block,
> +};
> +
> +int usb_softrst(struct poseidon *pd, s32 udelay)
> +{
> +	s32 ret = 0;
> +	s32 cmd_status = 0;
> +
> +	if (pd->state & POSEIDON_STATE_DISCONNECT)
> +		return -ENODEV;
> +
> +	ret = send_set_req(pd, CMD_CHIP_RST, udelay, &cmd_status);
> +	if (ret || cmd_status)
> +		return -ENXIO;
> +	return ret;
> +}
> +
> +int set_tuner_mode(struct poseidon *pd, unsigned char mode)
> +{
> +	s32 ret, cmd_status;
> +
> +	if (pd->state & POSEIDON_STATE_DISCONNECT)
> +		return -ENODEV;
> +
> +	ret = send_set_req(pd, TUNE_MODE_SELECT, mode, &cmd_status);
> +	if (ret || cmd_status)
> +		return -ENXIO;
> +	return 0;
> +}
> +
> +enum tlg__analog_audio_standard get_audio_std(s32 mode, s32 country_code)
> +{
> +	s32 nicam[] = {27, 32, 33, 34, 36, 44, 45, 46, 47, 48, 64,
> +			65, 86, 351, 352, 353, 354, 358, 372, 852, 972};
> +	s32 btsc[] = {1, 52, 54, 55, 886};
> +	s32 eiaj[] = {81};
> +	s32 i;
> +
> +	if (mode == TLG_MODE_FM_RADIO) {
> +		if (country_code == 1)
> +			return TLG_TUNE_ASTD_FM_US;
> +		else
> +			return TLG_TUNE_ASTD_FM_EUR;
> +	} else if (mode == TLG_MODE_ANALOG_TV_UNCOMP) {
> +		for (i = 0; i < sizeof(nicam) / sizeof(s32); i++) {
> +			if (country_code == nicam[i])
> +				return TLG_TUNE_ASTD_NICAM;
> +		}
> +
> +		for (i = 0; i < sizeof(btsc) / sizeof(s32); i++) {
> +			if (country_code == btsc[i])
> +				return TLG_TUNE_ASTD_BTSC;
> +		}
> +
> +		for (i = 0; i < sizeof(eiaj) / sizeof(s32); i++) {
> +			if (country_code == eiaj[i])
> +				return TLG_TUNE_ASTD_EIAJ;
> +		}
> +
> +		return TLG_TUNE_ASTD_A2;
> +	} else {
> +		return TLG_TUNE_ASTD_NONE;
> +	}
> +}
> +
> +void poseidon_delete(struct kref *kref)
> +{
> +	struct poseidon *pd = container_of(kref, struct poseidon, kref);
> +
> +	if (!pd)
> +		return;
> +	list_del(&pd->device_list);
> +
> +	pd_dvb_usb_device_cleanup(pd);
> +	/* clean_audio_data(&pd->audio_data);*/
> +
> +	if (pd->udev) {
> +		usb_put_dev(pd->udev);
> +		pd->udev = NULL;
> +	}
> +	if (pd->interface) {
> +		usb_put_intf(pd->interface);
> +		pd->interface = NULL;
> +	}
> +	kfree(pd);
> +	log();
> +}
> +
> +static int firmware_download(struct usb_device *udev)
> +{
> +	int ret = 0, actual_length;
> +	const struct firmware *fw = NULL;
> +	void *fwbuf = NULL;
> +	size_t fwlength = 0, offset;
> +	size_t max_packet_size;
> +
> +	ret = request_firmware(&fw, firmware_name, &udev->dev);
> +	if (ret) {
> +		log("download err : %d", ret);
> +		return ret;
> +	}
> +
> +	fwlength = fw->size;
> +
> +	fwbuf = kzalloc(fwlength, GFP_KERNEL);
> +	if (!fwbuf) {
> +		ret = -ENOMEM;
> +		goto out;
> +	}
> +	memcpy(fwbuf, fw->data, fwlength);
> +
> +	max_packet_size = udev->ep_out[0x1]->desc.wMaxPacketSize;
> +	log("\t\t download size : %d", (int)max_packet_size);
> +
> +	for (offset = 0; offset < fwlength; offset += max_packet_size) {
> +		actual_length = 0;
> +		ret = usb_bulk_msg(udev,
> +				usb_sndbulkpipe(udev, 0x01), /* ep 1 */
> +				fwbuf + offset,
> +				min(max_packet_size, fwlength - offset),
> +				&actual_length,
> +				HZ * 10);
> +		if (ret)
> +			break;
> +	}
> +	kfree(fwbuf);
> +out:
> +	release_firmware(fw);
> +	return ret;
> +}
> +
> +/* one-to-one map : poseidon{} <----> usb_device{}'s port */
> +static inline void set_map_flags(struct poseidon *pd, struct usb_device *udev)
> +{
> +	pd->portnum = udev->portnum;
> +}
> +
> +/* fixup something for poseidon */
> +static inline struct poseidon *fixup(struct poseidon *pd)
> +{
> +	list_del(&pd->device_list);
> +
> +	kref_get(&pd->kref);
> +
> +	/* old udev and interface have gone, so put back reference . */
> +	usb_put_dev(pd->udev);
> +	usb_put_intf(pd->interface);
> +	usb_autopm_set_interface(pd->interface);
> +
> +	log("event : %d\n", pd->msg.event);
> +	return pd;
> +}
> +
> +static struct poseidon *find_old_poseidon(struct usb_device *udev)
> +{
> +	struct poseidon *pd;
> +
> +	list_for_each_entry(pd, &pd_device_list, device_list) {
> +		if (pd->portnum == udev->portnum && in_hibernation(pd))
> +			return fixup(pd);
> +	}
> +	return NULL;
> +}
> +
> +#ifdef CONFIG_PM
> +/* Is the card working now ? */
> +static inline int is_working(struct poseidon *pd)
> +{
> +	if (pd->state & POSEIDON_STATE_IDLE_HIBERANTION)
> +		return 0;
> +	return pd->interface->pm_usage_cnt > 0;
> +}
> +
> +static int poseidon_suspend(struct usb_interface *intf, pm_message_t msg)
> +{
> +	struct poseidon *pd = usb_get_intfdata(intf);
> +
> +	if (!is_working(pd)) {
> +		if (pd->interface->pm_usage_cnt <= 0
> +			&& !in_hibernation(pd)) {
> +			pd->msg.event = PM_EVENT_AUTO_SUSPEND;
> +			pd->pm_resume = NULL; /*  a good guard */
> +			printk(KERN_DEBUG "\n\t ++ TLG2300 auto suspend ++\n");
> +		}
> +		return 0;
> +	}
> +	pd->msg = msg;
> +	return pd->pm_suspend ? pd->pm_suspend(pd) : 0;
> +}
> +
> +static int poseidon_resume(struct usb_interface *intf)
> +{
> +	struct poseidon *pd = usb_get_intfdata(intf);
> +
> +	printk(KERN_DEBUG "\n\t ++ TLG2300 resume ++\n");
> +	if (!is_working(pd)) {
> +		if (PM_EVENT_AUTO_SUSPEND == pd->msg.event)
> +			pd->msg = PMSG_ON;
> +		return 0;
> +	}
> +	return pd->pm_resume ? pd->pm_resume(pd) : 0;
> +}
> +
> +static void hibernation_resume(struct work_struct *w)
> +{
> +	struct poseidon *pd = container_of(w, struct poseidon, pm_work);
> +
> +	log();
> +	pd->msg.event = 0; /* clear it here */
> +	pd->state &= ~POSEIDON_STATE_DISCONNECT;
> +
> +	/*
> +	 *  we hibernated in the order : close() --> disconnect()
> +	 *  so now ,we must do in reverse order : open() --> resume();
> +	 */
> +	if (!pd->pm_open(pd->file_for_stream))
> +		pd->pm_resume(pd);
> +}
> +#endif
> +
> +static bool check_firmware(struct usb_device *udev, int *down_firmware)
> +{
> +	void *buf;
> +	int ret;
> +	struct cmd_firmware_vers_s *cmd_firm;
> +
> +	buf = kzalloc(sizeof(*cmd_firm) + sizeof(u32), GFP_KERNEL);
> +	if (!buf)
> +		return -ENOMEM;
> +	ret = usb_control_msg(udev,
> +			 usb_rcvctrlpipe(udev, 0),
> +			 REQ_GET_CMD | GET_FW_ID,
> +			 USB_DIR_IN | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
> +			 0,
> +			 0,
> +			 buf,
> +			 sizeof(*cmd_firm) + sizeof(u32),
> +			 USB_CTRL_GET_TIMEOUT);
> +	kfree(buf);
> +
> +	if (ret < 0) {
> +		*down_firmware = 1;
> +		return firmware_download(udev);
> +	}
> +	return ret;
> +}
> +
> +static int poseidon_probe(struct usb_interface *interface,
> +				const struct usb_device_id *id)
> +{
> +	struct usb_device *udev = interface_to_usbdev(interface);
> +	struct poseidon *pd = NULL;
> +	int ret = 0;
> +
> +	check_firmware(udev, &ret);
> +	if (ret)
> +		return 0;
> +
> +	pd = find_old_poseidon(udev);
> +	if (!pd) {
> +		pd = kzalloc(sizeof(*pd), GFP_KERNEL);
> +		if (!pd)
> +			return -ENOMEM;
> +		kref_init(&pd->kref);
> +		set_map_flags(pd, udev);
> +	}
> +
> +	pd->udev = usb_get_dev(udev);
> +	pd->interface = usb_get_intf(interface);
> +	pd->country_code = 86;
> +	usb_set_intfdata(interface, pd);
> +	mutex_init(&pd->lock);
> +
> +	/* register devices in /dev */
> +	pd_video_init(pd);
> +	poseidon_audio_init(pd);
> +	vbi_init(pd);
> +
> +	poseidon_fm_init(pd);
> +	pd_dvb_usb_device_init(pd);
> +
> +	INIT_LIST_HEAD(&pd->device_list);
> +	list_add_tail(&pd->device_list, &pd_device_list);
> +
> +	device_init_wakeup(&udev->dev, 1);
> +#ifdef CONFIG_PM
> +	pd->udev->autosuspend_disabled = 0;
> +	pd->udev->autoresume_disabled = 0;
> +	pd->udev->autosuspend_delay = HZ * PM_SUSPEND_DELAY;
> +
> +	if (in_hibernation(pd)) {
> +		INIT_WORK(&pd->pm_work, hibernation_resume);
> +		schedule_work(&pd->pm_work);
> +	}
> +#endif
> +	return 0;
> +}
> +
> +static void poseidon_disconnect(struct usb_interface *interface)
> +{
> +	struct poseidon *pd = usb_get_intfdata(interface);
> +
> +	if (!pd)
> +		return;
> +
> +	mutex_lock(&pd->lock);
> +	pd->state |= POSEIDON_STATE_DISCONNECT;
> +	mutex_unlock(&pd->lock);
> +
> +	/* stop urb transferring */
> +	pd_video_stop_stream(pd);
> +	dvb_stop_streaming(&pd->dvb_data);
> +
> +	lock_kernel();

Don't use KBL. It will be removed soon (likely on 2.6.34), so no new
drivers should use it anymore.

> +	{
> +		pd_dvb_usb_device_exit(pd);
> +		poseidon_fm_exit(pd);
> +
> +		vbi_exit(pd);
> +		poseidon_audio_free(pd);
> +		pd_video_exit(pd);
> +	}
> +	unlock_kernel();

Same here.

> +
> +	usb_set_intfdata(interface, NULL);
> +	kref_put(&pd->kref, poseidon_delete);
> +}
> +
> +struct usb_driver poseidon_driver = {
> +	.name		= "poseidon",
> +	.probe		= poseidon_probe,
> +	.disconnect	= poseidon_disconnect,
> +	.id_table	= id_table,
> +#ifdef CONFIG_PM
> +	.suspend	= poseidon_suspend,
> +	.resume		= poseidon_resume,
> +#endif
> +	.supports_autosuspend = 1,
> +};
> +
> +static int __init poseidon_init(void)
> +{
> +	int ret;
> +
> +	ret = usb_register(&poseidon_driver);
> +	if (ret)
> +		return ret;
> +	register_pm_notifier(&pm_notifer);
> +	return ret;
> +}
> +
> +static void __exit poseidon_exit(void)
> +{
> +	unregister_pm_notifier(&pm_notifer);
> +	usb_deregister(&poseidon_driver);
> +}
> +
> +module_init(poseidon_init);
> +module_exit(poseidon_exit);
> +
> +MODULE_AUTHOR("Telegent Systems");
> +MODULE_DESCRIPTION("For tlg2300-based USB device ");
> +MODULE_LICENSE("GPL");

