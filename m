Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:51465 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751055AbaHIUlX (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 9 Aug 2014 16:41:23 -0400
Message-ID: <53E6876B.1040008@iki.fi>
Date: Sat, 09 Aug 2014 23:41:15 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Bimow Chen <Bimow.Chen@ite.com.tw>, linux-media@vger.kernel.org
Subject: Re: [PATCH 2/4] V4L/DVB: Update tuner script for new firmware
References: <1407217543.2988.5.camel@ite-desktop>
In-Reply-To: <1407217543.2988.5.camel@ite-desktop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I applied that too, but removed those register writes you added to 
af9033 driver. Patch commit message was totally missing and I did a 
*lot* of reverse-engineering in order to understand patch (actually all 
these patches).

What I discovered, not sure if correct, but that patch updates IT9135 BX 
chipset tuner related inittabs. Tuner config 60 and 61 was updated. I 
take latest IT9135 windows driver binary from Hauppauge and extracted 
inittab for tuner 60. It was just same as here. So I suspect these tabs 
are just same than latest windows. Firmware is likely same too, but I 
was too lazy to dump it out from windows driver and compare...

Also, what I suspect, the 0xfba8 register write I removed from that 
patch, is some clock output provided by demod core. That is clock source 
for tuner, right?

regards
Antti

-- 
http://palosaari.fi/
