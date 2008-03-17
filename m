Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from urmel-5.rz.uni-frankfurt.de ([141.2.22.233]
	helo=mailout.cluster.uni-frankfurt.de)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <f.apitzsch@soz.uni-frankfurt.de>) id 1JbOJ0-0001Oi-Bs
	for linux-dvb@linuxtv.org; Mon, 17 Mar 2008 23:59:47 +0100
Received: from [10.2.22.4] (helo=smtpauth2.rz.uni-frankfurt.de)
	by mailout.cluster.uni-frankfurt.de with esmtps (TLSv1:AES256-SHA:256)
	(Exim 4.66) (envelope-from <f.apitzsch@soz.uni-frankfurt.de>)
	id 1JbOIw-0006VE-Qb
	for linux-dvb@linuxtv.org; Mon, 17 Mar 2008 23:59:42 +0100
Received: from e179025077.adsl.alicedsl.de ([85.179.25.77]
	helo=[192.168.178.1])
	by smtpauth2.rz.uni-frankfurt.de with esmtpsa (TLSv1:AES256-SHA:256)
	(Exim 4.69) (envelope-from <f.apitzsch@soz.uni-frankfurt.de>)
	id 1JbOIv-0002Hl-Jz
	for linux-dvb@linuxtv.org; Mon, 17 Mar 2008 23:59:41 +0100
Message-ID: <47DEF7DE.9080709@soz.uni-frankfurt.de>
Date: Mon, 17 Mar 2008 23:59:42 +0100
From: Felix Apitzsch <f.apitzsch@soz.uni-frankfurt.de>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] Terratec Cinergy HT Express
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Im am trying to get my Terratec Cinergy HT Express to work with v4l-dvb.

It's a DVB-T/analog hybrid (+radio) ExpressCard 34, but it connects
via the usb interface, not the pci-e interface. To confirm what I
reckoned, I openend the device to find the following:

DiBcom 7700C1-ACXXa-G QH0T8 D2PRJ.1 0646-1100-C

XCEIVE XC3028 AK47465,2 0620TWE3

CONEXANT CX25843-24Z 61024448 0625 KOREA

(I took some photos if someone is interested)

The usd-id is 0ccd:0060 .

For now, I would be happy to live with just DVB-T support.
As far as I understand the status quo, it should be possible to get
the card running, isn't it?

I would need some help to get the xc3028 part compiled and running and
add it to dib0700_devices.c and dvb-usb-ids.h with the right config
for the DIB770C1+XC3028. Additionally, I would need some assistance
with the firmware xc3028. The dib0700 firmeware should be ok.

Also, I had some trouble when I tried to get the xc3028 frontend code
compiled. It is not in v4l_experimental anymore, is it? Where did it
go and how do I include it?

Could anyone do a patch for me and pack me a .bz2, so I can do some testing?

I am running a kernel 2.6.24 on a x86_64 (~amd64) gentoo system with
current v4l-dvb-hg from portage.

Felix

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
