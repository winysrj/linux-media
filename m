Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from [130.149.205.37] (helo=mail.tu-berlin.de)
	by www.linuxtv.org with esmtp (Exim 4.69)
	(envelope-from <SRS0+4FAl+89+clarkson.id.au=rodd@internode.on.net>)
	id 1Nm0b0-0007ee-Rr
	for linux-dvb@linuxtv.org; Mon, 01 Mar 2010 09:03:19 +0100
Received: from bld-mail15.adl6.internode.on.net ([150.101.137.100]
	helo=mail.internode.on.net)
	by mail.tu-berlin.de (exim-4.69/mailfrontend-d) with esmtp
	for <linux-dvb@linuxtv.org>
	id 1Nm0az-0006ih-Ny; Mon, 01 Mar 2010 09:03:18 +0100
Received: from [192.168.1.100] (unverified [118.209.146.223])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	3839697-1927428
	for <linux-dvb@linuxtv.org>; Mon, 01 Mar 2010 18:33:08 +1030 (CDT)
From: Rodd Clarkson <rodd@clarkson.id.au>
To: linux-dvb@linuxtv.org
Date: Mon, 01 Mar 2010 19:03:06 +1100
Message-ID: <1267430586.3536.5.camel@localhost.localdomain>
Mime-Version: 1.0
Subject: [linux-dvb] DVB-T USB Devices
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/options/linux-dvb>,
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

Hi,

having a look at the page below, I noticed that my working card wasn't
listed and I'm not sure how to do it, so I thought I would report it
here (were I lurk).  I hope this is okay.

http://www.linuxtv.org/wiki/index.php/DVB-T_USB_Devices

My card reports as follows:

usb 1-4: Manufacturer: Hauppauge Computer Works
...
smscore_set_device_mode: firmware download success:
sms1xxx-nova-b-dvbt-01.fw
...
DVB: registering new adapter (Hauppauge Okemo-B)
DVB: registering adapter 0 frontend 0 (Siano Mobile Digital MDTV
Receiver)...

lsusb shows:

Bus 001 Device 003: ID 2040:1801 Hauppauge 

I've had this card working with me-tv and other video based viewers.

This has worked since at least kernel 2.6.31 but might have worked with
earlier kernels.

The card is of interest because Dell included them in some of their
laptops, so there should be a few of them out there.

Is this enough information to get the card included on this page?


R.




_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
