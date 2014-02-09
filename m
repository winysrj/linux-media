Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f171.google.com ([74.125.82.171]:45130 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751379AbaBIJAI (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 9 Feb 2014 04:00:08 -0500
Received: by mail-we0-f171.google.com with SMTP id u56so3440939wes.16
        for <linux-media@vger.kernel.org>; Sun, 09 Feb 2014 01:00:06 -0800 (PST)
Message-ID: <1391936396.2893.18.camel@canaries32-MCP7A>
Subject: Re: [PATCH] af9035: Move it913x single devices to af9035
From: Malcolm Priestley <tvboxspy@gmail.com>
To: linux-media@vger.kernel.org, Antti Palosaari <crope@iki.fi>
Cc: kapetr@mizera.cz
Date: Sun, 09 Feb 2014 08:59:56 +0000
In-Reply-To: <1391875876.2944.3.camel@canaries32-MCP7A>
References: <1391875876.2944.3.camel@canaries32-MCP7A>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 2014-02-08 at 16:11 +0000, Malcolm Priestley wrote:
> The generic v1 and v2 devices have been all tested.
> 
> IDs tested
> USB_PID_ITETECH_IT9135 v1 & v2
> USB_PID_ITETECH_IT9135_9005 v1
> USB_PID_ITETECH_IT9135_9006 v2
> 
> Current Issues
> There is no signal  on
> USB_PID_ITETECH_IT9135 v2 
> 
> No SNR reported all devices.
> 
> All single devices tune and scan fine.
> 
> All remotes tested okay.
> 
> Dual device failed to register second adapter
> USB_PID_KWORLD_UB499_2T_T09
> It is not clear what the problem is at the moment.
Hi Antti

I have found the problem here.

state->eeprom_addr + EEPROM_2ND_DEMOD_ADDR

contains no value

So on 9135 devices register 0x4bfb and the I2C address
(state->af9033_config[1].i2c_addr) need to be set to 0x3a.

I have only manually changed these and both adapters work fine.

Also, I can't find pick up for register 0xcfff although it appears
to be on by default.

I will try and do a patch later and the patch for remaining ids in
it913x.

Regards


Malcolm

