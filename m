Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:40485 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751225AbZCDFq6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 Mar 2009 00:46:58 -0500
From: "Aguirre Rodriguez, Sergio Alberto" <saaguirre@ti.com>
To: "stanley.miao" <stanley.miao@windriver.com>
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
Date: Tue, 3 Mar 2009 23:46:42 -0600
Subject: RE: [RFC 0/5] Sensor drivers for OMAP3430SDP and LDP camera
Message-ID: <A24693684029E5489D1D202277BE89442E1D95E5@dlee02.ent.ti.com>
In-Reply-To: <49AE14E7.2010709@windriver.com>
Content-Language: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



> -----Original Message-----
> From: stanley.miao [mailto:stanley.miao@windriver.com]
> Sent: Tuesday, March 03, 2009 11:43 PM
> To: Aguirre Rodriguez, Sergio Alberto
> Cc: linux-media@vger.kernel.org; linux-omap@vger.kernel.org; Sakari Ailus;
> Tuukka.O Toivonen; Hiroshi DOYU; DongSoo(Nathaniel) Kim; MiaoStanley;
> Nagalla, Hari; Hiremath, Vaibhav; Lakhani, Amish; Menon, Nishanth
> Subject: Re: [RFC 0/5] Sensor drivers for OMAP3430SDP and LDP camera
> 
> Aguirre Rodriguez, Sergio Alberto wrote:
> > This patch series depends on the following patches:
> >
> >  - "Add TWL4030 registers", posted by Tuukka Toivonen on March 2nd.
> >  - "OMAP3 ISP and camera drivers" patch series, posted by Sakari Ailus
> on
> >    March 3rd. (Please follow his instructions to pull from gitorious.org
> server)
> >
> > This has been tested with:
> >  - SDP3430-VG5.0.1 with OMAP3430-ES3.1 daughter board upgrade.
> >  - Camkit V3.0.1 with MT9P012 and OV3640 sensors
> >  - LDP with OV3640 sensor
> >
> > Sergio Aguirre (5):
> >   MT9P012: Add driver
> >   DW9710: Add driver
> >   OV3640: Add driver
> >
> Hi, Sergio,
> 
> You forgot to send the 3rd patch, "OV3640: Add driver".

Hmm, weird... I'm sure I have sent the 5 patches to both linux-omap and linux-media MLs... But, according to http://patchwork.kernel.org/ linux-omap didn't receive that patch you're telling me...

Anyways, resending that last patch to linux-omap only.

Thanks for the interest.

> 
> Stanley.
> 
> >   OMAP3430SDP: Add support for Camera Kit v3
> >   LDP: Add support for built-in camera
> >
> 

