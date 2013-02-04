Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:2826 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753691Ab3BDIlK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Feb 2013 03:41:10 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Huang Shijie <shijie8@gmail.com>
Subject: Re: [RFC PATCH 01/18] tlg2300: use correct device parent.
Date: Mon, 4 Feb 2013 09:40:57 +0100
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
References: <1359627936-14918-1-git-send-email-hverkuil@xs4all.nl> <608a45800f829b97fcc5c00b1decc64c829d71cb.1359627298.git.hans.verkuil@cisco.com> <510F1FA0.8030500@gmail.com>
In-Reply-To: <510F1FA0.8030500@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="gb18030"
Content-Transfer-Encoding: 8BIT
Message-Id: <201302040940.57718.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon February 4 2013 03:40:32 Huang Shijie wrote:
> 于 2013年01月31日 05:25, Hans Verkuil 写道:
> > From: Hans Verkuil <hans.verkuil@cisco.com>
> >
> > Set the correct parent for v4l2_device_register. Also remove an unnecessary
> > forward reference and fix two weird looking log messages.
> >
> > Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> > ---
> >  drivers/media/usb/tlg2300/pd-main.c |    9 ++++-----
> >  1 file changed, 4 insertions(+), 5 deletions(-)
> >
> > diff --git a/drivers/media/usb/tlg2300/pd-main.c b/drivers/media/usb/tlg2300/pd-main.c
> > index 7b1f6eb..c4eb57a 100644
> > --- a/drivers/media/usb/tlg2300/pd-main.c
> > +++ b/drivers/media/usb/tlg2300/pd-main.c
> > @@ -55,7 +55,6 @@ MODULE_PARM_DESC(debug_mode, "0 = disable, 1 = enable, 2 = verbose");
> >  
> >  #define TLG2300_FIRMWARE "tlg2300_firmware.bin"
> >  static const char *firmware_name = TLG2300_FIRMWARE;
> > -static struct usb_driver poseidon_driver;
> >  static LIST_HEAD(pd_device_list);
> >  
> >  /*
> > @@ -316,7 +315,7 @@ static int poseidon_suspend(struct usb_interface *intf, pm_message_t msg)
> >  		if (get_pm_count(pd) <= 0 && !in_hibernation(pd)) {
> >  			pd->msg.event = PM_EVENT_AUTO_SUSPEND;
> >  			pd->pm_resume = NULL; /*  a good guard */
> > -			printk(KERN_DEBUG "\n\t+ TLG2300 auto suspend +\n\n");
> > +			printk(KERN_DEBUG "TLG2300 auto suspend\n");
> >  		}
> >  		return 0;
> >  	}
> > @@ -331,7 +330,7 @@ static int poseidon_resume(struct usb_interface *intf)
> >  
> >  	if (!pd)
> >  		return 0;
> > -	printk(KERN_DEBUG "\n\t ++ TLG2300 resume ++\n\n");
> > +	printk(KERN_DEBUG "TLG2300 resume\n");
> >  
> >  	if (!is_working(pd)) {
> >  		if (PM_EVENT_AUTO_SUSPEND == pd->msg.event)
> > @@ -439,7 +438,7 @@ static int poseidon_probe(struct usb_interface *interface,
> >  		/* register v4l2 device */
> >  		snprintf(pd->v4l2_dev.name, sizeof(pd->v4l2_dev.name), "%s %s",
> >  			dev->driver->name, dev_name(dev));
> I think this line could be removed in this patch too. The
> v4l2_device_register() will assign the v4l2_dev->name if it's empty.

I agree, I'll remove this in the next version.

Regards,

	Hans

> 
> thanks
> Huang Shijie
> > -		ret = v4l2_device_register(NULL, &pd->v4l2_dev);
> > +		ret = v4l2_device_register(&interface->dev, &pd->v4l2_dev);
> >  
> >  		/* register devices in directory /dev */
> >  		ret = pd_video_init(pd);
> > @@ -530,7 +529,7 @@ module_init(poseidon_init);
> >  module_exit(poseidon_exit);
> >  
> >  MODULE_AUTHOR("Telegent Systems");
> > -MODULE_DESCRIPTION("For tlg2300-based USB device ");
> > +MODULE_DESCRIPTION("For tlg2300-based USB device");
> >  MODULE_LICENSE("GPL");
> >  MODULE_VERSION("0.0.2");
> >  MODULE_FIRMWARE(TLG2300_FIRMWARE);
> 
