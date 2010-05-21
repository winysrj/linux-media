Return-path: <linux-media-owner@vger.kernel.org>
Received: from tango.tkos.co.il ([62.219.50.35]:36902 "EHLO tango.tkos.co.il"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753217Ab0EUH2J (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 21 May 2010 03:28:09 -0400
Date: Fri, 21 May 2010 10:27:37 +0300
From: Baruch Siach <baruch@tkos.co.il>
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	Sascha Hauer <kernel@pengutronix.de>
Subject: Re: [PATCH 0/3] Driver for the i.MX2x CMOS Sensor Interface
Message-ID: <20100521072737.GA6967@tarshish>
References: <cover.1273150585.git.baruch@tkos.co.il>
 <20100521072045.GD17272@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100521072045.GD17272@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sascha,

On Fri, May 21, 2010 at 09:20:45AM +0200, Sascha Hauer wrote:
> On Thu, May 06, 2010 at 04:09:38PM +0300, Baruch Siach wrote:
> > This series contains a soc_camera driver for the i.MX25/i.MX27 CSI device, and 
> > platform code for the i.MX25 and i.MX27 chips. This driver is based on a driver 
> > for i.MX27 CSI from Sascha Hauer, that  Alan Carvalho de Assis has posted in 
> > linux-media last December[1]. Since all I have is a i.MX25 PDK paltform I can't 
> > test the mx27 specific code. Testers and comment are welcome.
> > 
> > [1] https://patchwork.kernel.org/patch/67636/
> > 
> > Baruch Siach (3):
> >   mx2_camera: Add soc_camera support for i.MX25/i.MX27
> >   mx27: add support for the CSI device
> >   mx25: add support for the CSI device
> 
> With the two additions I sent I can confirm this working on i.MX27, so
> no need to remove the related code.

Thanks. I'll add your patches to my queue and resend the series next week.

baruch

-- 
                                                     ~. .~   Tk Open Systems
=}------------------------------------------------ooO--U--Ooo------------{=
   - baruch@tkos.co.il - tel: +972.2.679.5364, http://www.tkos.co.il -
