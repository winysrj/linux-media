Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:52162 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751980Ab1E0Obm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 May 2011 10:31:42 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: javier Martin <javier.martin@vista-silicon.com>
Subject: Re: [beagleboard] [PATCH] Second RFC version of mt9p031 sensor with power managament.
Date: Fri, 27 May 2011 16:31:36 +0200
Cc: Koen Kooi <koen@beagleboard.org>, beagleboard@googlegroups.com,
	linux-media@vger.kernel.org, g.liakhovetski@gmx.de,
	carlighting@yahoo.co.nz
References: <1306322212-26879-1-git-send-email-javier.martin@vista-silicon.com> <D9AEF5C4-C0FE-4CBA-B124-0C3C0EC4F5EA@beagleboard.org> <BANLkTimCLVfvuVEPuEeYH_T3BCV-1EB5hw@mail.gmail.com>
In-Reply-To: <BANLkTimCLVfvuVEPuEeYH_T3BCV-1EB5hw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201105271631.37469.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Javier,

On Thursday 26 May 2011 13:31:37 javier Martin wrote:
> OK, I think I've found the problem with the power management.
> 
> As it is stated in mt9p031 datasheet [3] p 59, a sequence involving
> [VAA,VAA_PIX,VDD_PLL], [VDD,VDD_IO], [Reset] and [Ext Clk] must be
> followed in order to properly power up or down the sensor.
> 
> If we take a look to the LI-5M031 schematic[1] and Beagleboard xM
> schematic [2] we'll notice that voltages are connected as follows:
> 
> [VDD] (1,8V) <--- V2.8 <--- CAM_CORE <--- VAUX3 TPS65950
> [VDD_IO (VDDQ)] (1,8V) <--- V1.8 <--- CAM_IO <--- VAUX4 TPS65950
> [VAA, VAA_PIX, VDD_PLL] (2,8V) <---| U6 |<-- V3.3VD <-- HUB_3V3 <--|
> U16 | enabled by USBHOST_PWR_EN <-- LEDA TPS65950
> 
> VAUX3 (VDD) and VAUX4 (VDD_IO) are fine, they are only used for
> powering our camera sensor. However, when it comes to the analog part
> (VAA, VAA_PIX...), it is got from HUB_3V3 which is also used for
> powering USB and ethernet.

*sigh* Why do hardware designers do things like that, really ?

> If we really want to activate/deactivate regulators that power mt9p031
> we need to follow [3] p59. However, for that purpose we need to ensure
> that a call to regulator_enable() or regulator_disable() will really
> power on/off that supply, otherwise the sequence won't be matched and
> the chip will have problems.
> 
> Beagleboard xM is a good example of platform where this happens since
> HUB_3V3 and thus (VAA, VAA_PIX, etc...) cannot be deactivated since it
> is being used by other devices. But there could be others.
> 
> So, as a conclusion, and in order to unblock my work, my purpose for
> power management in mt9p031 would be the following:
> - Drop regulator handling as we cannot guarantee that power on
> sequence will be accomplished.
> - Keep on asserting/de-asserting reset which saves a lot of power.
> - Also activate/deactivate clock when necessary to save some power.
> 
> I'm looking forward to read your comments on this.

Even if you keep the sensor powered all the time, how do you ensure that VAUX3 
is available before HUB_3V3 when the system is powered up ?

> [1] https://www.leopardimaging.com/uploads/li-5m03_camera_board_v2.pdf
> [2] http://beagle.s3.amazonaws.com/design/xM-A3/BB-xM_Schematic_REVA3.pdf
> [3] http://www.aptina.com/products/image_sensors/mt9p031i12stc/

-- 
Regards,

Laurent Pinchart
