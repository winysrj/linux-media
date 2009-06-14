Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:37814 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751495AbZFNQNy (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 14 Jun 2009 12:13:54 -0400
Message-ID: <4A3521C2.1050509@iki.fi>
Date: Sun, 14 Jun 2009 19:13:54 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Simon Kenyon <simon@koala.ie>
CC: linux-media@vger.kernel.org
Subject: Re: {wanted] support for PDTV001 dual tuner PCI DVB-T card [EC188/EC100
 and 2x MxL5003S]
References: <4A34D581.7080306@koala.ie>
In-Reply-To: <4A34D581.7080306@koala.ie>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/14/2009 01:48 PM, Simon Kenyon wrote:
> just bought one of these on the off-chance that it might work
> i did not know what chips were on the car when i bought it
> but at €17 for a dual tuner dvb-t pci card i reckoned it was worth a try
> i have looked at the card and it has:
>
> the e3c EC188/EC100 pair of pci chips
> a pair of MaxLinear MxL5003S silicon tuners

EC188 chip contains PCI -bridge and integrated EC100 demodulator. Just 
like EC168 that is USB equivalent interface chip.

> it seems that there is support for the tuners but i only found support
> for the EC168 USB chip set.

Tuners are supported and also demodulator part have some kind of base 
driver in my EC168 devel tree. Someone should write PCI -bridge driver. 
I don't have any PCI -experience and I am not very motivated even 
finalize EC188/EC100 due to lack of specs.

> is there any prospect of support for this card? i don't think i could
> write it myself but i certainly could test it.

In my understanding, no one is working for that currently.

regards
Antti
-- 
http://palosaari.fi/
