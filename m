Return-path: <linux-media-owner@vger.kernel.org>
Received: from kenny.juvepoland.com ([193.218.153.206]:44008 "EHLO
	kenny.juvepoland.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751686AbZDNKvY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Apr 2009 06:51:24 -0400
From: Dominik Sito <railis@juvepoland.com>
To: linux-media@vger.kernel.org, nizar.saied@gmail.com
Subject: Re: [linux-dvb] technisat skystar usb 2.0
Date: Wed, 15 Apr 2009 12:51:09 +0200
References: <grverg$k26$1@ger.gmane.org>
In-Reply-To: <grverg$k26$1@ger.gmane.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200904151251.09812.railis@juvepoland.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Monday 13 April 2009 17:31:29 nizar napisał(a):
> Please help needed.
> I have skystar usb 2.0 (13d0:2282) i have also the log of usbsnoop 
(300
> Mo) .
> What are steps to :
>
> 1- know if a firmware is needed.
> 2- if yes how to extract it.
>
>
> thank you
> Nizar
>
>
> _______________________________________________
> linux-dvb users mailing list
> For V4L/DVB development, please use instead linux-
media@vger.kernel.org
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb

Just give `lspci -vvv` and `lsusb -vvv` result.
Regards.
