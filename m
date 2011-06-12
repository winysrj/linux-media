Return-path: <mchehab@pedra>
Received: from mail.kapsi.fi ([217.30.184.167]:53542 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751091Ab1FLLJJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 12 Jun 2011 07:09:09 -0400
Message-ID: <4DF49E2A.9030804@iki.fi>
Date: Sun, 12 Jun 2011 14:08:26 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Rune Evjen <rune.evjen@gmail.com>
CC: linux-media@vger.kernel.org
Subject: Re: PCTV nanoStick T2 290e (Sony CXD2820R DVB-T/T2/C) - DVB-C channel
 scan in mythtv - missing
References: <BANLkTimkYw70GAu1keW-N6ND=AyiRn2+CA@mail.gmail.com>
In-Reply-To: <BANLkTimkYw70GAu1keW-N6ND=AyiRn2+CA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On 06/12/2011 11:23 AM, Rune Evjen wrote:
> I just tested a PCTV 290e device using the latest media_build drivers
> in MythTV as a DVB-C device, and ran into some problems.
>
> The adapter is recognized by the em28xx-dvb driver [1] and dmesg
> output seems to be correct [2]. I can successfully scan for channels
> using the scan utility in dvb-apps but when I try to scan for channels
> in mythtv I get the following errors logged by mythtv-setup:
>
> 2011-06-12 00:57:20.971556  PIDInfo(/dev/dvb/adapter0/
> frontend1): Failed to open demux device /dev/dvb/adapter0/demux1 for
> filter on pid 0x0
>
> The demux1 does not exist, I only have the following nodes under
> /dev/dvb/adapter0:
>
> demux0  dvr0  frontend0  frontend1  net0
>
> When searching the linx-media I came across this thread:
> http://www.mail-archive.com/linux-media@vger.kernel.org/msg31839.html
>
> Is there any way to circumvent with the current driver that there is
> no corresponding demux1 for frontend1?
> Or can the DVB-T/T2 part be disabled somehow so that there is only one
> DVB-C frontend registered which corresponds to the demux0?

There is no way to say driver to create demux1 for frontend1.

After all it is not 100% clear even for me if that's correct or not, but 
most likely it is correct as far as I understood.


regards,
Antti

-- 
http://palosaari.fi/
