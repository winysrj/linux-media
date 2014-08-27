Return-path: <linux-media-owner@vger.kernel.org>
Received: from dd19416.kasserver.com ([85.13.139.185]:51821 "EHLO
	dd19416.kasserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753344AbaH0KYu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Aug 2014 06:24:50 -0400
Message-ID: <53FDB1EE.6010107@herbrechtsmeier.net>
Date: Wed, 27 Aug 2014 12:24:46 +0200
From: Stefan Herbrechtsmeier <stefan@herbrechtsmeier.net>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: Problems with the omap3isp
References: <53C4FC99.9050308@herbrechtsmeier.net> <3376696.nE771YBFja@avalon> <53DF513D.7010501@herbrechtsmeier.net> <5795344.auXD3SfuqM@avalon>
In-Reply-To: <5795344.auXD3SfuqM@avalon>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Am 04.08.2014 um 17:25 schrieb Laurent Pinchart:
> On Monday 04 August 2014 11:24:13 Stefan Herbrechtsmeier wrote:
>> Hi Laurent,
>>
>> thank you very much for your help.
>>
>> The problem is cross talk on the camera flex cable of the Gumstix Overo.
>> The XCLKA signal is beside PCLK and VS.
> Right, I should have mentioned that. It's a know issue, and there's not much
> that can be done about it without a hardware redesign. A ground (or power
> supply) signal should really have been inserted on each side of the XCLKA and
> PCLK signals.
Exists a list about knowing issues with the Gumstix Overo? Because I 
have some problems with the MMC3 too.

>> Additionally the OV5647 camera tristate all outputs by default. This leads
>> to HS_VS_IRQ interrupts.
> This should be taken care of by pull-up or pull-down resistors on the camera
> signals. I've disabled them with the Caspa camera given the low drive strength
> of the buffer on the camera board, but you could enable them on your system.
I have manually rework my camera adapter and change the camera clock 
from XCLKA to XCLKB. Additionally I have enable the pull-ups in my 
device tree. Now the camera sensor from the Raspberry Pi camera module 
works together with the Gumstix Overo.

Thank you for your help,
   Stefan

