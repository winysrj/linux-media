Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:34144 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755708Ab2ATWap (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Jan 2012 17:30:45 -0500
Message-ID: <4F19EB13.7010502@iki.fi>
Date: Sat, 21 Jan 2012 00:30:43 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Gordon Hecker <ghecker@gmx.de>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH] af9013: fix i2c failures for dual-tuner devices
References: <1327094337-12483-1-git-send-email-ghecker@gmx.de>
In-Reply-To: <1327094337-12483-1-git-send-email-ghecker@gmx.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/20/2012 11:18 PM, Gordon Hecker wrote:
> This patch fixes the following error messages with a
> Terratec Cinergy T Stick Dual RC DVB-T device.
>
> af9013: i2c wr failed=-1 reg=d607 len=1
> af9015: command failed:2
> af9013: i2c rd failed=-1 reg=d607 len=1
> af9015: command failed:1
>
> It implements exclusive access to i2c for only one frontend at a time
> through a use-counter that is increased for each af9013_i2c_gate_ctrl-enable
> or i2c-read/write and decreased accordingly. The use-counter remains
> incremented after af9013_i2c_gate_ctrl-enable until the corresponding
> disable.
>
> Debug output was added.
>
> ToDo:
>   * Replace frontend by adapter (the dual-tuner devices do actually
>     provide two adapters with one frontend each)
>   * move af9013_i2c_gate_mutex, locked_fe, af9013_i2c_gate_ctrl_usecnt
>     to the usb device

Again that same issue. But after af9013 rewrote those should not be very 
significant problem... If you looked, as I can guess, AF9015 code you 
can see callbacks lock that are for resolving same issue. Almost all 
callbacks are locked, but I left few rarely called callbacks without 
lock due to performance point of view. You can guess it causes always 
latency to wait other thread finish callback...

I think you may resolve that just adding one or two callback lock more, 
likely for tuner init() and sleep().

I don't like that you are adding such code for the demod driver - 
problem is USB-bridge, its I2C adapter and firmware. Due to that such 
code should be in AF9015 driver. There has been originally two I2C 
adapters in af9015 but I removed those. And there is actually only one 
I2C adapter in AF9015.
See these for more info about I2C bus connections:
http://palosaari.fi/linux/v4l-dvb/controlling_tuner_af9015_dual_demod.txt
http://palosaari.fi/linux/v4l-dvb/controlling_tuner.txt

I think that piece of code is not very important and I dont like to see 
it in current af9013 driver. Do needed changes for af9015 instead.

regards
Antti

-- 
http://palosaari.fi/
