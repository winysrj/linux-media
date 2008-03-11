Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from www.youplala.net ([88.191.51.216] helo=mail.youplala.net)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <nico@youplala.net>) id 1JZ9tu-0001Kn-VY
	for linux-dvb@linuxtv.org; Tue, 11 Mar 2008 20:12:48 +0100
Received: from [11.11.11.138] (user-5af0e527.wfd96.dsl.pol.co.uk
	[90.240.229.39])
	by mail.youplala.net (Postfix) with ESMTP id C2F21D88130
	for <linux-dvb@linuxtv.org>; Tue, 11 Mar 2008 20:11:31 +0100 (CET)
From: Nicolas Will <nico@youplala.net>
To: linux-dvb <linux-dvb@linuxtv.org>
In-Reply-To: <005101c8839e$797bb140$4101a8c0@ians>
References: <004601c8839a$365ac620$4101a8c0@ians>
	<1205256041.7463.34.camel@acropora>
	<005101c8839e$797bb140$4101a8c0@ians>
Date: Tue, 11 Mar 2008 19:11:27 +0000
Message-Id: <1205262687.19053.6.camel@youkaida>
Mime-Version: 1.0
Subject: Re: [linux-dvb] Nova T-500 detection problem
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


On Tue, 2008-03-11 at 17:36 +0000, Ian Liverton wrote:
> > What is lsusb saying?
> 
> Thanks for the fast reply! lsusb says:
> 
> Bus 005 Device 002: ID 2040:9940 Hauppauge
> Bus 005 Device 001: ID 0000:0000
> Bus 004 Device 001: ID 0000:0000
> Bus 003 Device 001: ID 0000:0000
> Bus 002 Device 001: ID 0000:0000
> Bus 001 Device 001: ID 0000:0000
> 

going back on list.

Mine says 

Bus 010 Device 002: ID 2040:9950 Hauppauge

and is recognized.

You will need to edit 

linux/drivers/media/dvb/dvb-usb/dvb-usb-ids.h

and define a new ID there (around line 128), then edit

linux/drivers/media/dvb/dvb-usb/dib0700_devices.c

and add the ID info (around line 980). I wonder if there is something to do around line 114 too, but not being a coder, I'm lost there.

A proper dev should probably confirm.

Nico


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
