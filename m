Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:30819 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752576Ab3HKJ0Z (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 11 Aug 2013 05:26:25 -0400
Message-ID: <520758BA.8040501@redhat.com>
Date: Sun, 11 Aug 2013 11:26:18 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Ondrej Zary <linux@rainbow-software.org>
CC: linux-media@vger.kernel.org
Subject: Re: [RFC PATCH] introduce gspca-stk1135: Syntek STK1135 driver
References: <201308110010.56508.linux@rainbow-software.org>
In-Reply-To: <201308110010.56508.linux@rainbow-software.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 08/11/2013 12:10 AM, Ondrej Zary wrote:
> Hello,
> this is a new gspca driver for Syntek STK1135 webcams. The code is completely
> new, but register values are based on Syntekdriver (stk11xx) by Nicolas VIVIEN
> (http://syntekdriver.sourceforge.net).
>
> Only one webcam type is supported now - vendor 0x174f, device 0x6a31.
> It's Asus F5RL laptop flippable webcam with MT9M112.
>
> The camera works better than in Windows - initializes much faster and
> provides more resolutions

You've certainly done this quickly, many thanks for working on this!

Looks good. Any reason why this is RFC, iow any reason why I should not add
this to my tree and include it in my next pullreq to Mauro ?

> Autoflip works too - when the camera is flipped around, the image is flipped
> automatically.

Cool, but I've some comments on the implementation:

1) It seems autoflip and manual flip with controls conflict, the manual
setting will be overwritten as soon as the switch is debounced.
I think it would be best to make the manual setting invert (when on) the
setting detected from the switch

2) You make the switch control both hflip and vflip, but the way the flipping
works the sensor is not turned upside down, but rotated over its x-axis, so
you should only set vflip based on the switch if I'm not mistaken. To verify this
take a piece of paper, and write on it with large letters "HELLO" then hold
it in front of the camera. It should read normally on the screen. I believe that
in one of the 2 orientations of the camera it will be mirrored now since you
set hflip while it should not be set

3) Once debounced is over 100, you re-set hflip and vflip every frame, this causes
expensive USB IO, so please cache the current setting and only change it if it
actually needs to change

If you can do a new version with these 3 things fixed I'll happily pull it into
my tree!

Regards,

Hans
