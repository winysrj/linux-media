Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:46472 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753688Ab3CXNLd (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 24 Mar 2013 09:11:33 -0400
Message-ID: <514EFB5E.3010808@iki.fi>
Date: Sun, 24 Mar 2013 15:10:54 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: David <zlokomatic@gmail.com>
CC: linux-media@vger.kernel.org
Subject: Re: Fwd: Delock 61959
References: <CALS5Gh60mV5UiOeNPf98QrhmY_j5MDi2T1xsjRn7DzdAYj7fQg@mail.gmail.com> <CALS5Gh7=UTEz8GDq0XK97_=Uaf4gVfifweY+v50XX0AUjoHBNg@mail.gmail.com>
In-Reply-To: <CALS5Gh7=UTEz8GDq0XK97_=Uaf4gVfifweY+v50XX0AUjoHBNg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Maybe it is em28xx + DRX-K + tda18271 based. There is few such devices 
already supported by em28xx driver. First device to test is 1b80:e425 
MaxMedia UB425-TC. Just replace USB ID 0xe425 with 0xe1cc, compile and 
test. There is some other devices too, especially all those which are 
using drx-k.

regards
Antti


On 03/24/2013 03:51 AM, David wrote:
> Hi there,
>
> today i got a new DVB-T / DVB-C USB Stick but as far as i can see on
> the web it is not (yet) supported.
>
> Is this currently being worked on or is there something i can do to
> get it working?
>
> Here is the lsusb output:
>
> Device Descriptor:
>    bLength                18
>    bDescriptorType         1
>    bcdUSB               2.00
>    bDeviceClass            0 (Defined at Interface level)
>    bDeviceSubClass         0
>    bDeviceProtocol         0
>    bMaxPacketSize0        64
>    idVendor           0x1b80 Afatech
>    idProduct          0xe1cc
>    bcdDevice            1.00
>    iManufacturer           0
>    iProduct                1 USB 2875 Device
>    iSerial                 0
>    bNumConfigurations      1
>
>
> David
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


-- 
http://palosaari.fi/
