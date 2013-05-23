Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43744 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754636Ab3EWIYH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 23 May 2013 04:24:07 -0400
Received: from int-mx11.intmail.prod.int.phx2.redhat.com (int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r4N8O7Vu010335
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Thu, 23 May 2013 04:24:07 -0400
Received: from shalem.localdomain (vpn1-7-57.ams2.redhat.com [10.36.7.57])
	by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id r4N8O5du005554
	(version=TLSv1/SSLv3 cipher=DHE-RSA-CAMELLIA256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Thu, 23 May 2013 04:24:06 -0400
Message-ID: <519DD31D.5080802@redhat.com>
Date: Thu, 23 May 2013 10:28:13 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: InstantFM
References: <51993390.6080202@theo.to> <5199C8FA.9060704@redhat.com> <519A4464.7060006@theo.to> <519A6DBB.60608@theo.to> <519B23A7.90504@redhat.com> <519B649C.9040903@theo.to> <519C7E8B.9090406@redhat.com> <20130522140525.GF4308@ptaff.ca>
In-Reply-To: <20130522140525.GF4308@ptaff.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 05/22/2013 04:05 PM, Patrice Levesque wrote:
>
>>> I could try the liquorix kernel (3.8) if you thought it might help.
>> Yes, if you could try that that would be great.
>
> If I may join the party, I too own an InstantFM USB device and I can't
> get it to play radio.  All of this under kernel 3.9.3-gentoo.
>
> dmesg:
>
> 	usb 4-2.4: new full-speed USB device number 5 using uhci_hcd
> 	usb 4-2.4: New USB device found, idVendor=06e1, idProduct=a155
> 	usb 4-2.4: New USB device strings: Mfr=1, Product=2, SerialNumber=0
> 	usb 4-2.4: Product: ADS InstantFM Music
> 	usb 4-2.4: Manufacturer: ADS TECH
> 	radio-si470x 4-2.4:1.2: DeviceID=0xffff ChipID=0xffff

This, as well as the "Invalid freq '127150000'" and the
"get_baseline:  min=65535.000000 max=65535.000000" messages seem to indicate
that only FFFF is being read from all the registers of the tuner chip, so
somehow the communication between the usb micro-controller and the
si470x tuner chip is not working.

If it does work under $otheros, you can try running $otheros in a
qemu vm with usb passthrough, and then with wireshark on the host catch the usb
traffic, and see what $otheros is doing ...

Regards,

Hans
