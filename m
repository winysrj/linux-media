Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx02.posteo.de ([89.146.194.165]:40103 "EHLO mx02.posteo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751684AbaJIP0S (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 9 Oct 2014 11:26:18 -0400
Date: Thu, 9 Oct 2014 17:26:14 +0200
From: Patrick Boettcher <patrick.boettcher@posteo.de>
To: JPT <j-p-t@gmx.net>
Cc: linux-media@vger.kernel.org
Subject: Re: technisat-usb2: i2c-error
Message-ID: <20141009172614.5e16f240@vdr>
In-Reply-To: <5434226B.3010804@gmx.net>
References: <5434226B.3010804@gmx.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jan,

On Tue, 07 Oct 2014 19:27:07 +0200 JPT <j-p-t@gmx.net> wrote:
> 01:14:52 VDR fails to start because there is no recording device.
> 
> I was able to get things running by unloading the modules and loading
> them again. After that I started VDR.
> 
> What exactly do the i2c-errors mean? Find attached a
> "grep i2c-error syslog*"

I can't tell you exactly what happens in the device, but I can tell you
that I have the same problem with my device on my PC sometimes. 

In addition to this I2c-failures from time to time the box is quite
sensitive regarding: repowering, replugging and host-rebooting. This is
a USB-device-firmware problem which makes the device crash and all
subsequent USB-transfers are failed. Reloading the module or replugging
the device will make it work again.

I lost contact with Technisat some time ago and wouldn't be able easily
to get the information (and I doubt they have a solution for this
problem - up to them to prove me wrong).

How many days without interruption did you use the device?

I was following quietly you're discussion with Antti. Has someone taken
care of the your changes regarding the transfer-size?

I think it should included.

regards,
-- 
Patrick.
