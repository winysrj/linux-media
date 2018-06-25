Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:42040 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755414AbeFYNKb (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 25 Jun 2018 09:10:31 -0400
Date: Mon, 25 Jun 2018 10:10:24 -0300
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: "Zheng, Jian Xu" <jian.xu.zheng@intel.com>
Cc: "Mario.Limonciello@dell.com" <Mario.Limonciello@dell.com>,
        "pavel@ucw.cz" <pavel@ucw.cz>,
        "nicolas@ndufresne.ca" <nicolas@ndufresne.ca>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "sakari.ailus@linux.intel.com" <sakari.ailus@linux.intel.com>,
        "niklas.soderlund@ragnatech.se" <niklas.soderlund@ragnatech.se>,
        "Hu, Jerry W" <jerry.w.hu@intel.com>
Subject: Re: Software-only image processing for Intel "complex" cameras
Message-ID: <20180625101024.2573892a@coco.lan>
In-Reply-To: <FA6CF6692DF0B343ABE491A46A2CD0E76C6E491B@SHSMSX101.ccr.corp.intel.com>
References: <20180620203838.GA13372@amd>
        <b7707ec241d9d2d2966bdc32f7bb9bc55ac55c5d.camel@ndufresne.ca>
        <20180620211144.GA16945@amd>
        <da642773adac42a6966b9716f0d53444@ausx13mpc120.AMER.DELL.COM>
        <20180622034946.2ae51f1e@vela.lan>
        <db8d91a47971417da424df7bf67a5cca@ausx13mpc120.AMER.DELL.COM>
        <20180622060850.3941d9a7@vela.lan>
        <20180622064032.550f24cb@vela.lan>
        <FA6CF6692DF0B343ABE491A46A2CD0E76C6E491B@SHSMSX101.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 25 Jun 2018 09:48:56 +0000
"Zheng, Jian Xu" <jian.xu.zheng@intel.com> escreveu:

> Hi Mauro,
> 
> > -----Original Message-----
> > From: linux-media-owner@vger.kernel.org [mailto:linux-media-
> > owner@vger.kernel.org] On Behalf Of Mauro Carvalho Chehab
> > Sent: Friday, June 22, 2018 5:41 AM
> > To: Mario.Limonciello@dell.com
> > Cc: pavel@ucw.cz; nicolas@ndufresne.ca; linux-media@vger.kernel.org;
> > sakari.ailus@linux.intel.com; niklas.soderlund@ragnatech.se; Hu, Jerry W
> > <jerry.w.hu@intel.com>; Zheng, Jian Xu <jian.xu.zheng@intel.com>
> > Subject: Re: Software-only image processing for Intel "complex" cameras
> > 
> > Em Fri, 22 Jun 2018 06:08:50 +0900
> > Mauro Carvalho Chehab <mchehab+samsung@kernel.org> escreveu:
> >   
> > > Em Thu, 21 Jun 2018 18:58:37 +0000
> > > <Mario.Limonciello@dell.com> escreveu:
> > >  
> > Jerry/Jian,
> > 
> > Could you please shed a light about how a Dell 5285 hardware would be
> > detected by the IPU3 driver and what MC graph is created by the current
> > driver?  
> 
> Sure, Mauro. I need to check the information on the Dell 5285.
> IPU3 driver are detected by PCI vendor id and device id.
> 
> IPU3 CIO2 MC graph is:
> Sensor A -> IPU3 CSI2 0(subdev) -> IPU3 CIO2 0 (video node)
> Sensor B -> IPU3 CSI2 1(subdev) -> IPU3 CIO2 1 (video node)

How does it detect what driver should be loaded for Sensor A and B?

Does the ACPI table identifies the sensors? If so, how the driver
associates an specific PCI vendor ID with the corresponding sensor
settings?

> 
> IPU3 IMGu MC graph is:
> IMGu subdev inputs:
> ipu3-imgu input [Pad0] => ipu3-imgu [Pad0]
> ipu3-imgu parameters [Pad0] => ipu3-imgu [Pad1]
> 
> IMGu subdev outputs:
> ipu3-imgu [Pad2]  => ipu3-imgu output [Pad0] 
> ipu3-imgu [Pad3]  => ipu3-imgu viewfinder [Pad0] 
> ipu3-imgu [Pad4]  => ipu3-imgu postview [Pad0] 
> ipu3-imgu [Pad5]  => ipu3-imgu 3a stat [Pad0]
> 
> Best Regards,
> Jianxu(Clive) Zheng



Thanks,
Mauro
