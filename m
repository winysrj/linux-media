Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp5-g21.free.fr ([212.27.42.5]:38962 "EHLO smtp5-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752056AbZCIH42 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 9 Mar 2009 03:56:28 -0400
Date: Mon, 9 Mar 2009 08:51:13 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: amol verule <amol.debian@gmail.com>
Cc: Linux Media <linux-media@vger.kernel.org>
Subject: Re: video4linux-list@redhat.com
Message-ID: <20090309085113.39741df9@free.fr>
In-Reply-To: <77ca8eab0903090037x6e0e2705sfe62940141780e7e@mail.gmail.com>
References: <77ca8eab0903090037x6e0e2705sfe62940141780e7e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 9 Mar 2009 13:07:10 +0530
amol verule <amol.debian@gmail.com> wrote:

> hi,

Hi Amol,

>  i am having iball 9.0 device and getting error while opening it as
> #camorama -D
> VIDIOCGCAP  --  could not get camera capabilities, exiting.....
> 
> #ls -l /dev/video0
> crw-rw---- 1 root video 81, 0 2009-03-09 18:16 /dev/video0
> 
>  this is dmesg when i plugged in camera
> usb 1-1: new full speed USB device using uhci_hcd and address 4
> usb 1-1: configuration #1 chosen from 1 choice
> Linux video capture interface: v2.00
> sn9c102: V4L2 driver for SN9C1xx PC Camera Controllers v1:1.44
> usb 1-1: SN9C120 PC Camera Controller detected (vid:pid 0x0C45:0x6130)
> usb 1-1: MI-0360 image sensor detected
> usb 1-1: Initialization succeeded
> usb 1-1: V4L2 device registered as /dev/video0
> usb 1-1: Optional device control through 'sysfs' interface disabled
> usbcore: registered new interface driver sn9c102
> usbcore: registered new interface driver gspca
> /usr/src/modules/gspca/gspca_core.c: gspca driver 01.00.20 registered
> ...
> what is actual problem even though driver is available and it created
> /dev/video0 ..i am not able to use webcam..

You have 2 drivers: sn9c102 and gspca v1.

- sn9c102 may or may not handle correctly your webcam.

- gspca v1 is not maintained anymore. You _must_ use gspca v2 instead.

As both drivers may handle your webcam, when both are generated, only
sn9c102 does the job. If it does not work, you must change the media
config removing the sn9c102 driver.

> --
> video4linux-list mailing list

You should not use this mailing list. The new one is in the Cc: field
of this message.

Cheers.

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
