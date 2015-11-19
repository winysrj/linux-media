Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f52.google.com ([74.125.82.52]:38675 "EHLO
	mail-wm0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932115AbbKSJ3J (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Nov 2015 04:29:09 -0500
Received: by wmec201 with SMTP id c201so108987136wme.1
        for <linux-media@vger.kernel.org>; Thu, 19 Nov 2015 01:29:08 -0800 (PST)
Subject: Re: [BUG] TechniSat SkyStar S2 - problem tuning DVB-S2 channels
To: Robert <wslegend@web.de>, linux-media@vger.kernel.org,
	Patrick Boettcher <patrick.boettcher@posteo.de>
References: <564C9355.1090203@web.de> <564CA4EB.60400@gmail.com>
 <564CCCA1.6010808@web.de>
From: Jemma Denson <jdenson@gmail.com>
Message-ID: <564D9662.9030905@gmail.com>
Date: Thu, 19 Nov 2015 09:29:06 +0000
MIME-Version: 1.0
In-Reply-To: <564CCCA1.6010808@web.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Robert,

On 18/11/15 19:08, Robert wrote:
> Normally i'm using kaffeine, but i have tried dvbv5-scan now.
> Unfortunately it segfaults. I have attached the full output including
> the backtrace [1]
>

I can't help with the segfault I'm afraid, but looking at that log it is 
definitely not managing to lock to any of the DVB-S2 transponders. The 
driver does work fine on S2 for me, but I am only able to test on 28.2E. 
Patrick did some testing on 19.2E so I'm going to cc him into this to 
confirm it does work there on S2.

In the meantime it might be worth checking that it is being tuned with 
the right parameters - I included some dynamic debug output to see what 
it was being asked to do when tuning:

echo 'file cx24120.c func cx24120_set_frontend +pf' > 
/sys/kernel/debug/dynamic_debug/control

This should output something like this in dmesg:

[2995692.044792] cx24120_set_frontend: i2c i2c-9: DVB-S2
[2995692.044799] cx24120_set_frontend: i2c i2c-9: delsys      = 6
[2995692.044802] cx24120_set_frontend: i2c i2c-9: modulation  = 9
[2995692.044805] cx24120_set_frontend: i2c i2c-9: frequency   = 1097000
[2995692.044808] cx24120_set_frontend: i2c i2c-9: pilot       = 0 (val = 
0x40)
[2995692.044811] cx24120_set_frontend: i2c i2c-9: symbol_rate = 23000000 
(clkdiv/ratediv = 0x03/0x06)
[2995692.044814] cx24120_set_frontend: i2c i2c-9: FEC         = 2 
(mask/val = 0x00/0x0d)
[2995692.044817] cx24120_set_frontend: i2c i2c-9: Inversion   = 2 (val = 
0x0c)

Hopefully from there it should be possible to see if it's being sent the 
correct parameters.

Regards,

Jemma.
