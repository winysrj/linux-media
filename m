Return-path: <linux-media-owner@vger.kernel.org>
Received: from gateway04.websitewelcome.com ([67.18.16.76]:37490 "HELO
	gateway04.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754992Ab0GPRV2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 16 Jul 2010 13:21:28 -0400
Subject: Re: Chicony Electronics 04f2:b1b4 webcam device unsupported (yet)
From: Pete Eberlein <pete@sensoray.com>
To: Michael Kromer <Michael.Kromer@millenux.com>
Cc: linux-media@vger.kernel.org
In-Reply-To: <OF56E589E0.BB18B6B2-ONC1257762.005AE925-C1257762.005AE95B@topalis.com>
References: <OF56E589E0.BB18B6B2-ONC1257762.005AE925-C1257762.005AE95B@topalis.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 16 Jul 2010 10:14:49 -0700
Message-ID: <1279300489.1989.4.camel@pete-desktop>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 2010-07-16 at 18:32 +0200, Michael Kromer wrote:
> Hi,
> 
> I have bought myself a rather new Lenovo Thinkpad X100e, and there is no
> support for the webcam device in the current (2.6.34) kernel (yet).
> 2.6.35 doesn't seem to have a driver for it either. Is there any
> possibility for one of you guys to take a look at it?

The descriptors look like a standard USB Video Class device.  Do you
have the uvcvideo module loaded?  Then have a look at your dmesg output
to see why it isn't working.



