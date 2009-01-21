Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx28.mail.ru ([194.67.23.67]:24587 "EHLO mx28.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753102AbZAUPpC (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 21 Jan 2009 10:45:02 -0500
Received: from mx39.mail.ru (mx39.mail.ru [194.67.23.35])
	by mx28.mail.ru (mPOP.Fallback_MX) with ESMTP id D19C177FB7C
	for <linux-media@vger.kernel.org>; Wed, 21 Jan 2009 16:49:23 +0300 (MSK)
Received: from [93.94.222.250] (port=58345 helo=[192.168.7.7])
	by mx39.mail.ru with asmtp
	id 1LPdRr-0006jW-00
	for linux-media@vger.kernel.org; Wed, 21 Jan 2009 16:48:51 +0300
Subject: Re: [linux-dvb] QQ box dvb-s usb dongle not supported ?
From: ar <ar-grig@mail.ru>
To: linux-media@vger.kernel.org
In-Reply-To: <200901202247.16446.liplianin@tut.by>
References: <1232480273.23804.10.camel@hp>
	 <200901202247.16446.liplianin@tut.by>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 21 Jan 2009 17:48:49 +0400
Message-Id: <1232545729.27923.5.camel@hp>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Втр, 2009-01-20 at 22:47 +0200, Igor M. Liplianin wrote:
> В сообщении от 20 January 2009 21:37:53 ar написал(а):
> > I am running ubuntu intrepid latest update on hp pavilion tx1000z with
> > latest dvb kernel modules.
> >
> > I have bought the "QQ box" dvb-s usb dongle and it seems to be
> > unsupported.
> >
> > HOW CAN I GET IT WORKING UNDER LINUX ?
> > ------------------------------------------------------------------------
> >
> I believe, it contains LME2510 USB chip.
it is really LME2510C chip

> As I have a card with that chip too, I begin to write code (hard to say 'driver').
> For now I can load firmware (of two parts) and determine 'cold' and 'warm' state.
> Eventually, the card was rejected by vendor and I drop it.
So no hope to have kernel module for linux 2.6... ?

> _______________________________________________
> linux-dvb users mailing list
> For V4L/DVB development, please use instead linux-media@vger.kernel.org
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb



