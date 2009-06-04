Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bcode.com ([150.101.204.108]:7388 "EHLO mail.bcode.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753965AbZFDABK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 3 Jun 2009 20:01:10 -0400
Date: Thu, 4 Jun 2009 10:01:10 +1000
From: Erik de Castro Lopo <erik@bcode.com>
To: linux-media@vger.kernel.org
Cc: Erik =?UTF-8?B?QW5kcsOpbg==?= <erik.andren@gmail.com>
Subject: Re: Creating a V4L driver for a USB camera
Message-Id: <20090604100110.c837c3df.erik@bcode.com>
In-Reply-To: <62e5edd40906022318l230992b7n34e5178b7e1a7d46@mail.gmail.com>
References: <20090603141350.04cde59b.erik@bcode.com>
	<62e5edd40906022318l230992b7n34e5178b7e1a7d46@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 3 Jun 2009 16:18:33 +1000
Erik Andrén <erik.andren@gmail.com> wrote:

> Do you have any datasheet available on what usb bridge / sensor that is used?

The USB device itself comes up as :

    Bus 001 Device 011: ID 0547:8031 Anchor Chips, Inc

The sensor is a Micron MT9T001P12STC and I have the data sheet for it.

I've asked the manufacturer for source code to the windows driver
and docs/source/whatever for the USB interface.

> If the chipsets are undocumented and some proprietary image
> compression technique is used, the time to reverse-engineer them can
> be quite lengthy.

I happen to know that the sensor/camera (via the windows driver) can
provide raw bayer data which is what I'm after (our application is
machine vision and bayer works best).

Cheers,
Erik
-- 
=======================
erik de castro lopo
senior design engineer

bCODE
level 2, 2a glen street
milsons point
sydney nsw 2061
australia

tel +61 (0)2 9954 4411
fax +61 (0)2 9954 4422
www.bcode.com
