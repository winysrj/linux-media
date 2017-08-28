Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bl2nam02on0045.outbound.protection.outlook.com ([104.47.38.45]:54117
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751190AbdH1SbW (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 28 Aug 2017 14:31:22 -0400
Date: Mon, 28 Aug 2017 11:31:16 -0700
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Nicolas Dufresne <nicolas@ndufresne.ca>
CC: <mchehab@kernel.org>, <robh+dt@kernel.org>, <mark.rutland@arm.com>,
        <hans.verkuil@cisco.com>, <sakari.ailus@linux.intel.com>,
        <linux-media@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Leon Luo <leonl@leopardimaging.com>
Subject: Re: [PATCH 2/2] media:imx274 V4l2 driver for Sony imx274 CMOS sensor
Message-ID: <20170828183116.qemy6df24tqjt4li@xsjsorenbubuntu.xilinx.com>
References: <20170828151534.13045-1-soren.brinkmann@xilinx.com>
 <20170828151534.13045-2-soren.brinkmann@xilinx.com>
 <1503944523.3316.8.camel@ndufresne.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1503944523.3316.8.camel@ndufresne.ca>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 2017-08-28 at 14:22:03 -0400, Nicolas Dufresne wrote:
> Le lundi 28 août 2017 à 08:15 -0700, Soren Brinkmann a écrit :
[...]
> > diff --git a/drivers/media/i2c/Kconfig b/drivers/media/i2c/Kconfig
> > index 94153895fcd4..4e8b64575b2a 100644
> > --- a/drivers/media/i2c/Kconfig
> > +++ b/drivers/media/i2c/Kconfig
> > @@ -547,16 +547,12 @@ config VIDEO_APTINA_PLL
> >  config VIDEO_SMIAPP_PLL
> >  	tristate
> >  
> > -config VIDEO_OV2640
> > -	tristate "OmniVision OV2640 sensor support"
> > -	depends on VIDEO_V4L2 && I2C
> > -	depends on MEDIA_CAMERA_SUPPORT
> > -	help
> > -	  This is a Video4Linux2 sensor-level driver for the OmniVision
> > -	  OV2640 camera.
> > -
> > -	  To compile this driver as a module, choose M here: the
> > -	  module will be called ov2640.
> 
> Is this removal of another sensor intentional ?

Oops, no, some rebase gone wrong, I guess. I'll put that on the list to
fix for v2.

	Thanks,
	Sören
