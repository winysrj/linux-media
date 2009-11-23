Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:8587 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756585AbZKWM65 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Nov 2009 07:58:57 -0500
Message-ID: <4B0A8710.9060104@redhat.com>
Date: Mon, 23 Nov 2009 10:58:56 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Jarod Wilson <jarod@redhat.com>
CC: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
	linux-media@vger.kernel.org, Janne Grunau <j@jannau.net>,
	Christoph Bartelmus <lirc@bartelmus.de>
Subject: Re: [PATCH 3/3 v2] lirc driver for SoundGraph iMON IR receivers and
 displays
References: <200910200956.33391.jarod@redhat.com> <200910201000.57536.jarod@redhat.com>
In-Reply-To: <200910201000.57536.jarod@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Jarod Wilson wrote:
> lirc driver for SoundGraph iMON IR receivers and displays
> 
> Successfully tested with multiple devices with and without displays.
> 


> +static struct usb_device_id imon_usb_id_table[] = {
> +	/* TriGem iMON (IR only) -- TG_iMON.inf */
> +	{ USB_DEVICE(0x0aa8, 0x8001) },
...

Another set of USB vendor ID's... this time, vendors weren't described. The
same comment I did on patch 2/3 applies here... IMO, we should really try
to create a global list of vendors/devices on kernel. Of course this is not
a non-go issue, as it is already present on several other USB drivers.

> +
> +	/*
> +	 * Translate received data to pulse and space lengths.
> +	 * Received data is active low, i.e. pulses are 0 and
> +	 * spaces are 1.
> +	 *
> +	 * My original algorithm was essentially similar to
> +	 * Changwoo Ryu's with the exception that he switched
> +	 * the incoming bits to active high and also fed an
> +	 * initial space to LIRC at the start of a new sequence
> +	 * if the previous bit was a pulse.
> +	 *
> +	 * I've decided to adopt his algorithm.
> +	 */
> +

Before digging into all code details, am I wrong or this device has the
pulse/space decoding inside the chip?

In this case, we shouldn't really be converting their IR keystroke events into
a pseudo set of pulse/space marks, but use the standard events interface.

Cheers,
Mauro.

