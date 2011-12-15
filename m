Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:63327 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932427Ab1LOQmN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 15 Dec 2011 11:42:13 -0500
Received: by eaaj10 with SMTP id j10so2097938eaa.19
        for <linux-media@vger.kernel.org>; Thu, 15 Dec 2011 08:42:11 -0800 (PST)
Message-ID: <1323967323.2273.17.camel@tvbox>
Subject: Re: [PATCH] it913x add support for IT9135 9006 devices
From: Malcolm Priestley <tvboxspy@gmail.com>
To: Adrian N <adexmail@tlen.pl>
Cc: linux-media@vger.kernel.org
Date: Thu, 15 Dec 2011 16:42:03 +0000
In-Reply-To: <4EEA16BA.4070209@tlen.pl>
References: <1323719580.2235.3.camel@tvbox>
	 <loom.20111214T071004-336@post.gmane.org> <4EEA16BA.4070209@tlen.pl>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


> [ 1103.536156] it913x: Chip Version=ec Chip Type=5830
> [ 1104.336178] it913x: Dual mode=92 Remote=92 Tuner Type=92
> [ 1106.248116] dvb-usb: found a 'ITE 9135(9006) Generic' in cold state, 
> will try to load a firmware
> [ 1106.253773] dvb-usb: downloading firmware from file 
> 'dvb-usb-it9135-02.fw'
> [ 1106.452123] it913x: FRM Starting Firmware Download
> [ 1130.756039] it913x: FRM Firmware Download Failed (ffffff92)
> [ 1130.956168] it913x: Chip Version=79 Chip Type=5823
> [ 1131.592192] it913x: DEV it913x Error
> [ 1131.592271] usbcore: registered new interface driver it913x
> 
> No frontend is generated anyway.

Looks like the the firmware is not at all compatible with your device.

Have you applied the patch cleanly to the latest media_build?

These appear to be new version of the 9006. A supplier is sending me one
of these devices.

As a last resort see if the device works with dvb-usb-it9137-01.fw

You will have force to use this firmware
dvb-usb-it913x firmware=1

For the moment this patch cannot proceed until the firmware has been
checked.

Regards


Malcolm

