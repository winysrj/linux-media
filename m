Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mABL7JH8021542
	for <video4linux-list@redhat.com>; Tue, 11 Nov 2008 16:07:19 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mABL7E4n005934
	for <video4linux-list@redhat.com>; Tue, 11 Nov 2008 16:07:14 -0500
Date: Tue, 11 Nov 2008 16:07:13 -0500 (EST)
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Laurent Pinchart <laurent.pinchart@skynet.be>
In-Reply-To: <200811111753.03430.laurent.pinchart@skynet.be>
Message-ID: <alpine.LFD.2.00.0811111559550.5321@bombadil.infradead.org>
References: <200811111753.03430.laurent.pinchart@skynet.be>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: video4linux-list@redhat.com
Subject: Re: [RFC] Add usb_endpoint_*, list_first_entry and uninitialized_var
 to compat.h
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

On Tue, 11 Nov 2008, Laurent Pinchart wrote:

> Hi everybody,
>
> This patch adds support for the usb_endpoint_* functions as well as
> list_first_entry and uninitialized_var macros to compat.h. The uvcvideo
> driver requires it to compile on kernels older than 2.6.22.
>
> As the usb_endpoint_* functions needs struct usb_endpoint_descriptor, they are
> only defined if linux/usb.h has been included before compat.h. This avoids
> including linux/usb.h unconditionally. I've tested the patch by compiling the
> v4l-dvb tree on 2.6.16 and 2.6.27 and didn't get any warning or error.
>
> If nobody objects I'll include the changes in my tree with the related
> uvcvideo changes and send a pull request.

I didn't test it here, but it seems OK to me.

Maybe instead of testing for a specific version, you may use 
make_config_compat.pl script to do some test at some include file, finding 
for some specific API call, like we did for some KABI changes that 
happened without incrementing kernel minor revision.
  >
> Cheers,
>
> Laurent Pinchart
>
> diff -r 54319724a6d1 v4l/compat.h
> --- a/v4l/compat.h	Sat Nov 08 23:14:50 2008 +0100
> +++ b/v4l/compat.h	Tue Nov 11 17:48:53 2008 +0100
> @@ -258,4 +258,69 @@
> #define PCI_DEVICE_ID_MARVELL_88ALP01_CCIC     0x4102
> #endif
>
> +#if LINUX_VERSION_CODE < KERNEL_VERSION(2, 6, 19)
> +#ifdef __LINUX_USB_H
> +/*
> + * usb_endpoint_* functions
> + *
> + * Included in Linux 2.6.19
> + * Backported to 2.6.18 in Red Hat Enterprise Linux 5.2
> + */
> +
> +#ifdef RHEL_RELEASE_CODE
> +#if RHEL_RELEASE_CODE >= RHEL_RELEASE_VERSION(5, 2)
> +#define RHEL_HAS_USB_ENDPOINT
> #endif
> +#endif
> +
> +#ifndef RHEL_HAS_USB_ENDPOINT
> +static inline int
> +usb_endpoint_dir_in(const struct usb_endpoint_descriptor *epd)
> +{
> +	return (epd->bEndpointAddress & USB_ENDPOINT_DIR_MASK) == USB_DIR_IN;
> +}
> +
> +static inline int
> +usb_endpoint_xfer_int(const struct usb_endpoint_descriptor *epd)
> +{
> +	return (epd->bmAttributes & USB_ENDPOINT_XFERTYPE_MASK) ==
> +		USB_ENDPOINT_XFER_INT;
> +}
> +
> +static inline int
> +usb_endpoint_xfer_isoc(const struct usb_endpoint_descriptor *epd)
> +{
> +	return (epd->bmAttributes & USB_ENDPOINT_XFERTYPE_MASK) ==
> +		USB_ENDPOINT_XFER_ISOC;
> +}
> +
> +static inline int
> +usb_endpoint_xfer_bulk(const struct usb_endpoint_descriptor *epd)
> +{
> +	return (epd->bmAttributes & USB_ENDPOINT_XFERTYPE_MASK) ==
> +		USB_ENDPOINT_XFER_BULK;
> +}
> +
> +static inline int
> +usb_endpoint_is_int_in(const struct usb_endpoint_descriptor *epd)
> +{
> +	return usb_endpoint_xfer_int(epd) && usb_endpoint_dir_in(epd);
> +}
> +#endif /* RHEL_HAS_USB_ENDPOINT */
> +#endif /* __LINUX_USB_H */
> +#endif
> +
> +#if LINUX_VERSION_CODE < KERNEL_VERSION(2, 6, 22)
> +/*
> + * Linked list API
> + */
> +#define list_first_entry(ptr, type, member) \
> +	list_entry((ptr)->next, type, member)
> +
> +/*
> + * uninitialized_var() macro
> + */
> +#define uninitialized_var(x) x
> +#endif
> +
> +#endif
>

-- 
Cheers,
Mauro Carvalho Chehab
http://linuxtv.org
mchehab@infradead.org

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
