Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40217 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754641Ab2HGTMr (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 7 Aug 2012 15:12:47 -0400
Message-ID: <502168A2.6020503@redhat.com>
Date: Tue, 07 Aug 2012 16:12:34 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>
CC: Malcolm Priestley <tvboxspy@gmail.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] lmedm04 2.06 conversion to dvb-usb-v2 version 2
References: <1344284500.12234.12.camel@router7789> <5021422F.6080601@iki.fi>
In-Reply-To: <5021422F.6080601@iki.fi>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 07-08-2012 13:28, Antti Palosaari escreveu:
> On 08/06/2012 11:21 PM, Malcolm Priestley wrote:
>> Conversion of lmedm04 to dvb-usb-v2
>>
>> Functional changes m88rs2000 tuner now uses all callbacks.
>> TODO migrate other tuners to the callbacks.
>>
>> This patch is applied on top of [BUG] Re: dvb_usb_lmedm04 crash Kernel (rs2000)
>> http://patchwork.linuxtv.org/patch/13584/
>>
>>
>> Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
> 
> Could you try to make this driver more generic?
> 
> You use some internals of dvb-usb directly and most likely those are without a reason.
> For example data streaming, lme2510_kill_urb() kills directly urbs allocated
> and submitted by dvb-usb. Guess that driver is broken just after someone changes
>  dvb-usb streaming code.

Yeah, it is better to replace it by the dvb-usb-v2 solution (usb_clear_halt),
as some special treatment there might be needed due to suspend/resume.

> lme2510_usb_talk() could be replaced by generic dvb_usbv2_generic_rw().
> 
> What is function of lme2510_int_read() ? I see you use own low level URB routines for here too. 
> It starts "polling", reads remote, tuner, demod, etc, and updates state. You would better to 
> implement I2C-adapter correctly and then start Kernel work-queue, which reads same information 
> using I2C-adapter. Or you could even abuse remote controller polling function provided by dvb-usb.

While I don't know any technical details about this device, this looks
similar to what dib0700_core does.

Instead of polling IR, with is expensive, it sets an special endpoint
to receive IR data, and sends an URB request. That URB request will
be pending until someone kicks the IR. If nothing is pressed, no URB
is received. This is a way better than polling, as no traffic
happens while a key is not pressed.

>From what I saw at the driver, the mpeg stream is at endpoint 0x08, and
it uses bulk transfer; for IR data, it uses endpoint 0x0a, and interrupt
URB.

So, this extra control is needed. It may make sense to move part of this
code to the dvb-usb-v2 core (the part that starts/stops the URB handling),
in order to properly handle device suspend/resume, as, depending on the
suspend level, you might need to stop it, restarting at resume.

The payload handling should be driver-specific, of course.

So, in summary, that seems to be OK, for the current dvb-usb-v2 core,
requiring further changes for suspend/resume to work properly.

> 
> lme2510_get_stream_config() enables pid-filter again over the dvb-usb, but I can live with it because there is no dynamic configuration for that. Anyhow, is that really needed?
> 
> I can live with the pid-filter "abuse", but killing stream URBs on behalf of DVB-USB is something I don't like to see. If you have very good explanation and I cannot fix DVB USB to meet it I could consider that kind of hack. And it should be documented clearly adding necessary comments to code.
> 
> Re-implementing that driver to use 100% DVB-USB services will reduce around 50% of code or more.

The thing that bother me at the code is the implementation of a device-specific
set_voltage() callback. This should be part of dvb-usb-v2 core, and, during
suspend, it makes sense to set voltage to OFF, returning it to its original
state during resume.

Regards,
Mauro
