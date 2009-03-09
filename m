Return-path: <linux-media-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:41706 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753331AbZCIVAj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 9 Mar 2009 17:00:39 -0400
From: "Aguirre Rodriguez, Sergio Alberto" <saaguirre@ti.com>
To: Trent Piepho <xyzzy@speakeasy.org>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	"Tuukka.O Toivonen" <tuukka.o.toivonen@nokia.com>,
	Hiroshi DOYU <Hiroshi.DOYU@nokia.com>,
	"DongSoo(Nathaniel) Kim" <dongsoo.kim@gmail.com>,
	MiaoStanley <stanleymiao@hotmail.com>,
	"Nagalla, Hari" <hnagalla@ti.com>,
	"Hiremath, Vaibhav" <hvaibhav@ti.com>,
	"Lakhani, Amish" <amish@ti.com>, "Menon, Nishanth" <nm@ti.com>
Date: Mon, 9 Mar 2009 16:00:22 -0500
Subject: RE: [PATCH 3/5] OV3640: Add driver
Message-ID: <A24693684029E5489D1D202277BE89442E40F7F7@dlee02.ent.ti.com>
In-Reply-To: <Pine.LNX.4.58.0903041737110.24268@shell2.speakeasy.net>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



> -----Original Message-----
> From: Trent Piepho [mailto:xyzzy@speakeasy.org]
> Sent: Wednesday, March 04, 2009 7:42 PM
> To: Aguirre Rodriguez, Sergio Alberto
> Cc: linux-media@vger.kernel.org; linux-omap@vger.kernel.org; Sakari Ailus;
> Tuukka.O Toivonen; Hiroshi DOYU; DongSoo(Nathaniel) Kim; MiaoStanley;
> Nagalla, Hari; Hiremath, Vaibhav; Lakhani, Amish; Menon, Nishanth
> Subject: Re: [PATCH 3/5] OV3640: Add driver
> 
> On Tue, 3 Mar 2009, Aguirre Rodriguez, Sergio Alberto wrote:
> > +       {
> > +               /* Note:  V4L2 defines RGB565 as:
> > +                *
> > +                *      Byte 0                    Byte 1
> > +                *      g2 g1 g0 r4 r3 r2 r1 r0   b4 b3 b2 b1 b0 g5 g4
> g3
> > +                *
> > +                * We interpret RGB565 as:
> > +                *
> > +                *      Byte 0                    Byte 1
> > +                *      g2 g1 g0 b4 b3 b2 b1 b0   r4 r3 r2 r1 r0 g5 g4
> g3
> 
> The V4L2 spec was corrected to define the RGB565 the normal way.

Oh ok.. Didn't knew that..

Removed that note.

Thanks!

Sergio
