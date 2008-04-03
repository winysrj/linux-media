Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from wx-out-0506.google.com ([66.249.82.225])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <rvm3000@gmail.com>) id 1JhDCG-0007d2-U4
	for linux-dvb@linuxtv.org; Thu, 03 Apr 2008 02:20:53 +0200
Received: by wx-out-0506.google.com with SMTP id s11so3201310wxc.17
	for <linux-dvb@linuxtv.org>; Wed, 02 Apr 2008 17:20:48 -0700 (PDT)
Message-ID: <f474f5b70804021720i7926ea17q77b3ef551fb0841f@mail.gmail.com>
Date: Thu, 3 Apr 2008 02:20:47 +0200
From: rvm <rvm3000@gmail.com>
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Content-Disposition: inline
Subject: [linux-dvb] Pinnacle PCTV 71e
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

Isn't still possible to use the Pinnacle PCTV 71e in linux?

I installed the latest v4l-dvb as explained in
http://www.linuxtv.org/wiki/index.php/How_to_install_DVB_device_drivers
but this dvb-t stick is still not recognized.

# lsusb
Bus 005 Device 003: ID 2304:022b Pinnacle Systems, Inc. [hex]
Bus 005 Device 002: ID 05e3:0710 Genesys Logic, Inc.
Bus 005 Device 001: ID 0000:0000
Bus 004 Device 001: ID 0000:0000
Bus 003 Device 001: ID 0000:0000
Bus 002 Device 001: ID 0000:0000
Bus 001 Device 001: ID 0000:0000

usbview:

PCTV 71e
Manufacturer: Pinnacle Systems
Serial Number: 010101010600001
Speed: 480Mb/s (high)
USB Version:  2.00
Device Class: 00(>ifc )
Device Subclass: 00
Device Protocol: 00
Maximum Default Endpoint Size: 64
Number of Configurations: 1
Vendor Id: 2304
Product Id: 022b
Revision Number:  2.00

Config Number: 1
	Number of Interfaces: 1
	Attributes: 80
	MaxPower Needed: 500mA

	Interface Number: 0
		Name: (none)
		Alternate Number: 0
		Class: ff(vend.)
		Sub Class: 0
		Protocol: 0
		Number of Endpoints: 4

			Endpoint Address: 81
			Direction: in
			Attribute: 2
			Type: Bulk
			Max Packet Size: 512
			Interval: 0ms

			Endpoint Address: 02
			Direction: out
			Attribute: 2
			Type: Bulk
			Max Packet Size: 512
			Interval: 0ms

			Endpoint Address: 84
			Direction: in
			Attribute: 2
			Type: Bulk
			Max Packet Size: 512
			Interval: 0ms

			Endpoint Address: 85
			Direction: in
			Attribute: 2
			Type: Bulk
			Max Packet Size: 512
			Interval: 0ms

-- 
Pepe

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
