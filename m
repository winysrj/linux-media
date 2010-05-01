Return-path: <linux-media-owner@vger.kernel.org>
Received: from fmmailgate02.web.de ([217.72.192.227]:51591 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752156Ab0EAL4R (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 1 May 2010 07:56:17 -0400
Received: from smtp07.web.de  ( [172.20.5.215])
	by fmmailgate02.web.de (Postfix) with ESMTP id 3364F15F8BA88
	for <linux-media@vger.kernel.org>; Sat,  1 May 2010 13:56:16 +0200 (CEST)
Received: from [213.182.109.137] (helo=[192.168.178.27])
	by smtp07.web.de with asmtp (TLSv1:AES256-SHA:256)
	(WEB.DE 4.110 #4)
	id 1O8BIt-0002jB-00
	for linux-media@vger.kernel.org; Sat, 01 May 2010 13:56:16 +0200
Subject: Technisat SkyStar USB plus
From: Carsten Wehmeier <casi.wehmeier@web.de>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 01 May 2010 13:56:14 +0200
Message-ID: <1272714974.3747.2.camel@linux-desktop>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Ubuntu 10.4, standard kernel
v4l-dvb sources (just updated)
Technisat SkyStar USB plus DVB-S USB device, output from lsusb:
Bus 001 Device 011: ID 0b48:3009 TechnoTrend AG 


Hello,

I own a Technisat SkyStar USB plus USB DVB-S device. It's a rebranded
Technotrend TT-connect S-2400, but it has a different USB_PID (0x3009
instead of 0x3006). After editing this in dvb-ids.h in the v4l-sources,
compiling and installing the drivers and adding the firmware file
dvb-usb-tt-s2400-01.fw, the device works fine on Ubuntu 10.4.
Please add the device with USB_PID  0x3009 to the v4l-dvb drivers.

Greetings

Carsten


