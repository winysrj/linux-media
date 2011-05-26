Return-path: <mchehab@pedra>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:49215 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753672Ab1EZLbv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 26 May 2011 07:31:51 -0400
Received: by iyb14 with SMTP id 14so537204iyb.19
        for <linux-media@vger.kernel.org>; Thu, 26 May 2011 04:31:51 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <D9AEF5C4-C0FE-4CBA-B124-0C3C0EC4F5EA@beagleboard.org>
References: <1306322212-26879-1-git-send-email-javier.martin@vista-silicon.com>
	<F50AF7E4-DCBA-4FC9-971A-ADF01F342FEF@beagleboard.org>
	<BANLkTiksN_+12hdQFOQ9+bS5LBU+QSR4cA@mail.gmail.com>
	<07EF42D6-0587-4F35-8431-E03B9994F9B5@beagleboard.org>
	<BANLkTikon2uw4DWcsXLCnLD1crfbV7HP_Q@mail.gmail.com>
	<D9AEF5C4-C0FE-4CBA-B124-0C3C0EC4F5EA@beagleboard.org>
Date: Thu, 26 May 2011 13:31:37 +0200
Message-ID: <BANLkTimCLVfvuVEPuEeYH_T3BCV-1EB5hw@mail.gmail.com>
Subject: Re: [beagleboard] [PATCH] Second RFC version of mt9p031 sensor with
 power managament.
From: javier Martin <javier.martin@vista-silicon.com>
To: Koen Kooi <koen@beagleboard.org>
Cc: beagleboard@googlegroups.com, linux-media@vger.kernel.org,
	g.liakhovetski@gmx.de, laurent.pinchart@ideasonboard.com,
	carlighting@yahoo.co.nz
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

OK, I think I've found the problem with the power management.

As it is stated in mt9p031 datasheet [3] p 59, a sequence involving
[VAA,VAA_PIX,VDD_PLL], [VDD,VDD_IO], [Reset] and [Ext Clk] must be
followed in order to properly power up or down the sensor.

If we take a look to the LI-5M031 schematic[1] and Beagleboard xM
schematic [2] we'll notice that voltages are connected as follows:

[VDD] (1,8V) <--- V2.8 <--- CAM_CORE <--- VAUX3 TPS65950
[VDD_IO (VDDQ)] (1,8V) <--- V1.8 <--- CAM_IO <--- VAUX4 TPS65950
[VAA, VAA_PIX, VDD_PLL] (2,8V) <---| U6 |<-- V3.3VD <-- HUB_3V3 <--|
U16 | enabled by USBHOST_PWR_EN <-- LEDA TPS65950

VAUX3 (VDD) and VAUX4 (VDD_IO) are fine, they are only used for
powering our camera sensor. However, when it comes to the analog part
(VAA, VAA_PIX...), it is got from HUB_3V3 which is also used for
powering USB and ethernet.

If we really want to activate/deactivate regulators that power mt9p031
we need to follow [3] p59. However, for that purpose we need to ensure
that a call to regulator_enable() or regulator_disable() will really
power on/off that supply, otherwise the sequence won't be matched and
the chip will have problems.

Beagleboard xM is a good example of platform where this happens since
HUB_3V3 and thus (VAA, VAA_PIX, etc...) cannot be deactivated since it
is being used by other devices. But there could be others.

So, as a conclusion, and in order to unblock my work, my purpose for
power management in mt9p031 would be the following:
- Drop regulator handling as we cannot guarantee that power on
sequence will be accomplished.
- Keep on asserting/de-asserting reset which saves a lot of power.
- Also activate/deactivate clock when necessary to save some power.

I'm looking forward to read your comments on this.

[1] https://www.leopardimaging.com/uploads/li-5m03_camera_board_v2.pdf
[2] http://beagle.s3.amazonaws.com/design/xM-A3/BB-xM_Schematic_REVA3.pdf
[3] http://www.aptina.com/products/image_sensors/mt9p031i12stc/


-- 
Javier Martin
Vista Silicon S.L.
CDTUC - FASE C - Oficina S-345
Avda de los Castros s/n
39005- Santander. Cantabria. Spain
+34 942 25 32 60
www.vista-silicon.com
