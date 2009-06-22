Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:54413 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750866AbZFVPot convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Jun 2009 11:44:49 -0400
From: "Aguirre Rodriguez, Sergio Alberto" <saaguirre@ti.com>
To: "Menon, Nishanth" <nm@ti.com>, Dongsoo Kim <dongsoo.kim@gmail.com>
CC: "Tuukka.O Toivonen" <tuukka.o.toivonen@nokia.com>,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"Hiremath, Vaibhav" <hvaibhav@ti.com>,
	"Koskipaa Antti (Nokia-D/Helsinki)" <antti.koskipaa@nokia.com>,
	"Cohen David.A (Nokia-D/Helsinki)" <david.cohen@nokia.com>,
	Alexey Klimov <klimov.linux@gmail.com>,
	"gary@mlbassoc.com" <gary@mlbassoc.com>
Date: Mon, 22 Jun 2009 10:46:28 -0500
Subject: RE: OMAP3 ISP and camera drivers (update 2)
Message-ID: <A24693684029E5489D1D202277BE894441306F5F@dlee02.ent.ti.com>
References: <4A3A7AE2.9080303@maxwell.research.nokia.com>
 <5e9665e10906200205ga45073eue92b73abba79e41c@mail.gmail.com>
 <200906221652.02119.tuukka.o.toivonen@nokia.com>
 <A24693684029E5489D1D202277BE894441306D3E@dlee02.ent.ti.com>
 <1DA2ED23-DD14-4E7C-9CDB-D86009620337@gmail.com>
 <A24693684029E5489D1D202277BE894441306D8A@dlee02.ent.ti.com>
 <7A436F7769CA33409C6B44B358BFFF0C0115F506D2@dlee02.ent.ti.com>
In-Reply-To: <7A436F7769CA33409C6B44B358BFFF0C0115F506D2@dlee02.ent.ti.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



> -----Original Message-----
> From: Menon, Nishanth
> Sent: Monday, June 22, 2009 9:50 AM
> To: Aguirre Rodriguez, Sergio Alberto; Dongsoo Kim
> Cc: Tuukka.O Toivonen; Sakari Ailus; linux-media@vger.kernel.org;
> Hiremath, Vaibhav; Koskipaa Antti (Nokia-D/Helsinki); Cohen David.A
> (Nokia-D/Helsinki); Alexey Klimov; gary@mlbassoc.com
> Subject: RE: OMAP3 ISP and camera drivers (update 2)
> 
> > -----Original Message-----
> > From: linux-media-owner@vger.kernel.org [mailto:linux-media-
> > owner@vger.kernel.org] On Behalf Of Aguirre Rodriguez, Sergio Alberto
> > Sent: Monday, June 22, 2009 5:22 PM
> > > Thank you Sergio. So you mean that I can buy OMAP Zoom target board
> > > with MT or OV sensor on it sooner or later? cool!
> >
> > AFAIK, when you buy the Zoom Target platform, you can only have OV3640
> > sensor. BUT you could hack the board to include another sensor (Maybe
> > consulting Logic people could clarify this).
> >
> > In Zoom1, I'll be able just to test the OV3640 sensor, which is the one
> I
> > have available here.
> >
> > On 3430SDP, is where I do have MT9P012 sensor (5MP RAW sensor) connected
> > in parallel, and an OV3640 (Smart sensor, but driver is using it as RAW
> > sensor currently only) in CSI2 interface.
> >
> 
> Curious: Thought we had two sensors: OV3640[1] on zoom1 and a 8MP sensor
> on zoom2[2] -> am I wrong in saying that the connectors are compatible
> since both are CSI2[3]?

You're not wrong. The connectors are compatible, it'll be a matter of the driver part located in board specific code to request the necessary datalanes for the transmission to be done adequately. But both should follow CSI2 standard spec.

> 
> SDP3430[4] supports MT9p012(CPI) and ov3640(CSI2).. as long as someone can
> put a sensor with the right connectors and voltage checks, they should be
> "plug and play" - at least from a h/w perspective ;)

Yes, that's correct.

Only proper sensor driver will be required of course...

> 
> Regards,
> Nishanth Menon
> Ref:
> [1] http://www.ovt.com/products/part_detail.php?id=26
> [2]
> https://www.omapzoom.org/gf/project/omapzoom/wiki/?pagename=WhatIsZoom2
> [3]
> https://www.omapzoom.com/gf/project/omapandroid/mailman/?_forum_action=For
> umMessageBrowse&thread_id=1912&action=ListThreads&mailman_id=22
> [4]
> http://focus.ti.com/general/docs/wtbu/wtbugencontent.tsp?templateId=6123&n
> avigationId=12013&contentId=28741#sdp
