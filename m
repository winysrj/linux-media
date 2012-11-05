Return-path: <linux-media-owner@vger.kernel.org>
Received: from eos.fwall.u-szeged.hu ([160.114.120.248]:35380 "EHLO
	eos.fwall.u-szeged.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754172Ab2KEMhV (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 5 Nov 2012 07:37:21 -0500
Received: from [192.168.105.4] (helo=esym.fwall.u-szeged.hu)
	by eos.fwall.u-szeged.hu with esmtp (Exim 4.63)
	(envelope-from <zarvai@inf.u-szeged.hu>)
	id 1TVLva-0003gJ-Vi
	for linux-media@vger.kernel.org; Mon, 05 Nov 2012 13:37:18 +0100
Received: from mail.inf.u-szeged.hu ([160.114.37.227])
	by eos.fwall.u-szeged.hu with esmtp (Exim 4.63)
	(envelope-from <zarvai@inf.u-szeged.hu>)
	id 1TVLva-0003gi-QH
	for linux-media@vger.kernel.org; Mon, 05 Nov 2012 13:37:18 +0100
Received: from [10.6.11.3] (azbest.inf.u-szeged.hu [10.6.11.3])
	by mail.inf.u-szeged.hu (Postfix) with ESMTP id 6BF4116A0473
	for <linux-media@vger.kernel.org>; Mon,  5 Nov 2012 13:37:18 +0100 (CET)
Message-ID: <5097B2FE.3090100@inf.u-szeged.hu>
Date: Mon, 05 Nov 2012 13:37:18 +0100
From: =?UTF-8?B?w4FydmFpIFpvbHTDoW4=?= <zarvai@inf.u-szeged.hu>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: avermedia, new version of avertv volar green hd
References: <5096B744.40308@free.fr>
In-Reply-To: <5096B744.40308@free.fr>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I asked the local guy from Avermedia about this tuner.
He said it is a new product called  "AVerTV Volar HD M" (A835M). It has 
probably the same hardware like the Volar Green, but it has extended 
software bundle (e.g. Mac support).
http://www.avermedia.com/Product/ProductDetail.aspx?Id=517

Regards,
Zoltan


On 11/04/2012 07:43 PM, moebius wrote:
> Bonjour,
> It's a dvb-t usb dongle
>
> It's the same name than a former device but with new id : 07ca:3835 
> instead of 07ca:a835 and probably new hardware ; and it doesn't work...
>
> I've tried to enter a new device in the v4l-dvb web list but nothing 
> has happened ;  the source, can be found at 
> http://www.linuxtv.org/wiki/index.php?title=DVB-T_USB_Devices_ListData/Helper&action=edit&section=1 
>
> I've made a photo too but don't know how I can upload it.
>
> Anyway, here is the source :
>
> ==== AVerMedia AVerTV Volar Green HD 07ca:3835 ====
> {{DeviceDisplayMedium|AVerMedia AVerTV Volar Green HD 07ca:3835}}
> </noinclude><includeonly>
> {{{{{renderwith}}}|src=USB_Device_Data|selatt1={{{selatt1|}}}|selval1={{{selval1|}}}|selatt2={{{selatt2|}}}|selval2={{{selval2|}}}|selatt3={{{selatt3|}}}|selval3={{{selval3|}}}|selatt4={{{selatt4|}}}|selval4={{{selval4|}}} 
>
> | did=AVerMedia AVerTV Volar Green HD 07ca:3835
> | vendor=[[AVerMedia]]
> | device=[[AVerMedia AVerTV Volar Green HD | AVerTV Volar Green HD]]
> | standard=DVB-T
> | supported={{no}}
> | pic=
> | pic=
> | url=
> | url=
> | hostinterface=USB2.0
> | usbid=07ca:3835
> | hw=unknown (see pic)
> | tuner=
> | demodulator=
> | usbbridge=
> | fw=
> | comment= New version with same name ; main chipset (square, 4x12 
> pins) named AV3007 SXB1102 ; a little chip with 8 pins named 402R6 
> K207, another one with 5 pins 215L1(or "I" instead of "1") AC1H ; last 
> small chip with metal on top T120 WtBF.
> This device don't work on recent ubuntu kernel (3.2.0-23-lowlatency), 
> even with the last (04/11/2012) v4l drivers that I've downloaded and 
> install today.
> }}
>
> cordialement,
>
>
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

