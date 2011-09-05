Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1-g21.free.fr ([212.27.42.1]:45570 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750844Ab1IEHTb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 5 Sep 2011 03:19:31 -0400
Received: from tele (unknown [IPv6:2a01:e35:2f5c:9de0:212:bfff:fe1e:8db5])
	by smtp1-g21.free.fr (Postfix) with ESMTP id 7CD43940099
	for <linux-media@vger.kernel.org>; Mon,  5 Sep 2011 09:19:20 +0200 (CEST)
Date: Mon, 5 Sep 2011 09:19:59 +0200
From: Jean-Francois Moine <moinejf@free.fr>
To: linux-media@vger.kernel.org
Subject: Re: spca1528 device (Device 015: ID 04fc:1528 Sunplus
 Technology)..libv4l2: error turning on	stream: Timer expired issue
Message-ID: <20110905091959.727346d5@tele>
In-Reply-To: <4E63D3F2.8090500@gmail.com>
References: <4E63D3F2.8090500@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 04 Sep 2011 15:39:30 -0400
Mauricio Henriquez <buhochileno@gmail.com> wrote:

> Recently I'm trying to make work a Sunplus crappy mini HD USB camera, lsusb
> list this info related to the device:
> 
> Picture Transfer Protocol (PIMA 15470)
> Bus 001 Device 015: ID 04fc:1528 Sunplus Technology Co., Ltd
> 
>   idVendor           0x04fc Sunplus Technology Co., Ltd
>    idProduct          0x1528
>    bcdDevice            1.00
>    iManufacturer           1 Sunplus Co Ltd
>    iProduct                2 General Image Devic
>    iSerial                 0
> ...
> 
> Using the gspca-2.13.6 on my Fed12 (2.6.31.6-166.fc12.i686.PAE kernel), the
> device is listed as /dev/video1 and no error doing a dmesg...but trying to
> make it work, let say with xawtv, I get:
	[snip]

Hi Mauricio,

The problem seems tied to the alternate setting. It must be the #3
while the lastest versions of gspca compute a "best" one. May you apply
the following patch to gspca-2.13.6?

----------------------8<----------------------
--- build/spca1528.c.orig	2011-09-05 08:41:54.000000000 +0200
+++ build/spca1528.c	2011-09-05 08:53:51.000000000 +0200
@@ -307,8 +307,6 @@
 	sd->color = COLOR_DEF;
 	sd->sharpness = SHARPNESS_DEF;
 
-	gspca_dev->nbalt = 4;		/* use alternate setting 3 */
-
 	return 0;
 }
 
@@ -349,6 +347,9 @@
 	reg_r(gspca_dev, 0x25, 0x0004, 1);
 	reg_wb(gspca_dev, 0x27, 0x0000, 0x0000, 0x06);
 	reg_r(gspca_dev, 0x27, 0x0000, 1);
+
+	gspca_dev->alt = 4;		/* use alternate setting 3 */
+
 	return gspca_dev->usb_err;
 }
 
----------------------8<----------------------

(Theodore, this webcam may work in mass storage mode with ID 04fc:0171.
In webcam mode with ID 04fc:1528, it offers 3 interfaces: interface 0
contains only an interrupt endpoint, interface 1 is the webcam with
only isochronous endpoints and interface 2 contains bulk in, bulk out
and interrupt in endpoints - I don't know how to use the interfaces 0
and 2, but sure the interface 2 could be used to access the camera
images)

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
