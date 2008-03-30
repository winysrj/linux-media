Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ti-out-0910.google.com ([209.85.142.186])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <cibyr@cibyr.com>) id 1JflqZ-0002ff-TM
	for linux-dvb@linuxtv.org; Sun, 30 Mar 2008 01:56:33 +0100
Received: by ti-out-0910.google.com with SMTP id y6so342505tia.13
	for <linux-dvb@linuxtv.org>; Sat, 29 Mar 2008 17:56:24 -0700 (PDT)
Message-ID: <bbf19b3d0803291756q743eca07t4b2f8290dd47c3e4@mail.gmail.com>
Date: Sun, 30 Mar 2008 10:56:24 +1000
From: "Ian Cullinan" <cibyr@cibyr.com>
To: linux-dvb <linux-dvb@linuxtv.org>
In-Reply-To: <8ad9209c0803280951y7d4f2eb3k8368b43c2a666e3e@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
References: <1206139910.12138.34.camel@youkaida>
	<1206605144.8947.18.camel@youkaida>
	<af2e95fa0803271044lda4ac30yb242d7c9920c2051@mail.gmail.com>
	<47EC13BE.6020600@simmons.titandsl.co.uk>
	<1206655986.17233.8.camel@youkaida>
	<8ad9209c0803280846q53e75546g2007d4e8be98fb8e@mail.gmail.com>
	<1206719797.14161.8.camel@acropora>
	<8ad9209c0803280936k2cba9115laa49f828ffda55bf@mail.gmail.com>
	<1206722837.12480.3.camel@acropora>
	<8ad9209c0803280951y7d4f2eb3k8368b43c2a666e3e@mail.gmail.com>
Subject: Re: [linux-dvb] Now with debug info - Nova-T-500 disconnects - They
	are back!
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

I've got one of these (which is described on it's mythTV wiki page as
"fully and reliably supported") in a server that I'm trying to use as
a mythtv backend. It seems I have become one of the many people having
problems with this card and linux. mythtv tells me it can't get a
channel lock, and dmesg tells me:

usb 3-1: USB disconnect, address 2
mt2060 I2C write failed
dvb-usb: error while stopping stream.

Interestingly, trying to run lsusb at this point seems to get stuck
inside a system call or something because it never exits and kill -9
doesn't kill it. Restarting mythbackend gets everything back.

This is on kernel 2.6.24-gentoo-r3, with hardware:
Gigabyte G33-DS3R motherboard (Intel G33 chipset)
Intel Q6600
2GB RAM (dual channel DDR2-800)

I'm using the dvb-usb-dib0700-1.10.fw firmware.

I saw somewhere on the archives that someone found the problem went
away with the following options to modprobe:
options dvb-usb-dib0700 debug=1
options mt2060 debug=1
options dibx000_common debug=1
options dvb_core debug=1
options dvb_core dvbdev_debug=1
options dvb_core frontend_debug=1
options dvb_usb debug=1
options dib3000mc debug=1

Problem hasn't gone away (but seems less frequent), and I figure
someone here could use the debugging data so here's the relevant part
of my syslog:
http://pastebin.com/f34ed8e20
(disconnect even is pretty much at the top, and down the bottom is
where I restarted mythbackend).

Ian Cullinan

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
