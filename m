Return-path: <linux-media-owner@vger.kernel.org>
Received: from 173-11-74-61-SFBA.hfc.comcastbusiness.net ([173.11.74.61]:35002
	"EHLO server.plumeriahale.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751031AbaKQQlS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Nov 2014 11:41:18 -0500
Received: from [192.168.3.11] (nuc.plumeriahale.net [192.168.3.11])
	by server.plumeriahale.net (Postfix) with ESMTP id 1EF7A3F02D
	for <linux-media@vger.kernel.org>; Mon, 17 Nov 2014 08:41:14 -0800 (PST)
Subject: Is it fair to say that the Terratec S7 does not in fact work with
 DVB-S2?
From: mpdcband <linuxdvb@plumeriahale.net>
To: Linux Media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 17 Nov 2014 08:41:13 -0800
Message-ID: <1416242473.25772.14.camel@nuc.plumeriahale.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I have a Terratec S7 USB device(actually an Elgato EyeTV Sat). This
works fine on a Mac Mini running EyeTV. It doesn't seem to scan DVB-S2
channels at all under Linux-DVB. I've noticed numerous messages in the
mailing list archive documenting problems with this device in regards to
S2. The only maintenance that seems to occur on the driver for this
device is to periodically update the list of identification strings for
this device.

So, because I want to use Linux-DVB for receiving DVB-S2 channels I have
the following questions:

   1) Is the Terratec S7 (in its many guises) actually supported at all
by either Terratec or someone else for use with DVB-S2 under linux-dvb?
And are there any cases where the device actually works under linux-dvb
as well as it does on a Mac or Windows system? 

   2) If not, are there in fact any devices for DVB-S2 with drivers that
are fully supported in linux-dvb and that in fact work on DVB-S2
channels with the utilities found in linux-dvb? (If there are I'd get
rid of my Terratec S7 and get something else).

   3) Or, is it not the case that there is any (active) support at all
in the linux-dvb community for DVB-S2 (perhaps because interest is
focused on different modulation methods and transmission types)?

Thanks for any information you can impart regarding this.

