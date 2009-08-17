Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:37259 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755634AbZHQAd6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 16 Aug 2009 20:33:58 -0400
Date: Sun, 16 Aug 2009 21:33:50 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Brandon Philips <brandon@ifup.org>
Cc: linux-media@vger.kernel.org, jayakumar.lkml@gmail.com, mag@mag.cx,
	Hans de Goede <hdegoede@redhat.com>
Subject: Re: [PATCH] quickcam_messenger.c: add support for all quickcam
 Messengers of the same family
Message-ID: <20090816213350.2cee217b@caramujo.chehab.org>
In-Reply-To: <20090808012135.GA11251@jenkins.home.ifup.org>
References: <20081202223854.GA5770@jenkins.ifup.org>
	<20090808012135.GA11251@jenkins.home.ifup.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 7 Aug 2009 18:21:35 -0700
Brandon Philips <brandon@ifup.org> escreveu:

> Hey Mauro-
> 
> I sent this patch long ago and it seemed to have gotten lost along the
> way.
> 
> Jaya acked the patch so it is in my mercurial tree now:
> 
>  http://ifup.org/hg/v4l-dvb/
>  http://ifup.org/hg/v4l-dvb/rev/335a6ccbacb3
> 
> Please pull the patch when you get a chance.

> Index: linux-2.6/drivers/media/video/usbvideo/quickcam_messenger.c

>  static struct usb_device_id qcm_table [] = {
> -	{ USB_DEVICE(USB_LOGITECH_VENDOR_ID, USB_QCM_PRODUCT_ID) },
> +	{ USB_DEVICE(0x046D, 0x08F0) },         /* QuickCam Messenger */
> +	{ USB_DEVICE(0x046D, 0x08F5) },         /* QuickCam Communicate */
> +	{ USB_DEVICE(0x046D, 0x08F6) },         /* QuickCam Messenger (new) */
> +	{ USB_DEVICE(0x046D, 0x08DA) },         /* QuickCam Messenger (new) */

Hmm... this module is obsolete, as I explained at:
	http://lkml.org/lkml/2009/6/23/56

There's also a patch proposing its removal for 2.6.32:
	http://patchwork.kernel.org/patch/33734/

(somehow, it seems that this were incorrectly unqueued. I'll add it on my next
upstream series of patches)

As support for QuickCam were already added at gspca and this module is V4L1, it
will be soon deprecated/removed from kernel. So, it would be good to test if
all those variants are supported by stv06xx.c. From its table, we have:

static const __devinitdata struct usb_device_id device_table[] = {
        /* QuickCam Express */
        {USB_DEVICE(0x046d, 0x0840), .driver_info = BRIDGE_STV600 },
        /* LEGO cam / QuickCam Web */
        {USB_DEVICE(0x046d, 0x0850), .driver_info = BRIDGE_STV610 },
        /* Dexxa WebCam USB */
        {USB_DEVICE(0x046d, 0x0870), .driver_info = BRIDGE_STV602 },
        /* QuickCam Messenger */
        {USB_DEVICE(0x046D, 0x08F0), .driver_info = BRIDGE_ST6422 },
        /* QuickCam Communicate */
        {USB_DEVICE(0x046D, 0x08F5), .driver_info = BRIDGE_ST6422 },
        /* QuickCam Messenger (new) */
        {USB_DEVICE(0x046D, 0x08F6), .driver_info = BRIDGE_ST6422 },
        /* QuickCam Messenger (new) */
        {USB_DEVICE(0x046D, 0x08DA), .driver_info = BRIDGE_ST6422 },
        {}

So, I suspect that everything is there already.

Jaya,

Could you please check if stv06xx.c is properly working with those devices?
Feel free to submit patches improving it, if needed.

--



Cheers,
Mauro
