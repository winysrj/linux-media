Return-path: <mchehab@pedra>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:49613 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752774Ab1CUKWE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Mar 2011 06:22:04 -0400
Received: by vws1 with SMTP id 1so5047153vws.19
        for <linux-media@vger.kernel.org>; Mon, 21 Mar 2011 03:22:02 -0700 (PDT)
Message-ID: <4D8726C5.2090403@gmail.com>
Date: Mon, 21 Mar 2011 07:21:57 -0300
From: Mauro Carvalho Chehab <maurochehab@gmail.com>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>
CC: goffa72@gmail.com, linux-media@vger.kernel.org
Subject: Re: Leadtek Winfast 1800H FM Tuner
References: <4D8550A3.5010604@aapt.net.au> <4D85B871.3010201@iki.fi>
In-Reply-To: <4D85B871.3010201@iki.fi>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 20-03-2011 05:18, Antti Palosaari escreveu:
> On 03/20/2011 02:56 AM, Andrew Goff wrote:
>> Hi, I hope someone may be able to help me solve a problem or point me in
>> the right direction.
>>
>> I have been using a Leadtek Winfast DTV1800H card (﻿Xceive xc3028 tuner)
>> for a while now without any issues (DTV & Radio have been working well),
>> I recently decided to get another tuner card, Leadtek Winfast DTV2000DS
>> (Tuner: NXP TDA18211, but detected as TDA18271 by V4L drivers, Chipset:
>> AF9015 + AF9013 ) and had to compile and install the V4L drivers to get
>> it working. Now DTV on both cards work well but there is a problem with
>> the radio tuner on the 1800H card.
>>
>> After installing the more recent V4L drivers the radio frequency is
>> 2.7MHz out, so if I want to listen to 104.9 I need to tune the radio to
>> 107.6. Now I could just change all my preset stations but I can not
>> listen to my preferred stations as I need to set the frequency above
>> 108MHz.
> 
> I think there is something wrong with the FM tuner (xc3028?) or other chipset drivers used for DTV1800H. No relations to the af9015, af9013 or tda18271. tda18211 is same chip as tda18271 but only DVB-T included. If DTV1800H does not contain tda18211 or tda18271 problem cannot be either that.

Yes, the problem is likely at xc3028. It has to do frequency shift for some
DVB standards, and the shift is dependent on what firmware is loaded.

So, you need to enable load tuner-xc2028 with debug=1, and provide us the
dmesg.

Mauro.
