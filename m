Return-path: <linux-media-owner@vger.kernel.org>
Received: from canardo.mork.no ([148.122.252.1]:49459 "EHLO canardo.mork.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933488Ab1IBLQA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 2 Sep 2011 07:16:00 -0400
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To: Antti Palosaari <crope@iki.fi>
Cc: =?utf-8?Q?Istv=C3=A1n_V=C3=A1radi?= <ivaradi@gmail.com>,
	linux-media@vger.kernel.org
Subject: Re: Smart card reader support for Anysee DVB devices
References: <CAFk-VPxQvGiEUdd+X4jjUqcygPO-JsT0gTFvrX-q4cGAW6tq_Q@mail.gmail.com>
	<4E485F81.9020700@iki.fi> <4E48FF99.7030006@iki.fi>
	<4E4C2784.2020003@iki.fi>
	<CAFk-VPzKa4bNLCMMCagFi1LLK6PnY245YJqP5yisQH77nJ0Org@mail.gmail.com>
	<4E5BA751.6090709@iki.fi>
	<CAFk-VPypTuaKgAHPxyvKg7GHYM358rZ2kypabfvxG-x7GjmFpw@mail.gmail.com>
	<4E5BAF03.503@iki.fi>
Date: Fri, 02 Sep 2011 13:04:22 +0200
In-Reply-To: <4E5BAF03.503@iki.fi> (Antti Palosaari's message of "Mon, 29 Aug
	2011 18:23:47 +0300")
Message-ID: <87wrdri4sp.fsf@nemi.mork.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Antti Palosaari <crope@iki.fi> writes:

> Since Anysee device itself does not have CCID interface it is needed
> to make virtual USB device in order to get CCID support. I have never
> seen virtual USB devices like that, but there is VHCI in current
> kernel staging that actually does something like that over IP.

Don't know if you have seen this already, but there's a virtual CCID
device implementation in QEMU.  See http://wiki.qemu.org/Features/Smartcard
Should be a good starting point.  Combine it withe the VHCI driver from
USBIP and you have your CCID device.


Bjørn
