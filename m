Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtpi2.ngi.it ([88.149.128.21]:33728 "EHLO smtpi2.ngi.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760743AbZAQXdX (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 17 Jan 2009 18:33:23 -0500
Message-ID: <49726ABB.6060003@robertoragusa.it>
Date: Sun, 18 Jan 2009 00:33:15 +0100
From: Roberto Ragusa <mail@robertoragusa.it>
MIME-Version: 1.0
To: Detlef Rohde <rohde.d@t-online.de>
CC: Antti Palosaari <crope@iki.fi>, Jochen Friedrich <jochen@scram.de>,
	linux-media@vger.kernel.org
Subject: Re: [PATCHv4] Add Freescale MC44S803 tuner driver
References: <496F9A1C.7040602@scram.de> <49722758.8030801@iki.fi> <49726547.7020903@t-online.de>
In-Reply-To: <49726547.7020903@t-online.de>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Detlef Rohde wrote:
> 
> Hi All,
> I have to apologize being a stupid newbie not able to put Antti's latest
> source (mc44s803-71b0ef33303a) into my kernel (2.6.27-11-generic).
> Have performed successfully a "make", but running "install" failed
> because of missed option settings for this operation. I am uncertain if
> I must set a path directory. Is'nt there a symbolic link to the right
> directory?

I don't understand what is happening.
What kind of error message you get?

Hmm, are you running "install" instead of "make install"?

 "make" compiled lots of not needed stuff here, but my system
> needs only a firmware file:
> (Copied from /var/log/messages)
> Jan 17 23:22:21 detlef-laptop kernel: [  155.512517] dvb-usb: found a
> 'TerraTec Cinergy T USB XE' in cold state, will try to load a firmware
> Jan 17 23:22:21 detlef-laptop kernel: [  155.512530] firmware:
> requesting dvb-usb-af9015.fw
> Jan 17 23:22:21 detlef-laptop kernel: [  155.526289] dvb_usb_af9015:
> probe of 4-3.3:1.0 failed with error -2
> 
> Maybe Antti can post me one which I simply can paste into /lib/firmware?

Here is the firmware I use.

http://www.otit.fi/~crope/v4l-dvb/af9015/af9015_firmware_cutter/firmware_files/4.95.0/dvb-usb-af9015.fw

> Hopefully one of you can give an advice..

I tried. :-)

-- 
   Roberto Ragusa    mail at robertoragusa.it
