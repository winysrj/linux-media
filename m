Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:46310 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752988Ab2LPOuf (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 16 Dec 2012 09:50:35 -0500
Message-ID: <50CDDF9A.1080509@iki.fi>
Date: Sun, 16 Dec 2012 16:50:02 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Renato Gallo <renatogallo@unixproducts.com>
CC: linux-media@vger.kernel.org
Subject: Re: cannot make this Asus my cinema-u3100miniplusv2 work under linux
References: <8e9f16405c8583e35cb97bb7d7daef4b@unixproducts.com>
In-Reply-To: <8e9f16405c8583e35cb97bb7d7daef4b@unixproducts.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/16/2012 04:23 PM, Renato Gallo wrote:
> any news on this ?
>
>
>
>
>
> Asus my cinema-u3100miniplusv2
>
> Bus 001 Device 015: ID 1b80:d3a8 Afatech
>
> [ 6956.333440] usb 1-6.3.6: new high-speed USB device number 16 using
> ehci_hcd
> [ 6956.453943] usb 1-6.3.6: New USB device found, idVendor=1b80,
> idProduct=d3a8
> [ 6956.453950] usb 1-6.3.6: New USB device strings: Mfr=1, Product=2,
> SerialNumber=0
> [ 6956.453955] usb 1-6.3.6: Product: Rtl2832UDVB
> [ 6956.453959] usb 1-6.3.6: Manufacturer: Realtek
>

Seems to be Realtek RTL2832U. Add that USB ID to the driver and test. It 
is very high probability it starts working.

Here is the patch:
http://git.linuxtv.org/anttip/media_tree.git/shortlog/refs/heads/rtl28xxu-usb-ids

Please test and report.

regards
Antti

-- 
http://palosaari.fi/
