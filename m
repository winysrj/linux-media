Return-path: <mchehab@pedra>
Received: from mail.kapsi.fi ([217.30.184.167]:52735 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756567Ab0JVO0I (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Oct 2010 10:26:08 -0400
Message-ID: <4CC19EFD.7010107@iki.fi>
Date: Fri, 22 Oct 2010 17:26:05 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Felix Droste <felixdroste@arcor.de>
CC: linux-media@vger.kernel.org
Subject: Re: USB DVBT af9015: tuner id:177 not supported, please report!
References: <4CC0444E.1040902@arcor.de>
In-Reply-To: <4CC0444E.1040902@arcor.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Moikka Felix.

It is already supported, will go the 2.6.37. Tuner ID 177 is MaxLinear 
MXL5007T.

Antti


On 10/21/2010 04:46 PM, Felix Droste wrote:
> I could not get this DVBT-Stick (USB) to work:
>
> auvisio USB-DVB-T-Receiver & -Recorder "DR-340"
>
> h t t p : / / w w w
> .pearl.de/product.jsp?pdid=HPM1520&catid=8909&vid=922&curr=DEM
>
> dmesg:
>
> [25239.410175] usb 2-1: new high speed USB device using ehci_hcd and
> address 6
> [25239.569729] Afatech DVB-T 2: Fixing fullspeed to highspeed interval:
> 10 -> 7
> [25239.570294] input: Afatech DVB-T 2 as
> /devices/pci0000:00/0000:00:1d.7/usb2/2-1/2-1:1.1/input/input12
> [25239.570642] generic-usb 0003:15A4:9016.0003: input,hidraw2: USB HID
> v1.01 Keyboard [Afatech DVB-T 2] on usb-0000:00:1d.7-1/input1
> [25239.982243] af9015: tuner id:177 not supported, please report!
> [25239.982339] usbcore: registered new interface driver dvb_usb_af9015
>
>
> Cheers!
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at http://vger.kernel.org/majordomo-info.html


-- 
http://palosaari.fi/
