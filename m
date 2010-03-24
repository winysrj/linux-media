Return-path: <linux-media-owner@vger.kernel.org>
Received: from 93-125-200-5.dsl.alice.nl ([93.125.200.5]:55118 "EHLO
	william-laptop" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754035Ab0CXFwo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Mar 2010 01:52:44 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by william-laptop (Postfix) with ESMTPS id 80A601800DD
	for <linux-media@vger.kernel.org>; Wed, 24 Mar 2010 06:46:06 +0100 (CET)
Message-ID: <4BA9A71E.6090309@cobradevil.org>
Date: Wed, 24 Mar 2010 06:46:06 +0100
From: william <kc@cobradevil.org>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: tevii s660 system slow/freeze
References: <54510.83.83.244.249.1269102017.squirrel@webmail.spothost.nl>
In-Reply-To: <54510.83.83.244.249.1269102017.squirrel@webmail.spothost.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Update

it was a problem with the device itself.

I have send it back to my supplier for rma.

With kind regards

William
On 03/20/2010 05:20 PM, kc@cobradevil.org wrote:
> Dear mailinglist/Tevii,
>
> i have received a new tevii s660 yesterday.
> I have tried to use the device with scan but then my system freezes/slows
> down and i don't get any channels. Also when i create a channel list with
> my nova 2 hd and check if that works with vdr, then i removed the drivers
> from the nova card and plugged in the s660 and started vdr. But then still
> no picture only system freeze/slow down. I get nothing in the logs so it
> seems a driver issue.
>
> i have tried the drivers from the tevii site and also tried the 2.6.34rc1
> kernel from ubuntu. I also tried it on 3 different systems but to no
> avail.
>
> in dmesg i get:
> [16735.496800] usbcore: deregistering interface driver dw2102
> [16735.562114] dvb-usb: TeVii S660 USB successfully deinitialized and
> disconnected.
> [16737.219577] dvb-usb: found a 'TeVii S660 USB' in cold state, will try
> to load a firmware
> [16737.219593] usb 1-1: firmware: requesting dvb-usb-teviis660.fw
> [16737.229441] dvb-usb: downloading firmware from file 'dvb-usb-teviis660.fw'
> [16737.229453] dw2102: start downloading DW210X firmware
> [16737.350052] dvb-usb: found a 'TeVii S660 USB' in warm state.
> [16737.350171] dvb-usb: will pass the complete MPEG2 transport stream to
> the software demuxer.
> [16737.350414] DVB: registering new adapter (TeVii S660 USB)
> [16747.590032] dvb-usb: MAC address: 00:18:bd:5c:55:bb
> [16747.650033] Only Zarlink VP310/MT312/ZL10313 are supported chips.
> [16748.074008] DS3000 chip version: 0.192 attached.
> [16748.074015] dw2102: Attached ds3000+ds2020!
> [16748.074017]
> [16748.074189] DVB: registering adapter 0 frontend 0 (Montage Technology
> DS3000/TS2020)...
> [16748.076014] input: IR-receiver inside an USB DVB receiver as
> /devices/pci0000:00/0000:00:1d.7/usb1/1-1/input/input11
> [16748.076312] dvb-usb: schedule remote query interval to 150 msecs.
> [16748.076327] dvb-usb: TeVii S660 USB successfully initialized and
> connected.
> [16748.076596] usbcore: registered new interface driver dw2102
>
>
> and after that i only see:
> [16748.224312] dw2102: query RC enter
> [16748.224320] dw2102: query RC start
> [16748.246317] dw2102: query RC end
> [16748.396311] dw2102: query RC enter
> [16748.396320] dw2102: query RC start
> [16748.415313] dw2102: query RC end
> [16748.561641] dw2102: query RC enter
> [16748.561650] dw2102: query RC start
> [16748.585317] dw2102: query RC end
>
>
> over and over just filling the logs. i saw that it was from/for the remote
> but it looks like debug messages.
>
> I have tried 3 different kernels 2.6.32/3/4rc1 but they all have the same
> issue with the driver from 15 march.
>
> What can be wrong?
> Any suggestions how i can troubleshoot this?
>
> With kind regards
> William van de Velde
>
>
> new tevii S660 system slow/freeze no channels linux
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>    

