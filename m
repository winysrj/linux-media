Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:44204 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751171AbaGXHEa (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Jul 2014 03:04:30 -0400
Message-ID: <53D0AFFB.1000809@iki.fi>
Date: Thu, 24 Jul 2014 10:04:27 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Olli Salonen <olli.salonen@iki.fi>, linux-media@vger.kernel.org
Subject: Re: cxusb: How to add CI support?
References: <CAAZRmGw8W2sLTqQ7cgpB-1Y+DrkHy9d83VrJ_ciQEY5K3H-EFw@mail.gmail.com>
In-Reply-To: <CAAZRmGw8W2sLTqQ7cgpB-1Y+DrkHy9d83VrJ_ciQEY5K3H-EFw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Moikka!

On 07/23/2014 10:24 PM, Olli Salonen wrote:
> Hi everyone,
>
> I'm in need of advice when it comes to the implementation of the
> drivers. I recently added support for TechnoTrend CT2-4400 DVB-T2
> tuner into the dvb-usb-cxusb module. Now I have gotten another
> TechnoTrend device CT2-4650 and it seems this is more or less the same
> device as CT2-4400 but with an added CI slot. The CI is realized using
> a CIMaX SP2HF chip.

Here is some brief cip info from manufacturer
http://www.smardtv.com/component/zoo/item/cimax.html

> There seems to be support already for the said CIMaX chip, but only in
> combination with cx23885 (drivers/media/pci/cx23885/
> cimax2.c). This cannot be reused directly in my case. When I look at
> the other dvb-usb devices that have CI slot the support for CI has
> been implemented directly in the code of the USB device (for example,
> pctv452e or az6027).

That is because CI driver usually by USB interface firmware. You could 
see also anysee as one of such example more.


> Of course, an easy way to do it is to reuse a lot of code from the
> existing cimax2 and add it in the cxusb. However, I'm not sure if
> that's an ok approach. As I'm relatively new to linux kernel coding,
> I'd like to ask your recommendation for implementing the CI support
> here before the endeavour. Thanks!

Implement CIMaX driver as a standalone SPI (I am not sure if it is SPI 
or I2C) driver, which implements CI (struct dvb_ca_en50221 callbacks). 
Then load it properly, like si2168/si2157 drivers. It could be hard to 
convert cx23885 without a hardware, but don't worry it - you could left 
it as it is.

regards
Antti

-- 
http://palosaari.fi/
