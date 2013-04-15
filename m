Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-1.atlantis.sk ([80.94.52.57]:39267 "EHLO mail.atlantis.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933000Ab3DOTCK (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Apr 2013 15:02:10 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [PATCH] bttv: Add CyberVision CV06
Date: Mon, 15 Apr 2013 21:01:38 +0200
Cc: linux-media@vger.kernel.org
References: <201304142326.22042.linux@rainbow-software.org>
In-Reply-To: <201304142326.22042.linux@rainbow-software.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201304152101.39164.linux@rainbow-software.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sunday 14 April 2013 23:26:21 Ondrej Zary wrote:
> Add CyberVision CV06 4-camera card (from CyberVision SV card kit):
> http://www.cybervision.com.tw/products-swcard_kits-sv.html
>
> There are some interesting things on the card but they're not supported:
> 4 LEDs, a connector with 4 IN and 4 OUT pins, RESET IN and RESET OUT
> connectors, a relay and CyberVision CV8088-SV16 chip

As there's no documentation and even no driver for any OS available, I've 
measured the GPIO connections on the card:
GPIO[00..11] - CV8088-SV16 (probably a relabelled MCU)
GPIO[12..15] - VIN1..VIN4 odd/even field (probably for camera disconnect 
detection - detected by a LM1881 chip for each input)
GPIO[16..19] - IN1..IN4 pins on connector
GPIO[20..23] - OUT1..OUT4 pins on connector


-- 
Ondrej Zary
