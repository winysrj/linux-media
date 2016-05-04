Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:41780 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752702AbcEDVvS (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 4 May 2016 17:51:18 -0400
Date: Wed, 4 May 2016 18:51:12 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
	Stefan Lippers-Hollmann <s.l-h@gmx.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL for v4.6-rc1] media updates
Message-ID: <20160504185112.70ea985b@recife.lan>
In-Reply-To: <CA+55aFxQSUHBvOSqyiqdt2faY6VZSXP0p-cPzRm+km=fk7z4kQ@mail.gmail.com>
References: <20160315080552.3cc5d146@recife.lan>
	<20160503233859.0f6506fa@mir>
	<CA+55aFxAor=MJSGFkynu72AQN75bNTh9kewLR4xe8CpjHQQvZQ@mail.gmail.com>
	<20160504063902.0af2f4d7@mir>
	<CA+55aFyE82Hi29az_MG9oG0=AEg1o++Wng_DO2RvNHQsSOz87g@mail.gmail.com>
	<20160504212845.21dab7c8@mir>
	<CA+55aFxQSUHBvOSqyiqdt2faY6VZSXP0p-cPzRm+km=fk7z4kQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 4 May 2016 13:49:52 -0700
Linus Torvalds <torvalds@linux-foundation.org> escreveu:

> On Wed, May 4, 2016 at 12:28 PM, Stefan Lippers-Hollmann <s.l-h@gmx.de> wrote:
> >
> > --- a/drivers/media/media-device.c
> > +++ b/drivers/media/media-device.c
> > @@ -875,7 +875,7 @@ void __media_device_usb_init(struct medi
> >                              const char *board_name,
> >                              const char *driver_name)
> >  {
> > -#ifdef CONFIG_USB
> > +#if defined(CONFIG_USB) || defined(CONFIG_USB_MODULE)
> 
> Ok, that should be fine. Can you verify that it builds and works even
> if USB isn't compiled in, but the media core code is?
> 
> IOW, can you test the
> 
>   CONFIG_USB=m
>   CONFIG_MEDIA_CONTROLLER=y
>   CONFIG_MEDIA_SUPPORT=y
> 
> case? Judging by your oops stack trace, I think you currently have
> MEDIA_SUPPORT=m.

I think we could use, instead:

#if IS_REACHABLE(CONFIG_USB)

This macro is defined as:
	/*
 	 * IS_REACHABLE(CONFIG_FOO) evaluates to 1 if the currently compiled
 	 * code can call a function defined in code compiled based on CONFIG_FOO.
 	 * This is similar to IS_ENABLED(), but returns false when invoked from
 	 * built-in code when CONFIG_FOO is set to 'm'.
 	 */
	#define IS_REACHABLE(option) (config_enabled(option) || \
		 (config_enabled(option##_MODULE) && config_enabled(MODULE)))

And we use it already on other places where we have dependencies
like that.



Btw, there are also some helper function there to initialize
for PCI devices.

> Also, I do wonder if we should move that #if to _outside_ the
> function. Because inside the function, things will compile but
> silently not work (like you found), if it is ever mis-used. Outside
> that function, you'll get link-errors if you try to misuse that
> function.

Yeah, that makes sense. This function is a helper function that
it is used only when CONFIG_USB.

The following (untested) patch should do the work.

Stefan,

Could you please test the enclosed patch?

Regards,
Mauro

[media] media-device: fix builds when USB or PCI is compiled as module

Just checking ifdef CONFIG_USB is not enough, if the USB is compiled
as module. The same applies to PCI.

Compile-tested only.

So, change the logic to use, instead, IS_REACHABLE.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
index b84825715f98..8c1f80ff33e3 100644
--- a/drivers/media/media-device.c
+++ b/drivers/media/media-device.c
@@ -842,11 +842,11 @@ struct media_device *media_device_find_devres(struct device *dev)
 }
 EXPORT_SYMBOL_GPL(media_device_find_devres);
 
+#if IS_REACHABLE(CONFIG_PCI)
 void media_device_pci_init(struct media_device *mdev,
 			   struct pci_dev *pci_dev,
 			   const char *name)
 {
-#ifdef CONFIG_PCI
 	mdev->dev = &pci_dev->dev;
 
 	if (name)
@@ -862,16 +862,16 @@ void media_device_pci_init(struct media_device *mdev,
 	mdev->driver_version = LINUX_VERSION_CODE;
 
 	media_device_init(mdev);
-#endif
 }
 EXPORT_SYMBOL_GPL(media_device_pci_init);
+#endif
 
+#if IS_REACHABLE(CONFIG_USB)
 void __media_device_usb_init(struct media_device *mdev,
 			     struct usb_device *udev,
 			     const char *board_name,
 			     const char *driver_name)
 {
-#ifdef CONFIG_USB
 	mdev->dev = &udev->dev;
 
 	if (driver_name)
@@ -891,9 +891,9 @@ void __media_device_usb_init(struct media_device *mdev,
 	mdev->driver_version = LINUX_VERSION_CODE;
 
 	media_device_init(mdev);
-#endif
 }
 EXPORT_SYMBOL_GPL(__media_device_usb_init);
+#endif
 
 
 #endif /* CONFIG_MEDIA_CONTROLLER */


