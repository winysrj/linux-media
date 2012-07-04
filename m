Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:59271 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753564Ab2GDOdf (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 4 Jul 2012 10:33:35 -0400
Message-ID: <4FF45438.4030809@iki.fi>
Date: Wed, 04 Jul 2012 17:33:28 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Fisher Grubb <fisher.grubb@gmail.com>
CC: linux-media@vger.kernel.org
Subject: Re: ATI theatre 750 HD tuner USB stick
References: <CAD4Xxq_s4zbRKBrjcQAfn4v5Dp0sytU=8_=XUViice98aQFysQ@mail.gmail.com> <CAD4Xxq9LXGXQKRiNsU_tE8LcyJY64Wk5H4OFzEyhhXtsJJy3dw@mail.gmail.com> <CAD4Xxq8c_SBbJsZc764oFwNjRDeGKuVEX_042ry=xeZBY_ZH-A@mail.gmail.com> <CAD4Xxq8CpCMtNP=sPSMhsWs4K1qULXWBtGzbu1ENqs1pgBBs3Q@mail.gmail.com>
In-Reply-To: <CAD4Xxq8CpCMtNP=sPSMhsWs4K1qULXWBtGzbu1ENqs1pgBBs3Q@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/04/2012 04:27 PM, Fisher Grubb wrote:
> Of course I wouldn't be surprised if people will have to reverse
> engineer it from the windows drivers but I thought I would mention it.
>   I could not find any info on this 750 HD on www.linuxtv.org regarding
> where it stands.  What help is needed for it?

>> Chips:
>> ATI:
>> T507
>> 0930
>> MADE IN TAIWAN
>> P0U493.00
>> 215-0692014

T507 driver is the missing piece. I suspect that SoC integrates many 
chips, USB-bridge (with IR etc.), DVB-T demodulator and analog decoder. 
Getting it work as DVB-T device is not mission impossible even without a 
specs. Reverse-engineering is fun ;-)

Generally speaking DVB-bridge is very simple, no problems at all to 
reverse. DVB demodulator is little bit harder but still possible without 
loosing even sensitivity. What you lose is configuration options like 
how IF frequency, SNR, BER is calculated. Tuners are most tricky as 
there is all kind of calibration routines etc. but in that case tuner 
driver exists.

>> NXP:
>> TDA18271HDC2
>> P3KN4 02
>> PG09361

That TDA18271 driver already exists - even two different drivers.

regards
Antti

-- 
http://palosaari.fi/


