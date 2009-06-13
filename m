Return-path: <linux-media-owner@vger.kernel.org>
Received: from hermes.acsalaska.net ([209.112.173.230]:56380 "EHLO
	hermes.acsalaska.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751156AbZFMDGM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Jun 2009 23:06:12 -0400
Received: from [192.168.1.3] (66-230-87-63-rb1.fai.dsl.dynamic.acsalaska.net [66.230.87.63])
	by hermes.acsalaska.net (8.14.1/8.14.1) with ESMTP id n5D36COw059454
	for <linux-media@vger.kernel.org>; Fri, 12 Jun 2009 19:06:12 -0800 (AKDT)
	(envelope-from rogerx@sdf.lonestar.org)
Subject: Re: s5h1411_readreg: readreg error (ret == -5)
From: Roger <rogerx@sdf.lonestar.org>
To: linux-media <linux-media@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0906121627000.6470@cnc.isely.net>
References: <1244446830.3797.6.camel@localhost2.local>
	 <Pine.LNX.4.64.0906102257130.7298@cnc.isely.net>
	 <4A311A64.4080008@kernellabs.com>
	 <Pine.LNX.4.64.0906111343220.17086@cnc.isely.net>
	 <1244759335.9812.2.camel@localhost2.local>
	 <Pine.LNX.4.64.0906121531100.6470@cnc.isely.net>
	 <1244841123.3264.55.camel@palomino.walls.org>
	 <Pine.LNX.4.64.0906121627000.6470@cnc.isely.net>
Content-Type: text/plain
Date: Fri, 12 Jun 2009 19:06:11 -0800
Message-Id: <1244862371.10484.2.camel@localhost2.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


> On Fri, 12 Jun 2009, Andy Walls wrote:
> > 
> > The digital demodulator driver to use is hardcoded in pvrusb2-devattr.c:
> > 
> > static const struct pvr2_dvb_props pvr2_750xx_dvb_props = {
> >         .frontend_attach = pvr2_s5h1409_attach,
> >         .tuner_attach    = pvr2_tda18271_8295_attach,
> > };
> > 
> > static const struct pvr2_dvb_props pvr2_751xx_dvb_props = {
> >         .frontend_attach = pvr2_s5h1411_attach,
> >         .tuner_attach    = pvr2_tda18271_8295_attach,
> > };
> > ...
> > static const struct pvr2_device_desc pvr2_device_750xx = {
> >                 .description = "WinTV HVR-1950 Model Category 750xx",
> > ...
> >                 .dvb_props = &pvr2_750xx_dvb_props,
> > #endif
> > };
> > ...
> > static const struct pvr2_device_desc pvr2_device_751xx = {
> >                 .description = "WinTV HVR-1950 Model Category 751xx",
> > ...
> >                 .dvb_props = &pvr2_751xx_dvb_props,
> > #endif

And, just to verify the obvious:

WinTV-HVR-1950
NTSC/ATSC/QAM
75111 LF
REV C3E9

(with a very nice light green RoHS sticker)

-- 
Roger
http://rogerx.freeshell.org

