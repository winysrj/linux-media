Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:46897 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755483Ab3AWP1J (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Jan 2013 10:27:09 -0500
Message-ID: <5100012A.8030107@iki.fi>
Date: Wed, 23 Jan 2013 17:26:34 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: didli <mediaklan@gmail.com>
CC: linux-media@vger.kernel.org
Subject: Re: [linux-media] Strange behavior between Terratec Cinergy HD RTL2838
 & Alfa AWUS036h RTL2870
References: <CAJscJ6mjUgFt4Tvo9Pa+FqhNs0=N31xFL0yJFDg_2J_sWTBwng@mail.gmail.com>
In-Reply-To: <CAJscJ6mjUgFt4Tvo9Pa+FqhNs0=N31xFL0yJFDg_2J_sWTBwng@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/23/2013 12:16 PM, didli wrote:
> Hi to u all !
> I'm using Xubuntu 12.10, v4l latest media_build, with Alfa Network
> AWUS036H (rtl2870) and a Terratec Cinergy HD (rtl2832).
> These two cards works flawlessly, but not together : I need to
> manually power off the Alfa Network card in order to get TV image with
> the Terratec Cinergy HD.
> If I use kaffeine or me-tv with AWUS036H power on, display is crappy
> and scan with Terratec is almost impossible.
> If I power off the AWUS036h usb card, everything with the Cinergy card
> works as expected.

[...]

> [45981.215807] i2c i2c-2: rtl2832: i2c rd failed=-110 reg=51 len=1
> [45982.539669] i2c i2c-2: rtl2832: i2c rd failed=-110 reg=51 len=1
> [45983.539751] i2c i2c-2: rtl2832: i2c rd failed=-110 reg=51 len=1
> [45985.264752] usb_urb_complete: 269 callbacks suppressed
> [45988.455662] i2c i2c-2: rtl2832: i2c rd failed=-110 reg=51 len=1
> [45989.011363] i2c i2c-2: rtl2832: i2c wr failed=-32 reg=01 len=1
> [45989.013075] i2c i2c-2: e4000: i2c wr failed=-32 reg=1a len=1
> [45989.020746] i2c i2c-2: rtl2832: i2c wr failed=-32 reg=1c len=1

[...]

> Any idea to fix this behavior please ?
> Thanks to u all !

Sounds like USB host controller issue. What is USB controller (AMD SBxxx?)?

Easiest way to work around problem is to put these devices to USB port 
that are under different USB HCI.

regards
Antti

-- 
http://palosaari.fi/
