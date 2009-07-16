Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yx0-f184.google.com ([209.85.210.184]:49259 "EHLO
	mail-yx0-f184.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757489AbZGPFZO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Jul 2009 01:25:14 -0400
Received: by yxe14 with SMTP id 14so6324247yxe.33
        for <linux-media@vger.kernel.org>; Wed, 15 Jul 2009 22:25:13 -0700 (PDT)
Message-ID: <4A5EB9B7.4040702@gmail.com>
Date: Thu, 16 Jul 2009 01:25:11 -0400
From: Brian Johnson <brijohn@gmail.com>
MIME-Version: 1.0
To: Hans de Goede <hdegoede@redhat.com>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH 1/1] gspca: Add sn9c20x subdriver
References: <1246879822-21348-1-git-send-email-brijohn@gmail.com> <1246879822-21348-2-git-send-email-brijohn@gmail.com> <4A5E1833.4030307@redhat.com>
In-Reply-To: <4A5E1833.4030307@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hans,
Thanks for the feedback, I'll work on the changes and hopefully post the revised patch this weekend.
> Hi,
> 
> First of all many many thanks for doings this!
> There are 4 issues with this driver, 2 of which are blockers:
> 
> 1) The big one is the use of a custom debugging mechanism,
>     please use the v4l standard debugging mechanism
>     which is activated by the kernel config option
>     VIDEO_ADV_DEBUG, please use this define to
>     enable / disable the debugging features of this
>     driver and use the standard VIDIOC_DBG_G_REGISTER
>     and VIDIOC_DBG_S_REGISTER ioctl's instead of an
>     sysfs interface. Note I'm not very familiar with
>     these myself, please send any questions on this to the
>     list.
>
Ok I'll change the debugging code to use those ioctl's instead of debugfs.
> 2) :
> 
>> +	case SENSOR_OV7660:
>> +		if (ov7660_init_sensor(gspca_dev)<  0)
>> +			return -ENODEV;
>> +		info("OV7660 sensor detected");
> 
> You are missing a break here! Which I found out because
> my only sn9c20x cam has ab ov7660 sensor
Oops. 

> 
>> +	case SENSOR_OV7670:
>> +		if (ov7670_init_sensor(gspca_dev)<  0)
>> +			return -ENODEV;
>> +		info("OV7670 sensor detected");
>> +		break;
> 
> 3) My cam works a lot better with the standalone driver
> then with you're gspca version. With your version it shows
> a bayer pattern ish pattern over the whole picture as if
> the bayer pixel order is of, except that the colors are right
> so that is most likely not the cause. I'll investigate this
> further as time permits.
> 
Hmm, Hans can you see if disabling the code for hvflip on the ov7660 helps any?

> 4) The evdev device creation and handling realyl belongs in the
> gspca core, as we can (and should) handle the snapshot button
> in other drivers too, but this is something which can be fixed
> after merging.


Thanks,
Brian Johnson
