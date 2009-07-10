Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:50675 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752302AbZGJVIN (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Jul 2009 17:08:13 -0400
Message-ID: <4A57ADB3.9090805@iki.fi>
Date: Sat, 11 Jul 2009 00:08:03 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Nick Burch <v4l@gagravarr.org>
CC: linux-media@vger.kernel.org
Subject: Re: KWorld USB DVB-T TV Stick II 395U almost but not quite working
References: <Pine.LNX.4.64.0907101934320.22332@urchin.earth.li>
In-Reply-To: <Pine.LNX.4.64.0907101934320.22332@urchin.earth.li>
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/10/2009 09:52 PM, Nick Burch wrote:

> usb 2-4: new high speed USB device using ehci_hcd and address 4
> usb 2-4: configuration #1 chosen from 1 choice
> dvb-usb: found a 'KWorld USB DVB-T TV Stick II (VS-DVB-T 395U)' in cold
> state, will try to load a firmware
> usb 2-4: firmware: requesting dvb-usb-af9015.fw
> dvb-usb: downloading firmware from file 'dvb-usb-af9015.fw'
> dvb-usb: found a 'KWorld USB DVB-T TV Stick II (VS-DVB-T 395U)' in warm
> state.
> dvb-usb: will pass the complete MPEG2 transport stream to the software
> demuxer.
> DVB: registering new adapter (KWorld USB DVB-T TV Stick II (VS-DVB-T 395U))
> af9013: firmware version:4.95.0
> DVB: registering adapter 0 frontend 0 (Afatech AF9013 DVB-T)...

No tuner.

> After this, /dev/dvb/adapter0/ exists, and contains the entries
> demux0 dvr0 frontend0 net0

> Checking dmesg after a failed scan run, I see these two entries:
> af9015: command failed:2
> qt1010 I2C read failed
>
>
> Am I right in thinking from this that it's the qt1010 tuner that's the
> problem? If so, can anyone suggest what I should do next to debug the
> issue further?

Tuner does not attach - I2C messages towards tuner are failing. That's 
most probably due to wrong GPIOs, tuner is usually powered by GPIO pin. 
It can also be wrong I2C address of tuner. You should take sniffs and 
look correct GPIO and I2C from there.

regards
Antti
-- 
http://palosaari.fi/
