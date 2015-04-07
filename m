Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f179.google.com ([209.85.212.179]:35858 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753735AbbDGQpL (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 7 Apr 2015 12:45:11 -0400
Received: by wizk4 with SMTP id k4so24670226wiz.1
        for <linux-media@vger.kernel.org>; Tue, 07 Apr 2015 09:45:10 -0700 (PDT)
MIME-Version: 1.0
Reply-To: whittenburg@gmail.com
In-Reply-To: <1885047.DP4uMGgtdr@avalon>
References: <CABcw_Okm1ZVob1s_JxZaRk_oFP2efh38qEyDeok4K2066dcMvQ@mail.gmail.com>
	<CABcw_O=Gv3xvnRU9LvVUaCKEEkLFFrhpqLZ9FZ89XRAp0_RR5Q@mail.gmail.com>
	<20150325235820.GP18321@valkosipuli.retiisi.org.uk>
	<1885047.DP4uMGgtdr@avalon>
Date: Tue, 7 Apr 2015 11:45:10 -0500
Message-ID: <CABcw_OkPa_xuN_R5B3PfVWcVKxVXFRCJS4xEvaGbCH=Vvdhbgg@mail.gmail.com>
Subject: Re: OMAP3 ISP previewer Y10 to UYVY conversion
From: Chris Whittenburg <whittenburg@gmail.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Sakari Ailus <sakari.ailus@iki.fi>, linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Apr 7, 2015 at 10:51 AM, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
> I suspect the RGB2RGB conversion matrix to be wrong. The default setting is
> supposed to handle fluorescent lighting. You could try setting the RGB2RGB
> matrix to the identity matrix and see if this helps. See
> http://git.ideasonboard.org/omap3-isp-live.git/blob/HEAD:/isp/controls.c#l184
> for sample code.
>
> Another matrix that could be worth being reprogrammed is the RGB2YUV matrix,
> which also defaults to fluorescent lighting. Sample code to reprogram it is
> available in the same location.

Thanks Laurent...

Just to verify, the conversion matrix still plays a role even though
the input format is Y10?
