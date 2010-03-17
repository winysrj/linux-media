Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay01.digicable.hu ([92.249.128.189]:36879 "EHLO
	relay01.digicable.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753812Ab0CQVZk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Mar 2010 17:25:40 -0400
Received: from [94.21.97.195]
	by relay01.digicable.hu with esmtpa
	id 1Ns0kE-0007Oi-DR for <linux-media@vger.kernel.org>; Wed, 17 Mar 2010 22:25:38 +0100
Message-ID: <4BA148CD.5060309@freemail.hu>
Date: Wed, 17 Mar 2010 22:25:33 +0100
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
MIME-Version: 1.0
To: V4L Mailing List <linux-media@vger.kernel.org>
Subject: Sony DCR-HC23 + USB (0540:00c0) + Linux?
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

does anybody have experience connecting Sony DCR-HC23 Handycam to Linux through
USB? I send the USB descriptor below.

The device appears only after selecting the "FN/MENU/SETUP MENU/USB STREAM"
menu item of the handycam to "ON". When I select "OFF" and press "EXEC" button
then the device disconnects from the USB bus, if I select "ON" and press "EXEC"
the device connects again to USB bus.

(The device also have a Firewire port, unfortunately my PC doesn't have one.)

Regards,

	Márton Németh

snd-usb-audio
Speed: 12Mb/s (full)
USB Version:  1.10
Device Class: 00(>ifc )
Device Subclass: 00
Device Protocol: 00
Maximum Default Endpoint Size: 64
Number of Configurations: 1
Vendor Id: 054c
Product Id: 00c0
Revision Number:  1.00

Config Number: 1
	Number of Interfaces: 3
	Attributes: c0
	MaxPower Needed:   2mA

	Interface Number: 0
		Name: (none)
		Alternate Number: 0
		Class: 00(>ifc )
		Sub Class: 00
		Protocol: 00
		Number of Endpoints: 2

			Endpoint Address: 81
			Direction: in
			Attribute: 1
			Type: Isoc
			Max Packet Size: 0
			Interval: 1ms

			Endpoint Address: 82
			Direction: in
			Attribute: 1
			Type: Isoc
			Max Packet Size: 0
			Interval: 1ms

	Interface Number: 0
		Name: (none)
		Alternate Number: 1
		Class: 00(>ifc )
		Sub Class: 00
		Protocol: 00
		Number of Endpoints: 2

			Endpoint Address: 81
			Direction: in
			Attribute: 1
			Type: Isoc
			Max Packet Size: 8
			Interval: 1ms

			Endpoint Address: 82
			Direction: in
			Attribute: 1
			Type: Isoc
			Max Packet Size: 256
			Interval: 1ms

	Interface Number: 0
		Name: (none)
		Alternate Number: 2
		Class: 00(>ifc )
		Sub Class: 00
		Protocol: 00
		Number of Endpoints: 2

			Endpoint Address: 81
			Direction: in
			Attribute: 1
			Type: Isoc
			Max Packet Size: 8
			Interval: 1ms

			Endpoint Address: 82
			Direction: in
			Attribute: 1
			Type: Isoc
			Max Packet Size: 384
			Interval: 1ms

	Interface Number: 0
		Name: (none)
		Alternate Number: 3
		Class: 00(>ifc )
		Sub Class: 00
		Protocol: 00
		Number of Endpoints: 2

			Endpoint Address: 81
			Direction: in
			Attribute: 1
			Type: Isoc
			Max Packet Size: 8
			Interval: 1ms

			Endpoint Address: 82
			Direction: in
			Attribute: 1
			Type: Isoc
			Max Packet Size: 512
			Interval: 1ms

	Interface Number: 0
		Name: (none)
		Alternate Number: 4
		Class: 00(>ifc )
		Sub Class: 00
		Protocol: 00
		Number of Endpoints: 2

			Endpoint Address: 81
			Direction: in
			Attribute: 1
			Type: Isoc
			Max Packet Size: 8
			Interval: 1ms

			Endpoint Address: 82
			Direction: in
			Attribute: 1
			Type: Isoc
			Max Packet Size: 640
			Interval: 1ms

	Interface Number: 0
		Name: (none)
		Alternate Number: 5
		Class: 00(>ifc )
		Sub Class: 00
		Protocol: 00
		Number of Endpoints: 2

			Endpoint Address: 81
			Direction: in
			Attribute: 1
			Type: Isoc
			Max Packet Size: 8
			Interval: 1ms

			Endpoint Address: 82
			Direction: in
			Attribute: 1
			Type: Isoc
			Max Packet Size: 768
			Interval: 1ms

	Interface Number: 0
		Name: (none)
		Alternate Number: 6
		Class: 00(>ifc )
		Sub Class: 00
		Protocol: 00
		Number of Endpoints: 2

			Endpoint Address: 81
			Direction: in
			Attribute: 1
			Type: Isoc
			Max Packet Size: 8
			Interval: 1ms

			Endpoint Address: 82
			Direction: in
			Attribute: 1
			Type: Isoc
			Max Packet Size: 896
			Interval: 1ms

	Interface Number: 0
		Name: (none)
		Alternate Number: 7
		Class: 00(>ifc )
		Sub Class: 00
		Protocol: 00
		Number of Endpoints: 2

			Endpoint Address: 81
			Direction: in
			Attribute: 1
			Type: Isoc
			Max Packet Size: 8
			Interval: 1ms

			Endpoint Address: 82
			Direction: in
			Attribute: 1
			Type: Isoc
			Max Packet Size: 1023
			Interval: 1ms

	Interface Number: 1
		Name: snd-usb-audio
		Alternate Number: 0
		Class: 01(audio)
		Sub Class: 01
		Protocol: 00
		Number of Endpoints: 0

	Interface Number: 2
		Name: snd-usb-audio
		Alternate Number: 0
		Class: 01(audio)
		Sub Class: 02
		Protocol: 00
		Number of Endpoints: 0

	Interface Number: 2
		Name: snd-usb-audio
		Alternate Number: 1
		Class: 01(audio)
		Sub Class: 02
		Protocol: 00
		Number of Endpoints: 1

			Endpoint Address: 83
			Direction: in
			Attribute: 1
			Type: Isoc
			Max Packet Size: 64
			Interval: 1ms
