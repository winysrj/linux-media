Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:48325 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932174AbZHUIYY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 21 Aug 2009 04:24:24 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: "Rath" <mailings@hardware-datenbank.de>
Subject: Re: Philips webcam support
Date: Fri, 21 Aug 2009 10:27:14 +0200
Cc: linux-media@vger.kernel.org
References: <FC97AC6037164F67B001AA702AC80B11@pcvirus>
In-Reply-To: <FC97AC6037164F67B001AA702AC80B11@pcvirus>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200908211027.14081.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On Thursday 20 August 2009 16:48:16 Rath wrote:
>
> are the Philips SPC1330NC and SPC2050NC supported by v4l?

The SPC1330NC is supported by the uvcvideo driver. I haven't heard about the 
SPC2050NC yet. My guess is that it would be a UVC device as well. Could you 
please post the output of

lsusb -v

for your camera (using usbutils 0.72 or newer, 0.73+ preferred) ? Thanks.

> Can I get higher framerates than 30fps (The webcam supports framerates up
> to 90fps)?

Not with the SPC1330NC. 90fps is just a marketing claim achieved by software 
interpolation. The camera itself supports frame rates up to 30fps.

> I want to use one of them with a Beagleboard when they are supported.

-- 
Regards,

Laurent Pinchart
