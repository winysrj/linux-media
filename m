Return-path: <mchehab@pedra>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:37790 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750922Ab1E0Pg0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 May 2011 11:36:26 -0400
Received: by ewy4 with SMTP id 4so670999ewy.19
        for <linux-media@vger.kernel.org>; Fri, 27 May 2011 08:36:25 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201105271631.37469.laurent.pinchart@ideasonboard.com>
References: <1306322212-26879-1-git-send-email-javier.martin@vista-silicon.com>
	<D9AEF5C4-C0FE-4CBA-B124-0C3C0EC4F5EA@beagleboard.org>
	<BANLkTimCLVfvuVEPuEeYH_T3BCV-1EB5hw@mail.gmail.com>
	<201105271631.37469.laurent.pinchart@ideasonboard.com>
Date: Fri, 27 May 2011 17:36:24 +0200
Message-ID: <BANLkTim1U-K1pTav2LsgVGnEsJ4LxKcCGw@mail.gmail.com>
Subject: Re: [beagleboard] [PATCH] Second RFC version of mt9p031 sensor with
 power managament.
From: javier Martin <javier.martin@vista-silicon.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Koen Kooi <koen@beagleboard.org>, beagleboard@googlegroups.com,
	linux-media@vger.kernel.org, g.liakhovetski@gmx.de,
	carlighting@yahoo.co.nz
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On 27 May 2011 16:31, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
> Hi Javier,
>
> On Thursday 26 May 2011 13:31:37 javier Martin wrote:
>> OK, I think I've found the problem with the power management.
>>
>> As it is stated in mt9p031 datasheet [3] p 59, a sequence involving
>> [VAA,VAA_PIX,VDD_PLL], [VDD,VDD_IO], [Reset] and [Ext Clk] must be
>> followed in order to properly power up or down the sensor.
>>
>> If we take a look to the LI-5M031 schematic[1] and Beagleboard xM
>> schematic [2] we'll notice that voltages are connected as follows:
>>
>> [VDD] (1,8V) <--- V2.8 <--- CAM_CORE <--- VAUX3 TPS65950
>> [VDD_IO (VDDQ)] (1,8V) <--- V1.8 <--- CAM_IO <--- VAUX4 TPS65950
>> [VAA, VAA_PIX, VDD_PLL] (2,8V) <---| U6 |<-- V3.3VD <-- HUB_3V3 <--|
>> U16 | enabled by USBHOST_PWR_EN <-- LEDA TPS65950
>>
>> VAUX3 (VDD) and VAUX4 (VDD_IO) are fine, they are only used for
>> powering our camera sensor. However, when it comes to the analog part
>> (VAA, VAA_PIX...), it is got from HUB_3V3 which is also used for
>> powering USB and ethernet.
>
> *sigh* Why do hardware designers do things like that, really ?
>
>> If we really want to activate/deactivate regulators that power mt9p031
>> we need to follow [3] p59. However, for that purpose we need to ensure
>> that a call to regulator_enable() or regulator_disable() will really
>> power on/off that supply, otherwise the sequence won't be matched and
>> the chip will have problems.
>>
>> Beagleboard xM is a good example of platform where this happens since
>> HUB_3V3 and thus (VAA, VAA_PIX, etc...) cannot be deactivated since it
>> is being used by other devices. But there could be others.
>>
>> So, as a conclusion, and in order to unblock my work, my purpose for
>> power management in mt9p031 would be the following:
>> - Drop regulator handling as we cannot guarantee that power on
>> sequence will be accomplished.
>> - Keep on asserting/de-asserting reset which saves a lot of power.
>> - Also activate/deactivate clock when necessary to save some power.
>>
>> I'm looking forward to read your comments on this.
>
> Even if you keep the sensor powered all the time, how do you ensure that VAUX3
> is available before HUB_3V3 when the system is powered up ?

You can't. And in fact what happens its the opposite. But it works.

On the other hand, not being able to disable/enable HUB_3V3 can make,
as a hardware guy has told me, power on reset internal circuit not to
work [1] and thus the power down / power up fails.

[1] http://en.wikipedia.org/wiki/Power-on_reset


-- 
Javier Martin
Vista Silicon S.L.
CDTUC - FASE C - Oficina S-345
Avda de los Castros s/n
39005- Santander. Cantabria. Spain
+34 942 25 32 60
www.vista-silicon.com
