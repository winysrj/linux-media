Return-path: <linux-media-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:55592 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753307AbZCEXC5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 Mar 2009 18:02:57 -0500
From: "Curran, Dominic" <dcurran@ti.com>
To: Alexey Klimov <klimov.linux@gmail.com>
CC: "DongSoo(Nathaniel) Kim" <dongsoo.kim@gmail.com>,
	"Aguirre Rodriguez, Sergio Alberto" <saaguirre@ti.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	"Tuukka.O Toivonen" <tuukka.o.toivonen@nokia.com>,
	Hiroshi DOYU <Hiroshi.DOYU@nokia.com>,
	MiaoStanley <stanleymiao@hotmail.com>,
	"Nagalla, Hari" <hnagalla@ti.com>,
	"Hiremath, Vaibhav" <hvaibhav@ti.com>,
	"Lakhani, Amish" <amish@ti.com>, "Menon, Nishanth" <nm@ti.com>
Date: Thu, 5 Mar 2009 17:02:44 -0600
Subject: RE: [PATCH 4/5] OMAP3430SDP: Add support for Camera Kit v3
Message-ID: <96DA7A230D3B2F42BA3EF203A7A1B3B5012EAC2699@dlee07.ent.ti.com>
In-Reply-To: <208cbae30903051405p7588b3a9pb17338ec99dc749a@mail.gmail.com>
Content-Language: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



> -----Original Message-----
> From: Alexey Klimov [mailto:klimov.linux@gmail.com]
> Sent: Thursday, March 05, 2009 4:05 PM
> To: Curran, Dominic
> Cc: DongSoo(Nathaniel) Kim; Aguirre Rodriguez, Sergio Alberto; linux-
> media@vger.kernel.org; linux-omap@vger.kernel.org; Sakari Ailus; Tuukka.O
> Toivonen; Hiroshi DOYU; MiaoStanley; Nagalla, Hari; Hiremath, Vaibhav;
> Lakhani, Amish; Menon, Nishanth
> Subject: Re: [PATCH 4/5] OMAP3430SDP: Add support for Camera Kit v3
>
> >> > +               /* out of standby */
> >> > +               gpio_set_value(MT9P012_STANDBY_GPIO, 0);
> >> > +               udelay(1000);
> >>
> >> It seems better using msleep rather than udelay for 1000us much. Just
> >> to be safe :)
> >> How about you?
> >>
> >
> > Why is msleep safer than udelay ?
>
> I have small guess that he is wondering why you are using big delays
> with help of udelay(). (It's may be obvious but as we know udelay uses
> cpu loops to make delay and msleep calls to scheduler) So, msleep is
> more flexible and "softer" but if you need precise time or you can't
> sleep in code you need udelay. Sometimes using udelay is reasonably
> required.
>

Ah, I did not know that msleep() called scheduler.
Thank you.
