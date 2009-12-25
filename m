Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f219.google.com ([209.85.219.219]:38302 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755297AbZLYPgD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 25 Dec 2009 10:36:03 -0500
Received: by ewy19 with SMTP id 19so235466ewy.21
        for <linux-media@vger.kernel.org>; Fri, 25 Dec 2009 07:36:01 -0800 (PST)
Date: Fri, 25 Dec 2009 16:35:58 +0100 (CET)
From: BOUWSMA Barry <freebeer.bouwsma@gmail.com>
To: TAXI <taxi@a-city.de>
cc: linux-media@vger.kernel.org
Subject: Re: Bad image/sound quality with Medion MD 95700
In-Reply-To: <4B34961D.6060207@a-city.de>
Message-ID: <alpine.DEB.2.01.0912251529470.5481@ybpnyubfg.ybpnyqbznva>
References: <4B33F4CA.7060607@a-city.de> <alpine.DEB.2.01.0912251021210.5481@ybpnyubfg.ybpnyqbznva> <4B34961D.6060207@a-city.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 25 Dec 2009, TAXI wrote:

> > I have my machine operating fully again (yeahright), I can send
> > you some of these alternative patches to try -- running 
> > successfully on 2.6.14 and 2.6.27-rc4.

> That would be nice.

Hintergrund (aber nicht so wightig)...

I have not had the chance to update my `git' kernel source since 
more than a month, and even then, it is on a disk which I cannot
plug in at present.  The latest source I have at hand which I've
patched is 2.6.27-rc4.  There may be some differences from the
present code, so I am not sending a normal patch.

(Ich verwende aeltere Quellcode, deswegen musst Du per Hand
etwas aendern)


THIS IS NOT A PATCH TO BE APPLIED BY EVERYONE.  This is only to
verify that you are seeing the same problem I have had.

As I do not have a simple patch, I will give you the simple
changes to be made by hand.  Either way should give you a working
receiver, and both, but not together, should work.


Make a copy of the source file...
$  cd (your linux source)
$  cd drivers/media/dvb/dvb-usb
$  cp -pvi  cxusb.c  cxusb.c-DIST

Edit cxusb.c

find the function
cxusb_cx22702_frontend_attach
      ^^^^^^^
it should have the line
if (usb_set_interface(adap->dev->udev, 0, 6) < 0)
                                         ^^^
or something very similar -- change this 6 to 0.

This will cause the driver to look at alternate interface 0 for
bulk data.

Now rebuild the kernel or the dvb_usb_cxusb module, reboot or load
the new module, and try it and see if it is better.


I will send a second alternative patch, to read isoc data from
interface 6, in a separate message.


barry bouwsma
