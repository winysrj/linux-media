Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f219.google.com ([209.85.219.219]:55297 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753655Ab0AQKSQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 17 Jan 2010 05:18:16 -0500
Received: by ewy19 with SMTP id 19so2317574ewy.21
        for <linux-media@vger.kernel.org>; Sun, 17 Jan 2010 02:18:14 -0800 (PST)
From: Patrick Boettcher <pboettcher@kernellabs.com>
To: Harald Albrecht <harald.albrecht@gmx.net>
Subject: Re: PCTV (ex Pinnacle) 74e pico USB stick DVB-T: no frontend registered
Date: Sun, 17 Jan 2010 11:18:08 +0100
Cc: linux-media@vger.kernel.org
References: <4B52D0DF.9030106@gmx.net>
In-Reply-To: <4B52D0DF.9030106@gmx.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201001171118.08149.pboettcher@kernellabs.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Harald,

On Sunday 17 January 2010 09:57:03 Harald Albrecht wrote:
> Hello,
> 
> I've run into a roadblock problem with my PCTV 74e pico USB stick for
> receiving DVB-T. My setup is as follows: the system is a Kubuntu Kaotic
> Koala 9.10 stock distribution, kept current. The Linux kernel is thus a
> 2.6.31-18-generic one as distributed by Ubuntu. It contains the stock
> kernel video4linux and I also installed the non-free firmware package in
> order to have the dvb-usb-dib0700-1.20.fw firmware at hand.
> 
> With this setup, the pico was not even properly recognized (USB VID:DID
> = 2013:0246). Yesterday I pulled the most recent set of v4l-dvb files of
> the mercury repository using "hg clone http://linuxtv.org/hg/v4l-dvb".
> For reasons I yet don't understand, this file set does not include the
> complete patch from
> http://linuxtv.org/hg/v4l-dvb/rev/87039167057078a29ca91c1bcd3369977d6ca463

This one was followed by 

http://linuxtv.org/hg/v4l-dvb/rev/c0af9bb51052

which removed the association of the 74e to the dib0700-driver.

> It seems that the frontend registration did (silently) fail, at least
> from the perspective of dib0700_devices.c. Has anyone information
> whether the 74e shares the same frontend with the 73e?

The 74e is not a dib0700-based device, my assumption at that time was wrong.

For the 74e afaik, there is no LinuxTV driver right now. (IIRC it is a Abilis 
based design)

best regards,
-- 
Patrick Boettcher - KernelLabs
http://www.kernellabs.com/
