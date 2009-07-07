Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:41950 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1758772AbZGGOhC (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 7 Jul 2009 10:37:02 -0400
From: Nils Kassube <kassube@gmx.net>
To: Antti Palosaari <crope@iki.fi>
Subject: Re: Fix for crash in dvb-usb-af9015
Date: Tue, 7 Jul 2009 16:33:59 +0200
Cc: linux-media@vger.kernel.org
References: <200907071232.00459.kassube@gmx.net> <4A532ACA.1070607@iki.fi>
In-Reply-To: <4A532ACA.1070607@iki.fi>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907071634.00168.kassube@gmx.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Antti,

Antti Palosaari wrote:
> Nils Kassube wrote:
> > As I'm not familiar with the hardware, I can't say what buffer size
> > would be appropriate but I can say that for my device the parameter
>
> I see the problem but your fix is not ideally correct for my eyes. 

You're probably right - like I wrote, I'm not familiar with the 
hardware.

> I
> don't have currently access to sniffs to ensure that but I think BOOT
> should be write command. Now it is defined as read. I think moving
> BOOT from read to write fixes problem.

Yes, that makes a lot of sense to me. Therefore I changed the code to 
make it a write command like this:

--- orig/linux-2.6.31/drivers/media/dvb/dvb-usb/af9015.c	2009-06-30 
11:34:45.000000000 +0200
+++ linux-2.6.31/drivers/media/dvb/dvb-usb/af9015.c	2009-07-07 
14:58:27.000000000 +0200
@@ -81,7 +81,6 @@
 
 	switch (req->cmd) {
 	case GET_CONFIG:
-	case BOOT:
 	case READ_MEMORY:
 	case RECONNECT_USB:
 	case GET_IR_CODE:
@@ -100,6 +99,7 @@
 	case WRITE_VIRTUAL_MEMORY:
 	case COPY_FIRMWARE:
 	case DOWNLOAD_FIRMWARE:
+	case BOOT:
 		break;
 	default:
 		err("unknown command:%d", req->cmd);

And of course I removed the earlier change. With this modification it 
works as well.


Nils

