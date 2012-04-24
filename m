Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:43200 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757253Ab2DXTnE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Apr 2012 15:43:04 -0400
Received: by obbta14 with SMTP id ta14so1584810obb.19
        for <linux-media@vger.kernel.org>; Tue, 24 Apr 2012 12:43:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4F96FCCA.30106@lysator.liu.se>
References: <4F96FCCA.30106@lysator.liu.se>
Date: Tue, 24 Apr 2012 21:43:03 +0200
Message-ID: <CAJbz7-0T-SSnjWKXLLr_o2KdFTaBxz2u1hP1sC+eKr-0Cn4P5A@mail.gmail.com>
Subject: Re: New version of Anysee E7 T2C?
From: =?ISO-8859-2?Q?Honza_Petrou=B9?= <jpetrous@gmail.com>
To: Magnus Ekhall <koma@lysator.liu.se>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Magnus.

Dne 24. dubna 2012 21:19 Magnus Ekhall <koma@lysator.liu.se> napsal(a):
> Hi,
>
> I just got a new Anysee E7 T2C DVB-USB device.
>
> When I load the module dvb-usb-anysee.ko "Driver Anysee E30 DVB-C &
> DVB-T USB2.0" version 3.2.0-23-generic I get:
>
> [    8.353474] DVB: registering new adapter (Anysee DVB USB2.0)
> [    8.356162] anysee: firmware version:1.0 hardware id:20
> [    8.356164] anysee: Unsupported Anysee version. Please report the
> <linux-media@vger.kernel.org>.
> [    8.356167] dvb-usb: no frontend was attached by 'Anysee DVB USB2.0'
>
> Strange thing is that hardware id:20 should be supported by the driver
> from what I can see in the source?
>
> Any ideas?

I'm not sure if T2C model is supported in 3.2.0 kernel. You should better
ask author of the drivers - Antti.

If you are programmer, you can check against some 3.3.x tree, as
there is supported for sure.

Honza
