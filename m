Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:48844 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751673Ab2HGQ2q (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 7 Aug 2012 12:28:46 -0400
Received: by lboi8 with SMTP id i8so210054lbo.19
        for <linux-media@vger.kernel.org>; Tue, 07 Aug 2012 09:28:45 -0700 (PDT)
Message-ID: <5021422F.6080601@iki.fi>
Date: Tue, 07 Aug 2012 19:28:31 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Malcolm Priestley <tvboxspy@gmail.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [PATCH] lmedm04 2.06 conversion to dvb-usb-v2 version 2
References: <1344284500.12234.12.camel@router7789>
In-Reply-To: <1344284500.12234.12.camel@router7789>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/06/2012 11:21 PM, Malcolm Priestley wrote:
> Conversion of lmedm04 to dvb-usb-v2
>
> Functional changes m88rs2000 tuner now uses all callbacks.
> TODO migrate other tuners to the callbacks.
>
> This patch is applied on top of [BUG] Re: dvb_usb_lmedm04 crash Kernel (rs2000)
> http://patchwork.linuxtv.org/patch/13584/
>
>
> Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>

Could you try to make this driver more generic?

You use some internals of dvb-usb directly and most likely those are 
without a reason. For example data streaming, lme2510_kill_urb() kills 
directly urbs allocated and submitted by dvb-usb. Guess that driver is 
broken just after someone changes dvb-usb streaming code.

lme2510_usb_talk() could be replaced by generic dvb_usbv2_generic_rw().

What is function of lme2510_int_read() ? I see you use own low level URB 
routines for here too. It starts "polling", reads remote, tuner, demod, 
etc, and updates state. You would better to implement I2C-adapter 
correctly and then start Kernel work-queue, which reads same information 
using I2C-adapter. Or you could even abuse remote controller polling 
function provided by dvb-usb.

lme2510_get_stream_config() enables pid-filter again over the dvb-usb, 
but I can live with it because there is no dynamic configuration for 
that. Anyhow, is that really needed?

I can live with the pid-filter "abuse", but killing stream URBs on 
behalf of DVB-USB is something I don't like to see. If you have very 
good explanation and I cannot fix DVB USB to meet it I could consider 
that kind of hack. And it should be documented clearly adding necessary 
comments to code.

Re-implementing that driver to use 100% DVB-USB services will reduce 
around 50% of code or more.

regards
Antti


-- 
http://palosaari.fi/
