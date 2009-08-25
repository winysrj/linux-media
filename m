Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:57794 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753923AbZHYBFh (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 24 Aug 2009 21:05:37 -0400
Message-ID: <4A9338E2.2070701@iki.fi>
Date: Tue, 25 Aug 2009 04:05:38 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: linux-dvb@linuxtv.org, Benjamin Larsson <banan@ludd.ltu.se>
Subject: Re: [linux-dvb] Anysee E30 Combo Plus startup mode
References: <7606f7c10908210621r77acf304g1c921396a566399a@mail.gmail.com>
In-Reply-To: <7606f7c10908210621r77acf304g1c921396a566399a@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/21/2009 04:21 PM, Alexander Saers wrote:
> Hello
>
> I have a Anysee E30 Combo Plus USB device. It's capable of both DVB-C and
> DVB-T. I currently use the device with ubuntu 9.04 64bit with mythtv. I have
> problem with selction of mode for the device
>
> The following way i can get DVB-T
> 1. Power up computer with E30 Combo Plus connected.
> 2. run dmesg

>
> Anyone experienced this problem? It would be nice to run DVB-C without
> having to disconnect and connect hardware.

You are not alone.
Looks like it is GPIO related problem. I don't have currently that device...
It is a little bit hard to fix without knowing exactly how GPIO pins are 
connected in each device. There is too many different hardware revisions 
with different GPIOs, fix one break the other.

 From the anysee.c code you can find following entry:

	/* Try to attach demodulator in following order:
	      model      demod     hw  firmware
	   1. E30        MT352     02  0.2.1
	   2. E30        ZL10353   02  0.2.1
	   3. E30 Combo  ZL10353   0f  0.1.2    DVB-T/C combo
	   4. E30 Plus   ZL10353   06  0.1.0
	   5. E30C Plus  TDA10023  0a  0.1.0    rev 0.2
	      E30C Plus  TDA10023  0f  0.1.2    rev 0.4
	      E30 Combo  TDA10023  0f  0.1.2    DVB-T/C combo
	*/

Antti
-- 
http://palosaari.fi/
