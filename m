Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:40380 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753756AbbDHKQz (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 8 Apr 2015 06:16:55 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: whittenburg@gmail.com
Cc: Sakari Ailus <sakari.ailus@iki.fi>, linux-media@vger.kernel.org
Subject: Re: OMAP3 ISP previewer Y10 to UYVY conversion
Date: Wed, 08 Apr 2015 13:17:13 +0300
Message-ID: <4266372.QbGlLsYjom@avalon>
In-Reply-To: <CABcw_OkPa_xuN_R5B3PfVWcVKxVXFRCJS4xEvaGbCH=Vvdhbgg@mail.gmail.com>
References: <CABcw_Okm1ZVob1s_JxZaRk_oFP2efh38qEyDeok4K2066dcMvQ@mail.gmail.com> <1885047.DP4uMGgtdr@avalon> <CABcw_OkPa_xuN_R5B3PfVWcVKxVXFRCJS4xEvaGbCH=Vvdhbgg@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Chris,

On Tuesday 07 April 2015 11:45:10 Chris Whittenburg wrote:
> On Tue, Apr 7, 2015 at 10:51 AM, Laurent Pinchart wrote:
> > I suspect the RGB2RGB conversion matrix to be wrong. The default setting
> > is supposed to handle fluorescent lighting. You could try setting the
> > RGB2RGB matrix to the identity matrix and see if this helps. See
> > http://git.ideasonboard.org/omap3-isp-live.git/blob/HEAD:/isp/controls.c#l
> > 184 for sample code.
> > 
> > Another matrix that could be worth being reprogrammed is the RGB2YUV
> > matrix, which also defaults to fluorescent lighting. Sample code to
> > reprogram it is available in the same location.
> 
> Thanks Laurent...
> 
> Just to verify, the conversion matrix still plays a role even though
> the input format is Y10?

Yes it does. The preview engine first converts Y10 to RGB by duplicating the Y 
value for all three channels, then feeds it through the RGB2RGB matrix, the 
gamma table, and the RGB2YUV matrix.

-- 
Regards,

Laurent Pinchart

