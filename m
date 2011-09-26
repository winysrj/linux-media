Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:2762 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752331Ab1IZJa5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Sep 2011 05:30:57 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "corp\\KChen" <keqiang.chen@windriver.com>
Subject: Re: SI470X Radio /  ADS Instant FM Music in linux
Date: Mon, 26 Sep 2011 11:30:44 +0200
Cc: linux-media@vger.kernel.org
References: <4E6883AC.9010900@windriver.com>
In-Reply-To: <4E6883AC.9010900@windriver.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201109261130.44596.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi!

I have one of these devices as well (although I don't know if it is identical
to yours), so I will take a look. Unfortunately, I don't have access to it until
next week.

I hope to have more information for you by then.

Regards,

	Hans

On Thursday, September 08, 2011 10:58:20 corp\KChen wrote:
> Dear Manager,
> 
> I am debugging a platform with SI470x FM radio module(Usb interface).
> The linux kernel version is 2.6.35.7.
> I have configured the linux kernel and it can recognize this module.
> But there are some abnormal log and I cant scan the FM channel normally.
> 
> The log list as below, Would you like help me?
> 
> //--------------Log start 
> ----------------------\|/-------------------------------------
> usb 1-1.3: new full speed USB device using ehci-omap and address 4
> usb 1-1.3: New USB device found, idVendor=06e1, idProduct=a155
> usb 1-1.3: New USB device strings: Mfr=1, Product=2, SerialNumber=0
> usb 1-1.3: Product: ADS InstantFM Music
> usb 1-1.3: Manufacturer: ADS TECH
> 
> 4:1:1: endpoint lacks sample rate attribute bit, cannot 
> set.                       // This is the first abnormal point.
> 
> radio-si470x 1-1.3:1.2: DeviceID=0x1242 ChipID=0x0a0f
> radio-si470x 1-1.3:1.2: software version 0, hardware version 7
> radio-si470x 1-1.3:1.2: This driver is known to work with software 
> version 7,       //
> radio-si470x 1-1.3:1.2: but the device has software version 
> 0.                              //This is the second abnormal point.
> radio-si470x 1-1.3:1.2: If you have some trouble using this driver,
> radio-si470x 1-1.3:1.2: please report to V4L ML at 
> linux-media@vger.kernel.org
> 
> //-----------------Log end 
> ---------------------/|\----------------------------------------
> Note:
> The device is bought from US but it is marked "Made in China".
> It is bought in one month.
> 
> Thanks
> 
> KeQiang.Chen.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
