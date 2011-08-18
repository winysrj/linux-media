Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:36581 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755166Ab1HRKic (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Aug 2011 06:38:32 -0400
Received: by wwf5 with SMTP id 5so1936057wwf.1
        for <linux-media@vger.kernel.org>; Thu, 18 Aug 2011 03:38:30 -0700 (PDT)
MIME-Version: 1.0
From: Damien Cassou <damien.cassou@gmail.com>
Date: Thu, 18 Aug 2011 12:31:51 +0200
Message-ID: <CA+y5ggjdGZsBSs7UOEpRnoOZh0C96_GOcnvNzmUNAcPo_LF0Lw@mail.gmail.com>
Subject: Image and webcam freeze on Ubuntu with Logitech QuickCam Communicate STX
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

my Logitech QuickCam Communicate STX works perfectly well for a few
minutes when I use it. However, after that the image is frozen and I
can't make it work again until I reboot the system (before rebooting,
the webcam has a blue color indicating it is "working" even though I
can't get anything displayed). What can I do? A way to avoid rebooting
would be a very welcomed workaround.

Details below:

- because of this bug I compiled the driver manually to see if the bug
was fixed. I compiled it from gspca-2.13.6.tar.gz

- ubuntu 11.04, all updates installed

- dmesg displays a lot of the following line:
gspca: ISOC data error: [0] len=0, status=-18

- lsusb returns:
Bus 003 Device 002: ID 046d:08ad Logitech, Inc. QuickCam Communicate STX

$ modinfo gspca_zc3xx
filename:
/lib/modules/2.6.38-10-generic/kernel/drivers/media/video/gspca/gspca_zc3xx.ko
license:        GPL
description:    GSPCA ZC03xx/VC3xx USB Camera Driver
author:         Jean-Francois Moine <http://moinejf.free.fr>, Serge A.
Suchkov <Serge.A.S@tochka.ru>
srcversion:     97DB70F27D4B7F8143E2C14
alias:          usb:v10FDp8050d*dc*dsc*dp*ic*isc*ip*
...
depends:        gspca_main
vermagic:       2.6.38-10-generic SMP mod_unload modversions 686
parm:           force_sensor:Force sensor. Only for experts!!! (int)

Below are some messages from /var/log/syslog

Aug 18 10:33:16 ancizan kernel: [ 8284.112090] usb 2-1: reset high
speed USB device using ehci_hcd and address 2
Aug 18 10:50:37 ancizan kernel: [ 9325.511335] zc3xx: probe 2wr ov vga 0x0000
Aug 18 10:55:08 ancizan kernel: [ 9596.091366] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:08 ancizan kernel: [ 9596.123367] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:08 ancizan kernel: [ 9596.155374] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:08 ancizan kernel: [ 9596.187363] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:08 ancizan kernel: [ 9596.219379] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:08 ancizan kernel: [ 9596.251367] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:08 ancizan kernel: [ 9596.283375] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:08 ancizan kernel: [ 9596.315377] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:08 ancizan kernel: [ 9596.347364] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:08 ancizan kernel: [ 9596.379368] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:08 ancizan kernel: [ 9596.411363] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:08 ancizan kernel: [ 9596.443366] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:08 ancizan kernel: [ 9596.475379] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:08 ancizan kernel: [ 9596.507372] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:08 ancizan kernel: [ 9596.539361] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:08 ancizan kernel: [ 9596.571377] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:08 ancizan kernel: [ 9596.603377] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:08 ancizan kernel: [ 9596.635383] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:08 ancizan kernel: [ 9596.667387] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:08 ancizan kernel: [ 9596.699374] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:08 ancizan kernel: [ 9596.731358] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:08 ancizan kernel: [ 9596.763366] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:08 ancizan kernel: [ 9596.795374] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:08 ancizan kernel: [ 9596.827366] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:08 ancizan kernel: [ 9596.859364] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:08 ancizan kernel: [ 9596.891365] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:08 ancizan kernel: [ 9596.923373] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:08 ancizan kernel: [ 9596.955366] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:09 ancizan kernel: [ 9596.987377] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:09 ancizan kernel: [ 9597.019369] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:09 ancizan kernel: [ 9597.051368] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:09 ancizan kernel: [ 9597.083363] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:09 ancizan kernel: [ 9597.115371] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:09 ancizan kernel: [ 9597.147366] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:09 ancizan kernel: [ 9597.179364] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:09 ancizan kernel: [ 9597.211364] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:09 ancizan kernel: [ 9597.243369] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:09 ancizan kernel: [ 9597.275378] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:09 ancizan kernel: [ 9597.307367] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:09 ancizan kernel: [ 9597.339372] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:09 ancizan kernel: [ 9597.371375] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:09 ancizan kernel: [ 9597.403367] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:09 ancizan kernel: [ 9597.435376] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:09 ancizan kernel: [ 9597.467367] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:09 ancizan kernel: [ 9597.499365] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:09 ancizan kernel: [ 9597.531372] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:09 ancizan kernel: [ 9597.563379] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:09 ancizan kernel: [ 9597.595367] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:09 ancizan kernel: [ 9597.627361] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:09 ancizan kernel: [ 9597.659365] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:09 ancizan kernel: [ 9597.691367] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:09 ancizan kernel: [ 9597.723374] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:09 ancizan kernel: [ 9597.755397] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:09 ancizan kernel: [ 9597.787366] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:09 ancizan kernel: [ 9597.819379] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:09 ancizan kernel: [ 9597.851367] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:09 ancizan kernel: [ 9597.883369] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:09 ancizan kernel: [ 9597.915369] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:09 ancizan kernel: [ 9597.947375] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:10 ancizan kernel: [ 9597.979368] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:10 ancizan kernel: [ 9598.011367] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:10 ancizan kernel: [ 9598.043373] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:10 ancizan kernel: [ 9598.075367] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:10 ancizan kernel: [ 9598.107362] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:10 ancizan kernel: [ 9598.139365] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:10 ancizan kernel: [ 9598.171365] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:10 ancizan kernel: [ 9598.203362] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:10 ancizan kernel: [ 9598.235368] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:10 ancizan kernel: [ 9598.267369] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:10 ancizan kernel: [ 9598.299376] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:10 ancizan kernel: [ 9598.331369] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:10 ancizan kernel: [ 9598.363367] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:10 ancizan kernel: [ 9598.395368] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:10 ancizan kernel: [ 9598.427368] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:10 ancizan kernel: [ 9598.459364] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:10 ancizan kernel: [ 9598.491362] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:10 ancizan kernel: [ 9598.523379] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:10 ancizan kernel: [ 9598.555376] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:10 ancizan kernel: [ 9598.587361] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:10 ancizan kernel: [ 9598.619361] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:10 ancizan kernel: [ 9598.651374] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:10 ancizan kernel: [ 9598.683365] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:10 ancizan kernel: [ 9598.715360] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:10 ancizan kernel: [ 9598.747378] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:10 ancizan kernel: [ 9598.779362] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:10 ancizan kernel: [ 9598.811367] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:10 ancizan kernel: [ 9598.843371] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:10 ancizan kernel: [ 9598.875443] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:10 ancizan kernel: [ 9598.907375] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:10 ancizan kernel: [ 9598.939365] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:11 ancizan kernel: [ 9598.971377] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:11 ancizan kernel: [ 9599.003360] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:11 ancizan kernel: [ 9599.035362] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:11 ancizan kernel: [ 9599.067376] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:11 ancizan kernel: [ 9599.099360] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:11 ancizan kernel: [ 9599.131371] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:11 ancizan kernel: [ 9599.163362] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:11 ancizan kernel: [ 9599.195375] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:11 ancizan kernel: [ 9599.227365] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:11 ancizan kernel: [ 9599.259361] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:11 ancizan kernel: [ 9599.291368] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:11 ancizan kernel: [ 9599.323363] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:11 ancizan kernel: [ 9599.355395] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:11 ancizan kernel: [ 9599.387361] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:11 ancizan kernel: [ 9599.419369] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:11 ancizan kernel: [ 9599.451373] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:11 ancizan kernel: [ 9599.483364] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:11 ancizan kernel: [ 9599.515367] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:11 ancizan kernel: [ 9599.547363] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:11 ancizan kernel: [ 9599.579368] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:11 ancizan kernel: [ 9599.611367] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:11 ancizan kernel: [ 9599.643366] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:11 ancizan kernel: [ 9599.675378] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:11 ancizan kernel: [ 9599.707390] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:11 ancizan kernel: [ 9599.739395] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:11 ancizan kernel: [ 9599.771370] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:11 ancizan kernel: [ 9599.803366] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:11 ancizan kernel: [ 9599.835377] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:11 ancizan kernel: [ 9599.867378] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:11 ancizan kernel: [ 9599.899368] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:11 ancizan kernel: [ 9599.931374] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:12 ancizan kernel: [ 9599.963371] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:12 ancizan kernel: [ 9599.995373] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:12 ancizan kernel: [ 9600.027371] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:12 ancizan kernel: [ 9600.059374] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:12 ancizan kernel: [ 9600.091376] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:12 ancizan kernel: [ 9600.123368] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:12 ancizan kernel: [ 9600.155385] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:12 ancizan kernel: [ 9600.187374] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:12 ancizan kernel: [ 9600.219376] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:12 ancizan kernel: [ 9600.251374] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:12 ancizan kernel: [ 9600.283375] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:12 ancizan kernel: [ 9600.315381] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:12 ancizan kernel: [ 9600.347377] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:12 ancizan kernel: [ 9600.379360] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:12 ancizan kernel: [ 9600.411366] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:12 ancizan kernel: [ 9600.443368] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:12 ancizan kernel: [ 9600.475368] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:12 ancizan kernel: [ 9600.507368] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:12 ancizan kernel: [ 9600.539364] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:12 ancizan kernel: [ 9600.571360] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:12 ancizan kernel: [ 9600.603379] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:12 ancizan kernel: [ 9600.635362] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:12 ancizan kernel: [ 9600.667362] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:12 ancizan kernel: [ 9600.699364] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:12 ancizan kernel: [ 9600.731359] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:12 ancizan kernel: [ 9600.763386] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:12 ancizan kernel: [ 9600.795407] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:12 ancizan kernel: [ 9600.827363] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:12 ancizan kernel: [ 9600.859378] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:12 ancizan kernel: [ 9600.891366] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:12 ancizan kernel: [ 9600.923366] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:12 ancizan kernel: [ 9600.955363] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:13 ancizan kernel: [ 9600.987369] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:13 ancizan kernel: [ 9601.019367] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:13 ancizan kernel: [ 9601.051364] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:13 ancizan kernel: [ 9601.083360] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:13 ancizan kernel: [ 9601.115361] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:13 ancizan kernel: [ 9601.147368] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:13 ancizan kernel: [ 9601.179363] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:13 ancizan kernel: [ 9601.211362] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:13 ancizan kernel: [ 9601.243364] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:13 ancizan kernel: [ 9601.275363] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:13 ancizan kernel: [ 9601.307378] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:13 ancizan kernel: [ 9601.339370] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:13 ancizan kernel: [ 9601.371379] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:13 ancizan kernel: [ 9601.403361] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:13 ancizan kernel: [ 9601.435380] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:13 ancizan kernel: [ 9601.467374] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:13 ancizan kernel: [ 9601.499378] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:13 ancizan kernel: [ 9601.531375] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:13 ancizan kernel: [ 9601.563363] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:13 ancizan kernel: [ 9601.595370] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:13 ancizan kernel: [ 9601.627369] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:13 ancizan kernel: [ 9601.659364] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:13 ancizan kernel: [ 9601.691370] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:13 ancizan kernel: [ 9601.723380] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:13 ancizan kernel: [ 9601.755371] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:13 ancizan kernel: [ 9601.787368] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:13 ancizan kernel: [ 9601.819363] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:13 ancizan kernel: [ 9601.851379] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:13 ancizan kernel: [ 9601.883369] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:13 ancizan kernel: [ 9601.915370] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:13 ancizan kernel: [ 9601.947370] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:14 ancizan kernel: [ 9601.979370] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:14 ancizan kernel: [ 9602.011379] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:14 ancizan kernel: [ 9602.043363] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:14 ancizan kernel: [ 9602.075378] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:14 ancizan kernel: [ 9602.107377] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:14 ancizan kernel: [ 9602.139369] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:14 ancizan kernel: [ 9602.171378] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:14 ancizan kernel: [ 9602.203378] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:14 ancizan kernel: [ 9602.235377] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:14 ancizan kernel: [ 9602.267364] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:14 ancizan kernel: [ 9602.299362] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:14 ancizan kernel: [ 9602.331368] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:14 ancizan kernel: [ 9602.363374] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:14 ancizan kernel: [ 9602.395381] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:14 ancizan kernel: [ 9602.427364] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:14 ancizan kernel: [ 9602.459366] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:14 ancizan kernel: [ 9602.491370] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:14 ancizan kernel: [ 9602.523367] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:14 ancizan kernel: [ 9602.555370] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:14 ancizan kernel: [ 9602.587374] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:14 ancizan kernel: [ 9602.619369] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:14 ancizan kernel: [ 9602.651377] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:14 ancizan kernel: [ 9602.683383] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:14 ancizan kernel: [ 9602.715364] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:14 ancizan kernel: [ 9602.747369] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:14 ancizan kernel: [ 9602.779370] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:14 ancizan kernel: [ 9602.811369] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:14 ancizan kernel: [ 9602.843365] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:14 ancizan kernel: [ 9602.875370] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:14 ancizan kernel: [ 9602.907371] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:14 ancizan kernel: [ 9602.939379] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:15 ancizan kernel: [ 9602.971377] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:15 ancizan kernel: [ 9603.003371] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:15 ancizan kernel: [ 9603.035381] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:15 ancizan kernel: [ 9603.067390] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:15 ancizan kernel: [ 9603.099377] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:15 ancizan kernel: [ 9603.131375] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:15 ancizan kernel: [ 9603.163372] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:15 ancizan kernel: [ 9603.195367] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:15 ancizan kernel: [ 9603.227375] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:15 ancizan kernel: [ 9603.259373] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:15 ancizan kernel: [ 9603.291393] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:15 ancizan kernel: [ 9603.323388] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:15 ancizan kernel: [ 9603.355372] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:15 ancizan kernel: [ 9603.387359] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:15 ancizan kernel: [ 9603.419403] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:15 ancizan kernel: [ 9603.451362] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:15 ancizan kernel: [ 9603.483359] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:15 ancizan kernel: [ 9603.515363] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:15 ancizan kernel: [ 9603.547369] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:15 ancizan kernel: [ 9603.579395] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:15 ancizan kernel: [ 9603.611367] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:15 ancizan kernel: [ 9603.643378] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:15 ancizan kernel: [ 9603.675371] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:15 ancizan kernel: [ 9603.707392] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:15 ancizan kernel: [ 9603.739378] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:15 ancizan kernel: [ 9603.771370] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:15 ancizan kernel: [ 9603.803378] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:15 ancizan kernel: [ 9603.835379] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:15 ancizan kernel: [ 9603.867386] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:15 ancizan kernel: [ 9603.899376] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:15 ancizan kernel: [ 9603.931380] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:16 ancizan kernel: [ 9603.963369] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:16 ancizan kernel: [ 9603.995365] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:16 ancizan kernel: [ 9604.027372] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:16 ancizan kernel: [ 9604.059365] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:16 ancizan kernel: [ 9604.091369] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:16 ancizan kernel: [ 9604.123367] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:16 ancizan kernel: [ 9604.155369] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:16 ancizan kernel: [ 9604.187369] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:16 ancizan kernel: [ 9604.219393] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:16 ancizan kernel: [ 9604.251373] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:16 ancizan kernel: [ 9604.283381] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:16 ancizan kernel: [ 9604.315390] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:16 ancizan kernel: [ 9604.347388] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:16 ancizan kernel: [ 9604.379383] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:16 ancizan kernel: [ 9604.411382] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:16 ancizan kernel: [ 9604.443377] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:16 ancizan kernel: [ 9604.475370] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:16 ancizan kernel: [ 9604.507378] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:16 ancizan kernel: [ 9604.539392] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:16 ancizan kernel: [ 9604.571378] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:16 ancizan kernel: [ 9604.603372] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:16 ancizan kernel: [ 9604.635370] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:16 ancizan kernel: [ 9604.667371] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:16 ancizan kernel: [ 9604.699392] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:16 ancizan kernel: [ 9604.731375] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:16 ancizan kernel: [ 9604.763384] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:16 ancizan kernel: [ 9604.795388] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:16 ancizan kernel: [ 9604.827371] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:16 ancizan kernel: [ 9604.859385] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:16 ancizan kernel: [ 9604.891374] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:16 ancizan kernel: [ 9604.923375] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:16 ancizan kernel: [ 9604.955372] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:17 ancizan kernel: [ 9604.987373] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:17 ancizan kernel: [ 9605.019375] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:17 ancizan kernel: [ 9605.051378] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:17 ancizan kernel: [ 9605.083371] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:17 ancizan kernel: [ 9605.115374] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:17 ancizan kernel: [ 9605.147369] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:17 ancizan kernel: [ 9605.179373] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:17 ancizan kernel: [ 9605.211383] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:17 ancizan kernel: [ 9605.243379] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:17 ancizan kernel: [ 9605.275374] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:17 ancizan kernel: [ 9605.307388] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:17 ancizan kernel: [ 9605.339380] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:17 ancizan kernel: [ 9605.371387] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:17 ancizan kernel: [ 9605.403370] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:17 ancizan kernel: [ 9605.435366] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:17 ancizan kernel: [ 9605.467369] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:17 ancizan kernel: [ 9605.499406] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:17 ancizan kernel: [ 9605.531363] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:17 ancizan kernel: [ 9605.563372] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:17 ancizan kernel: [ 9605.595375] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:17 ancizan kernel: [ 9605.627380] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:17 ancizan kernel: [ 9605.659386] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:17 ancizan kernel: [ 9605.691368] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:17 ancizan kernel: [ 9605.723370] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:17 ancizan kernel: [ 9605.755388] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:17 ancizan kernel: [ 9605.787373] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:17 ancizan kernel: [ 9605.819372] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:17 ancizan kernel: [ 9605.851369] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:17 ancizan kernel: [ 9605.883381] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:17 ancizan kernel: [ 9605.915372] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:17 ancizan kernel: [ 9605.947377] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:18 ancizan kernel: [ 9605.979388] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:18 ancizan kernel: [ 9606.011368] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:18 ancizan kernel: [ 9606.043375] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:18 ancizan kernel: [ 9606.075376] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:18 ancizan kernel: [ 9606.107387] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:18 ancizan kernel: [ 9606.139377] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:18 ancizan kernel: [ 9606.171388] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:18 ancizan kernel: [ 9606.203385] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:18 ancizan kernel: [ 9606.235378] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:18 ancizan kernel: [ 9606.267377] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:18 ancizan kernel: [ 9606.299374] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:18 ancizan kernel: [ 9606.331389] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:18 ancizan kernel: [ 9606.363371] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:18 ancizan kernel: [ 9606.395370] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:18 ancizan kernel: [ 9606.427409] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:18 ancizan kernel: [ 9606.459378] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:18 ancizan kernel: [ 9606.491375] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:18 ancizan kernel: [ 9606.523370] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:18 ancizan kernel: [ 9606.555397] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:18 ancizan kernel: [ 9606.587376] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:18 ancizan kernel: [ 9606.619378] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:18 ancizan kernel: [ 9606.651368] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:18 ancizan kernel: [ 9606.683370] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:18 ancizan kernel: [ 9606.715379] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:18 ancizan kernel: [ 9606.747403] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:18 ancizan kernel: [ 9606.779375] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:18 ancizan kernel: [ 9606.811368] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:18 ancizan kernel: [ 9606.843381] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:18 ancizan kernel: [ 9606.875368] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:18 ancizan kernel: [ 9606.907369] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:18 ancizan kernel: [ 9606.939367] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:19 ancizan kernel: [ 9606.971378] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:19 ancizan kernel: [ 9607.003374] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:19 ancizan kernel: [ 9607.035378] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:19 ancizan kernel: [ 9607.067379] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:19 ancizan kernel: [ 9607.099375] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:19 ancizan kernel: [ 9607.131378] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:19 ancizan kernel: [ 9607.163379] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:19 ancizan kernel: [ 9607.195381] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:19 ancizan kernel: [ 9607.227377] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:19 ancizan kernel: [ 9607.259394] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:19 ancizan kernel: [ 9607.291370] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:19 ancizan kernel: [ 9607.323378] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:19 ancizan kernel: [ 9607.355364] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:19 ancizan kernel: [ 9607.387373] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:19 ancizan kernel: [ 9607.419370] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:19 ancizan kernel: [ 9607.451369] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:19 ancizan kernel: [ 9607.483371] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:19 ancizan kernel: [ 9607.515370] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:19 ancizan kernel: [ 9607.547381] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:19 ancizan kernel: [ 9607.579389] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:19 ancizan kernel: [ 9607.611389] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:19 ancizan kernel: [ 9607.643387] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:19 ancizan kernel: [ 9607.675376] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:19 ancizan kernel: [ 9607.707370] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:19 ancizan kernel: [ 9607.739376] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:19 ancizan kernel: [ 9607.771397] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:19 ancizan kernel: [ 9607.803374] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:19 ancizan kernel: [ 9607.835373] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:19 ancizan kernel: [ 9607.867380] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:19 ancizan kernel: [ 9607.899369] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:19 ancizan kernel: [ 9607.931377] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:20 ancizan kernel: [ 9607.963370] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:20 ancizan kernel: [ 9607.995369] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:20 ancizan kernel: [ 9608.027375] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:20 ancizan kernel: [ 9608.059379] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:20 ancizan kernel: [ 9608.091378] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:20 ancizan kernel: [ 9608.123376] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:20 ancizan kernel: [ 9608.155379] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:20 ancizan kernel: [ 9608.187367] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:20 ancizan kernel: [ 9608.219369] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:20 ancizan kernel: [ 9608.251383] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:20 ancizan kernel: [ 9608.283373] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:20 ancizan kernel: [ 9608.315384] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:20 ancizan kernel: [ 9608.347372] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:20 ancizan kernel: [ 9608.379391] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:20 ancizan kernel: [ 9608.411377] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:20 ancizan kernel: [ 9608.443379] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:20 ancizan kernel: [ 9608.475379] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:20 ancizan kernel: [ 9608.507379] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:20 ancizan kernel: [ 9608.539391] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:20 ancizan kernel: [ 9608.571375] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:20 ancizan kernel: [ 9608.603372] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:20 ancizan kernel: [ 9608.635376] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:20 ancizan kernel: [ 9608.667376] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:20 ancizan kernel: [ 9608.699377] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:20 ancizan kernel: [ 9608.731377] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:20 ancizan kernel: [ 9608.763386] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:20 ancizan kernel: [ 9608.795375] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:20 ancizan kernel: [ 9608.827389] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:20 ancizan kernel: [ 9608.859391] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:20 ancizan kernel: [ 9608.891380] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:20 ancizan kernel: [ 9608.923373] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:20 ancizan kernel: [ 9608.955374] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:21 ancizan kernel: [ 9608.987380] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:21 ancizan kernel: [ 9609.019387] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:21 ancizan kernel: [ 9609.051390] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:21 ancizan kernel: [ 9609.083372] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:21 ancizan kernel: [ 9609.115382] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:21 ancizan kernel: [ 9609.147378] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:21 ancizan kernel: [ 9609.179375] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:21 ancizan kernel: [ 9609.211378] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:21 ancizan kernel: [ 9609.243364] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:21 ancizan kernel: [ 9609.275374] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:21 ancizan kernel: [ 9609.307380] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:21 ancizan kernel: [ 9609.339369] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:21 ancizan kernel: [ 9609.371373] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:21 ancizan kernel: [ 9609.403422] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:21 ancizan kernel: [ 9609.435368] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:21 ancizan kernel: [ 9609.467366] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:21 ancizan kernel: [ 9609.499381] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:21 ancizan kernel: [ 9609.531370] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:21 ancizan kernel: [ 9609.563374] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:21 ancizan kernel: [ 9609.595373] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:21 ancizan kernel: [ 9609.627371] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:21 ancizan kernel: [ 9609.659371] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:21 ancizan kernel: [ 9609.691380] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:21 ancizan kernel: [ 9609.723380] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:21 ancizan kernel: [ 9609.755385] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:21 ancizan kernel: [ 9609.787379] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:21 ancizan kernel: [ 9609.819392] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:21 ancizan kernel: [ 9609.851372] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:21 ancizan kernel: [ 9609.883385] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:21 ancizan kernel: [ 9609.915389] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:21 ancizan kernel: [ 9609.947391] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:22 ancizan kernel: [ 9609.979378] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:22 ancizan kernel: [ 9610.011380] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:22 ancizan kernel: [ 9610.043382] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:22 ancizan kernel: [ 9610.075388] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:22 ancizan kernel: [ 9610.107372] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:22 ancizan kernel: [ 9610.139376] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:22 ancizan kernel: [ 9610.171371] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:22 ancizan kernel: [ 9610.203379] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:22 ancizan kernel: [ 9610.235378] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:22 ancizan kernel: [ 9610.267405] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:22 ancizan kernel: [ 9610.299372] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:22 ancizan kernel: [ 9610.331380] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:22 ancizan kernel: [ 9610.363372] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:22 ancizan kernel: [ 9610.395378] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:22 ancizan kernel: [ 9610.427398] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:22 ancizan kernel: [ 9610.459383] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:22 ancizan kernel: [ 9610.491370] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:22 ancizan kernel: [ 9610.523373] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:22 ancizan kernel: [ 9610.555379] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:22 ancizan kernel: [ 9610.587377] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:22 ancizan kernel: [ 9610.619374] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:22 ancizan kernel: [ 9610.651372] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:22 ancizan kernel: [ 9610.683377] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:22 ancizan kernel: [ 9610.715392] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:22 ancizan kernel: [ 9610.747378] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:22 ancizan kernel: [ 9610.779372] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:22 ancizan kernel: [ 9610.811376] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:22 ancizan kernel: [ 9610.843367] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:22 ancizan kernel: [ 9610.875371] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:22 ancizan kernel: [ 9610.907372] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:22 ancizan kernel: [ 9610.939365] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:23 ancizan kernel: [ 9610.971372] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:23 ancizan kernel: [ 9611.003394] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:23 ancizan kernel: [ 9611.035371] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:23 ancizan kernel: [ 9611.067372] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:23 ancizan kernel: [ 9611.099381] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:23 ancizan kernel: [ 9611.131381] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:23 ancizan kernel: [ 9611.163376] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:23 ancizan kernel: [ 9611.195387] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:23 ancizan kernel: [ 9611.227379] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:23 ancizan kernel: [ 9611.259394] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:23 ancizan kernel: [ 9611.291379] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:23 ancizan kernel: [ 9611.323373] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:23 ancizan kernel: [ 9611.355389] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:23 ancizan kernel: [ 9611.387382] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:23 ancizan kernel: [ 9611.419391] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:23 ancizan kernel: [ 9611.451390] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:23 ancizan kernel: [ 9611.483389] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:23 ancizan kernel: [ 9611.515375] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:23 ancizan kernel: [ 9611.547378] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:23 ancizan kernel: [ 9611.579379] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:23 ancizan kernel: [ 9611.611390] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:23 ancizan kernel: [ 9611.643374] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:23 ancizan kernel: [ 9611.675370] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:23 ancizan kernel: [ 9611.707371] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:23 ancizan kernel: [ 9611.739370] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:23 ancizan kernel: [ 9611.771373] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:23 ancizan kernel: [ 9611.803381] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:23 ancizan kernel: [ 9611.835377] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:23 ancizan kernel: [ 9611.867390] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:23 ancizan kernel: [ 9611.899391] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:23 ancizan kernel: [ 9611.931377] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:24 ancizan kernel: [ 9611.963383] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:24 ancizan kernel: [ 9611.995374] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:24 ancizan kernel: [ 9612.027380] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:24 ancizan kernel: [ 9612.059372] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:24 ancizan kernel: [ 9612.091379] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:24 ancizan kernel: [ 9612.123386] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:24 ancizan kernel: [ 9612.155377] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:24 ancizan kernel: [ 9612.187374] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:24 ancizan kernel: [ 9612.219383] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:24 ancizan kernel: [ 9612.251388] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:24 ancizan kernel: [ 9612.283375] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:24 ancizan kernel: [ 9612.315383] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:24 ancizan kernel: [ 9612.347376] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:24 ancizan kernel: [ 9612.379390] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:24 ancizan kernel: [ 9612.411390] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:24 ancizan kernel: [ 9612.443378] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:24 ancizan kernel: [ 9612.475371] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:24 ancizan kernel: [ 9612.507379] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:24 ancizan kernel: [ 9612.539381] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:24 ancizan kernel: [ 9612.571378] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:24 ancizan kernel: [ 9612.603377] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:24 ancizan kernel: [ 9612.635377] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:24 ancizan kernel: [ 9612.667372] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:24 ancizan kernel: [ 9612.699374] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:24 ancizan kernel: [ 9612.731373] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:24 ancizan kernel: [ 9612.763382] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:24 ancizan kernel: [ 9612.795379] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:24 ancizan kernel: [ 9612.827368] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:24 ancizan kernel: [ 9612.859374] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:24 ancizan kernel: [ 9612.891371] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:24 ancizan kernel: [ 9612.923371] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:24 ancizan kernel: [ 9612.955376] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:25 ancizan kernel: [ 9612.987381] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:25 ancizan kernel: [ 9613.019382] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:25 ancizan kernel: [ 9613.051383] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:25 ancizan kernel: [ 9613.083373] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:25 ancizan kernel: [ 9613.115383] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:25 ancizan kernel: [ 9613.147393] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:25 ancizan kernel: [ 9613.179372] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:25 ancizan kernel: [ 9613.211367] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:25 ancizan kernel: [ 9613.243368] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:25 ancizan kernel: [ 9613.275373] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:25 ancizan kernel: [ 9613.307375] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:25 ancizan kernel: [ 9613.339378] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:25 ancizan kernel: [ 9613.371374] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:25 ancizan kernel: [ 9613.403363] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:25 ancizan kernel: [ 9613.435367] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:25 ancizan kernel: [ 9613.467369] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:25 ancizan kernel: [ 9613.499367] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:25 ancizan kernel: [ 9613.531374] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:25 ancizan kernel: [ 9613.563365] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:25 ancizan kernel: [ 9613.595381] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:25 ancizan kernel: [ 9613.627390] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:25 ancizan kernel: [ 9613.659384] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:25 ancizan kernel: [ 9613.691370] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:25 ancizan kernel: [ 9613.723366] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:25 ancizan kernel: [ 9613.755384] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:25 ancizan kernel: [ 9613.787378] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:25 ancizan kernel: [ 9613.819377] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:25 ancizan kernel: [ 9613.851367] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:25 ancizan kernel: [ 9613.883372] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:25 ancizan kernel: [ 9613.915409] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:25 ancizan kernel: [ 9613.947392] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:26 ancizan kernel: [ 9613.979374] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:26 ancizan kernel: [ 9614.011367] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:26 ancizan kernel: [ 9614.043369] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:26 ancizan kernel: [ 9614.075372] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:26 ancizan kernel: [ 9614.107368] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:26 ancizan kernel: [ 9614.139369] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:26 ancizan kernel: [ 9614.171371] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:26 ancizan kernel: [ 9614.203392] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:26 ancizan kernel: [ 9614.235372] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:26 ancizan kernel: [ 9614.267377] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:26 ancizan kernel: [ 9614.299369] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:26 ancizan kernel: [ 9614.331368] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:26 ancizan kernel: [ 9614.363373] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:26 ancizan kernel: [ 9614.395369] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:26 ancizan kernel: [ 9614.427379] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:26 ancizan kernel: [ 9614.459380] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:26 ancizan kernel: [ 9614.491376] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:26 ancizan kernel: [ 9614.523374] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:26 ancizan kernel: [ 9614.555366] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:26 ancizan kernel: [ 9614.587366] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:26 ancizan kernel: [ 9614.619368] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:26 ancizan kernel: [ 9614.651365] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:26 ancizan kernel: [ 9614.683366] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:26 ancizan kernel: [ 9614.715365] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:26 ancizan kernel: [ 9614.747365] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:26 ancizan kernel: [ 9614.779366] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:26 ancizan kernel: [ 9614.811366] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:26 ancizan kernel: [ 9614.843368] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:26 ancizan kernel: [ 9614.875381] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:26 ancizan kernel: [ 9614.907402] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:26 ancizan kernel: [ 9614.939376] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:27 ancizan kernel: [ 9614.971366] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:27 ancizan kernel: [ 9615.003368] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:27 ancizan kernel: [ 9615.035371] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:27 ancizan kernel: [ 9615.067371] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:27 ancizan kernel: [ 9615.099391] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:27 ancizan kernel: [ 9615.131385] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:27 ancizan kernel: [ 9615.163381] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:27 ancizan kernel: [ 9615.195379] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:27 ancizan kernel: [ 9615.227368] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:27 ancizan kernel: [ 9615.259372] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:27 ancizan kernel: [ 9615.291370] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:27 ancizan kernel: [ 9615.323383] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:27 ancizan kernel: [ 9615.355375] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:27 ancizan kernel: [ 9615.387393] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:27 ancizan kernel: [ 9615.419393] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:27 ancizan kernel: [ 9615.451363] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:27 ancizan kernel: [ 9615.483366] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:27 ancizan kernel: [ 9615.515409] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:27 ancizan kernel: [ 9615.547380] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:27 ancizan kernel: [ 9615.579390] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:27 ancizan kernel: [ 9615.611401] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:27 ancizan kernel: [ 9615.643380] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:27 ancizan kernel: [ 9615.675389] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:27 ancizan kernel: [ 9615.707381] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:27 ancizan kernel: [ 9615.739379] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:27 ancizan kernel: [ 9615.771381] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:27 ancizan kernel: [ 9615.803390] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:27 ancizan kernel: [ 9615.835375] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:27 ancizan kernel: [ 9615.867378] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:27 ancizan kernel: [ 9615.899393] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:27 ancizan kernel: [ 9615.931391] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:28 ancizan kernel: [ 9615.963379] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:28 ancizan kernel: [ 9615.995378] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:28 ancizan kernel: [ 9616.027381] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:28 ancizan kernel: [ 9616.059379] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:28 ancizan kernel: [ 9616.091394] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:28 ancizan kernel: [ 9616.123376] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:28 ancizan kernel: [ 9616.155375] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:28 ancizan kernel: [ 9616.187386] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:28 ancizan kernel: [ 9616.219366] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:28 ancizan kernel: [ 9616.251380] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:28 ancizan kernel: [ 9616.283383] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:28 ancizan kernel: [ 9616.315391] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:28 ancizan kernel: [ 9616.347372] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:28 ancizan kernel: [ 9616.379383] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:28 ancizan kernel: [ 9616.411372] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:28 ancizan kernel: [ 9616.443374] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:28 ancizan kernel: [ 9616.475375] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:28 ancizan kernel: [ 9616.507393] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:28 ancizan kernel: [ 9616.539384] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:28 ancizan kernel: [ 9616.571378] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:28 ancizan kernel: [ 9616.603375] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:28 ancizan kernel: [ 9616.635373] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:28 ancizan kernel: [ 9616.667365] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:28 ancizan kernel: [ 9616.699369] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:28 ancizan kernel: [ 9616.731364] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:28 ancizan kernel: [ 9616.763367] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:28 ancizan kernel: [ 9616.795369] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:28 ancizan kernel: [ 9616.827377] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:28 ancizan kernel: [ 9616.859371] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:28 ancizan kernel: [ 9616.891367] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:28 ancizan kernel: [ 9616.923372] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:28 ancizan kernel: [ 9616.955379] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:29 ancizan kernel: [ 9616.987387] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:29 ancizan kernel: [ 9617.019373] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:29 ancizan kernel: [ 9617.051376] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:29 ancizan kernel: [ 9617.083376] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:29 ancizan kernel: [ 9617.115384] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:29 ancizan kernel: [ 9617.147392] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:29 ancizan kernel: [ 9617.179379] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:29 ancizan kernel: [ 9617.211371] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:29 ancizan kernel: [ 9617.243367] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:29 ancizan kernel: [ 9617.275368] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:29 ancizan kernel: [ 9617.307368] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:29 ancizan kernel: [ 9617.339376] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:29 ancizan kernel: [ 9617.371380] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:29 ancizan kernel: [ 9617.403367] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:29 ancizan kernel: [ 9617.435376] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:29 ancizan kernel: [ 9617.467372] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:29 ancizan kernel: [ 9617.499368] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:29 ancizan kernel: [ 9617.531372] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:29 ancizan kernel: [ 9617.563374] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:29 ancizan kernel: [ 9617.595376] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:29 ancizan kernel: [ 9617.627371] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:29 ancizan kernel: [ 9617.659378] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:29 ancizan kernel: [ 9617.691382] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:29 ancizan kernel: [ 9617.723368] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:29 ancizan kernel: [ 9617.755383] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:29 ancizan kernel: [ 9617.787374] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:29 ancizan kernel: [ 9617.819385] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:29 ancizan kernel: [ 9617.851383] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:29 ancizan kernel: [ 9617.883392] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:29 ancizan kernel: [ 9617.915382] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:29 ancizan kernel: [ 9617.947391] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:30 ancizan kernel: [ 9617.979387] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:30 ancizan kernel: [ 9618.011379] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:30 ancizan kernel: [ 9618.043404] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:30 ancizan kernel: [ 9618.075376] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:30 ancizan kernel: [ 9618.107375] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:30 ancizan kernel: [ 9618.139377] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:30 ancizan kernel: [ 9618.171378] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:30 ancizan kernel: [ 9618.203381] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:30 ancizan kernel: [ 9618.235382] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:30 ancizan kernel: [ 9618.267376] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:30 ancizan kernel: [ 9618.299381] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:30 ancizan kernel: [ 9618.331382] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:30 ancizan kernel: [ 9618.363397] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:30 ancizan kernel: [ 9618.395381] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:30 ancizan kernel: [ 9618.427396] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:30 ancizan kernel: [ 9618.459381] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:30 ancizan kernel: [ 9618.491375] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:30 ancizan kernel: [ 9618.523375] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:30 ancizan kernel: [ 9618.555392] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:30 ancizan kernel: [ 9618.587387] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:30 ancizan kernel: [ 9618.619376] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:30 ancizan kernel: [ 9618.651375] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:30 ancizan kernel: [ 9618.683393] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:30 ancizan kernel: [ 9618.715380] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:30 ancizan kernel: [ 9618.747380] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:30 ancizan kernel: [ 9618.779379] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:30 ancizan kernel: [ 9618.811384] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:30 ancizan kernel: [ 9618.843382] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:30 ancizan kernel: [ 9618.875380] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:30 ancizan kernel: [ 9618.907381] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:30 ancizan kernel: [ 9618.939373] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:31 ancizan kernel: [ 9618.971374] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:31 ancizan kernel: [ 9619.003383] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:31 ancizan kernel: [ 9619.035392] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:31 ancizan kernel: [ 9619.067382] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:31 ancizan kernel: [ 9619.099376] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:31 ancizan kernel: [ 9619.131391] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:31 ancizan kernel: [ 9619.163385] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:31 ancizan kernel: [ 9619.195395] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:31 ancizan kernel: [ 9619.227372] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:31 ancizan kernel: [ 9619.259380] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:31 ancizan kernel: [ 9619.291368] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:31 ancizan kernel: [ 9619.323384] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:31 ancizan kernel: [ 9619.355375] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:31 ancizan kernel: [ 9619.387372] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:31 ancizan kernel: [ 9619.419374] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:31 ancizan kernel: [ 9619.451372] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:31 ancizan kernel: [ 9619.483378] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:31 ancizan kernel: [ 9619.515382] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:31 ancizan kernel: [ 9619.547381] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:31 ancizan kernel: [ 9619.579375] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:31 ancizan kernel: [ 9619.611378] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:31 ancizan kernel: [ 9619.643379] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:31 ancizan kernel: [ 9619.675373] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:31 ancizan kernel: [ 9619.707393] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:31 ancizan kernel: [ 9619.739375] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:31 ancizan kernel: [ 9619.771387] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:31 ancizan kernel: [ 9619.803376] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:31 ancizan kernel: [ 9619.835382] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:31 ancizan kernel: [ 9619.867396] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:31 ancizan kernel: [ 9619.899372] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:31 ancizan kernel: [ 9619.931389] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:32 ancizan kernel: [ 9619.963386] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:32 ancizan kernel: [ 9619.995376] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:32 ancizan kernel: [ 9620.027383] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:32 ancizan kernel: [ 9620.059399] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:32 ancizan kernel: [ 9620.091377] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:32 ancizan kernel: [ 9620.123375] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:32 ancizan kernel: [ 9620.155389] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:32 ancizan kernel: [ 9620.187372] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:32 ancizan kernel: [ 9620.219406] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:32 ancizan kernel: [ 9620.251384] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:32 ancizan kernel: [ 9620.283399] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:32 ancizan kernel: [ 9620.315395] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:32 ancizan kernel: [ 9620.347377] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:32 ancizan kernel: [ 9620.379375] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:32 ancizan kernel: [ 9620.411396] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:32 ancizan kernel: [ 9620.443375] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:32 ancizan kernel: [ 9620.475376] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:32 ancizan kernel: [ 9620.507382] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:32 ancizan kernel: [ 9620.539373] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:32 ancizan kernel: [ 9620.571376] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:32 ancizan kernel: [ 9620.603382] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:32 ancizan kernel: [ 9620.635376] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:32 ancizan kernel: [ 9620.667377] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:32 ancizan kernel: [ 9620.699383] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:32 ancizan kernel: [ 9620.731383] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:32 ancizan kernel: [ 9620.763396] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:32 ancizan kernel: [ 9620.795382] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:32 ancizan kernel: [ 9620.827376] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:32 ancizan kernel: [ 9620.859383] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:32 ancizan kernel: [ 9620.891376] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:32 ancizan kernel: [ 9620.923393] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:32 ancizan kernel: [ 9620.955367] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:33 ancizan kernel: [ 9620.987384] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:33 ancizan kernel: [ 9621.019384] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:33 ancizan kernel: [ 9621.051383] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:33 ancizan kernel: [ 9621.083384] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:33 ancizan kernel: [ 9621.115391] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:33 ancizan kernel: [ 9621.147375] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:33 ancizan kernel: [ 9621.179385] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:33 ancizan kernel: [ 9621.211397] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:33 ancizan kernel: [ 9621.243377] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:33 ancizan kernel: [ 9621.275379] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:33 ancizan kernel: [ 9621.307379] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:33 ancizan kernel: [ 9621.339378] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:33 ancizan kernel: [ 9621.371376] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:33 ancizan kernel: [ 9621.403399] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:33 ancizan kernel: [ 9621.435374] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:33 ancizan kernel: [ 9621.467377] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:33 ancizan kernel: [ 9621.499384] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:33 ancizan kernel: [ 9621.531383] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:33 ancizan kernel: [ 9621.563376] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:33 ancizan kernel: [ 9621.595400] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:33 ancizan kernel: [ 9621.627383] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:33 ancizan kernel: [ 9621.659383] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:33 ancizan kernel: [ 9621.691391] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:33 ancizan kernel: [ 9621.723380] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:33 ancizan kernel: [ 9621.755377] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:33 ancizan kernel: [ 9621.787395] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:33 ancizan kernel: [ 9621.819383] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:33 ancizan kernel: [ 9621.851376] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:33 ancizan kernel: [ 9621.883384] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:33 ancizan kernel: [ 9621.915377] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:33 ancizan kernel: [ 9621.947389] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:34 ancizan kernel: [ 9621.979377] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:34 ancizan kernel: [ 9622.011377] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:34 ancizan kernel: [ 9622.043375] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:34 ancizan kernel: [ 9622.075387] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:34 ancizan kernel: [ 9622.107373] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:34 ancizan kernel: [ 9622.139384] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:34 ancizan kernel: [ 9622.171375] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:34 ancizan kernel: [ 9622.203375] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:34 ancizan kernel: [ 9622.235384] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:34 ancizan kernel: [ 9622.267381] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:34 ancizan kernel: [ 9622.299380] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:34 ancizan kernel: [ 9622.331384] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:34 ancizan kernel: [ 9622.363376] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:34 ancizan kernel: [ 9622.395385] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:34 ancizan kernel: [ 9622.427398] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:34 ancizan kernel: [ 9622.459387] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:34 ancizan kernel: [ 9622.491383] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:34 ancizan kernel: [ 9622.523375] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:34 ancizan kernel: [ 9622.555383] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:34 ancizan kernel: [ 9622.587384] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:34 ancizan kernel: [ 9622.619378] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:34 ancizan kernel: [ 9622.651383] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:34 ancizan kernel: [ 9622.683383] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:34 ancizan kernel: [ 9622.715380] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:34 ancizan kernel: [ 9622.747381] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:34 ancizan kernel: [ 9622.779377] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:34 ancizan kernel: [ 9622.811380] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:34 ancizan kernel: [ 9622.843374] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:34 ancizan kernel: [ 9622.875385] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:34 ancizan kernel: [ 9622.907374] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:34 ancizan kernel: [ 9622.939376] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:35 ancizan kernel: [ 9622.971372] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:35 ancizan kernel: [ 9623.003381] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:35 ancizan kernel: [ 9623.035380] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:35 ancizan kernel: [ 9623.067385] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:35 ancizan kernel: [ 9623.099376] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:35 ancizan kernel: [ 9623.131375] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:35 ancizan kernel: [ 9623.163369] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:35 ancizan kernel: [ 9623.195381] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:35 ancizan kernel: [ 9623.227371] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:35 ancizan kernel: [ 9623.259374] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:35 ancizan kernel: [ 9623.291375] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:35 ancizan kernel: [ 9623.323370] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:35 ancizan kernel: [ 9623.355386] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:35 ancizan kernel: [ 9623.387388] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:35 ancizan kernel: [ 9623.419384] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:35 ancizan kernel: [ 9623.451392] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:35 ancizan kernel: [ 9623.483380] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:35 ancizan kernel: [ 9623.515377] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:35 ancizan kernel: [ 9623.547386] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:35 ancizan kernel: [ 9623.579382] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:35 ancizan kernel: [ 9623.611377] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:35 ancizan kernel: [ 9623.643396] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:35 ancizan kernel: [ 9623.675375] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:35 ancizan kernel: [ 9623.707401] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:35 ancizan kernel: [ 9623.739373] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:35 ancizan kernel: [ 9623.771376] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:35 ancizan kernel: [ 9623.803379] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:35 ancizan kernel: [ 9623.835384] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:35 ancizan kernel: [ 9623.867387] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:35 ancizan kernel: [ 9623.899372] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:35 ancizan kernel: [ 9623.931374] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:36 ancizan kernel: [ 9623.963369] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:36 ancizan kernel: [ 9623.995371] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:36 ancizan kernel: [ 9624.027369] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:36 ancizan kernel: [ 9624.059370] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:36 ancizan kernel: [ 9624.091377] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:36 ancizan kernel: [ 9624.123386] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:36 ancizan kernel: [ 9624.155387] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:36 ancizan kernel: [ 9624.187384] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:36 ancizan kernel: [ 9624.219381] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:36 ancizan kernel: [ 9624.251377] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:36 ancizan kernel: [ 9624.283378] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:36 ancizan kernel: [ 9624.315388] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:36 ancizan kernel: [ 9624.347374] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:36 ancizan kernel: [ 9624.379371] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:36 ancizan kernel: [ 9624.411381] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:36 ancizan kernel: [ 9624.443372] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:36 ancizan kernel: [ 9624.475378] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:36 ancizan kernel: [ 9624.507386] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:36 ancizan kernel: [ 9624.539376] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:36 ancizan kernel: [ 9624.571374] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:36 ancizan kernel: [ 9624.603384] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:36 ancizan kernel: [ 9624.635392] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:36 ancizan kernel: [ 9624.667381] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:36 ancizan kernel: [ 9624.699375] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:36 ancizan kernel: [ 9624.731377] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:36 ancizan kernel: [ 9624.763374] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:36 ancizan kernel: [ 9624.795374] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:36 ancizan kernel: [ 9624.827374] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:36 ancizan kernel: [ 9624.859376] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:36 ancizan kernel: [ 9624.891376] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:36 ancizan kernel: [ 9624.923384] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:36 ancizan kernel: [ 9624.955378] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:37 ancizan kernel: [ 9624.987384] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:37 ancizan kernel: [ 9625.019377] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:37 ancizan kernel: [ 9625.051410] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:37 ancizan kernel: [ 9625.083380] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:37 ancizan kernel: [ 9625.115382] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:37 ancizan kernel: [ 9625.147380] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:37 ancizan kernel: [ 9625.179382] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:37 ancizan kernel: [ 9625.211377] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:37 ancizan kernel: [ 9625.243376] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:37 ancizan kernel: [ 9625.275383] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:37 ancizan kernel: [ 9625.307383] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:37 ancizan kernel: [ 9625.339384] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:37 ancizan kernel: [ 9625.371397] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:37 ancizan kernel: [ 9625.403375] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:37 ancizan kernel: [ 9625.435375] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:37 ancizan kernel: [ 9625.467387] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:37 ancizan kernel: [ 9625.499375] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:37 ancizan kernel: [ 9625.531403] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:37 ancizan kernel: [ 9625.563402] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:37 ancizan kernel: [ 9625.595384] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:37 ancizan kernel: [ 9625.627396] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:37 ancizan kernel: [ 9625.659399] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:37 ancizan kernel: [ 9625.691387] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:37 ancizan kernel: [ 9625.723386] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:37 ancizan kernel: [ 9625.755374] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:37 ancizan kernel: [ 9625.787388] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:37 ancizan kernel: [ 9625.819377] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:37 ancizan kernel: [ 9625.851377] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:37 ancizan kernel: [ 9625.883377] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:37 ancizan kernel: [ 9625.915375] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:37 ancizan kernel: [ 9625.947383] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:38 ancizan kernel: [ 9625.979371] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:38 ancizan kernel: [ 9626.011386] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:38 ancizan kernel: [ 9626.043373] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:38 ancizan kernel: [ 9626.075385] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:38 ancizan kernel: [ 9626.107376] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:38 ancizan kernel: [ 9626.139384] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:38 ancizan kernel: [ 9626.171378] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:38 ancizan kernel: [ 9626.203379] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:38 ancizan kernel: [ 9626.235384] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:38 ancizan kernel: [ 9626.267380] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:38 ancizan kernel: [ 9626.299389] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:38 ancizan kernel: [ 9626.331378] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:38 ancizan kernel: [ 9626.363374] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:38 ancizan kernel: [ 9626.395389] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:38 ancizan kernel: [ 9626.427387] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:38 ancizan kernel: [ 9626.459386] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:38 ancizan kernel: [ 9626.491376] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:38 ancizan kernel: [ 9626.523384] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:38 ancizan kernel: [ 9626.555377] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:38 ancizan kernel: [ 9626.587396] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:38 ancizan kernel: [ 9626.619388] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:38 ancizan kernel: [ 9626.651381] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:38 ancizan kernel: [ 9626.683377] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:38 ancizan kernel: [ 9626.715377] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:38 ancizan kernel: [ 9626.747381] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:38 ancizan kernel: [ 9626.779396] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:38 ancizan kernel: [ 9626.811379] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:38 ancizan kernel: [ 9626.843384] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:38 ancizan kernel: [ 9626.875402] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:38 ancizan kernel: [ 9626.907382] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:38 ancizan kernel: [ 9626.939401] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:39 ancizan kernel: [ 9626.971378] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:39 ancizan kernel: [ 9627.003384] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:39 ancizan kernel: [ 9627.035400] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:39 ancizan kernel: [ 9627.067378] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:39 ancizan kernel: [ 9627.099382] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:39 ancizan kernel: [ 9627.131379] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:39 ancizan kernel: [ 9627.163377] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:39 ancizan kernel: [ 9627.195378] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:39 ancizan kernel: [ 9627.227395] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:39 ancizan kernel: [ 9627.259385] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:39 ancizan kernel: [ 9627.291379] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:39 ancizan kernel: [ 9627.323381] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:39 ancizan kernel: [ 9627.355385] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:39 ancizan kernel: [ 9627.387383] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:39 ancizan kernel: [ 9627.419395] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:39 ancizan kernel: [ 9627.451396] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:39 ancizan kernel: [ 9627.483383] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:39 ancizan kernel: [ 9627.515383] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:39 ancizan kernel: [ 9627.547395] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:39 ancizan kernel: [ 9627.579384] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:39 ancizan kernel: [ 9627.611403] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:39 ancizan kernel: [ 9627.643385] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:39 ancizan kernel: [ 9627.675393] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:39 ancizan kernel: [ 9627.707385] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:39 ancizan kernel: [ 9627.739377] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:39 ancizan kernel: [ 9627.771387] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:39 ancizan kernel: [ 9627.803389] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:39 ancizan kernel: [ 9627.835385] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:39 ancizan kernel: [ 9627.867386] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:39 ancizan kernel: [ 9627.899382] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:39 ancizan kernel: [ 9627.931379] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:40 ancizan kernel: [ 9627.963375] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:40 ancizan kernel: [ 9627.995386] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:40 ancizan kernel: [ 9628.027386] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:40 ancizan kernel: [ 9628.059387] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:40 ancizan kernel: [ 9628.091397] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:40 ancizan kernel: [ 9628.123379] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:40 ancizan kernel: [ 9628.155384] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:40 ancizan kernel: [ 9628.187395] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:40 ancizan kernel: [ 9628.219378] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:40 ancizan kernel: [ 9628.251407] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:40 ancizan kernel: [ 9628.283384] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:40 ancizan kernel: [ 9628.315376] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:40 ancizan kernel: [ 9628.347385] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:40 ancizan kernel: [ 9628.379376] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:40 ancizan kernel: [ 9628.411374] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:40 ancizan kernel: [ 9628.443387] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:40 ancizan kernel: [ 9628.475374] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:40 ancizan kernel: [ 9628.507377] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:40 ancizan kernel: [ 9628.539388] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:40 ancizan kernel: [ 9628.571371] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:40 ancizan kernel: [ 9628.603388] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:40 ancizan kernel: [ 9628.635378] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:40 ancizan kernel: [ 9628.667399] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:40 ancizan kernel: [ 9628.699380] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:40 ancizan kernel: [ 9628.731385] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:40 ancizan kernel: [ 9628.763385] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:40 ancizan kernel: [ 9628.795388] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:40 ancizan kernel: [ 9628.827386] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:40 ancizan kernel: [ 9628.859385] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:40 ancizan kernel: [ 9628.891383] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:40 ancizan kernel: [ 9628.923381] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:40 ancizan kernel: [ 9628.955386] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:41 ancizan kernel: [ 9628.987385] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:41 ancizan kernel: [ 9629.019382] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:41 ancizan kernel: [ 9629.051381] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:41 ancizan kernel: [ 9629.083383] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:41 ancizan kernel: [ 9629.115378] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:41 ancizan kernel: [ 9629.147388] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:41 ancizan kernel: [ 9629.179379] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:41 ancizan kernel: [ 9629.211392] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:41 ancizan kernel: [ 9629.243380] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:41 ancizan kernel: [ 9629.275384] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:41 ancizan kernel: [ 9629.307383] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:41 ancizan kernel: [ 9629.339387] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:41 ancizan kernel: [ 9629.371394] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:41 ancizan kernel: [ 9629.403383] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:41 ancizan kernel: [ 9629.435385] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:41 ancizan kernel: [ 9629.467383] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:41 ancizan kernel: [ 9629.499383] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:41 ancizan kernel: [ 9629.531376] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:41 ancizan kernel: [ 9629.563376] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:41 ancizan kernel: [ 9629.595377] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:41 ancizan kernel: [ 9629.627371] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:41 ancizan kernel: [ 9629.659374] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:41 ancizan kernel: [ 9629.691388] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:41 ancizan kernel: [ 9629.723382] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:41 ancizan kernel: [ 9629.755382] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:41 ancizan kernel: [ 9629.787382] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:41 ancizan kernel: [ 9629.819379] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:41 ancizan kernel: [ 9629.851386] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:41 ancizan kernel: [ 9629.883371] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:41 ancizan kernel: [ 9629.915376] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:41 ancizan kernel: [ 9629.947375] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:42 ancizan kernel: [ 9629.979382] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:42 ancizan kernel: [ 9630.011381] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:42 ancizan kernel: [ 9630.043389] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:42 ancizan kernel: [ 9630.075372] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:42 ancizan kernel: [ 9630.107385] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:42 ancizan kernel: [ 9630.139379] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:42 ancizan kernel: [ 9630.171396] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:42 ancizan kernel: [ 9630.203391] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:42 ancizan kernel: [ 9630.235386] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:42 ancizan kernel: [ 9630.267388] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:42 ancizan kernel: [ 9630.299421] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:42 ancizan kernel: [ 9630.331400] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:42 ancizan kernel: [ 9630.363388] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:42 ancizan kernel: [ 9630.395392] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:42 ancizan kernel: [ 9630.427385] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:42 ancizan kernel: [ 9630.459389] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:42 ancizan kernel: [ 9630.491391] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:42 ancizan kernel: [ 9630.523384] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:42 ancizan kernel: [ 9630.555394] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:42 ancizan kernel: [ 9630.587386] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:42 ancizan kernel: [ 9630.619396] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:42 ancizan kernel: [ 9630.651384] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:42 ancizan kernel: [ 9630.683399] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:42 ancizan kernel: [ 9630.715379] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:42 ancizan kernel: [ 9630.747376] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:42 ancizan kernel: [ 9630.779399] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:42 ancizan kernel: [ 9630.811384] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:42 ancizan kernel: [ 9630.843377] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:42 ancizan kernel: [ 9630.875378] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:42 ancizan kernel: [ 9630.907386] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:42 ancizan kernel: [ 9630.939383] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:43 ancizan kernel: [ 9630.971373] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:43 ancizan kernel: [ 9631.003372] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:43 ancizan kernel: [ 9631.035389] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:43 ancizan kernel: [ 9631.067385] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:43 ancizan kernel: [ 9631.099378] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:43 ancizan kernel: [ 9631.131383] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:43 ancizan kernel: [ 9631.163379] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:43 ancizan kernel: [ 9631.195385] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:43 ancizan kernel: [ 9631.227382] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:43 ancizan kernel: [ 9631.259386] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:43 ancizan kernel: [ 9631.291384] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:43 ancizan kernel: [ 9631.323376] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:43 ancizan kernel: [ 9631.355425] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:43 ancizan kernel: [ 9631.387378] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:43 ancizan kernel: [ 9631.419376] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:43 ancizan kernel: [ 9631.451391] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:43 ancizan kernel: [ 9631.483385] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:43 ancizan kernel: [ 9631.515385] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:43 ancizan kernel: [ 9631.547375] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:43 ancizan kernel: [ 9631.579388] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:43 ancizan kernel: [ 9631.611378] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:43 ancizan kernel: [ 9631.643373] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:43 ancizan kernel: [ 9631.675377] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:43 ancizan kernel: [ 9631.707397] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:43 ancizan kernel: [ 9631.739379] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:43 ancizan kernel: [ 9631.771374] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:43 ancizan kernel: [ 9631.803376] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:43 ancizan kernel: [ 9631.835379] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:43 ancizan kernel: [ 9631.867376] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:43 ancizan kernel: [ 9631.899389] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:43 ancizan kernel: [ 9631.931381] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:44 ancizan kernel: [ 9631.963385] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:44 ancizan kernel: [ 9631.995380] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:44 ancizan kernel: [ 9632.027401] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:44 ancizan kernel: [ 9632.059379] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:44 ancizan kernel: [ 9632.091385] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:44 ancizan kernel: [ 9632.123404] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:44 ancizan kernel: [ 9632.155375] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:44 ancizan kernel: [ 9632.187392] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:44 ancizan kernel: [ 9632.219381] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:44 ancizan kernel: [ 9632.251372] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:44 ancizan kernel: [ 9632.283382] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:44 ancizan kernel: [ 9632.315384] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:44 ancizan kernel: [ 9632.347390] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:44 ancizan kernel: [ 9632.379375] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:44 ancizan kernel: [ 9632.411374] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:44 ancizan kernel: [ 9632.443380] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:44 ancizan kernel: [ 9632.475388] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:44 ancizan kernel: [ 9632.507394] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:44 ancizan kernel: [ 9632.539395] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:44 ancizan kernel: [ 9632.571385] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:44 ancizan kernel: [ 9632.603398] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:44 ancizan kernel: [ 9632.635388] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:44 ancizan kernel: [ 9632.667383] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:44 ancizan kernel: [ 9632.699379] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:44 ancizan kernel: [ 9632.731383] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:44 ancizan kernel: [ 9632.763380] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:44 ancizan kernel: [ 9632.795396] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:44 ancizan kernel: [ 9632.827397] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:44 ancizan kernel: [ 9632.859389] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:44 ancizan kernel: [ 9632.891380] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:44 ancizan kernel: [ 9632.923380] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:44 ancizan kernel: [ 9632.955379] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:45 ancizan kernel: [ 9632.987378] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:45 ancizan kernel: [ 9633.019395] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:45 ancizan kernel: [ 9633.051378] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:45 ancizan kernel: [ 9633.083380] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:45 ancizan kernel: [ 9633.115387] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:45 ancizan kernel: [ 9633.147379] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:45 ancizan kernel: [ 9633.179398] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:45 ancizan kernel: [ 9633.211382] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:45 ancizan kernel: [ 9633.243377] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:45 ancizan kernel: [ 9633.275382] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:45 ancizan kernel: [ 9633.307379] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:45 ancizan kernel: [ 9633.339378] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:45 ancizan kernel: [ 9633.371378] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:45 ancizan kernel: [ 9633.403373] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:45 ancizan kernel: [ 9633.435389] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:45 ancizan kernel: [ 9633.467382] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:45 ancizan kernel: [ 9633.499394] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:45 ancizan kernel: [ 9633.531398] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:45 ancizan kernel: [ 9633.563386] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:45 ancizan kernel: [ 9633.595386] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:45 ancizan kernel: [ 9633.627385] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:45 ancizan kernel: [ 9633.659385] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:45 ancizan kernel: [ 9633.691379] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:45 ancizan kernel: [ 9633.723383] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:45 ancizan kernel: [ 9633.755379] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:45 ancizan kernel: [ 9633.787400] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:45 ancizan kernel: [ 9633.819386] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:45 ancizan kernel: [ 9633.851401] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:45 ancizan kernel: [ 9633.883386] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:45 ancizan kernel: [ 9633.915420] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:45 ancizan kernel: [ 9633.947398] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:46 ancizan kernel: [ 9633.979383] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:46 ancizan kernel: [ 9634.011406] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:46 ancizan kernel: [ 9634.043387] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:46 ancizan kernel: [ 9634.075394] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:46 ancizan kernel: [ 9634.107379] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:46 ancizan kernel: [ 9634.139385] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:46 ancizan kernel: [ 9634.171396] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:46 ancizan kernel: [ 9634.203397] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:46 ancizan kernel: [ 9634.235380] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:46 ancizan kernel: [ 9634.267388] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:46 ancizan kernel: [ 9634.299387] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:46 ancizan kernel: [ 9634.331389] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:46 ancizan kernel: [ 9634.363400] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:46 ancizan kernel: [ 9634.395386] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:46 ancizan kernel: [ 9634.427393] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:46 ancizan kernel: [ 9634.459391] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:46 ancizan kernel: [ 9634.491385] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:46 ancizan kernel: [ 9634.523388] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:46 ancizan kernel: [ 9634.555387] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:46 ancizan kernel: [ 9634.587390] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:46 ancizan kernel: [ 9634.619381] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:46 ancizan kernel: [ 9634.651404] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:46 ancizan kernel: [ 9634.683384] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:46 ancizan kernel: [ 9634.715377] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:46 ancizan kernel: [ 9634.747388] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:46 ancizan kernel: [ 9634.779386] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:46 ancizan kernel: [ 9634.811387] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:46 ancizan kernel: [ 9634.843389] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:46 ancizan kernel: [ 9634.875388] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:46 ancizan kernel: [ 9634.907382] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:46 ancizan kernel: [ 9634.939381] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:47 ancizan kernel: [ 9634.971384] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:47 ancizan kernel: [ 9635.003382] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:47 ancizan kernel: [ 9635.035380] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:47 ancizan kernel: [ 9635.067393] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:47 ancizan kernel: [ 9635.099387] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:47 ancizan kernel: [ 9635.131379] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:47 ancizan kernel: [ 9635.163389] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:47 ancizan kernel: [ 9635.195377] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:47 ancizan kernel: [ 9635.227384] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:47 ancizan kernel: [ 9635.259392] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:47 ancizan kernel: [ 9635.291388] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:47 ancizan kernel: [ 9635.323390] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:47 ancizan kernel: [ 9635.355381] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:47 ancizan kernel: [ 9635.387380] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:47 ancizan kernel: [ 9635.419377] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:47 ancizan kernel: [ 9635.451386] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:47 ancizan kernel: [ 9635.483384] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:47 ancizan kernel: [ 9635.515380] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:47 ancizan kernel: [ 9635.547395] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:47 ancizan kernel: [ 9635.579388] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:47 ancizan kernel: [ 9635.611376] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:47 ancizan kernel: [ 9635.643375] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:47 ancizan kernel: [ 9635.675389] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:47 ancizan kernel: [ 9635.707379] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:47 ancizan kernel: [ 9635.739383] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:47 ancizan kernel: [ 9635.771382] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:47 ancizan kernel: [ 9635.803383] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:47 ancizan kernel: [ 9635.835386] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:47 ancizan kernel: [ 9635.867387] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:47 ancizan kernel: [ 9635.899386] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:47 ancizan kernel: [ 9635.931380] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:48 ancizan kernel: [ 9635.963376] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:48 ancizan kernel: [ 9635.995380] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:48 ancizan kernel: [ 9636.027385] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:48 ancizan kernel: [ 9636.059390] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:48 ancizan kernel: [ 9636.091388] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:48 ancizan kernel: [ 9636.123388] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:48 ancizan kernel: [ 9636.155385] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:48 ancizan kernel: [ 9636.187388] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:48 ancizan kernel: [ 9636.219392] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:48 ancizan kernel: [ 9636.251379] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:48 ancizan kernel: [ 9636.283398] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:48 ancizan kernel: [ 9636.315403] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:48 ancizan kernel: [ 9636.347395] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:48 ancizan kernel: [ 9636.379384] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:48 ancizan kernel: [ 9636.411377] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:48 ancizan kernel: [ 9636.443380] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:48 ancizan kernel: [ 9636.475386] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:48 ancizan kernel: [ 9636.507408] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:48 ancizan kernel: [ 9636.539405] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:48 ancizan kernel: [ 9636.571387] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:48 ancizan kernel: [ 9636.603382] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:48 ancizan kernel: [ 9636.635383] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:48 ancizan kernel: [ 9636.667382] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:48 ancizan kernel: [ 9636.699377] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:48 ancizan kernel: [ 9636.731381] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:48 ancizan kernel: [ 9636.763378] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:48 ancizan kernel: [ 9636.795380] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:48 ancizan kernel: [ 9636.827389] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:48 ancizan kernel: [ 9636.859386] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:48 ancizan kernel: [ 9636.891398] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:48 ancizan kernel: [ 9636.923395] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:48 ancizan kernel: [ 9636.955384] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:49 ancizan kernel: [ 9636.987396] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:49 ancizan kernel: [ 9637.019381] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:49 ancizan kernel: [ 9637.051381] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:49 ancizan kernel: [ 9637.083392] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:49 ancizan kernel: [ 9637.115386] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:49 ancizan kernel: [ 9637.147384] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:49 ancizan kernel: [ 9637.179386] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:49 ancizan kernel: [ 9637.211388] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:49 ancizan kernel: [ 9637.243382] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:49 ancizan kernel: [ 9637.275395] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:49 ancizan kernel: [ 9637.307392] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:49 ancizan kernel: [ 9637.339389] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:49 ancizan kernel: [ 9637.371389] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:49 ancizan kernel: [ 9637.403389] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:49 ancizan kernel: [ 9637.435401] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:49 ancizan kernel: [ 9637.467391] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:49 ancizan kernel: [ 9637.499381] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:49 ancizan kernel: [ 9637.531390] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:49 ancizan kernel: [ 9637.563387] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:49 ancizan kernel: [ 9637.595402] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:49 ancizan kernel: [ 9637.627387] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:49 ancizan kernel: [ 9637.659384] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:49 ancizan kernel: [ 9637.691384] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:49 ancizan kernel: [ 9637.723386] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:49 ancizan kernel: [ 9637.755386] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:49 ancizan kernel: [ 9637.787382] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:49 ancizan kernel: [ 9637.819389] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:49 ancizan kernel: [ 9637.851389] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:49 ancizan kernel: [ 9637.883405] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:49 ancizan kernel: [ 9637.915386] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:49 ancizan kernel: [ 9637.947389] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:50 ancizan kernel: [ 9637.979389] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:50 ancizan kernel: [ 9638.011404] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:50 ancizan kernel: [ 9638.043384] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:50 ancizan kernel: [ 9638.075401] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:50 ancizan kernel: [ 9638.107381] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:50 ancizan kernel: [ 9638.139383] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:50 ancizan kernel: [ 9638.171380] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:50 ancizan kernel: [ 9638.203405] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:50 ancizan kernel: [ 9638.235388] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:50 ancizan kernel: [ 9638.267383] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:50 ancizan kernel: [ 9638.299398] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:50 ancizan kernel: [ 9638.331392] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:50 ancizan kernel: [ 9638.363398] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:50 ancizan kernel: [ 9638.395388] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:50 ancizan kernel: [ 9638.427390] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:50 ancizan kernel: [ 9638.459392] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:50 ancizan kernel: [ 9638.491386] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:50 ancizan kernel: [ 9638.523382] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:50 ancizan kernel: [ 9638.555387] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:50 ancizan kernel: [ 9638.587390] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:50 ancizan kernel: [ 9638.619403] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:50 ancizan kernel: [ 9638.651397] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:50 ancizan kernel: [ 9638.683387] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:50 ancizan kernel: [ 9638.715389] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:50 ancizan kernel: [ 9638.747385] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:50 ancizan kernel: [ 9638.779381] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:50 ancizan kernel: [ 9638.811390] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:50 ancizan kernel: [ 9638.843386] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:50 ancizan kernel: [ 9638.875389] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:50 ancizan kernel: [ 9638.907385] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:50 ancizan kernel: [ 9638.939378] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:51 ancizan kernel: [ 9638.971396] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:51 ancizan kernel: [ 9639.003380] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:51 ancizan kernel: [ 9639.035380] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:51 ancizan kernel: [ 9639.067380] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:51 ancizan kernel: [ 9639.099378] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:51 ancizan kernel: [ 9639.131382] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:51 ancizan kernel: [ 9639.163380] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:51 ancizan kernel: [ 9639.195378] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:51 ancizan kernel: [ 9639.227381] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:51 ancizan kernel: [ 9639.259381] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:51 ancizan kernel: [ 9639.291379] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:51 ancizan kernel: [ 9639.323383] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:51 ancizan kernel: [ 9639.355380] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:51 ancizan kernel: [ 9639.387382] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:51 ancizan kernel: [ 9639.419385] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:51 ancizan kernel: [ 9639.451382] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:51 ancizan kernel: [ 9639.483375] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:51 ancizan kernel: [ 9639.515377] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:51 ancizan kernel: [ 9639.547390] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:51 ancizan kernel: [ 9639.579385] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:51 ancizan kernel: [ 9639.611378] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:51 ancizan kernel: [ 9639.643377] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:51 ancizan kernel: [ 9639.675389] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:51 ancizan kernel: [ 9639.707379] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:51 ancizan kernel: [ 9639.739395] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:51 ancizan kernel: [ 9639.771393] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:51 ancizan kernel: [ 9639.803381] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:51 ancizan kernel: [ 9639.835379] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:51 ancizan kernel: [ 9639.867382] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:51 ancizan kernel: [ 9639.899379] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:51 ancizan kernel: [ 9639.931381] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:52 ancizan kernel: [ 9639.963382] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:52 ancizan kernel: [ 9639.995382] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:52 ancizan kernel: [ 9640.027393] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:52 ancizan kernel: [ 9640.059390] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:52 ancizan kernel: [ 9640.091383] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:52 ancizan kernel: [ 9640.123390] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:52 ancizan kernel: [ 9640.155395] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:52 ancizan kernel: [ 9640.187390] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:52 ancizan kernel: [ 9640.219398] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:52 ancizan kernel: [ 9640.251380] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:52 ancizan kernel: [ 9640.283376] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:52 ancizan kernel: [ 9640.315392] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:52 ancizan kernel: [ 9640.347389] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:52 ancizan kernel: [ 9640.379387] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:52 ancizan kernel: [ 9640.411386] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:52 ancizan kernel: [ 9640.443392] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:52 ancizan kernel: [ 9640.475404] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:52 ancizan kernel: [ 9640.507388] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:52 ancizan kernel: [ 9640.539388] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:52 ancizan kernel: [ 9640.571381] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:52 ancizan kernel: [ 9640.603381] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:52 ancizan kernel: [ 9640.635431] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:52 ancizan kernel: [ 9640.667385] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:52 ancizan kernel: [ 9640.699381] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:52 ancizan kernel: [ 9640.731382] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:52 ancizan kernel: [ 9640.763390] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:52 ancizan kernel: [ 9640.795382] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:52 ancizan kernel: [ 9640.827389] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:52 ancizan kernel: [ 9640.859380] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:52 ancizan kernel: [ 9640.891381] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:52 ancizan kernel: [ 9640.923387] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:52 ancizan kernel: [ 9640.955384] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:53 ancizan kernel: [ 9640.987391] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:53 ancizan kernel: [ 9641.019376] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:53 ancizan kernel: [ 9641.051382] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:53 ancizan kernel: [ 9641.083381] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:53 ancizan kernel: [ 9641.115387] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:53 ancizan kernel: [ 9641.147380] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:53 ancizan kernel: [ 9641.179382] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:53 ancizan kernel: [ 9641.211377] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:53 ancizan kernel: [ 9641.243384] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:53 ancizan kernel: [ 9641.275394] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:53 ancizan kernel: [ 9641.307392] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:53 ancizan kernel: [ 9641.339388] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:53 ancizan kernel: [ 9641.371391] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:53 ancizan kernel: [ 9641.403383] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:53 ancizan kernel: [ 9641.435381] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:53 ancizan kernel: [ 9641.467391] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:53 ancizan kernel: [ 9641.499398] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:53 ancizan kernel: [ 9641.531387] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:53 ancizan kernel: [ 9641.563390] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:53 ancizan kernel: [ 9641.595376] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:53 ancizan kernel: [ 9641.627394] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:53 ancizan kernel: [ 9641.659376] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:53 ancizan kernel: [ 9641.691391] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:53 ancizan kernel: [ 9641.723393] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:53 ancizan kernel: [ 9641.755392] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:53 ancizan kernel: [ 9641.787382] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:53 ancizan kernel: [ 9641.819390] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:53 ancizan kernel: [ 9641.851390] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:53 ancizan kernel: [ 9641.883386] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:53 ancizan kernel: [ 9641.915382] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:53 ancizan kernel: [ 9641.947384] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:54 ancizan kernel: [ 9641.979380] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:54 ancizan kernel: [ 9642.011394] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:54 ancizan kernel: [ 9642.043377] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:54 ancizan kernel: [ 9642.075390] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:54 ancizan kernel: [ 9642.107377] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:54 ancizan kernel: [ 9642.139411] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:54 ancizan kernel: [ 9642.171384] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:54 ancizan kernel: [ 9642.203387] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:54 ancizan kernel: [ 9642.235388] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:54 ancizan kernel: [ 9642.267388] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:54 ancizan kernel: [ 9642.299393] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:54 ancizan kernel: [ 9642.331386] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:54 ancizan kernel: [ 9642.363376] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:54 ancizan kernel: [ 9642.395392] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:54 ancizan kernel: [ 9642.427381] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:54 ancizan kernel: [ 9642.459382] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:54 ancizan kernel: [ 9642.491381] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:54 ancizan kernel: [ 9642.523381] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:54 ancizan kernel: [ 9642.555384] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:54 ancizan kernel: [ 9642.587391] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:54 ancizan kernel: [ 9642.619388] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:54 ancizan kernel: [ 9642.651378] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:54 ancizan kernel: [ 9642.683380] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:54 ancizan kernel: [ 9642.715393] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:54 ancizan kernel: [ 9642.747379] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:54 ancizan kernel: [ 9642.779381] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:54 ancizan kernel: [ 9642.811391] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:54 ancizan kernel: [ 9642.843391] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:54 ancizan kernel: [ 9642.875382] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:54 ancizan kernel: [ 9642.907377] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:54 ancizan kernel: [ 9642.939380] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:55 ancizan kernel: [ 9642.971381] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:55 ancizan kernel: [ 9643.003390] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:55 ancizan kernel: [ 9643.035385] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:55 ancizan kernel: [ 9643.067390] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:55 ancizan kernel: [ 9643.099392] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:55 ancizan kernel: [ 9643.131393] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:55 ancizan kernel: [ 9643.163383] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:55 ancizan kernel: [ 9643.195392] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:55 ancizan kernel: [ 9643.227378] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:55 ancizan kernel: [ 9643.259382] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:55 ancizan kernel: [ 9643.291383] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:55 ancizan kernel: [ 9643.323382] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:55 ancizan kernel: [ 9643.355382] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:55 ancizan kernel: [ 9643.387388] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:55 ancizan kernel: [ 9643.419382] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:55 ancizan kernel: [ 9643.451381] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:55 ancizan kernel: [ 9643.483393] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:55 ancizan kernel: [ 9643.515392] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:55 ancizan kernel: [ 9643.547385] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:55 ancizan kernel: [ 9643.579389] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:55 ancizan kernel: [ 9643.611386] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:55 ancizan kernel: [ 9643.643381] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:55 ancizan kernel: [ 9643.675437] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:55 ancizan kernel: [ 9643.707382] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:55 ancizan kernel: [ 9643.739392] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:55 ancizan kernel: [ 9643.771379] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:55 ancizan kernel: [ 9643.803390] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:55 ancizan kernel: [ 9643.835380] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:55 ancizan kernel: [ 9643.867376] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:55 ancizan kernel: [ 9643.899386] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:55 ancizan kernel: [ 9643.931385] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:56 ancizan kernel: [ 9643.963391] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:56 ancizan kernel: [ 9643.995379] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:56 ancizan kernel: [ 9644.027381] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:56 ancizan kernel: [ 9644.059387] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:56 ancizan kernel: [ 9644.091383] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:56 ancizan kernel: [ 9644.123390] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:56 ancizan kernel: [ 9644.155382] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:56 ancizan kernel: [ 9644.187390] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:56 ancizan kernel: [ 9644.219390] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:56 ancizan kernel: [ 9644.251479] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:56 ancizan kernel: [ 9644.283374] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:56 ancizan kernel: [ 9644.315389] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:56 ancizan kernel: [ 9644.347384] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:56 ancizan kernel: [ 9644.379379] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:56 ancizan kernel: [ 9644.411379] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:56 ancizan kernel: [ 9644.443376] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:56 ancizan kernel: [ 9644.475384] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:56 ancizan kernel: [ 9644.507387] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:56 ancizan kernel: [ 9644.539383] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:56 ancizan kernel: [ 9644.571392] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:56 ancizan kernel: [ 9644.603378] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:56 ancizan kernel: [ 9644.635383] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:56 ancizan kernel: [ 9644.667392] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:56 ancizan kernel: [ 9644.699395] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:56 ancizan kernel: [ 9644.731401] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:56 ancizan kernel: [ 9644.763393] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:56 ancizan kernel: [ 9644.795386] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:56 ancizan kernel: [ 9644.827377] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:56 ancizan kernel: [ 9644.859382] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:56 ancizan kernel: [ 9644.891375] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:56 ancizan kernel: [ 9644.923376] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:56 ancizan kernel: [ 9644.955382] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:57 ancizan kernel: [ 9644.987392] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:57 ancizan kernel: [ 9645.019388] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:57 ancizan kernel: [ 9645.051384] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:57 ancizan kernel: [ 9645.083390] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:57 ancizan kernel: [ 9645.115390] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:57 ancizan kernel: [ 9645.147384] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:57 ancizan kernel: [ 9645.179387] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:57 ancizan kernel: [ 9645.211389] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:57 ancizan kernel: [ 9645.243390] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:57 ancizan kernel: [ 9645.275382] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:57 ancizan kernel: [ 9645.307402] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:57 ancizan kernel: [ 9645.339385] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:57 ancizan kernel: [ 9645.371385] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:57 ancizan kernel: [ 9645.403378] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:57 ancizan kernel: [ 9645.435386] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:57 ancizan kernel: [ 9645.467391] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:57 ancizan kernel: [ 9645.499381] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:57 ancizan kernel: [ 9645.531399] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:57 ancizan kernel: [ 9645.563383] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:57 ancizan kernel: [ 9645.595394] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:57 ancizan kernel: [ 9645.627388] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:57 ancizan kernel: [ 9645.659379] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:57 ancizan kernel: [ 9645.691426] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:57 ancizan kernel: [ 9645.723440] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:57 ancizan kernel: [ 9645.755384] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:57 ancizan kernel: [ 9645.787393] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:57 ancizan kernel: [ 9645.819383] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:57 ancizan kernel: [ 9645.851383] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:57 ancizan kernel: [ 9645.883391] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:57 ancizan kernel: [ 9645.915392] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:57 ancizan kernel: [ 9645.947389] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:58 ancizan kernel: [ 9645.979385] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:58 ancizan kernel: [ 9646.011381] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:58 ancizan kernel: [ 9646.043376] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:58 ancizan kernel: [ 9646.075374] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:58 ancizan kernel: [ 9646.107376] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:58 ancizan kernel: [ 9646.139374] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:58 ancizan kernel: [ 9646.171375] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:58 ancizan kernel: [ 9646.203379] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:58 ancizan kernel: [ 9646.235387] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:58 ancizan kernel: [ 9646.267376] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:58 ancizan kernel: [ 9646.299380] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:58 ancizan kernel: [ 9646.331378] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:58 ancizan kernel: [ 9646.363387] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:58 ancizan kernel: [ 9646.395377] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:58 ancizan kernel: [ 9646.427391] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:58 ancizan kernel: [ 9646.459374] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:58 ancizan kernel: [ 9646.491377] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:58 ancizan kernel: [ 9646.523377] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:58 ancizan kernel: [ 9646.555388] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:58 ancizan kernel: [ 9646.587375] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:58 ancizan kernel: [ 9646.619388] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:58 ancizan kernel: [ 9646.651376] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:58 ancizan kernel: [ 9646.683388] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:58 ancizan kernel: [ 9646.715380] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:58 ancizan kernel: [ 9646.747376] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:58 ancizan kernel: [ 9646.779376] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:58 ancizan kernel: [ 9646.811383] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:58 ancizan kernel: [ 9646.843392] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:58 ancizan kernel: [ 9646.875400] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:58 ancizan kernel: [ 9646.907380] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:58 ancizan kernel: [ 9646.939427] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:59 ancizan kernel: [ 9646.971392] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:59 ancizan kernel: [ 9647.003377] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:59 ancizan kernel: [ 9647.035411] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:59 ancizan kernel: [ 9647.067396] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:59 ancizan kernel: [ 9647.099382] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:59 ancizan kernel: [ 9647.131390] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:59 ancizan kernel: [ 9647.163380] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:59 ancizan kernel: [ 9647.195384] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:59 ancizan kernel: [ 9647.227423] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:59 ancizan kernel: [ 9647.259428] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:59 ancizan kernel: [ 9647.291392] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:59 ancizan kernel: [ 9647.323382] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:59 ancizan kernel: [ 9647.355414] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:59 ancizan kernel: [ 9647.387386] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:59 ancizan kernel: [ 9647.419378] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:59 ancizan kernel: [ 9647.451391] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:59 ancizan kernel: [ 9647.483380] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:59 ancizan kernel: [ 9647.515384] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:59 ancizan kernel: [ 9647.547395] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:59 ancizan kernel: [ 9647.579381] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:59 ancizan kernel: [ 9647.611381] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:59 ancizan kernel: [ 9647.643435] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:59 ancizan kernel: [ 9647.675400] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:59 ancizan kernel: [ 9647.707394] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:59 ancizan kernel: [ 9647.739393] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:59 ancizan kernel: [ 9647.771403] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:59 ancizan kernel: [ 9647.803393] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:59 ancizan kernel: [ 9647.835384] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:59 ancizan kernel: [ 9647.867385] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:59 ancizan kernel: [ 9647.899397] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:55:59 ancizan kernel: [ 9647.931389] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:00 ancizan kernel: [ 9647.963394] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:00 ancizan kernel: [ 9647.995383] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:00 ancizan kernel: [ 9648.027385] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:00 ancizan kernel: [ 9648.059394] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:00 ancizan kernel: [ 9648.091389] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:00 ancizan kernel: [ 9648.123379] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:00 ancizan kernel: [ 9648.155388] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:00 ancizan kernel: [ 9648.187397] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:00 ancizan kernel: [ 9648.219393] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:00 ancizan kernel: [ 9648.251391] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:00 ancizan kernel: [ 9648.283395] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:00 ancizan kernel: [ 9648.315382] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:00 ancizan kernel: [ 9648.347382] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:00 ancizan kernel: [ 9648.379380] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:00 ancizan kernel: [ 9648.411392] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:00 ancizan kernel: [ 9648.443393] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:00 ancizan kernel: [ 9648.475399] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:00 ancizan kernel: [ 9648.507389] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:00 ancizan kernel: [ 9648.539385] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:00 ancizan kernel: [ 9648.571393] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:00 ancizan kernel: [ 9648.603436] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:00 ancizan kernel: [ 9648.635392] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:00 ancizan kernel: [ 9648.667381] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:00 ancizan kernel: [ 9648.699386] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:00 ancizan kernel: [ 9648.731394] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:00 ancizan kernel: [ 9648.763378] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:00 ancizan kernel: [ 9648.795400] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:00 ancizan kernel: [ 9648.827385] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:00 ancizan kernel: [ 9648.859384] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:00 ancizan kernel: [ 9648.891439] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:00 ancizan kernel: [ 9648.923384] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:00 ancizan kernel: [ 9648.955386] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:01 ancizan kernel: [ 9648.987446] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:01 ancizan kernel: [ 9649.019386] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:01 ancizan kernel: [ 9649.051383] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:01 ancizan kernel: [ 9649.083436] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:01 ancizan kernel: [ 9649.115385] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:01 ancizan kernel: [ 9649.147381] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:01 ancizan kernel: [ 9649.179388] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:01 ancizan kernel: [ 9649.211382] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:01 ancizan kernel: [ 9649.243375] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:01 ancizan kernel: [ 9649.275378] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:01 ancizan kernel: [ 9649.307376] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:01 ancizan kernel: [ 9649.339395] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:01 ancizan kernel: [ 9649.371383] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:01 ancizan kernel: [ 9649.403378] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:01 ancizan kernel: [ 9649.435379] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:01 ancizan kernel: [ 9649.467375] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:01 ancizan kernel: [ 9649.499377] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:01 ancizan kernel: [ 9649.531392] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:01 ancizan kernel: [ 9649.563379] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:01 ancizan kernel: [ 9649.595379] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:01 ancizan kernel: [ 9649.627389] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:01 ancizan kernel: [ 9649.659387] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:01 ancizan kernel: [ 9649.691404] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:01 ancizan kernel: [ 9649.723385] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:01 ancizan kernel: [ 9649.755393] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:01 ancizan kernel: [ 9649.787381] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:01 ancizan kernel: [ 9649.819395] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:01 ancizan kernel: [ 9649.851393] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:01 ancizan kernel: [ 9649.883382] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:01 ancizan kernel: [ 9649.915387] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:01 ancizan kernel: [ 9649.947382] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:02 ancizan kernel: [ 9649.979384] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:02 ancizan kernel: [ 9650.011385] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:02 ancizan kernel: [ 9650.043378] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:02 ancizan kernel: [ 9650.075386] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:02 ancizan kernel: [ 9650.107395] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:02 ancizan kernel: [ 9650.139396] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:02 ancizan kernel: [ 9650.171384] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:02 ancizan kernel: [ 9650.203389] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:02 ancizan kernel: [ 9650.235385] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:02 ancizan kernel: [ 9650.267388] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:02 ancizan kernel: [ 9650.299379] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:02 ancizan kernel: [ 9650.331375] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:02 ancizan kernel: [ 9650.363374] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:02 ancizan kernel: [ 9650.395376] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:02 ancizan kernel: [ 9650.427382] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:02 ancizan kernel: [ 9650.459393] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:02 ancizan kernel: [ 9650.491385] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:02 ancizan kernel: [ 9650.523381] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:02 ancizan kernel: [ 9650.555410] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:02 ancizan kernel: [ 9650.587418] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:02 ancizan kernel: [ 9650.619380] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:02 ancizan kernel: [ 9650.651383] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:02 ancizan kernel: [ 9650.683381] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:02 ancizan kernel: [ 9650.715392] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:02 ancizan kernel: [ 9650.747390] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:02 ancizan kernel: [ 9650.779385] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:02 ancizan kernel: [ 9650.811383] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:02 ancizan kernel: [ 9650.843381] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:02 ancizan kernel: [ 9650.875383] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:02 ancizan kernel: [ 9650.907409] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:02 ancizan kernel: [ 9650.939378] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:03 ancizan kernel: [ 9650.971385] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:03 ancizan kernel: [ 9651.003380] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:03 ancizan kernel: [ 9651.035379] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:03 ancizan kernel: [ 9651.067395] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:03 ancizan kernel: [ 9651.099396] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:03 ancizan kernel: [ 9651.131394] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:03 ancizan kernel: [ 9651.163412] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:03 ancizan kernel: [ 9651.195393] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:03 ancizan kernel: [ 9651.227396] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:03 ancizan kernel: [ 9651.259388] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:03 ancizan kernel: [ 9651.291396] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:03 ancizan kernel: [ 9651.323383] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:03 ancizan kernel: [ 9651.355382] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:03 ancizan kernel: [ 9651.387396] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:03 ancizan kernel: [ 9651.419385] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:03 ancizan kernel: [ 9651.451398] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:03 ancizan kernel: [ 9651.483387] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:03 ancizan kernel: [ 9651.515390] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:03 ancizan kernel: [ 9651.547385] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:03 ancizan kernel: [ 9651.579383] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:03 ancizan kernel: [ 9651.611383] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:03 ancizan kernel: [ 9651.643386] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:03 ancizan kernel: [ 9651.675387] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:03 ancizan kernel: [ 9651.707385] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:03 ancizan kernel: [ 9651.739383] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:03 ancizan kernel: [ 9651.771396] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:03 ancizan kernel: [ 9651.803394] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:03 ancizan kernel: [ 9651.835380] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:03 ancizan kernel: [ 9651.867396] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:03 ancizan kernel: [ 9651.899379] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:03 ancizan kernel: [ 9651.931381] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:04 ancizan kernel: [ 9651.963387] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:04 ancizan kernel: [ 9651.995397] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:04 ancizan kernel: [ 9652.027387] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:04 ancizan kernel: [ 9652.059394] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:04 ancizan kernel: [ 9652.091389] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:04 ancizan kernel: [ 9652.123381] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:04 ancizan kernel: [ 9652.155384] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:04 ancizan kernel: [ 9652.187416] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:04 ancizan kernel: [ 9652.219405] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:04 ancizan kernel: [ 9652.251387] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:04 ancizan kernel: [ 9652.283388] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:04 ancizan kernel: [ 9652.315381] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:04 ancizan kernel: [ 9652.347395] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:04 ancizan kernel: [ 9652.379383] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:04 ancizan kernel: [ 9652.411381] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:04 ancizan kernel: [ 9652.443384] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:04 ancizan kernel: [ 9652.475387] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:04 ancizan kernel: [ 9652.507388] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:04 ancizan kernel: [ 9652.539391] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:04 ancizan kernel: [ 9652.571379] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:04 ancizan kernel: [ 9652.603395] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:04 ancizan kernel: [ 9652.635393] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:04 ancizan kernel: [ 9652.667396] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:04 ancizan kernel: [ 9652.699385] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:04 ancizan kernel: [ 9652.731385] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:04 ancizan kernel: [ 9652.763404] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:04 ancizan kernel: [ 9652.795395] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:04 ancizan kernel: [ 9652.827385] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:04 ancizan kernel: [ 9652.859394] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:04 ancizan kernel: [ 9652.891387] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:04 ancizan kernel: [ 9652.923403] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:04 ancizan kernel: [ 9652.955412] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:05 ancizan kernel: [ 9652.987381] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:05 ancizan kernel: [ 9653.019382] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:05 ancizan kernel: [ 9653.051388] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:05 ancizan kernel: [ 9653.083381] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:05 ancizan kernel: [ 9653.115388] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:05 ancizan kernel: [ 9653.147394] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:05 ancizan kernel: [ 9653.179391] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:05 ancizan kernel: [ 9653.211386] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:05 ancizan kernel: [ 9653.243396] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:05 ancizan kernel: [ 9653.275405] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:05 ancizan kernel: [ 9653.307423] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:05 ancizan kernel: [ 9653.339405] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:05 ancizan kernel: [ 9653.371407] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:05 ancizan kernel: [ 9653.403388] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:05 ancizan kernel: [ 9653.435403] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:05 ancizan kernel: [ 9653.467391] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:05 ancizan kernel: [ 9653.499402] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:05 ancizan kernel: [ 9653.531380] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:05 ancizan kernel: [ 9653.563396] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:05 ancizan kernel: [ 9653.595389] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:05 ancizan kernel: [ 9653.627402] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:05 ancizan kernel: [ 9653.659396] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:05 ancizan kernel: [ 9653.691400] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:05 ancizan kernel: [ 9653.723380] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:05 ancizan kernel: [ 9653.755403] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:05 ancizan kernel: [ 9653.787404] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:05 ancizan kernel: [ 9653.819407] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:05 ancizan kernel: [ 9653.851415] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:05 ancizan kernel: [ 9653.883380] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:05 ancizan kernel: [ 9653.915393] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:05 ancizan kernel: [ 9653.947396] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:06 ancizan kernel: [ 9653.979387] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:06 ancizan kernel: [ 9654.011393] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:06 ancizan kernel: [ 9654.043384] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:06 ancizan kernel: [ 9654.075382] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:06 ancizan kernel: [ 9654.107396] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:06 ancizan kernel: [ 9654.139387] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:06 ancizan kernel: [ 9654.171383] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:06 ancizan kernel: [ 9654.203381] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:06 ancizan kernel: [ 9654.235388] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:06 ancizan kernel: [ 9654.267384] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:06 ancizan kernel: [ 9654.299396] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:06 ancizan kernel: [ 9654.331386] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:06 ancizan kernel: [ 9654.363394] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:06 ancizan kernel: [ 9654.395382] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:06 ancizan kernel: [ 9654.427381] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:06 ancizan kernel: [ 9654.459378] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:06 ancizan kernel: [ 9654.491381] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:06 ancizan kernel: [ 9654.523377] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:06 ancizan kernel: [ 9654.555395] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:06 ancizan kernel: [ 9654.587381] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:06 ancizan kernel: [ 9654.619379] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:06 ancizan kernel: [ 9654.651378] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:06 ancizan kernel: [ 9654.683383] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:06 ancizan kernel: [ 9654.715392] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:06 ancizan kernel: [ 9654.747382] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:06 ancizan kernel: [ 9654.779380] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:06 ancizan kernel: [ 9654.811392] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:06 ancizan kernel: [ 9654.843378] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:06 ancizan kernel: [ 9654.875387] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:06 ancizan kernel: [ 9654.907384] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:06 ancizan kernel: [ 9654.939383] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:07 ancizan kernel: [ 9654.971388] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:07 ancizan kernel: [ 9655.003394] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:07 ancizan kernel: [ 9655.035393] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:07 ancizan kernel: [ 9655.067386] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:07 ancizan kernel: [ 9655.099388] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:07 ancizan kernel: [ 9655.131387] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:07 ancizan kernel: [ 9655.163384] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:07 ancizan kernel: [ 9655.195385] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:07 ancizan kernel: [ 9655.227388] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:07 ancizan kernel: [ 9655.259397] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:07 ancizan kernel: [ 9655.291390] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:07 ancizan kernel: [ 9655.323386] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:07 ancizan kernel: [ 9655.355384] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:07 ancizan kernel: [ 9655.387397] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:07 ancizan kernel: [ 9655.419384] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:07 ancizan kernel: [ 9655.451384] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:07 ancizan kernel: [ 9655.483398] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:07 ancizan kernel: [ 9655.515397] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:07 ancizan kernel: [ 9655.547385] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:07 ancizan kernel: [ 9655.579393] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:07 ancizan kernel: [ 9655.611380] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:07 ancizan kernel: [ 9655.643381] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:07 ancizan kernel: [ 9655.675398] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:07 ancizan kernel: [ 9655.707392] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:07 ancizan kernel: [ 9655.739385] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:07 ancizan kernel: [ 9655.771397] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:07 ancizan kernel: [ 9655.803388] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:07 ancizan kernel: [ 9655.835386] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:07 ancizan kernel: [ 9655.867388] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:07 ancizan kernel: [ 9655.899446] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:07 ancizan kernel: [ 9655.931382] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:08 ancizan kernel: [ 9655.963396] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:08 ancizan kernel: [ 9655.995387] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:08 ancizan kernel: [ 9656.027386] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:08 ancizan kernel: [ 9656.059399] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:08 ancizan kernel: [ 9656.091387] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:08 ancizan kernel: [ 9656.123382] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:08 ancizan kernel: [ 9656.155384] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:08 ancizan kernel: [ 9656.187377] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:08 ancizan kernel: [ 9656.219386] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:08 ancizan kernel: [ 9656.251404] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:08 ancizan kernel: [ 9656.283383] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:08 ancizan kernel: [ 9656.315378] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:08 ancizan kernel: [ 9656.347378] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:08 ancizan kernel: [ 9656.379382] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:08 ancizan kernel: [ 9656.411382] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:08 ancizan kernel: [ 9656.443380] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:08 ancizan kernel: [ 9656.475382] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:08 ancizan kernel: [ 9656.507394] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:08 ancizan kernel: [ 9656.539387] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:08 ancizan kernel: [ 9656.571380] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:08 ancizan kernel: [ 9656.603393] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:08 ancizan kernel: [ 9656.635393] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:08 ancizan kernel: [ 9656.667393] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:08 ancizan kernel: [ 9656.699382] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:08 ancizan kernel: [ 9656.731384] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:08 ancizan kernel: [ 9656.763397] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:08 ancizan kernel: [ 9656.795389] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:08 ancizan kernel: [ 9656.827395] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:08 ancizan kernel: [ 9656.859396] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:08 ancizan kernel: [ 9656.891398] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:08 ancizan kernel: [ 9656.923394] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:08 ancizan kernel: [ 9656.955390] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:09 ancizan kernel: [ 9656.987393] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:09 ancizan kernel: [ 9657.019396] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:09 ancizan kernel: [ 9657.051392] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:09 ancizan kernel: [ 9657.083382] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:09 ancizan kernel: [ 9657.115418] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:09 ancizan kernel: [ 9657.147411] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:09 ancizan kernel: [ 9657.179388] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:09 ancizan kernel: [ 9657.211384] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:09 ancizan kernel: [ 9657.243382] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:09 ancizan kernel: [ 9657.275385] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:09 ancizan kernel: [ 9657.307405] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:09 ancizan kernel: [ 9657.339397] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:09 ancizan kernel: [ 9657.371386] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:09 ancizan kernel: [ 9657.403392] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:09 ancizan kernel: [ 9657.435381] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:09 ancizan kernel: [ 9657.467395] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:09 ancizan kernel: [ 9657.499389] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:09 ancizan kernel: [ 9657.531394] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:09 ancizan kernel: [ 9657.563391] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:09 ancizan kernel: [ 9657.595383] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:09 ancizan kernel: [ 9657.627397] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:09 ancizan kernel: [ 9657.659391] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:09 ancizan kernel: [ 9657.691395] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:09 ancizan kernel: [ 9657.723385] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:09 ancizan kernel: [ 9657.755388] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:09 ancizan kernel: [ 9657.787382] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:09 ancizan kernel: [ 9657.819412] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:09 ancizan kernel: [ 9657.851387] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:09 ancizan kernel: [ 9657.883382] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:09 ancizan kernel: [ 9657.915383] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:09 ancizan kernel: [ 9657.947384] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:10 ancizan kernel: [ 9657.979413] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:10 ancizan kernel: [ 9658.011396] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:10 ancizan kernel: [ 9658.043391] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:10 ancizan kernel: [ 9658.075384] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:10 ancizan kernel: [ 9658.107468] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:10 ancizan kernel: [ 9658.139382] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:10 ancizan kernel: [ 9658.171382] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:10 ancizan kernel: [ 9658.203382] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:10 ancizan kernel: [ 9658.235438] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:10 ancizan kernel: [ 9658.267396] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:10 ancizan kernel: [ 9658.299380] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:10 ancizan kernel: [ 9658.331396] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:10 ancizan kernel: [ 9658.363382] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:10 ancizan kernel: [ 9658.395442] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:10 ancizan kernel: [ 9658.427397] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:10 ancizan kernel: [ 9658.459391] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:10 ancizan kernel: [ 9658.491387] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:10 ancizan kernel: [ 9658.523401] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:10 ancizan kernel: [ 9658.555397] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:10 ancizan kernel: [ 9658.587396] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:10 ancizan kernel: [ 9658.619394] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:10 ancizan kernel: [ 9658.651383] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:10 ancizan kernel: [ 9658.683384] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:10 ancizan kernel: [ 9658.715390] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:10 ancizan kernel: [ 9658.747403] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:10 ancizan kernel: [ 9658.779385] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:10 ancizan kernel: [ 9658.811391] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:10 ancizan kernel: [ 9658.843434] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:10 ancizan kernel: [ 9658.875402] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:10 ancizan kernel: [ 9658.907403] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:10 ancizan kernel: [ 9658.939391] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:11 ancizan kernel: [ 9658.971389] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:11 ancizan kernel: [ 9659.003397] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:11 ancizan kernel: [ 9659.035396] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:11 ancizan kernel: [ 9659.067393] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:11 ancizan kernel: [ 9659.099385] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:11 ancizan kernel: [ 9659.131387] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:11 ancizan kernel: [ 9659.163383] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:11 ancizan kernel: [ 9659.195386] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:11 ancizan kernel: [ 9659.227391] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:11 ancizan kernel: [ 9659.259389] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:11 ancizan kernel: [ 9659.291388] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:11 ancizan kernel: [ 9659.323387] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:11 ancizan kernel: [ 9659.355387] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:11 ancizan kernel: [ 9659.387397] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:11 ancizan kernel: [ 9659.419384] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:11 ancizan kernel: [ 9659.451476] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:11 ancizan kernel: [ 9659.483398] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:11 ancizan kernel: [ 9659.515396] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:11 ancizan kernel: [ 9659.547401] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:11 ancizan kernel: [ 9659.579391] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:11 ancizan kernel: [ 9659.611382] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:11 ancizan kernel: [ 9659.643433] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:11 ancizan kernel: [ 9659.675392] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:11 ancizan kernel: [ 9659.707387] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:11 ancizan kernel: [ 9659.739443] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:11 ancizan kernel: [ 9659.771394] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:11 ancizan kernel: [ 9659.803387] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:11 ancizan kernel: [ 9659.835383] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:11 ancizan kernel: [ 9659.867389] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:11 ancizan kernel: [ 9659.899385] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:11 ancizan kernel: [ 9659.931393] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:12 ancizan kernel: [ 9659.963419] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:12 ancizan kernel: [ 9659.995411] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:12 ancizan kernel: [ 9660.027390] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:12 ancizan kernel: [ 9660.059389] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:12 ancizan kernel: [ 9660.091389] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:12 ancizan kernel: [ 9660.123388] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:12 ancizan kernel: [ 9660.155398] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:12 ancizan kernel: [ 9660.187384] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:12 ancizan kernel: [ 9660.219396] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:12 ancizan kernel: [ 9660.251387] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:12 ancizan kernel: [ 9660.283394] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:12 ancizan kernel: [ 9660.315399] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:12 ancizan kernel: [ 9660.347481] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:12 ancizan kernel: [ 9660.379399] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:12 ancizan kernel: [ 9660.411408] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:12 ancizan kernel: [ 9660.443450] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:12 ancizan kernel: [ 9660.475383] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:12 ancizan kernel: [ 9660.507400] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:12 ancizan kernel: [ 9660.539398] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:12 ancizan kernel: [ 9660.571396] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:12 ancizan kernel: [ 9660.603391] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:12 ancizan kernel: [ 9660.635391] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:12 ancizan kernel: [ 9660.667411] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:12 ancizan kernel: [ 9660.699390] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:12 ancizan kernel: [ 9660.731396] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:12 ancizan kernel: [ 9660.763408] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:12 ancizan kernel: [ 9660.795389] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:12 ancizan kernel: [ 9660.827387] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:12 ancizan kernel: [ 9660.859388] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:12 ancizan kernel: [ 9660.891399] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:12 ancizan kernel: [ 9660.923398] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:12 ancizan kernel: [ 9660.955390] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:13 ancizan kernel: [ 9660.987408] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:13 ancizan kernel: [ 9661.019389] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:13 ancizan kernel: [ 9661.051409] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:13 ancizan kernel: [ 9661.083383] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:13 ancizan kernel: [ 9661.115389] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:13 ancizan kernel: [ 9661.147397] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:13 ancizan kernel: [ 9661.179398] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:13 ancizan kernel: [ 9661.211397] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:13 ancizan kernel: [ 9661.243437] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:13 ancizan kernel: [ 9661.275390] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:13 ancizan kernel: [ 9661.307384] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:13 ancizan kernel: [ 9661.339393] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:13 ancizan kernel: [ 9661.371390] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:13 ancizan kernel: [ 9661.403391] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:13 ancizan kernel: [ 9661.435433] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:13 ancizan kernel: [ 9661.467415] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:13 ancizan kernel: [ 9661.499389] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:13 ancizan kernel: [ 9661.531398] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:13 ancizan kernel: [ 9661.563388] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:13 ancizan kernel: [ 9661.595384] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:13 ancizan kernel: [ 9661.627386] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:13 ancizan kernel: [ 9661.659400] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:13 ancizan kernel: [ 9661.691391] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:13 ancizan kernel: [ 9661.723387] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:13 ancizan kernel: [ 9661.755397] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:13 ancizan kernel: [ 9661.787397] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:13 ancizan kernel: [ 9661.819396] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:13 ancizan kernel: [ 9661.851390] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:13 ancizan kernel: [ 9661.883384] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:13 ancizan kernel: [ 9661.915384] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:13 ancizan kernel: [ 9661.947389] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:14 ancizan kernel: [ 9661.979388] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:14 ancizan kernel: [ 9662.011386] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:14 ancizan kernel: [ 9662.043394] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:14 ancizan kernel: [ 9662.075390] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:14 ancizan kernel: [ 9662.107390] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:14 ancizan kernel: [ 9662.139407] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:14 ancizan kernel: [ 9662.171390] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:14 ancizan kernel: [ 9662.203382] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:14 ancizan kernel: [ 9662.235400] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:14 ancizan kernel: [ 9662.267400] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:14 ancizan kernel: [ 9662.299383] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:14 ancizan kernel: [ 9662.331392] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:14 ancizan kernel: [ 9662.363397] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:14 ancizan kernel: [ 9662.395388] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:14 ancizan kernel: [ 9662.427396] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:14 ancizan kernel: [ 9662.459398] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:14 ancizan kernel: [ 9662.491389] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:14 ancizan kernel: [ 9662.523398] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:14 ancizan kernel: [ 9662.555388] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:14 ancizan kernel: [ 9662.587408] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:14 ancizan kernel: [ 9662.619393] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:14 ancizan kernel: [ 9662.651383] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:14 ancizan kernel: [ 9662.683388] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:14 ancizan kernel: [ 9662.715398] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:14 ancizan kernel: [ 9662.747385] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:14 ancizan kernel: [ 9662.779391] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:14 ancizan kernel: [ 9662.811386] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:14 ancizan kernel: [ 9662.843385] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:14 ancizan kernel: [ 9662.875400] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:14 ancizan kernel: [ 9662.907386] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:14 ancizan kernel: [ 9662.939384] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:15 ancizan kernel: [ 9662.971399] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:15 ancizan kernel: [ 9663.003397] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:15 ancizan kernel: [ 9663.035390] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:15 ancizan kernel: [ 9663.067382] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:15 ancizan kernel: [ 9663.099420] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:15 ancizan kernel: [ 9663.131386] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:15 ancizan kernel: [ 9663.163385] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:15 ancizan kernel: [ 9663.195402] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:15 ancizan kernel: [ 9663.227387] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:15 ancizan kernel: [ 9663.259397] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:15 ancizan kernel: [ 9663.291398] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:15 ancizan kernel: [ 9663.323397] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:15 ancizan kernel: [ 9663.355391] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:15 ancizan kernel: [ 9663.387398] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:15 ancizan kernel: [ 9663.419389] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:15 ancizan kernel: [ 9663.451390] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:15 ancizan kernel: [ 9663.483411] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:15 ancizan kernel: [ 9663.515385] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:15 ancizan kernel: [ 9663.547402] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:15 ancizan kernel: [ 9663.579381] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:15 ancizan kernel: [ 9663.611384] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:15 ancizan kernel: [ 9663.643382] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:15 ancizan kernel: [ 9663.675398] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:15 ancizan kernel: [ 9663.707392] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:15 ancizan kernel: [ 9663.739390] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:15 ancizan kernel: [ 9663.771391] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:15 ancizan kernel: [ 9663.803383] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:15 ancizan kernel: [ 9663.835412] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:15 ancizan kernel: [ 9663.867390] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:15 ancizan kernel: [ 9663.899390] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:15 ancizan kernel: [ 9663.931391] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:16 ancizan kernel: [ 9663.963391] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:16 ancizan kernel: [ 9663.995387] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:16 ancizan kernel: [ 9664.027387] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:16 ancizan kernel: [ 9664.059392] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:16 ancizan kernel: [ 9664.091392] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:16 ancizan kernel: [ 9664.123386] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:16 ancizan kernel: [ 9664.155389] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:16 ancizan kernel: [ 9664.187388] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:16 ancizan kernel: [ 9664.219386] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:16 ancizan kernel: [ 9664.251381] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:16 ancizan kernel: [ 9664.283387] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:16 ancizan kernel: [ 9664.315395] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:16 ancizan kernel: [ 9664.347391] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:16 ancizan kernel: [ 9664.379383] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:16 ancizan kernel: [ 9664.411396] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:16 ancizan kernel: [ 9664.443394] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:16 ancizan kernel: [ 9664.475385] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:16 ancizan kernel: [ 9664.507386] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:16 ancizan kernel: [ 9664.539396] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:16 ancizan kernel: [ 9664.571384] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:16 ancizan kernel: [ 9664.603396] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:16 ancizan kernel: [ 9664.635389] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:16 ancizan kernel: [ 9664.667400] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:16 ancizan kernel: [ 9664.699390] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:16 ancizan kernel: [ 9664.731398] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:16 ancizan kernel: [ 9664.763390] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:16 ancizan kernel: [ 9664.795400] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:16 ancizan kernel: [ 9664.827389] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:16 ancizan kernel: [ 9664.859394] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:16 ancizan kernel: [ 9664.891399] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:16 ancizan kernel: [ 9664.923392] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:16 ancizan kernel: [ 9664.955392] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:17 ancizan kernel: [ 9664.987384] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:17 ancizan kernel: [ 9665.019391] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:17 ancizan kernel: [ 9665.051450] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:17 ancizan kernel: [ 9665.083383] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:17 ancizan kernel: [ 9665.115387] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:17 ancizan kernel: [ 9665.147384] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:17 ancizan kernel: [ 9665.179435] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:17 ancizan kernel: [ 9665.211393] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:17 ancizan kernel: [ 9665.243392] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:17 ancizan kernel: [ 9665.275436] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:17 ancizan kernel: [ 9665.307390] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:17 ancizan kernel: [ 9665.339384] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:17 ancizan kernel: [ 9665.371440] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:17 ancizan kernel: [ 9665.403385] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:17 ancizan kernel: [ 9665.435394] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:17 ancizan kernel: [ 9665.467405] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:17 ancizan kernel: [ 9665.499455] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:17 ancizan kernel: [ 9665.531390] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:17 ancizan kernel: [ 9665.563389] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:17 ancizan kernel: [ 9665.595386] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:17 ancizan kernel: [ 9665.627396] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:17 ancizan kernel: [ 9665.659387] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:17 ancizan kernel: [ 9665.691388] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:17 ancizan kernel: [ 9665.723416] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:17 ancizan kernel: [ 9665.755384] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:17 ancizan kernel: [ 9665.787390] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:17 ancizan kernel: [ 9665.819407] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:17 ancizan kernel: [ 9665.851398] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:17 ancizan kernel: [ 9665.883404] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:17 ancizan kernel: [ 9665.915386] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:17 ancizan kernel: [ 9665.947387] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:18 ancizan kernel: [ 9665.979399] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:18 ancizan kernel: [ 9666.011398] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:18 ancizan kernel: [ 9666.043386] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:18 ancizan kernel: [ 9666.075427] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:18 ancizan kernel: [ 9666.107401] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:18 ancizan kernel: [ 9666.139398] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:18 ancizan kernel: [ 9666.171393] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:18 ancizan kernel: [ 9666.203388] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:18 ancizan kernel: [ 9666.235390] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:18 ancizan kernel: [ 9666.267393] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:18 ancizan kernel: [ 9666.299412] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:18 ancizan kernel: [ 9666.331391] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:18 ancizan kernel: [ 9666.363388] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:18 ancizan kernel: [ 9666.395389] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:18 ancizan kernel: [ 9666.427387] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:18 ancizan kernel: [ 9666.459393] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:18 ancizan kernel: [ 9666.491392] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:18 ancizan kernel: [ 9666.523393] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:18 ancizan kernel: [ 9666.555406] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:18 ancizan kernel: [ 9666.587396] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:18 ancizan kernel: [ 9666.619400] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:18 ancizan kernel: [ 9666.651386] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:18 ancizan kernel: [ 9666.683388] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:18 ancizan kernel: [ 9666.715402] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:18 ancizan kernel: [ 9666.747400] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:18 ancizan kernel: [ 9666.779403] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:18 ancizan kernel: [ 9666.811391] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:18 ancizan kernel: [ 9666.843393] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:18 ancizan kernel: [ 9666.875404] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:18 ancizan kernel: [ 9666.907382] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:18 ancizan kernel: [ 9666.939386] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:19 ancizan kernel: [ 9666.971401] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:19 ancizan kernel: [ 9667.003390] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:19 ancizan kernel: [ 9667.035386] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:19 ancizan kernel: [ 9667.067382] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:19 ancizan kernel: [ 9667.099385] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:19 ancizan kernel: [ 9667.131399] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:19 ancizan kernel: [ 9667.163424] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:19 ancizan kernel: [ 9667.195396] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:19 ancizan kernel: [ 9667.227389] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:19 ancizan kernel: [ 9667.259428] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:19 ancizan kernel: [ 9667.291388] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:19 ancizan kernel: [ 9667.323405] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:19 ancizan kernel: [ 9667.355393] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:19 ancizan kernel: [ 9667.387389] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:19 ancizan kernel: [ 9667.419449] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:19 ancizan kernel: [ 9667.451390] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:19 ancizan kernel: [ 9667.483393] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:19 ancizan kernel: [ 9667.515449] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:19 ancizan kernel: [ 9667.547391] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:19 ancizan kernel: [ 9667.579389] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:19 ancizan kernel: [ 9667.611390] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:19 ancizan kernel: [ 9667.643400] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:19 ancizan kernel: [ 9667.675406] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:19 ancizan kernel: [ 9667.707394] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:19 ancizan kernel: [ 9667.739387] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:19 ancizan kernel: [ 9667.771391] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:19 ancizan kernel: [ 9667.803391] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:19 ancizan kernel: [ 9667.835393] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:19 ancizan kernel: [ 9667.867400] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:19 ancizan kernel: [ 9667.899445] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:19 ancizan kernel: [ 9667.931399] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:20 ancizan kernel: [ 9667.963385] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:20 ancizan kernel: [ 9667.995382] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:20 ancizan kernel: [ 9668.027390] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:20 ancizan kernel: [ 9668.059393] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:20 ancizan kernel: [ 9668.091397] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:20 ancizan kernel: [ 9668.123389] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:20 ancizan kernel: [ 9668.155409] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:20 ancizan kernel: [ 9668.187398] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:20 ancizan kernel: [ 9668.219422] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:20 ancizan kernel: [ 9668.251393] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:20 ancizan kernel: [ 9668.283410] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:20 ancizan kernel: [ 9668.315409] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:20 ancizan kernel: [ 9668.347399] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:20 ancizan kernel: [ 9668.379399] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:20 ancizan kernel: [ 9668.411395] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:20 ancizan kernel: [ 9668.443392] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:20 ancizan kernel: [ 9668.475403] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:20 ancizan kernel: [ 9668.507412] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:20 ancizan kernel: [ 9668.539398] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:20 ancizan kernel: [ 9668.571391] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:20 ancizan kernel: [ 9668.603382] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:20 ancizan kernel: [ 9668.635383] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:20 ancizan kernel: [ 9668.667383] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:20 ancizan kernel: [ 9668.699387] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:20 ancizan kernel: [ 9668.731395] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:20 ancizan kernel: [ 9668.763402] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:20 ancizan kernel: [ 9668.795407] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:20 ancizan kernel: [ 9668.827401] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:20 ancizan kernel: [ 9668.859396] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:20 ancizan kernel: [ 9668.891389] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:20 ancizan kernel: [ 9668.923399] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:20 ancizan kernel: [ 9668.955395] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:21 ancizan kernel: [ 9668.987413] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:21 ancizan kernel: [ 9669.019412] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:21 ancizan kernel: [ 9669.051420] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:21 ancizan kernel: [ 9669.083403] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:21 ancizan kernel: [ 9669.115412] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:21 ancizan kernel: [ 9669.147408] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:21 ancizan kernel: [ 9669.179409] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:21 ancizan kernel: [ 9669.211411] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:21 ancizan kernel: [ 9669.243412] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:21 ancizan kernel: [ 9669.275409] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:21 ancizan kernel: [ 9669.307380] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:21 ancizan kernel: [ 9669.339398] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:21 ancizan kernel: [ 9669.371419] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:21 ancizan kernel: [ 9669.403385] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:21 ancizan kernel: [ 9669.435411] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:21 ancizan kernel: [ 9669.467411] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:21 ancizan kernel: [ 9669.499408] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:21 ancizan kernel: [ 9669.531409] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:21 ancizan kernel: [ 9669.563410] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:21 ancizan kernel: [ 9669.595408] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:21 ancizan kernel: [ 9669.627409] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:21 ancizan kernel: [ 9669.659410] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:21 ancizan kernel: [ 9669.691414] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:21 ancizan kernel: [ 9669.723391] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:21 ancizan kernel: [ 9669.755390] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:21 ancizan kernel: [ 9669.787391] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:21 ancizan kernel: [ 9669.819410] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:21 ancizan kernel: [ 9669.851397] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:21 ancizan kernel: [ 9669.883410] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:21 ancizan kernel: [ 9669.915409] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:21 ancizan kernel: [ 9669.947409] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:22 ancizan kernel: [ 9669.979408] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:22 ancizan kernel: [ 9670.011408] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:22 ancizan kernel: [ 9670.043396] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:22 ancizan kernel: [ 9670.075409] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:22 ancizan kernel: [ 9670.107409] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:22 ancizan kernel: [ 9670.139409] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:22 ancizan kernel: [ 9670.171408] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:22 ancizan kernel: [ 9670.203409] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:22 ancizan kernel: [ 9670.235410] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:22 ancizan kernel: [ 9670.267393] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:22 ancizan kernel: [ 9670.299410] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:22 ancizan kernel: [ 9670.331403] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:22 ancizan kernel: [ 9670.363396] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:22 ancizan kernel: [ 9670.395412] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:22 ancizan kernel: [ 9670.427402] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:22 ancizan kernel: [ 9670.459400] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:22 ancizan kernel: [ 9670.491401] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:22 ancizan kernel: [ 9670.523418] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:22 ancizan kernel: [ 9670.555409] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:22 ancizan kernel: [ 9670.587419] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:22 ancizan kernel: [ 9670.619393] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:22 ancizan kernel: [ 9670.651408] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:22 ancizan kernel: [ 9670.683410] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:22 ancizan kernel: [ 9670.715398] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:22 ancizan kernel: [ 9670.747410] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:22 ancizan kernel: [ 9670.779409] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:22 ancizan kernel: [ 9670.811391] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:22 ancizan kernel: [ 9670.843411] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:22 ancizan kernel: [ 9670.875390] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:22 ancizan kernel: [ 9670.907410] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:22 ancizan kernel: [ 9670.939396] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:23 ancizan kernel: [ 9670.971404] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:23 ancizan kernel: [ 9671.003396] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:23 ancizan kernel: [ 9671.035410] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:23 ancizan kernel: [ 9671.067410] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:56:23 ancizan kernel: [ 9671.099392] gspca: ISOC data error:
[0] len=0, status=-18
Aug 18 10:59:12 ancizan kernel: [ 9840.252203] INFO: task
GoogleTalkPlugi:4221 blocked for more than 120 seconds.
Aug 18 10:59:12 ancizan kernel: [ 9840.252212] "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Aug 18 10:59:12 ancizan kernel: [ 9840.252219] GoogleTalkPlugi D
ee1a7d28     0  4221      1 0x00000004
Aug 18 10:59:12 ancizan kernel: [ 9840.252231]  ee1a7d68 00000086
c1dfa80c ee1a7d28 ee1a7d58 c14accd0 c1c00f2c c183a8c0
Aug 18 10:59:12 ancizan kernel: [ 9840.252246]  bc268cc9 000008cb
c1c00f28 c183a8c0 c183a8c0 f54068c0 c1c00ca0 c1731f60
Aug 18 10:59:12 ancizan kernel: [ 9840.252260]  ee1a7d38 eeb49c00
00000000 ee1a7d44 c1272fad c1557a80 eeb49c00 ee1a7d3c
Aug 18 10:59:12 ancizan kernel: [ 9840.252274] Call Trace:
Aug 18 10:59:12 ancizan kernel: [ 9840.252291]  [<c14accd0>] ?
unix_dgram_sendmsg+0x4f0/0x560
Aug 18 10:59:12 ancizan kernel: [ 9840.252303]  [<c1272fad>] ?
kobject_put+0x1d/0x50
Aug 18 10:59:12 ancizan kernel: [ 9840.252313]  [<c102d978>] ?
default_spin_lock_flags+0x8/0x10
Aug 18 10:59:12 ancizan kernel: [ 9840.252324]  [<c1509f0f>] ?
_raw_spin_lock_irqsave+0x2f/0x50
Aug 18 10:59:12 ancizan kernel: [ 9840.252334]  [<c106d738>] ?
prepare_to_wait+0x48/0x70
Aug 18 10:59:12 ancizan kernel: [ 9840.252342]  [<c13a657d>]
usb_kill_urb+0x6d/0xa0
Aug 18 10:59:12 ancizan kernel: [ 9840.252351]  [<c106d4d0>] ?
autoremove_wake_function+0x0/0x50
Aug 18 10:59:12 ancizan kernel: [ 9840.252369]  [<f813d30c>]
destroy_urbs+0x3c/0x80 [gspca_main]
Aug 18 10:59:12 ancizan kernel: [ 9840.252381]  [<f813ec96>]
gspca_stream_off+0x36/0xa0 [gspca_main]
Aug 18 10:59:12 ancizan kernel: [ 9840.252391]  [<c1508c80>] ?
mutex_lock_interruptible+0x10/0x40
Aug 18 10:59:12 ancizan kernel: [ 9840.252403]  [<f813f0e5>]
vidioc_streamoff+0x95/0xe0 [gspca_main]
Aug 18 10:59:12 ancizan kernel: [ 9840.252415]  [<f813f050>] ?
vidioc_streamoff+0x0/0xe0 [gspca_main]
Aug 18 10:59:12 ancizan kernel: [ 9840.252433]  [<f815cc32>]
__video_do_ioctl+0x17f2/0x4400 [videodev]
Aug 18 10:59:12 ancizan kernel: [ 9840.252446]  [<c1022346>] ?
native_smp_send_reschedule+0x36/0x50
Aug 18 10:59:12 ancizan kernel: [ 9840.252454]  [<c127bba4>] ?
_copy_from_user+0x44/0x70
Aug 18 10:59:12 ancizan kernel: [ 9840.252470]  [<f815f95f>]
video_ioctl2+0x11f/0x570 [videodev]
Aug 18 10:59:12 ancizan kernel: [ 9840.252487]  [<f815a2f2>]
v4l2_ioctl+0x82/0x120 [videodev]
Aug 18 10:59:12 ancizan kernel: [ 9840.252501]  [<f815a270>] ?
v4l2_ioctl+0x0/0x120 [videodev]
Aug 18 10:59:12 ancizan kernel: [ 9840.252510]  [<c113696b>]
do_vfs_ioctl+0x7b/0x2e0
Aug 18 10:59:12 ancizan kernel: [ 9840.252518]  [<c1136c57>] sys_ioctl+0x87/0x90
Aug 18 10:59:12 ancizan kernel: [ 9840.252526]  [<c1054fa2>] ?
sys_gettimeofday+0x32/0x70
Aug 18 10:59:12 ancizan kernel: [ 9840.252534]  [<c150a194>]
syscall_call+0x7/0xb


Thank you

-- 
Damien Cassou
http://damiencassou.seasidehosting.st

"Lambdas are relegated to relative obscurity until Java makes them
popular by not having them." James Iry
