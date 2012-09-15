Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailfe03.c2i.net ([212.247.154.66]:34664 "EHLO swip.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753629Ab2IOMv1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 15 Sep 2012 08:51:27 -0400
From: Hans Petter Selasky <hselasky@c2i.net>
To: Antti Palosaari <crope@iki.fi>
Subject: Re: Strong pairing cam doesn't work with CT-3650 driver (ttusb2)
Date: Sat, 15 Sep 2012 14:52:35 +0200
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
References: <201208172135.17623.hselasky@c2i.net> <502EB0A9.4090501@iki.fi>
In-Reply-To: <502EB0A9.4090501@iki.fi>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201209151452.35183.hselasky@c2i.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Friday 17 August 2012 22:59:21 Antti Palosaari wrote:
> On 08/17/2012 10:35 PM, Hans Petter Selasky wrote:
> > Hi,
> > 
> > Have anyone out there tested the CT-3650 USB driver in the Linux kernel
> > with a "strong pairing cam".
> 
> Likely that means CI+ with some pairing features enabled.
> 
> > According to some web-forums, the hardware should support that given
> > using the vendor provided DVB WinXXX software.
> > 
> > drivers/media/dvb/dvb-usb/ttusb2.c
> > 
> > Any clues how to debug or what can be wrong?
> 
> Take USB traffic capture from working Windows setup and analyze what is
> done differently.
> 

Just forget this thread. The CAM was broken. Works now.

--HPS
