Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:36743 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752017Ab1IBNdC (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 2 Sep 2011 09:33:02 -0400
Message-ID: <4E60DB09.1060304@iki.fi>
Date: Fri, 02 Sep 2011 16:32:57 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: =?UTF-8?B?QmrDuHJuIE1vcms=?= <bjorn@mork.no>
CC: =?UTF-8?B?SXN0dsOhbiBWw6FyYWRp?= <ivaradi@gmail.com>,
	linux-media@vger.kernel.org
Subject: Re: Smart card reader support for Anysee DVB devices
References: <CAFk-VPxQvGiEUdd+X4jjUqcygPO-JsT0gTFvrX-q4cGAW6tq_Q@mail.gmail.com>	<4E485F81.9020700@iki.fi> <4E48FF99.7030006@iki.fi>	<4E4C2784.2020003@iki.fi>	<CAFk-VPzKa4bNLCMMCagFi1LLK6PnY245YJqP5yisQH77nJ0Org@mail.gmail.com>	<4E5BA751.6090709@iki.fi>	<CAFk-VPypTuaKgAHPxyvKg7GHYM358rZ2kypabfvxG-x7GjmFpw@mail.gmail.com>	<4E5BAF03.503@iki.fi> <87wrdri4sp.fsf@nemi.mork.no>
In-Reply-To: <87wrdri4sp.fsf@nemi.mork.no>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/02/2011 02:04 PM, Bjørn Mork wrote:
> Antti Palosaari<crope@iki.fi>  writes:
>
>> Since Anysee device itself does not have CCID interface it is needed
>> to make virtual USB device in order to get CCID support. I have never
>> seen virtual USB devices like that, but there is VHCI in current
>> kernel staging that actually does something like that over IP.
>
> Don't know if you have seen this already, but there's a virtual CCID
> device implementation in QEMU.  See http://wiki.qemu.org/Features/Smartcard
> Should be a good starting point.  Combine it withe the VHCI driver from
> USBIP and you have your CCID device.

It is first time I hear about QEMU virtual CCID. Now we have all parts 
needed for USBIP VHCI and QEMU virtual CCID, just glue those together.

I wonder if it is wise to even create virtual CCID "core" to Kernel. 
There is few other readers that can use that too, actually I think all 
USB readers that have unique USB ID (blocking out those which uses 
USB-serial converters with common IDs).

As I see that CCID still more complex as serial device I will still look 
implementing it as serial as now.

regards
Antti


-- 
http://palosaari.fi/
