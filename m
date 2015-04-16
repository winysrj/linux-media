Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f46.google.com ([74.125.82.46]:33852 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754239AbbDPSFb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Apr 2015 14:05:31 -0400
Received: by wgso17 with SMTP id o17so89667853wgs.1
        for <linux-media@vger.kernel.org>; Thu, 16 Apr 2015 11:05:30 -0700 (PDT)
MIME-Version: 1.0
Reply-To: whittenburg@gmail.com
In-Reply-To: <1885047.DP4uMGgtdr@avalon>
References: <CABcw_Okm1ZVob1s_JxZaRk_oFP2efh38qEyDeok4K2066dcMvQ@mail.gmail.com>
	<CABcw_O=Gv3xvnRU9LvVUaCKEEkLFFrhpqLZ9FZ89XRAp0_RR5Q@mail.gmail.com>
	<20150325235820.GP18321@valkosipuli.retiisi.org.uk>
	<1885047.DP4uMGgtdr@avalon>
Date: Thu, 16 Apr 2015 13:05:30 -0500
Message-ID: <CABcw_Om0fujOR+-O+zw6z_aor8ZgOpJiLUJ0pq4hrHP7v_tKCA@mail.gmail.com>
Subject: Re: OMAP3 ISP previewer Y10 to UYVY conversion
From: Chris Whittenburg <whittenburg@gmail.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Sakari Ailus <sakari.ailus@iki.fi>, linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Apr 7, 2015 at 10:51 AM, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
> Black level compensation is applied by the CCDC before writing raw frames to
> memory. If your raw frames are correct BLC is probably not to blame.
>
> The default contrast is x1.0 and the default brightness is +0.0, so I don't
> think those should be blame either.
>
> I suspect the RGB2RGB conversion matrix to be wrong. The default setting is
> supposed to handle fluorescent lighting. You could try setting the RGB2RGB
> matrix to the identity matrix and see if this helps. See
> http://git.ideasonboard.org/omap3-isp-live.git/blob/HEAD:/isp/controls.c#l184
> for sample code.
>
> Another matrix that could be worth being reprogrammed is the RGB2YUV matrix,
> which also defaults to fluorescent lighting. Sample code to reprogram it is
> available in the same location.

I tried changing the rgb2rgb matrx to the identity matrix:

{0x0100, 0x0000, 0x0000},
{0x0000, 0x0100, 0x0000},
{0x0000, 0x0000, 0x0100}

And the csc (rgb2yuv) to this:
{256, 0, 0},
{0, 0, 0},
{0, 0, 0}

But I couldn't see much, if any, difference.

However, when I forced the gamma correction to be bypassed, it seemed to fix it.

Does that make sense?  I guess I don't understand it enough to
understand if gamma correction would have compressed all my luma
values.

Thanks,
Chris
