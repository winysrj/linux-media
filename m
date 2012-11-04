Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1-g21.free.fr ([212.27.42.1]:41961 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752618Ab2KDSnZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 4 Nov 2012 13:43:25 -0500
Received: from [IPv6:2a01:e34:ef32:80c0:316a:cf75:7e20:94c2] (unknown [IPv6:2a01:e34:ef32:80c0:316a:cf75:7e20:94c2])
	by smtp1-g21.free.fr (Postfix) with ESMTP id 015F0940193
	for <linux-media@vger.kernel.org>; Sun,  4 Nov 2012 19:43:17 +0100 (CET)
Message-ID: <5096B744.40308@free.fr>
Date: Sun, 04 Nov 2012 19:43:16 +0100
From: moebius <moebius1@free.fr>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: avermedia, new version of avertv volar green hd
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Bonjour,
It's a dvb-t usb dongle

It's the same name than a former device but with new id : 07ca:3835 
instead of 07ca:a835 and probably new hardware ; and it doesn't work...

I've tried to enter a new device in the v4l-dvb web list but nothing has 
happened ;  the source, can be found at 
http://www.linuxtv.org/wiki/index.php?title=DVB-T_USB_Devices_ListData/Helper&action=edit&section=1 

I've made a photo too but don't know how I can upload it.

Anyway, here is the source :

==== AVerMedia AVerTV Volar Green HD 07ca:3835 ====
{{DeviceDisplayMedium|AVerMedia AVerTV Volar Green HD 07ca:3835}}
</noinclude><includeonly>
{{{{{renderwith}}}|src=USB_Device_Data|selatt1={{{selatt1|}}}|selval1={{{selval1|}}}|selatt2={{{selatt2|}}}|selval2={{{selval2|}}}|selatt3={{{selatt3|}}}|selval3={{{selval3|}}}|selatt4={{{selatt4|}}}|selval4={{{selval4|}}}
| did=AVerMedia AVerTV Volar Green HD 07ca:3835
| vendor=[[AVerMedia]]
| device=[[AVerMedia AVerTV Volar Green HD | AVerTV Volar Green HD]]
| standard=DVB-T
| supported={{no}}
| pic=
| pic=
| url=
| url=
| hostinterface=USB2.0
| usbid=07ca:3835
| hw=unknown (see pic)
| tuner=
| demodulator=
| usbbridge=
| fw=
| comment= New version with same name ; main chipset (square, 4x12 pins) 
named AV3007 SXB1102 ; a little chip with 8 pins named 402R6 K207, 
another one with 5 pins 215L1(or "I" instead of "1") AC1H ; last small 
chip with metal on top T120 WtBF.
This device don't work on recent ubuntu kernel (3.2.0-23-lowlatency), 
even with the last (04/11/2012) v4l drivers that I've downloaded and 
install today.
}}

cordialement,


