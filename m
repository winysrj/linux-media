Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ia0-f180.google.com ([209.85.210.180]:37416 "EHLO
	mail-ia0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751438Ab3BQGTf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 17 Feb 2013 01:19:35 -0500
Received: by mail-ia0-f180.google.com with SMTP id f27so4322790iae.39
        for <linux-media@vger.kernel.org>; Sat, 16 Feb 2013 22:19:34 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <201302071336.25366.hverkuil@xs4all.nl>
References: <201302071336.25366.hverkuil@xs4all.nl>
Date: Sun, 17 Feb 2013 14:19:34 +0800
Message-ID: <CAMiH66Hy5mP-8Y0xek4L-7XRLXUnRP4taqNLegUE_Z=GHeMhiQ@mail.gmail.com>
Subject: Re: [RFC PATCHv2 01/18] tlg2300: use correct device parent.
From: Huang Shijie <shijie8@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Feb 7, 2013 at 8:36 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> Set the correct parent for v4l2_device_register and don't set the name
> anymore (that's now deduced from the parent). Also remove an unnecessary
> forward reference and fix two weird looking log messages.
>
> Changes since v1: don't set v4l2_dev.name anymore as per Huang's suggestion.
> Huang: can you Ack this?
>
> Regards,
>
>         Hans
>
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  drivers/media/usb/tlg2300/pd-main.c |   13 ++++---------
>  1 file changed, 4 insertions(+), 9 deletions(-)
>
> diff --git a/drivers/media/usb/tlg2300/pd-main.c b/drivers/media/usb/tlg2300/pd-main.c
> index 7b1f6eb..247d6ac 100644
> --- a/drivers/media/usb/tlg2300/pd-main.c
> +++ b/drivers/media/usb/tlg2300/pd-main.c
> @@ -55,7 +55,6 @@ MODULE_PARM_DESC(debug_mode, "0 = disable, 1 = enable, 2 = verbose");
>
>  #define TLG2300_FIRMWARE "tlg2300_firmware.bin"
>  static const char *firmware_name = TLG2300_FIRMWARE;
> -static struct usb_driver poseidon_driver;
>  static LIST_HEAD(pd_device_list);
>
>  /*
> @@ -316,7 +315,7 @@ static int poseidon_suspend(struct usb_interface *intf, pm_message_t msg)
>                 if (get_pm_count(pd) <= 0 && !in_hibernation(pd)) {
>                         pd->msg.event = PM_EVENT_AUTO_SUSPEND;
>                         pd->pm_resume = NULL; /*  a good guard */
> -                       printk(KERN_DEBUG "\n\t+ TLG2300 auto suspend +\n\n");
> +                       printk(KERN_DEBUG "TLG2300 auto suspend\n");
>                 }
>                 return 0;
>         }
> @@ -331,7 +330,7 @@ static int poseidon_resume(struct usb_interface *intf)
>
>         if (!pd)
>                 return 0;
> -       printk(KERN_DEBUG "\n\t ++ TLG2300 resume ++\n\n");
> +       printk(KERN_DEBUG "TLG2300 resume\n");
>
>         if (!is_working(pd)) {
>                 if (PM_EVENT_AUTO_SUSPEND == pd->msg.event)
> @@ -431,15 +430,11 @@ static int poseidon_probe(struct usb_interface *interface,
>         usb_set_intfdata(interface, pd);
>
>         if (new_one) {
> -               struct device *dev = &interface->dev;
> -
>                 logpm(pd);
>                 mutex_init(&pd->lock);
>
>                 /* register v4l2 device */
> -               snprintf(pd->v4l2_dev.name, sizeof(pd->v4l2_dev.name), "%s %s",
> -                       dev->driver->name, dev_name(dev));
> -               ret = v4l2_device_register(NULL, &pd->v4l2_dev);
> +               ret = v4l2_device_register(&interface->dev, &pd->v4l2_dev);
>
>                 /* register devices in directory /dev */
>                 ret = pd_video_init(pd);
> @@ -530,7 +525,7 @@ module_init(poseidon_init);
>  module_exit(poseidon_exit);
>
>  MODULE_AUTHOR("Telegent Systems");
> -MODULE_DESCRIPTION("For tlg2300-based USB device ");
> +MODULE_DESCRIPTION("For tlg2300-based USB device");
>  MODULE_LICENSE("GPL");
>  MODULE_VERSION("0.0.2");
>  MODULE_FIRMWARE(TLG2300_FIRMWARE);
> --
> 1.7.10.4
>
sorry for the later reply. I was on vacation.

Acked-by: Huang Shijie <shijie8@gmail.com>
