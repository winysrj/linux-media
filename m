Return-path: <mchehab@pedra>
Received: from mail-gw0-f46.google.com ([74.125.83.46]:57005 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753087Ab1CUKzq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Mar 2011 06:55:46 -0400
Received: by gwaa18 with SMTP id a18so2338526gwa.19
        for <linux-media@vger.kernel.org>; Mon, 21 Mar 2011 03:55:46 -0700 (PDT)
Message-ID: <4D872EA6.8070502@aapt.net.au>
Date: Mon, 21 Mar 2011 21:55:34 +1100
From: Andrew Goff <goffa72@gmail.com>
Reply-To: goffa72@gmail.com
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>
CC: linux-media@vger.kernel.org
Subject: Re: Leadtek Winfast 1800H FM Tuner
References: <4D8550A3.5010604@aapt.net.au> <4D85B871.3010201@iki.fi>
In-Reply-To: <4D85B871.3010201@iki.fi>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Sun 20-Mar-2011 7:18 PM, Antti Palosaari wrote:
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
> I think there is something wrong with the FM tuner (xc3028?) or other 
> chipset drivers used for DTV1800H. No relations to the af9015, af9013 
> or tda18271. tda18211 is same chip as tda18271 but only DVB-T 
> included. If DTV1800H does not contain tda18211 or tda18271 problem 
> cannot be either that.
>
> Antti
>
>
yes, I suspect it is a problem with the newer drivers for the DTV1800H 
card. I am using mythbuntu 10.04 as my operating systems and the FM 
tuner works fine until the the newer V4L drivers installed.  The FM 
tuner frequency is not correct with the new drivers.
