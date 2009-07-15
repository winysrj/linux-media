Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:43688 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755340AbZGORxv (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 15 Jul 2009 13:53:51 -0400
Message-ID: <4A5E1833.4030307@redhat.com>
Date: Wed, 15 Jul 2009 19:56:03 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Brian Johnson <brijohn@gmail.com>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH 1/1] gspca: Add sn9c20x subdriver
References: <1246879822-21348-1-git-send-email-brijohn@gmail.com> <1246879822-21348-2-git-send-email-brijohn@gmail.com>
In-Reply-To: <1246879822-21348-2-git-send-email-brijohn@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

First of all many many thanks for doings this!
There are 4 issues with this driver, 2 of which are blockers:

1) The big one is the use of a custom debugging mechanism,
    please use the v4l standard debugging mechanism
    which is activated by the kernel config option
    VIDEO_ADV_DEBUG, please use this define to
    enable / disable the debugging features of this
    driver and use the standard VIDIOC_DBG_G_REGISTER
    and VIDIOC_DBG_S_REGISTER ioctl's instead of an
    sysfs interface. Note I'm not very familiar with
    these myself, please send any questions on this to the
    list.

2) :

> +	switch (sd->sensor) {
> +	case SENSOR_OV9650:
> +		if (ov9650_init_sensor(gspca_dev)<  0)
> +			return -ENODEV;
> +		info("OV9650 sensor detected");
> +		break;
> +	case SENSOR_OV9655:
> +		if (ov9655_init_sensor(gspca_dev)<  0)
> +			return -ENODEV;
> +		info("OV9655 sensor detected");
> +		break;
> +	case SENSOR_SOI968:
> +		if (soi968_init_sensor(gspca_dev)<  0)
> +			return -ENODEV;
> +		info("SOI968 sensor detected");
> +		break;
> +	case SENSOR_OV7660:
> +		if (ov7660_init_sensor(gspca_dev)<  0)
> +			return -ENODEV;
> +		info("OV7660 sensor detected");

You are missing a break here! Which I found out because
my only sn9c20x cam has ab ov7660 sensor

> +	case SENSOR_OV7670:
> +		if (ov7670_init_sensor(gspca_dev)<  0)
> +			return -ENODEV;
> +		info("OV7670 sensor detected");
> +		break;

3) My cam works a lot better with the standalone driver
then with you're gspca version. With your version it shows
a bayer pattern ish pattern over the whole picture as if
the bayer pixel order is of, except that the colors are right
so that is most likely not the cause. I'll investigate this
further as time permits.

4) The evdev device creation and handling realyl belongs in the
gspca core, as we can (and should) handle the snapshot button
in other drivers too, but this is something which can be fixed
after merging.

Thanks & Regards,

Hans
