Return-path: <linux-media-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:49368 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754400Ab2APMms (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Jan 2012 07:42:48 -0500
From: Oliver Neukum <oneukum@suse.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [RFC PATCH 2/3] radio-keene: add a driver for the Keene FM Transmitter.
Date: Mon, 16 Jan 2012 13:44:37 +0100
Cc: linux-media@vger.kernel.org, linux-input@vger.kernel.org,
	Jiri Kosina <jkosina@suse.cz>,
	Hans Verkuil <hans.verkuil@cisco.com>
References: <1326716960-4424-1-git-send-email-hverkuil@xs4all.nl> <955b875452cd4dca966f87d45a31a718637b03c0.1326716517.git.hans.verkuil@cisco.com>
In-Reply-To: <955b875452cd4dca966f87d45a31a718637b03c0.1326716517.git.hans.verkuil@cisco.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201201161344.37499.oneukum@suse.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am Montag, 16. Januar 2012, 13:29:19 schrieb Hans Verkuil:
> From: Hans Verkuil <hans.verkuil@cisco.com>

> +MODULE_DEVICE_TABLE(usb, usb_keene_device_table);
> +
> +struct keene_device {
> +	struct usb_device *usbdev;
> +	struct usb_interface *intf;
> +	struct video_device vdev;
> +	struct v4l2_device v4l2_dev;
> +	struct v4l2_ctrl_handler hdl;
> +	struct mutex lock;
> +
> +	u8 buffer[BUFFER_LENGTH];

This is a violation of the DMA  API. You need to alocate the buffer with
a separate kmalloc.

> +	unsigned curfreq;
> +	u8 tx;
> +	u8 pa;
> +	bool stereo;
> +	bool muted;
> +	bool preemph_75_us;
> +};
> +
> +static inline struct keene_device *to_keene_dev(struct v4l2_device *v4l2_dev)
> +{
> +	return container_of(v4l2_dev, struct keene_device, v4l2_dev);
> +}
> +
> +/* Set frequency (if non-0), PA, mute and turn on/off the FM transmitter. */
> +static int keene_cmd_main(struct keene_device *radio, unsigned freq, bool play)
> +{
> +	unsigned short freq_send = freq ? (freq - 76 * 16000) / 800 : 0;
> +	int ret;
> +
> +	radio->buffer[0] = 0x00;
> +	radio->buffer[1] = 0x50;
> +	radio->buffer[2] = (freq_send >> 8) & 0xff;
> +	radio->buffer[3] = freq_send & 0xff;

Please use the endianness macro appropriate here

	Regards
		Oliver
