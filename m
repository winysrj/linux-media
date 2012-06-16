Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f42.google.com ([74.125.82.42]:59855 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758482Ab2FPAfV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Jun 2012 20:35:21 -0400
Received: by wgbds11 with SMTP id ds11so28264wgb.1
        for <linux-media@vger.kernel.org>; Fri, 15 Jun 2012 17:35:19 -0700 (PDT)
Message-ID: <1339806912.13364.35.camel@Route3278>
Subject: Re: dvb_usb_v2: use pointers to properties[REGRESSION]
From: Malcolm Priestley <tvboxspy@gmail.com>
To: Antti Palosaari <crope@iki.fi>
Cc: linux-media <linux-media@vger.kernel.org>
Date: Sat, 16 Jun 2012 01:35:12 +0100
In-Reply-To: <4FDBBD36.9020302@iki.fi>
References: <1339798273.12274.21.camel@Route3278> <4FDBBD36.9020302@iki.fi>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 2012-06-16 at 01:54 +0300, Antti Palosaari wrote:
> Hello Malcolm,
> 
> On 06/16/2012 01:11 AM, Malcolm Priestley wrote:
> > Hi Antti
> >
> > You can't have dvb_usb_device_properties as constant structure pointer.
> >
> > At run time it needs to be copied to a private area.
> 
> Having constant structure for properties was one of main idea of whole 
> change. Earlier it causes some problems when driver changes those values 
> - for example remote configuration based info from the eeprom.
> 
> > Two or more devices of the same type on the system will be pointing to
> > the same structure.
> 
> Yes and no. You can define struct dvb_usb_device_properties for each USB ID.
> 
> > Any changes they make to the structure will be common to all.
> 
> For those devices having same USB ID only.
> Changing dvb_usb_device_properties is *not* allowed. It is constant and 
> should be. That was how I designed it. Due to that I introduced those 
> new callbacks to resolve needed values dynamically.
Yes, but it does make run-time tweaks difficult.

> If there is still something that is needed to resolve at runtime I am 
> happy to add new callback. For example PID filter configuration is 
> static currently as per adapter and if it is needed to to reconfigure at 
> runtime new callback is needed.
I will look at the PID filter later, it defaulted to off.

However, in my builds for ARM devices it is defaulted on. I will be
testing this later. I can't see any problems.

> 
> Could you say what is your problem I can likely say how to resolve it.
> 

Well, the problem is, I now need two separate structures for LME2510 and
LME2510C as in the existing driver, the hope was to merge them as one.
The only difference being the stream endpoint number.

Currently, it is implemented in identify_state on dvb_usb_v2.

The get_usb_stream_config has no access to device to to allow a run-time
change there.

Regards


Malcolm

