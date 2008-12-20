Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBKFRoIV005240
	for <video4linux-list@redhat.com>; Sat, 20 Dec 2008 10:27:50 -0500
Received: from qw-out-2122.google.com (qw-out-2122.google.com [74.125.92.25])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mBKFRaPY022265
	for <video4linux-list@redhat.com>; Sat, 20 Dec 2008 10:27:36 -0500
Received: by qw-out-2122.google.com with SMTP id 3so367769qwe.39
	for <video4linux-list@redhat.com>; Sat, 20 Dec 2008 07:27:36 -0800 (PST)
Date: Sat, 20 Dec 2008 13:27:30 -0200
From: Douglas Schilling Landgraf <dougsland@gmail.com>
To: Alexey Klimov <klimov.linux@gmail.com>
Message-ID: <20081220132730.45e9c365@gmail.com>
In-Reply-To: <1229742563.10297.114.camel@tux.localhost>
References: <1229742563.10297.114.camel@tux.localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: Re: [review patch 2/5] dsbr100: fix codinstyle, make ifs more clear
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

Hello Alexey,

On Sat, 20 Dec 2008 06:09:23 +0300
Alexey Klimov <klimov.linux@gmail.com> wrote:

> We should make if-constructions more clear. Introduce int variables in
> some functions to make it this way.
> 
> ---
> diff -r a302bfcb23f8 linux/drivers/media/radio/dsbr100.c
> --- a/linux/drivers/media/radio/dsbr100.c	Fri Dec 19 14:34:30
> 2008 +0300 +++ b/linux/drivers/media/radio/dsbr100.c	Sat Dec
> 20 02:31:26 2008 +0300 @@ -200,15 +200,24 @@
>  /* switch on radio */
>  static int dsbr100_start(struct dsbr100_device *radio)
>  {
> +	int first;
> +	int second;
> +
>  	mutex_lock(&radio->lock);
> -	if (usb_control_msg(radio->usbdev,
> usb_rcvctrlpipe(radio->usbdev, 0),
> -			USB_REQ_GET_STATUS,
> -			USB_TYPE_VENDOR | USB_RECIP_DEVICE |
> USB_DIR_IN,
> -			0x00, 0xC7, radio->transfer_buffer, 8, 300)
> < 0 ||
> -	usb_control_msg(radio->usbdev,
> usb_rcvctrlpipe(radio->usbdev, 0),
> -			DSB100_ONOFF,
> -			USB_TYPE_VENDOR | USB_RECIP_DEVICE |
> USB_DIR_IN,
> -			0x01, 0x00, radio->transfer_buffer, 8, 300)
> < 0) { +
> +	first = usb_control_msg(radio->usbdev,
> +		usb_rcvctrlpipe(radio->usbdev, 0),
> +		USB_REQ_GET_STATUS,
> +		USB_TYPE_VENDOR | USB_RECIP_DEVICE | USB_DIR_IN,
> +		0x00, 0xC7, radio->transfer_buffer, 8, 300);
> +
> +	second = usb_control_msg(radio->usbdev,
> +		usb_rcvctrlpipe(radio->usbdev, 0),
> +		DSB100_ONOFF,
> +		USB_TYPE_VENDOR | USB_RECIP_DEVICE | USB_DIR_IN,
> +		0x01, 0x00, radio->transfer_buffer, 8, 300);
> +
> +	if (first < 0 || second < 0) {
>  		mutex_unlock(&radio->lock);
>  		return -1;
>  	}

IMO, we could create a variable like "ret" or "retval" to validate each
usb_control_msg call instead of create 3 variables "first", "second" and "third".

> @@ -222,15 +231,24 @@
>  /* switch off radio */
>  static int dsbr100_stop(struct dsbr100_device *radio)
>  {
> +	int first;
> +	int second;
> +
>  	mutex_lock(&radio->lock);
> -	if (usb_control_msg(radio->usbdev,
> usb_rcvctrlpipe(radio->usbdev, 0),
> -			USB_REQ_GET_STATUS,
> -			USB_TYPE_VENDOR | USB_RECIP_DEVICE |
> USB_DIR_IN,
> -			0x16, 0x1C, radio->transfer_buffer, 8, 300)
> < 0 ||
> -	usb_control_msg(radio->usbdev,
> usb_rcvctrlpipe(radio->usbdev, 0),
> -			DSB100_ONOFF,
> -			USB_TYPE_VENDOR | USB_RECIP_DEVICE |
> USB_DIR_IN,
> -			0x00, 0x00, radio->transfer_buffer, 8, 300)
> < 0) { +
> +	first = usb_control_msg(radio->usbdev,
> +		usb_rcvctrlpipe(radio->usbdev, 0),
> +		USB_REQ_GET_STATUS,
> +		USB_TYPE_VENDOR | USB_RECIP_DEVICE | USB_DIR_IN,
> +		0x16, 0x1C, radio->transfer_buffer, 8, 300);
> +
> +	second = usb_control_msg(radio->usbdev,
> +		usb_rcvctrlpipe(radio->usbdev, 0),
> +		DSB100_ONOFF,
> +		USB_TYPE_VENDOR | USB_RECIP_DEVICE | USB_DIR_IN,
> +		0x00, 0x00, radio->transfer_buffer, 8, 300);
> +
> +	if (first < 0 || second < 0) {
>  		mutex_unlock(&radio->lock);
>  		return -1;
>  	}

The same here.

> @@ -243,21 +261,33 @@
>  /* set a frequency, freq is defined by v4l's TUNER_LOW, i.e. 1/16th
> kHz */ static int dsbr100_setfreq(struct dsbr100_device *radio, int
> freq) {
> +	int first;
> +	int second;
> +	int third;
> +
>  	freq = (freq / 16 * 80) / 1000 + 856;
>  	mutex_lock(&radio->lock);
> -	if (usb_control_msg(radio->usbdev,
> usb_rcvctrlpipe(radio->usbdev, 0),
> -			DSB100_TUNE,
> -			USB_TYPE_VENDOR | USB_RECIP_DEVICE |
> USB_DIR_IN,
> -			(freq >> 8) & 0x00ff, freq & 0xff,
> -			radio->transfer_buffer, 8, 300) < 0 ||
> -	   usb_control_msg(radio->usbdev,
> usb_rcvctrlpipe(radio->usbdev, 0),
> -			USB_REQ_GET_STATUS,
> -			USB_TYPE_VENDOR | USB_RECIP_DEVICE |
> USB_DIR_IN,
> -			0x96, 0xB7, radio->transfer_buffer, 8, 300)
> < 0 ||
> -	usb_control_msg(radio->usbdev,
> usb_rcvctrlpipe(radio->usbdev, 0),
> -			USB_REQ_GET_STATUS,
> -			USB_TYPE_VENDOR | USB_RECIP_DEVICE |
> USB_DIR_IN,
> -			0x00, 0x24, radio->transfer_buffer, 8, 300)
> < 0) { +
> +	first = usb_control_msg(radio->usbdev,
> +		usb_rcvctrlpipe(radio->usbdev, 0),
> +		DSB100_TUNE,
> +		USB_TYPE_VENDOR | USB_RECIP_DEVICE | USB_DIR_IN,
> +		(freq >> 8) & 0x00ff, freq & 0xff,
> +		radio->transfer_buffer, 8, 300);
> +
> +	second = usb_control_msg(radio->usbdev,
> +		usb_rcvctrlpipe(radio->usbdev, 0),
> +		USB_REQ_GET_STATUS,
> +		USB_TYPE_VENDOR | USB_RECIP_DEVICE | USB_DIR_IN,
> +		0x96, 0xB7, radio->transfer_buffer, 8, 300);
> +
> +	third = usb_control_msg(radio->usbdev,
> +		usb_rcvctrlpipe(radio->usbdev, 0),
> +		USB_REQ_GET_STATUS,
> +		USB_TYPE_VENDOR | USB_RECIP_DEVICE |  USB_DIR_IN,
> +		0x00, 0x24, radio->transfer_buffer, 8, 300);
> +
> +	if (first < 0 || second < 0 || third < 0) {
>  		radio->stereo = -1;
>  		mutex_unlock(&radio->lock);
>  		return -1;

The same here. What do you think?

Cheers,
Douglas

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
